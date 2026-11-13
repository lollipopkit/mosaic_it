use std::collections::HashSet;
use std::sync::atomic::{AtomicU64, Ordering};

use image::RgbImage;
use ndarray::{Array4, s};
use serde::Serialize;

use crate::eval::iou;
use crate::model::resized_height;
use crate::{Backend, Error, FACE, FaceDetector, ModelMeta, Preprocessed, RawOutput, Result, preprocess};

/// Overlap between consecutive tiles of a fixed-size graph, in model pixels.
/// Larger than the tallest region expected (a QR code is ~300 px at width
/// 720), so every region is whole in the tile that keeps it.
pub const TILE_OVERLAP: usize = 384;

/// Tops of the tiles covering a `h`-tall input with `th`-tall tiles, each
/// with the y range it owns: a detection is kept only by the tile whose range
/// holds its centre, and ranges split each overlap down the middle.
fn tile_plan(h: usize, th: usize) -> Vec<(usize, f32, f32)> {
    if h <= th {
        return vec![(0, f32::NEG_INFINITY, f32::INFINITY)];
    }
    let step = th - TILE_OVERLAP;
    let mut tops: Vec<usize> = (0..).map(|i| i * step).take_while(|&y| y + th < h).collect();
    tops.push(h - th);
    let cut = |i: usize| (tops[i + 1] + tops[i] + th) as f32 / 2.0;
    (0..tops.len())
        .map(|i| {
            let lo = if i == 0 { f32::NEG_INFINITY } else { cut(i - 1) };
            let hi = if i + 1 == tops.len() { f32::INFINITY } else { cut(i) };
            (tops[i], lo, hi)
        })
        .collect()
}

fn softplus(x: f32) -> f32 {
    if x > 20.0 { x } else { x.exp().ln_1p() }
}

#[derive(Debug, Clone, Serialize)]
pub struct Detection {
    pub class: String,
    pub class_id: usize,
    pub score: f32,
    /// xyxy in original-image pixels.
    pub bbox: [f32; 4],
}

#[derive(Debug, Clone)]
pub struct DetectOptions {
    /// Candidates below this score are dropped before NMS.
    pub min_score: f32,
    pub iou: f32,
    pub max_detections: usize,
}

impl Default for DetectOptions {
    fn default() -> Self {
        Self {
            min_score: 0.05,
            iou: 0.6,
            max_detections: 500,
        }
    }
}

/// Candidates of one image before NMS, kept per run of the graph so that
/// [`Detector::redetect`] can rerun only the runs an edit touches.
#[derive(Debug, Clone)]
pub struct Candidates {
    /// The detector that made them.
    detector: u64,
    /// Pixel hash of the image, when reusable by [`Detector::redetect`].
    image: Option<blake3::Hash>,
    size: (u32, u32),
    scale: f32,
    min_score: f32,
    /// Per run of the graph: (class, score, xyxy in model pixels).
    runs: Vec<Vec<(usize, f32, [f32; 4])>>,
    /// (score, xyxy in image pixels) from the face detector, if any.
    faces: Vec<(f32, [f32; 4])>,
}

impl Candidates {
    pub fn min_score(&self) -> f32 {
        self.min_score
    }
}

/// Which of the `ph` preprocessed rows can differ between `a` and `b` (same
/// size): every output row whose bilinear filter reaches a differing source
/// row, plus one row of margin on each side.
fn changed_rows(a: &RgbImage, b: &RgbImage, ph: usize) -> Vec<bool> {
    let (w, h) = a.dimensions();
    // Source rows per output row, and the filter radius in source rows.
    let r = h as f64 / resized_height(w, h) as f64;
    let radius = r.max(1.0);
    let mut dirty = vec![false; ph];
    let stride = w as usize * 3;
    for (k, (ra, rb)) in a.chunks_exact(stride).zip(b.chunks_exact(stride)).enumerate() {
        if ra != rb {
            let k = k as f64;
            // Output row y reads source rows [floor(c - radius), ceil(c + radius))
            // around its centre c = (y + 0.5) * r.
            let lo = ((k - radius - 1.0) / r - 0.5).floor() - 1.0;
            let hi = ((k + radius + 1.0) / r - 0.5).ceil() + 2.0;
            let (lo, hi) = (lo.max(0.0) as usize, hi.max(0.0) as usize);
            dirty[lo.min(ph)..hi.min(ph)].fill(true);
        }
    }
    dirty
}

/// A user's preset over the model's thresholds. Only [`Threshold::Medium`]
/// keeps the calibration, and with it a calibrated model's recall guarantee.
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub enum Threshold {
    /// Pre-selects more: thresholds at two thirds.
    Low,
    #[default]
    Medium,
    /// Pre-selects less: thresholds at four thirds.
    High,
}

/// A scaled threshold stays reachable by a score.
const MAX_THRESHOLD: f32 = 0.95;

impl Threshold {
    fn scale(self) -> f32 {
        match self {
            Self::Low => 2.0 / 3.0,
            Self::Medium => 1.0,
            Self::High => 4.0 / 3.0,
        }
    }
}

/// How a detection is presented before the user edits the selection.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum Selection {
    /// At or above the class's calibrated `select` threshold.
    Selected,
    /// At or above `review`, of a class that is off by default
    /// ([`Detector::set_off`]): shown unselected, not highlighted; the export
    /// check skips it.
    Suggested,
    /// Between `review` and `select`: shown unselected, highlighted.
    Review,
    /// Below `review`: not shown.
    Hidden,
}

/// Model metadata plus a backend, and optionally a face detector: image in,
/// detections out.
pub struct Detector {
    pub meta: ModelMeta,
    backend: Box<dyn Backend>,
    faces: Option<FaceDetector>,
    /// Classes not pre-selected: see [`Selection::Suggested`].
    off: HashSet<String>,
    threshold: Threshold,
    /// Tells this detector's [`Candidates`] from another's.
    id: u64,
}

impl Detector {
    pub fn new(meta: ModelMeta, backend: Box<dyn Backend>) -> Self {
        static NEXT: AtomicU64 = AtomicU64::new(0);
        Self {
            meta,
            backend,
            faces: None,
            off: HashSet::new(),
            threshold: Threshold::default(),
            id: NEXT.fetch_add(1, Ordering::Relaxed),
        }
    }

    /// Adds [`FACE`] detections, with class id `meta.classes.len()`.
    /// Evaluation and calibration against the model's classes run without.
    pub fn with_faces(mut self, faces: FaceDetector) -> Self {
        self.faces = Some(faces);
        self
    }

    /// Classes whose detections are [`Selection::Suggested`] instead of
    /// pre-selected.
    pub fn set_off(&mut self, classes: impl IntoIterator<Item = String>) {
        self.off = classes.into_iter().collect();
    }

    /// Moves every class's thresholds: see [`Threshold`].
    pub fn set_threshold(&mut self, threshold: Threshold) {
        self.threshold = threshold;
    }

    /// Every class a detection can have, in class id order.
    pub fn classes(&self) -> Vec<String> {
        let mut c = self.meta.classes.clone();
        if self.faces.is_some() {
            c.push(FACE.into());
        }
        c
    }

    /// (select, review) thresholds of a class.
    fn thresholds(&self, class: &str) -> (f32, f32) {
        let (select, review) = match &self.faces {
            Some(f) if class == FACE => (f.select, f.review),
            _ => self.meta.thresholds(class),
        };
        let scale = |t: f32| (t * self.threshold.scale()).min(MAX_THRESHOLD);
        (scale(select), scale(review))
    }

    /// Pre-selection state of a detection under the model's calibration (the
    /// face detector's operating points for faces).
    pub fn selection(&self, d: &Detection) -> Selection {
        let (select, review) = self.thresholds(&d.class);
        if d.score < review {
            Selection::Hidden
        } else if self.off.contains(&d.class) {
            Selection::Suggested
        } else if d.score >= select {
            Selection::Selected
        } else {
            Selection::Review
        }
    }

    pub fn backend_name(&self) -> String {
        match &self.faces {
            Some(f) => format!("{}, faces {}", self.backend.name(), f.backend_name()),
            None => self.backend.name(),
        }
    }

    pub fn detect(&mut self, img: &RgbImage, opts: &DetectOptions) -> Result<Vec<Detection>> {
        let pre = preprocess(img);
        let c = self.collect(img, &pre, opts.min_score, None)?;
        self.detections(&c, opts)
    }

    fn faces(&mut self, img: &RgbImage, min_score: f32) -> Result<Vec<(f32, [f32; 4])>> {
        self.faces.as_mut().map_or(Ok(vec![]), |f| f.detect(img, min_score))
    }

    /// Candidates scoring at least `min_score` on `img`, before NMS, to pass
    /// to [`Detector::detections`] and later to [`Detector::redetect`].
    pub fn candidates(&mut self, img: &RgbImage, min_score: f32) -> Result<Candidates> {
        let pre = preprocess(img);
        self.collect(img, &pre, min_score, Some(blake3::hash(img.as_raw())))
    }

    /// Candidates on `out`, given `prev` from [`Detector::candidates`] on
    /// `src`: runs of the graph whose input `out` leaves unchanged keep their
    /// candidates, so the result equals a full run on `out`. Runs everything
    /// when `prev` is from another image or detector.
    pub fn redetect(&mut self, prev: &Candidates, src: &RgbImage, out: &RgbImage) -> Result<Candidates> {
        let pre = preprocess(out);
        let same = prev.detector == self.id
            && src.dimensions() == out.dimensions()
            && prev.size == src.dimensions()
            && prev.image == Some(blake3::hash(src.as_raw()));
        if !same {
            return self.collect(out, &pre, prev.min_score, None);
        }
        let plan = self.plan(&pre)?;
        let dirty = changed_rows(src, out, pre.tensor.dim().2);
        let rows = self.meta.input_size.map_or(dirty.len(), |[_, th]| th as usize);
        let runs = plan
            .into_iter()
            .zip(&prev.runs)
            .map(|((top, own), old)| {
                if dirty[top..(top + rows).min(dirty.len())].contains(&true) {
                    self.run(&pre, top, own, prev.min_score)
                } else {
                    Ok(old.clone())
                }
            })
            .collect::<Result<_>>()?;
        // One run over the whole image: rerun on any change.
        let faces = if dirty.contains(&true) {
            self.faces(out, prev.min_score)?
        } else {
            prev.faces.clone()
        };
        Ok(Candidates {
            detector: self.id,
            image: None,
            size: out.dimensions(),
            scale: pre.scale,
            min_score: prev.min_score,
            runs,
            faces,
        })
    }

    /// Runs every run of the graph over `pre`, made from `img`, and the face
    /// detector over `img`.
    fn collect(
        &mut self,
        img: &RgbImage,
        pre: &Preprocessed,
        min_score: f32,
        image: Option<blake3::Hash>,
    ) -> Result<Candidates> {
        let runs = self
            .plan(pre)?
            .into_iter()
            .map(|(top, own)| self.run(pre, top, own, min_score))
            .collect::<Result<_>>()?;
        Ok(Candidates {
            detector: self.id,
            image,
            size: img.dimensions(),
            scale: pre.scale,
            min_score,
            runs,
            faces: self.faces(img, min_score)?,
        })
    }

    /// Final detections from `c`, which this detector made with a
    /// `min_score` at most `opts.min_score`: original-image pixels, then NMS.
    /// A face inside an avatar keeps its own box, so unselecting the avatar
    /// leaves the face selected.
    pub fn detections(&self, c: &Candidates, opts: &DetectOptions) -> Result<Vec<Detection>> {
        if c.detector != self.id {
            return Err(Error::Meta("candidates from another detector".into()));
        }
        if opts.min_score < c.min_score {
            return Err(Error::Meta(format!(
                "min_score {} below the candidates' {}",
                opts.min_score, c.min_score
            )));
        }
        let (w, h) = (c.size.0 as f32, c.size.1 as f32);
        let cands = c
            .runs
            .iter()
            .flatten()
            .filter(|&&(_, score, _)| score >= opts.min_score)
            .map(|&(k, score, b)| Detection {
                class: self.meta.classes[k].clone(),
                class_id: k,
                score,
                bbox: [
                    (b[0] * c.scale).clamp(0.0, w),
                    (b[1] * c.scale).clamp(0.0, h),
                    (b[2] * c.scale).clamp(0.0, w),
                    (b[3] * c.scale).clamp(0.0, h),
                ],
            })
            .collect::<Vec<_>>();
        let faces = c
            .faces
            .iter()
            .filter(|f| f.0 >= opts.min_score)
            .map(|&(score, b)| Detection {
                class: FACE.into(),
                class_id: self.meta.classes.len(),
                score,
                bbox: [
                    b[0].clamp(0.0, w),
                    b[1].clamp(0.0, h),
                    b[2].clamp(0.0, w),
                    b[3].clamp(0.0, h),
                ],
            });
        let mut dets = nms(cands.into_iter().chain(faces).collect(), opts.iou);
        dets.truncate(opts.max_detections);
        Ok(dets)
    }

    /// Top row and owned y range of each run of the graph over `pre`.
    fn plan(&self, pre: &Preprocessed) -> Result<Vec<(usize, (f32, f32))>> {
        let (_, _, ph, pw) = pre.tensor.dim();
        let Some([tw, th]) = self.meta.input_size else {
            return Ok(vec![(0, (f32::NEG_INFINITY, f32::INFINITY))]);
        };
        let (tw, th) = (tw as usize, th as usize);
        if pw != tw || th <= TILE_OVERLAP {
            return Err(Error::Meta(format!(
                "input_size {tw}x{th} does not fit inputs {pw} wide"
            )));
        }
        Ok(tile_plan(ph, th)
            .into_iter()
            .map(|(top, lo, hi)| (top, (lo, hi)))
            .collect())
    }

    /// Runs the graph on `pre` from row `top` (the whole input for a
    /// dynamic-height graph, else one tile).
    fn run(
        &mut self,
        pre: &Preprocessed,
        top: usize,
        own: (f32, f32),
        min_score: f32,
    ) -> Result<Vec<(usize, f32, [f32; 4])>> {
        let out = match self.meta.input_size {
            None => self.backend.run(pre.tensor.view())?,
            Some([tw, th]) => {
                let (tw, th, ph) = (tw as usize, th as usize, pre.tensor.dim().2);
                // Short images are padded with zeros (the mean colour).
                let mut tile = Array4::<f32>::zeros((1, 3, th, tw));
                let rows = th.min(ph - top);
                tile.slice_mut(s![.., .., ..rows, ..])
                    .assign(&pre.tensor.slice(s![.., .., top..top + rows, ..]));
                self.backend.run(tile.view())?
            }
        };
        let mut raw = Vec::new();
        self.decode(&out, top, own, min_score, &mut raw)?;
        Ok(raw)
    }

    /// Decodes one run's outputs (see [`RawOutput`]) into candidates in model
    /// pixels, shifted down by `top`, keeping those whose centre lies in `own`.
    /// Mirrors the training code's decoding.
    fn decode(
        &self,
        out: &RawOutput,
        top: usize,
        own: (f32, f32),
        min_score: f32,
        raw: &mut Vec<(usize, f32, [f32; 4])>,
    ) -> Result<()> {
        let c = self.meta.classes.len();
        if out.outputs.len() != 2 * self.meta.strides.len() {
            return Err(Error::Shape(format!(
                "{} outputs for {} strides",
                out.outputs.len(),
                self.meta.strides.len()
            )));
        }
        for (level, &stride) in self.meta.strides.iter().enumerate() {
            let (scores, boxes) = (
                view4(&out.outputs[2 * level], stride)?,
                view4(&out.outputs[2 * level + 1], stride)?,
            );
            let (_, sc, h, w) = scores.dim();
            if sc != c || boxes.dim() != (1, 4, h, w) {
                return Err(Error::Shape(format!(
                    "stride {stride}: scores {:?}, boxes {:?}, {c} classes",
                    scores.dim(),
                    boxes.dim()
                )));
            }
            let s = stride as f32;
            for y in 0..h {
                for x in 0..w {
                    let (cx, cy) = ((x as f32 + 0.5) * s, (y as f32 + 0.5) * s + top as f32);
                    let mut bbox = None;
                    for k in 0..c {
                        let score = scores[[0, k, y, x]];
                        if score < min_score {
                            continue;
                        }
                        let b = *bbox.get_or_insert_with(|| {
                            let d = |i: usize| softplus(boxes[[0, i, y, x]]) * s;
                            [cx - d(0), cy - d(1), cx + d(2), cy + d(3)]
                        });
                        let centre = (b[1] + b[3]) / 2.0;
                        if centre >= own.0 && centre < own.1 {
                            raw.push((k, score, b));
                        }
                    }
                }
            }
        }
        Ok(())
    }
}

fn view4(a: &ndarray::ArrayD<f32>, stride: u32) -> Result<ndarray::ArrayView4<'_, f32>> {
    a.view()
        .into_dimensionality()
        .map_err(|e| Error::Shape(format!("stride {stride}: {e}")))
}

/// Class-wise greedy NMS. Output is sorted by descending score.
pub fn nms(mut dets: Vec<Detection>, iou_thr: f32) -> Vec<Detection> {
    dets.sort_by(|a, b| b.score.total_cmp(&a.score));
    let mut keep: Vec<Detection> = Vec::with_capacity(dets.len().min(512));
    for d in dets {
        if keep
            .iter()
            .all(|k| k.class_id != d.class_id || iou(&k.bbox, &d.bbox) <= iou_thr)
        {
            keep.push(d);
        }
    }
    keep
}

#[cfg(test)]
mod tests {
    use std::sync::Arc;
    use std::sync::atomic::AtomicUsize;

    use image::Rgb;
    use ndarray::{Array4, ArrayView4};

    use super::*;

    /// Scores from each cell's mean per channel plus the input's overall
    /// mean, so any change in a run's input moves all of its outputs.
    struct Fake(Arc<AtomicUsize>);

    impl Backend for Fake {
        fn name(&self) -> String {
            "fake".into()
        }

        fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
            self.0.fetch_add(1, Ordering::Relaxed);
            let (_, _, h, w) = input.dim();
            let all = input.mean().unwrap_or(0.0);
            let mut outputs = Vec::new();
            let px = input.as_standard_layout();
            let px = px.as_slice().expect("contiguous");
            for stride in [8, 16] {
                let (oh, ow) = (h / stride, w / stride);
                let mut cell = vec![0f32; 3 * oh * ow];
                for (row, line) in px.chunks_exact(w).enumerate() {
                    let (c, y) = (row / h, row % h / stride);
                    for (x, v) in line.iter().enumerate() {
                        cell[(c * oh + y) * ow + x / stride] += v;
                    }
                }
                let at = |c: usize, y: usize, x: usize| cell[(c * oh + y) * ow + x] / (stride * stride) as f32;
                outputs.push(
                    Array4::from_shape_fn((1, 2, oh, ow), |(_, k, y, x)| {
                        (((at(k, y, x) * 13.7 + 0.01 * all).sin() - 0.9995) * 2000.0).clamp(0.0, 1.0)
                    })
                    .into_dyn(),
                );
                outputs.push(
                    Array4::from_shape_fn((1, 4, oh, ow), |(_, i, y, x)| at(2, y, x) + i as f32 * 0.1).into_dyn(),
                );
            }
            Ok(RawOutput { outputs })
        }
    }

    fn fake(input_size: Option<[u32; 2]>) -> (Detector, Arc<AtomicUsize>) {
        let meta = ModelMeta {
            classes: vec!["a".into(), "b".into()],
            strides: vec![8, 16],
            input_size,
            calibration: None,
        };
        let runs = Arc::new(AtomicUsize::new(0));
        (Detector::new(meta, Box::new(Fake(Arc::clone(&runs)))), runs)
    }

    fn key(d: &[Detection]) -> Vec<(usize, u32, [u32; 4])> {
        d.iter()
            .map(|d| (d.class_id, d.score.to_bits(), d.bbox.map(f32::to_bits)))
            .collect()
    }

    fn page(w: u32, h: u32) -> RgbImage {
        RgbImage::from_fn(w, h, |x, y| {
            let text = (y / 37) % 3 == 0 && (x / 9 + y / 5) % 4 != 0;
            if text {
                Rgb([10, 10, 20])
            } else {
                Rgb([(x % 211) as u8, (y % 199) as u8, ((x * y) % 253) as u8])
            }
        })
    }

    #[test]
    fn redetect_equals_a_full_run() {
        let opts = DetectOptions::default();
        for (input_size, size) in [
            (Some([736, 768]), (1290, 2400)),
            (Some([736, 768]), (390, 700)),
            (None, (1290, 1600)),
        ] {
            let (mut det, runs) = fake(input_size);
            let src = page(size.0, size.1);
            let prev = det.candidates(&src, opts.min_score).unwrap();
            let before = key(&det.detections(&prev, &opts).unwrap());
            let full_runs = runs.swap(0, Ordering::Relaxed);
            // One box inside a tile, one across a tile boundary.
            for boxes in [
                vec![[40.0, 300.0, 300.0, 340.0]],
                vec![[40.0, 300.0, 300.0, 340.0], [10.0, 900.0, 380.0, 960.0]],
            ] {
                let mut out = src.clone();
                crate::redact(&mut out, &boxes, 2.0, crate::RedactStyle::Noise { seed: 1 });
                let want = det.detect(&out, &opts).unwrap();
                runs.store(0, Ordering::Relaxed);
                let c = det.redetect(&prev, &src, &out).unwrap();
                let got = det.detections(&c, &opts).unwrap();
                assert_eq!(key(&got), key(&want), "{input_size:?} {size:?}");
                // Redaction changes what the detector sees.
                assert!(!want.is_empty() && key(&want) != before);
                let reran = runs.swap(0, Ordering::Relaxed);
                if input_size.is_some() && size.1 > 2000 {
                    assert!(reran < full_runs, "{reran} of {full_runs} runs");
                }
            }
            // Candidates from another image are not reused.
            let other = page(size.0, size.1 + 1);
            let mut out = src.clone();
            out.put_pixel(0, 0, Rgb([1, 2, 3]));
            let stale = det.candidates(&other, opts.min_score).unwrap();
            let c = det.redetect(&stale, &src, &out).unwrap();
            let got = det.detections(&c, &opts).unwrap();
            assert_eq!(key(&got), key(&det.detect(&out, &opts).unwrap()));
            // Nor are another detector's: the fallback is one full run.
            let (mut twin, twin_runs) = fake(input_size);
            let theirs = twin.candidates(&src, opts.min_score).unwrap();
            let full = twin_runs.swap(0, Ordering::Relaxed);
            runs.store(0, Ordering::Relaxed);
            let c = det.redetect(&theirs, &src, &out).unwrap();
            assert_eq!(runs.load(Ordering::Relaxed), full);
            let got = det.detections(&c, &opts).unwrap();
            assert_eq!(key(&got), key(&det.detect(&out, &opts).unwrap()));
        }
    }

    /// One `avatar` box on the stride-32 cell (1, 1): xyxy (16, 16, 80, 80) in
    /// model pixels, scored `score` (none on inputs under 64 px tall).
    struct Avatar(f32);

    impl Backend for Avatar {
        fn name(&self) -> String {
            "avatar".into()
        }

        fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
            let (_, _, h, w) = input.dim();
            let (oh, ow) = (h / 32, w / 32);
            let mut scores = Array4::<f32>::zeros((1, 1, oh, ow));
            if oh > 1 {
                scores[[0, 0, 1, 1]] = self.0;
            }
            // softplus(x) * 32 = 32: x = ln(e - 1).
            let boxes = Array4::from_elem((1, 4, oh, ow), (std::f32::consts::E - 1.0).ln());
            Ok(RawOutput {
                outputs: vec![scores.into_dyn(), boxes.into_dyn()],
            })
        }
    }

    fn with_faces(avatar: f32) -> (Detector, crate::face::tests::Sizes) {
        let meta = ModelMeta {
            classes: vec!["avatar".into()],
            strides: vec![32],
            input_size: None,
            calibration: None,
        };
        let runs = Arc::default();
        let faces = FaceDetector::new(Box::new(crate::face::tests::Fake(Arc::clone(&runs))));
        (Detector::new(meta, Box::new(Avatar(avatar))).with_faces(faces), runs)
    }

    #[test]
    fn faces_are_detections_of_their_own_class() {
        // 720 wide: model pixels are image pixels. The fake's native face is
        // (16, 0, 48, 32), inside no avatar; the 640 pass finds it again at
        // (18, 0, 54, 36) and NMS keeps one.
        let (mut det, _) = with_faces(0.0);
        assert_eq!(det.classes(), ["avatar", FACE]);
        let dets = det.detect(&RgbImage::new(720, 400), &DetectOptions::default()).unwrap();
        let faces: Vec<_> = dets.iter().filter(|d| d.class == FACE).collect();
        assert_eq!(faces.len(), 1);
        assert!(
            faces
                .iter()
                .all(|d| d.class_id == 1 && det.selection(d) == Selection::Selected)
        );
        assert!(det.backend_name().contains("faces fake"));
    }

    #[test]
    fn threshold_presets_scale_the_thresholds() {
        let (mut det, _) = with_faces(0.0);
        let img = RgbImage::new(720, 400);
        let dets = det.detect(&img, &DetectOptions::default()).unwrap();
        let mut face = dets.into_iter().find(|d| d.class == FACE).unwrap();
        let (select, _) = det.thresholds(FACE);
        face.score = select;
        assert_eq!(det.selection(&face), Selection::Selected);
        det.set_threshold(Threshold::High);
        assert_ne!(det.selection(&face), Selection::Selected);
        face.score = select * 0.8;
        det.set_threshold(Threshold::Medium);
        assert_ne!(det.selection(&face), Selection::Selected);
        det.set_threshold(Threshold::Low);
        assert_eq!(det.selection(&face), Selection::Selected);
    }

    #[test]
    fn an_off_class_is_suggested_and_skipped_by_the_export_check() {
        let (mut det, _) = with_faces(0.0);
        let img = RgbImage::new(720, 400);
        let style = crate::RedactStyle::Solid(image::Rgb([0, 0, 0]));
        let faces_left = |det: &mut Detector| {
            let check = crate::export_check(det, &img, &img, None, &[], 0.0, style).unwrap();
            check.surviving.iter().filter(|d| d.class == FACE).count()
        };
        assert_eq!(faces_left(&mut det), 1);
        det.set_off([FACE.to_string()]);
        let dets = det.detect(&img, &DetectOptions::default()).unwrap();
        let face = dets.iter().find(|d| d.class == FACE).unwrap();
        assert_eq!(det.selection(face), Selection::Suggested);
        assert_eq!(faces_left(&mut det), 0);
    }

    #[test]
    fn a_face_inside_a_selected_avatar_keeps_its_box() {
        // The fake's face (16, 0, 48, 32) lies within the avatar
        // (16, 16, 80, 80) grown over it: unselecting the avatar must leave
        // the face to redact.
        struct Big;
        impl Backend for Big {
            fn name(&self) -> String {
                "big".into()
            }
            fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
                let (_, _, h, w) = input.dim();
                let mut scores = Array4::<f32>::zeros((1, 1, h / 32, w / 32));
                scores[[0, 0, 0, 0]] = 0.9;
                // Centre (16, 16), 96 px each way: (0, 0, 112, 112) clamped.
                let boxes = Array4::from_elem((1, 4, h / 32, w / 32), 3f32.exp_m1().ln());
                Ok(RawOutput {
                    outputs: vec![scores.into_dyn(), boxes.into_dyn()],
                })
            }
        }
        let meta = ModelMeta {
            classes: vec!["avatar".into()],
            strides: vec![32],
            input_size: None,
            calibration: None,
        };
        let faces = FaceDetector::new(Box::new(crate::face::tests::Fake(Arc::default())));
        let mut det = Detector::new(meta, Box::new(Big)).with_faces(faces);
        let dets = det.detect(&RgbImage::new(720, 400), &DetectOptions::default()).unwrap();
        let mut classes: Vec<&str> = dets.iter().map(|d| d.class.as_str()).collect();
        classes.sort();
        assert_eq!(classes, ["avatar", FACE]);
    }

    #[test]
    fn face_boxes_stay_inside_the_image() {
        // The fake's 640-pass face on a 40 px tall image runs past its bottom.
        let (mut det, _) = with_faces(0.0);
        let img = RgbImage::new(720, 20);
        for d in det.detect(&img, &DetectOptions::default()).unwrap() {
            assert!(
                d.bbox[0] >= 0.0 && d.bbox[1] >= 0.0 && d.bbox[2] <= 720.0 && d.bbox[3] <= 20.0,
                "{:?}",
                d.bbox
            );
        }
    }

    #[test]
    fn redetect_reuses_faces_only_on_an_unchanged_image() {
        let (mut det, runs) = with_faces(0.9);
        let opts = DetectOptions::default();
        let src = page(720, 400);
        let prev = det.candidates(&src, opts.min_score).unwrap();
        let first = runs.lock().unwrap().len();
        let same = det.redetect(&prev, &src, &src.clone()).unwrap();
        assert_eq!(runs.lock().unwrap().len(), first, "unchanged: no face run");
        assert_eq!(
            key(&det.detections(&same, &opts).unwrap()),
            key(&det.detections(&prev, &opts).unwrap())
        );
        let mut out = src.clone();
        out.put_pixel(5, 5, Rgb([1, 2, 3]));
        det.redetect(&prev, &src, &out).unwrap();
        assert_eq!(runs.lock().unwrap().len(), 2 * first, "changed: faces rerun");
    }

    #[test]
    fn detections_reject_candidates_they_cannot_finish() {
        let (mut a, _) = fake(None);
        let (b, _) = fake(None);
        let c = a.candidates(&page(390, 300), 0.2).unwrap();
        let opts = DetectOptions::default();
        assert!(
            b.detections(
                &c,
                &DetectOptions {
                    min_score: 0.2,
                    ..opts.clone()
                }
            )
            .is_err()
        );
        assert!(a.detections(&c, &opts).is_err(), "min_score 0.05 below 0.2");
        assert!(a.detections(&c, &DetectOptions { min_score: 0.3, ..opts }).is_ok());
    }

    #[test]
    fn changed_rows_cover_every_changed_input_row() {
        for (w, h) in [(1290, 1300), (390, 500), (2160, 1500), (720, 400)] {
            let a = page(w, h);
            for y in [0, h / 3, h - 1] {
                let mut b = a.clone();
                for x in 0..w {
                    b.put_pixel(x, y, Rgb([255, 0, 255]));
                }
                let (ta, tb) = (preprocess(&a).tensor, preprocess(&b).tensor);
                let dirty = changed_rows(&a, &b, ta.dim().2);
                for (row, &d) in dirty.iter().enumerate() {
                    if !d {
                        assert_eq!(
                            ta.slice(s![.., .., row, ..]),
                            tb.slice(s![.., .., row, ..]),
                            "{w}x{h}, source row {y}, model row {row}"
                        );
                    }
                }
                // The margin stays small.
                assert!(dirty.iter().filter(|&&d| d).count() <= 16, "{w}x{h}");
            }
        }
    }

    fn d(class_id: usize, score: f32, bbox: [f32; 4]) -> Detection {
        Detection {
            class: String::new(),
            class_id,
            score,
            bbox,
        }
    }

    #[test]
    fn tiles_cover_the_input_and_own_disjoint_ranges() {
        assert_eq!(tile_plan(1000, 1280), vec![(0, f32::NEG_INFINITY, f32::INFINITY)]);
        let plan = tile_plan(3000, 1280);
        let tops: Vec<usize> = plan.iter().map(|p| p.0).collect();
        assert_eq!(tops, vec![0, 896, 1720]);
        // Last tile ends at the bottom; ranges chain without gaps.
        assert_eq!(tops[2] + 1280, 3000);
        for w in plan.windows(2) {
            assert_eq!(w[0].2, w[1].1);
            // Each cut leaves at least half the overlap on both sides.
            let (prev_end, next_top) = ((w[0].0 + 1280) as f32, w[1].0 as f32);
            assert!(w[0].2 - next_top >= TILE_OVERLAP as f32 / 2.0 && prev_end - w[0].2 >= TILE_OVERLAP as f32 / 2.0);
        }
    }

    #[test]
    fn nms_suppresses_same_class_only() {
        let out = nms(
            vec![
                d(0, 0.5, [0., 0., 10., 10.]),
                d(0, 0.9, [1., 1., 10., 10.]),
                d(1, 0.8, [0., 0., 10., 10.]),
            ],
            0.5,
        );
        let got: Vec<_> = out.iter().map(|x| (x.class_id, x.score)).collect();
        assert_eq!(got, vec![(0, 0.9), (1, 0.8)]);
    }
}

use std::borrow::Cow;
use std::collections::HashSet;
use std::sync::atomic::{AtomicU64, Ordering};

use image::RgbImage;
use serde::Serialize;

use crate::eval::iou;
use crate::model::resize;
use crate::{
    Backend, Error, FACE, FaceDetector, ModelMeta, RawOutput, Resolution, Result, scale_for, scaled_size, shape_for,
    tensor,
};

/// Horizontal overlap between neighbouring tiles, in pixels.
/// Wide enough that horizontal text lines (emails, addresses, card numbers)
/// stay whole in the tile that owns them.
pub const TILE_OVERLAP_X: usize = 384;
/// Vertical overlap between neighbouring tiles, in pixels.
/// Smaller than horizontal overlap because UI text rows and small icons are
/// short (>99.8% of non-person boxes are <= 192 px tall), cutting tile count
/// on long screenshots and tablets.
pub const TILE_OVERLAP_Y: usize = 192;
/// Maximum tile overlap across axes (kept for validation and compatibility).
pub const TILE_OVERLAP: usize = if TILE_OVERLAP_X >= TILE_OVERLAP_Y {
    TILE_OVERLAP_X
} else {
    TILE_OVERLAP_Y
};
/// Largest side a dynamic graph runs on at once: the training crop size, so
/// attention sees the token counts it was trained on and memory stays bounded.
pub const DYNAMIC_TILE: usize = 1280;

/// Starts of the tiles covering a `len`-long axis with `tile`-long tiles and
/// `overlap` pixels of overlap, each with the range it owns: a detection is
/// kept only by the tile whose range holds its centre, and ranges split each
/// overlap down the middle.
pub(crate) fn tile_plan(len: usize, tile: usize, overlap: usize) -> Vec<(usize, f32, f32)> {
    if len <= tile {
        return vec![(0, f32::NEG_INFINITY, f32::INFINITY)];
    }
    assert!(tile > overlap, "tile {tile} must exceed overlap {overlap}");
    let step = tile - overlap;
    let mut tops: Vec<usize> = (0..).map(|i| i * step).take_while(|&y| y + tile < len).collect();
    tops.push(len - tile);
    let cut = |i: usize| (tops[i + 1] + tops[i] + tile) as f32 / 2.0;
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
    /// Size of the graph input `size` was scaled to.
    input: (u32, u32),
    /// Original over graph-input pixels, per axis: above 1 when the image was
    /// scaled down for the graph ([`Resolution::Pt2`]).
    scale: [f32; 2],
    min_score: f32,
    /// Per run of the graph: (class, score, xyxy in graph-input pixels).
    runs: Vec<Vec<(usize, f32, [f32; 4])>>,
    /// (score, xyxy in original pixels) from the face detector, if any.
    faces: Vec<(f32, [f32; 4])>,
}

impl Candidates {
    pub fn min_score(&self) -> f32 {
        self.min_score
    }
}

/// One run of the graph: the window at (`x`, `y`) of the graph's input size
/// (the padded image for a dynamic graph), and the x and y ranges whose
/// detection centres it keeps, in graph-input pixels.
#[derive(Debug, Clone, Copy, PartialEq)]
struct Tile {
    x: usize,
    y: usize,
    w: usize,
    h: usize,
    own_x: (f32, f32),
    own_y: (f32, f32),
}

/// `a` and `b` (same size) differ inside the original pixels tile `t` of
/// an image scaled by `scale` (original over graph-input pixels) is made
/// from: its window, widened by the resize filter's reach when scaled.
fn changed(a: &RgbImage, b: &RgbImage, t: &Tile, scale: [f32; 2]) -> bool {
    let (w, h) = (a.width() as usize, a.height() as usize);
    let span = |p: usize, n: usize, k: f32, len: usize| {
        // Bilinear downscaling by k reads k pixels either side.
        let pad = if k > 1.0 { (2.0 * k).ceil() as usize + 1 } else { 0 };
        let lo = ((p as f32 * k).floor() as usize).saturating_sub(pad);
        let hi = (((p + n) as f32 * k).ceil() as usize + pad).min(len);
        (lo.min(hi), hi)
    };
    let (x0, x1) = span(t.x, t.w, scale[0], w);
    let (y0, y1) = span(t.y, t.h, scale[1], h);
    (y0..y1).any(|y| {
        let r = (y * w + x0) * 3..(y * w + x1) * 3;
        a.as_raw()[r.clone()] != b.as_raw()[r]
    })
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

    /// Unscaled `select` threshold for every class, including the built-in
    /// face detector when loaded.
    pub fn base_select_thresholds(&self) -> std::collections::HashMap<String, f32> {
        self.classes()
            .into_iter()
            .map(|c| {
                let select = match &self.faces {
                    Some(f) if c == FACE => f.select,
                    _ => self.meta.thresholds(&c).0,
                };
                (c, select)
            })
            .collect()
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
        let c = self.collect(img, opts.min_score, None)?;
        self.detections(&c, opts)
    }

    /// Candidates scoring at least `min_score` on `img`, before NMS, to pass
    /// to [`Detector::detections`] and later to [`Detector::redetect`].
    pub fn candidates(&mut self, img: &RgbImage, min_score: f32) -> Result<Candidates> {
        self.collect(img, min_score, Some(blake3::hash(img.as_raw())))
    }

    /// Candidates on `out`, given `prev` from [`Detector::candidates`] on
    /// `src`: runs of the graph whose window `out` leaves unchanged keep their
    /// candidates, so the result equals a full run on `out`. Runs everything
    /// when `prev` is from another image or detector.
    pub fn redetect(&mut self, prev: &Candidates, src: &RgbImage, out: &RgbImage) -> Result<Candidates> {
        let same = prev.detector == self.id
            && src.dimensions() == out.dimensions()
            && prev.size == src.dimensions()
            && prev.image == Some(blake3::hash(src.as_raw()));
        if !same {
            return self.collect(out, prev.min_score, Some(blake3::hash(out.as_raw())));
        }
        let plan = self.plan(prev.input.0, prev.input.1);
        let dirty: Vec<bool> = plan.iter().map(|t| changed(src, out, t, prev.scale)).collect();
        if !dirty.iter().any(|&d| d) {
            return Ok(Candidates {
                detector: self.id,
                image: prev.image,
                size: out.dimensions(),
                input: prev.input,
                scale: prev.scale,
                min_score: prev.min_score,
                runs: prev.runs.clone(),
                faces: prev.faces.clone(),
            });
        }
        let input = self.input(out);
        let (runs, faces) = match &mut self.faces {
            Some(face_det) => {
                let backend = self.backend.as_mut();
                let meta = &self.meta;
                std::thread::scope(|s| {
                    let fh = s.spawn(|| face_det.detect(out, prev.min_score));
                    let mut runs = Vec::with_capacity(prev.runs.len());
                    for ((t, old), is_dirty) in plan.iter().zip(&prev.runs).zip(&dirty) {
                        if *is_dirty {
                            runs.push(run_tile(backend, meta, &input, t, prev.min_score)?);
                        } else {
                            runs.push(old.clone());
                        }
                    }
                    let faces = fh
                        .join()
                        .map_err(|_| Error::Backend("face detector thread panicked".into()))??;
                    Ok::<_, Error>((runs, faces))
                })?
            }
            None => {
                let mut runs = Vec::with_capacity(prev.runs.len());
                for ((t, old), is_dirty) in plan.iter().zip(&prev.runs).zip(&dirty) {
                    if *is_dirty {
                        runs.push(run_tile(self.backend.as_mut(), &self.meta, &input, t, prev.min_score)?);
                    } else {
                        runs.push(old.clone());
                    }
                }
                (runs, Vec::new())
            }
        };
        Ok(Candidates {
            detector: self.id,
            image: Some(blake3::hash(out.as_raw())),
            size: out.dimensions(),
            input: prev.input,
            scale: prev.scale,
            min_score: prev.min_score,
            runs,
            faces,
        })
    }

    /// Incremental detection for sequential frames (e.g. video keyframes):
    /// reuses unchanged tiles from `prev`, falling back to a full run on the
    /// first frame or if dimensions differ. Returns detections and the new
    /// [`Candidates`] for chaining into the next frame.
    pub fn detect_next(
        &mut self,
        prev: Option<(&RgbImage, &Candidates)>,
        img: &RgbImage,
        opts: &DetectOptions,
    ) -> Result<(Vec<Detection>, Candidates)> {
        let c = match prev {
            Some((src, prev_c)) if prev_c.min_score <= opts.min_score => self.redetect(prev_c, src, img)?,
            _ => self.candidates(img, opts.min_score)?,
        };
        let dets = self.detections(&c, opts)?;
        Ok((dets, c))
    }

    /// `img` as the graph sees it: scaled down for a [`Resolution::Pt2`]
    /// model, else itself.
    fn input<'a>(&self, img: &'a RgbImage) -> Cow<'a, RgbImage> {
        let (w, h) = img.dimensions();
        let s = match self.meta.resolution {
            Resolution::Native => 1.0,
            Resolution::Pt2 => scale_for(w, h),
        };
        if s < 1.0 {
            let (sw, sh) = scaled_size(w, h, s);
            Cow::Owned(resize(img, sw, sh))
        } else {
            Cow::Borrowed(img)
        }
    }

    /// Runs every run of the graph and the face detector over `img`.
    fn collect(&mut self, img: &RgbImage, min_score: f32, image: Option<blake3::Hash>) -> Result<Candidates> {
        let input = self.input(img);
        let plan = self.plan(input.width(), input.height());
        let (runs, faces) = match &mut self.faces {
            Some(face_det) => {
                // Main detector (GPU/ANE) and YuNet (CPU) use disjoint
                // hardware; overlap them to hide face detection latency.
                let backend = self.backend.as_mut();
                let meta = &self.meta;
                std::thread::scope(|s| {
                    let fh = s.spawn(|| face_det.detect(img, min_score));
                    let runs = plan
                        .iter()
                        .map(|t| run_tile(backend, meta, &input, t, min_score))
                        .collect::<Result<Vec<_>>>();
                    let faces = fh
                        .join()
                        .map_err(|_| Error::Backend("face detector thread panicked".into()))??;
                    Ok::<_, Error>((runs?, faces))
                })?
            }
            None => {
                let runs = plan
                    .iter()
                    .map(|t| run_tile(self.backend.as_mut(), &self.meta, &input, t, min_score))
                    .collect::<Result<Vec<_>>>()?;
                (runs, Vec::new())
            }
        };
        let (w, h) = img.dimensions();
        Ok(Candidates {
            detector: self.id,
            image,
            size: (w, h),
            input: input.dimensions(),
            scale: [w as f32 / input.width() as f32, h as f32 / input.height() as f32],
            min_score,
            runs,
            faces,
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
        let [kx, ky] = c.scale;
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
                    (b[0] * kx).clamp(0.0, w),
                    (b[1] * ky).clamp(0.0, h),
                    (b[2] * kx).clamp(0.0, w),
                    (b[3] * ky).clamp(0.0, h),
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
        let mut dets = self.drop_covered(nms(cands.into_iter().chain(faces).collect(), opts.iou));
        dets.truncate(opts.max_detections);
        Ok(dets)
    }

    /// `dets` (sorted by score) without the boxes another box covers almost
    /// wholly and outranks. Class-wise NMS keeps a value read as two classes,
    /// and a line with its fragments; the outranking box masks the same
    /// pixels and is pre-selected whenever they would be: rank is the score
    /// over its class's select threshold, classes switched off ranking last.
    /// Faces keep their own boxes (inside an avatar, say).
    fn drop_covered(&self, dets: Vec<Detection>) -> Vec<Detection> {
        let rank = |d: &Detection| (!self.off.contains(&d.class), d.score / self.thresholds(&d.class).0);
        let mut order: Vec<usize> = (0..dets.len()).collect();
        order.sort_by(|&a, &b| rank(&dets[b]).partial_cmp(&rank(&dets[a])).expect("finite scores"));
        let mut keep = vec![true; dets.len()];
        for (i, &a) in order.iter().enumerate() {
            if dets[a].class == FACE {
                continue;
            }
            keep[a] = !order[..i]
                .iter()
                .any(|&b| keep[b] && dets[b].class != FACE && covered(&dets[a].bbox, &dets[b].bbox));
        }
        dets.into_iter().zip(keep).filter_map(|(d, k)| k.then_some(d)).collect()
    }

    /// The runs of the graph over a `w`x`h` graph input: a grid of
    /// overlapping tiles of the graph's input size, of the shape
    /// [`shape_for`] picks ([`Resolution::Pt2`]), or for another dynamic
    /// graph of up to [`DYNAMIC_TILE`] (sides of a smaller image padded to a
    /// multiple of 32).
    fn plan(&self, w: u32, h: u32) -> Vec<Tile> {
        let (tw, th) = match (self.meta.input_size, self.meta.resolution) {
            (Some([tw, th]), _) => (tw as usize, th as usize),
            (None, Resolution::Pt2) => {
                let [tw, th] = shape_for(w, h, &self.meta.shapes);
                (tw as usize, th as usize)
            }
            (None, Resolution::Native) => (
                DYNAMIC_TILE.min((w as usize).div_ceil(32) * 32),
                DYNAMIC_TILE.min((h as usize).div_ceil(32) * 32),
            ),
        };
        let (w, h) = (w as usize, h as usize);
        let cols = tile_plan(w, tw, TILE_OVERLAP_X);
        tile_plan(h, th, TILE_OVERLAP_Y)
            .into_iter()
            .flat_map(|(y, ylo, yhi)| {
                cols.iter().map(move |&(x, xlo, xhi)| Tile {
                    x,
                    y,
                    w: tw,
                    h: th,
                    own_x: (xlo, xhi),
                    own_y: (ylo, yhi),
                })
            })
            .collect()
    }
}

/// Runs `backend` on tile `t` of `img` and decodes candidates into image
/// pixels, keeping those whose centre lies in the tile's own ranges.
fn run_tile(
    backend: &mut dyn Backend,
    meta: &ModelMeta,
    img: &RgbImage,
    t: &Tile,
    min_score: f32,
) -> Result<Vec<(usize, f32, [f32; 4])>> {
    let out = backend.run(tensor(img, t.x, t.y, t.w, t.h).view())?;
    let mut raw = Vec::new();
    decode_tile(meta, &out, t, min_score, &mut raw)?;
    Ok(raw)
}

/// Decodes one run's outputs (see [`RawOutput`]) into candidates in image
/// pixels, keeping those whose centre lies in the tile's own ranges.
/// Mirrors the training code's decoding.
fn decode_tile(
    meta: &ModelMeta,
    out: &RawOutput,
    t: &Tile,
    min_score: f32,
    raw: &mut Vec<(usize, f32, [f32; 4])>,
) -> Result<()> {
    let c = meta.classes.len();
    if out.outputs.len() != 2 * meta.strides.len() {
        return Err(Error::Shape(format!(
            "{} outputs for {} strides",
            out.outputs.len(),
            meta.strides.len()
        )));
    }
    for (level, &stride) in meta.strides.iter().enumerate() {
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
                let (cx, cy) = ((x as f32 + 0.5) * s + t.x as f32, (y as f32 + 0.5) * s + t.y as f32);
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
                    let (mx, my) = ((b[0] + b[2]) / 2.0, (b[1] + b[3]) / 2.0);
                    if mx >= t.own_x.0 && mx < t.own_x.1 && my >= t.own_y.0 && my < t.own_y.1 {
                        raw.push((k, score, b));
                    }
                }
            }
        }
    }
    Ok(())
}

fn view4(a: &ndarray::ArrayD<f32>, stride: u32) -> Result<ndarray::ArrayView4<'_, f32>> {
    a.view()
        .into_dimensionality()
        .map_err(|e| Error::Shape(format!("stride {stride}: {e}")))
}

/// Share of `a`'s area inside `b` from which `a` counts as covered.
const COVERED: f32 = 0.9;

fn covered(a: &[f32; 4], b: &[f32; 4]) -> bool {
    let area = (a[2] - a[0]).max(0.0) * (a[3] - a[1]).max(0.0);
    let (w, h) = (a[2].min(b[2]) - a[0].max(b[0]), a[3].min(b[3]) - a[1].max(b[1]));
    area > 0.0 && w > 0.0 && h > 0.0 && w * h >= COVERED * area
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
        fake_at(input_size, Resolution::Native)
    }

    fn fake_at(input_size: Option<[u32; 2]>, resolution: Resolution) -> (Detector, Arc<AtomicUsize>) {
        let meta = ModelMeta {
            classes: vec!["a".into(), "b".into()],
            strides: vec![8, 16],
            input_size,
            shapes: match resolution {
                Resolution::Native => vec![],
                Resolution::Pt2 => crate::SHAPES.to_vec(),
            },
            resolution,
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
        for (input_size, resolution, size) in [
            (Some([736, 768]), Resolution::Native, (1290, 2400)),
            (Some([736, 768]), Resolution::Native, (390, 700)),
            (None, Resolution::Native, (1290, 1600)),
            // Scaled to 786x1709, two 896x1280 tiles.
            (None, Resolution::Pt2, (1206, 2622)),
        ] {
            let (mut det, runs) = fake_at(input_size, resolution);
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
                if size.1 > 2000 && boxes.len() == 1 {
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
            let (mut twin, twin_runs) = fake_at(input_size, resolution);
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
    /// input pixels, scored `score` (none on inputs under 64 px tall).
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
            shapes: vec![],
            resolution: crate::Resolution::Native,
            calibration: None,
        };
        let runs = Arc::default();
        let faces = FaceDetector::new(Box::new(crate::face::tests::Fake(Arc::clone(&runs))));
        (Detector::new(meta, Box::new(Avatar(avatar))).with_faces(faces), runs)
    }

    #[test]
    fn faces_are_detections_of_their_own_class() {
        // The fake's native face is (16, 0, 48, 32), inside no avatar; the
        // 640 pass finds it again at (18, 0, 54, 36) and NMS keeps one.
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
            shapes: vec![],
            resolution: crate::Resolution::Native,
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
    fn scaled_detections_are_in_original_pixels() {
        let meta = ModelMeta {
            classes: vec!["avatar".into()],
            strides: vec![32],
            input_size: None,
            shapes: crate::SHAPES.to_vec(),
            resolution: Resolution::Pt2,
            calibration: None,
        };
        let mut det = Detector::new(meta, Box::new(Avatar(0.9)));
        // A phone screenshot runs at 786x1709: (16, 16, 80, 80) there.
        let d = det.detect(&page(1206, 2622), &DetectOptions::default()).unwrap();
        let near = |d: &[Detection], want: [f32; 4]| {
            assert_eq!(d.len(), 1);
            assert!(
                d[0].bbox.iter().zip(want).all(|(a, b)| (a - b).abs() < 1e-3),
                "{:?}",
                d[0].bbox
            );
        };
        let (kx, ky) = (1206.0 / 786.0, 2622.0 / 1709.0);
        near(&d, [16.0 * kx, 16.0 * ky, 80.0 * kx, 80.0 * ky]);
        // A desktop screenshot is not scaled.
        near(
            &det.detect(&page(1920, 1080), &DetectOptions::default()).unwrap(),
            [16.0, 16.0, 80.0, 80.0],
        );
        let plan = det.plan(5120, 1440);
        assert_eq!(plan.len(), 12);
        assert!(plan.iter().all(|t| (t.w, t.h) == (1280, 896)));
    }

    #[test]
    fn covered_boxes_give_way_to_the_box_that_outranks_them() {
        let (mut det, _) = fake(None);
        let line = d(0, 0.5, [0.0, 0.0, 100.0, 20.0]);
        let part = d(0, 0.4, [50.0, 1.0, 99.0, 19.0]);
        let other_class = d(1, 0.35, [1.0, 0.0, 100.0, 20.0]);
        let apart = d(1, 0.9, [0.0, 50.0, 100.0, 70.0]);
        let classes = det.meta.classes.clone();
        let named = |v: Vec<Detection>| {
            v.into_iter()
                .map(|mut x| {
                    x.class = classes[x.class_id].clone();
                    x
                })
                .collect::<Vec<_>>()
        };
        let got = det.drop_covered(named(vec![apart.clone(), line.clone(), part, other_class]));
        assert_eq!(
            got.iter().map(|x| x.bbox).collect::<Vec<_>>(),
            vec![apart.bbox, line.bbox]
        );
        // A class switched off never outranks one that is on.
        det.set_off(["a".to_string()]);
        let got = det.drop_covered(named(vec![line.clone(), d(1, 0.35, [1.0, 0.0, 100.0, 20.0])]));
        assert_eq!(got.len(), 1);
        assert_eq!(got[0].class, "b");
    }

    #[test]
    fn tiles_own_every_pixel_once() {
        let (det, _) = fake(Some([736, 768]));
        for (w, h) in [(1206, 2622), (2880, 1800), (500, 300), (736, 768)] {
            let plan = det.plan(w, h);
            for (x, y) in [(0, 0), (w - 1, h - 1), (w / 2, h / 3), (w / 3 + 1, h - 2)] {
                let (x, y) = (x as f32 + 0.5, y as f32 + 0.5);
                let owners = plan
                    .iter()
                    .filter(|t| x >= t.own_x.0 && x < t.own_x.1 && y >= t.own_y.0 && y < t.own_y.1)
                    .collect::<Vec<_>>();
                assert_eq!(owners.len(), 1, "{w}x{h} ({x}, {y})");
                let t = owners[0];
                assert!(x >= t.x as f32 && x < (t.x + t.w) as f32 && y >= t.y as f32 && y < (t.y + t.h) as f32);
            }
        }
        // A dynamic graph runs once over a small image padded to 32, and in
        // DYNAMIC_TILE tiles over a large one.
        let (det, _) = fake(None);
        assert_eq!(
            det.plan(1000, 700).iter().map(|t| (t.w, t.h)).collect::<Vec<_>>(),
            vec![(1024, 704)]
        );
        let plan = det.plan(1206, 2622);
        assert_eq!(plan.len(), 3);
        assert!(plan.iter().all(|t| (t.w, t.h) == (1216, DYNAMIC_TILE)));
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
        assert_eq!(
            tile_plan(1000, 1280, TILE_OVERLAP_X),
            vec![(0, f32::NEG_INFINITY, f32::INFINITY)]
        );
        let plan = tile_plan(3000, 1280, TILE_OVERLAP_X);
        let tops: Vec<usize> = plan.iter().map(|p| p.0).collect();
        assert_eq!(tops, vec![0, 896, 1720]);
        // Last tile ends at the bottom; ranges chain without gaps.
        assert_eq!(tops[2] + 1280, 3000);
        for w in plan.windows(2) {
            assert_eq!(w[0].2, w[1].1);
            // Each cut leaves at least half the overlap on both sides.
            let (prev_end, next_top) = ((w[0].0 + 1280) as f32, w[1].0 as f32);
            assert!(
                w[0].2 - next_top >= TILE_OVERLAP_X as f32 / 2.0
                    && prev_end - w[0].2 >= TILE_OVERLAP_X as f32 / 2.0
            );
        }
        // Vertical overlap is smaller, so tall axes need fewer tiles.
        let vplan = tile_plan(5214, 1280, TILE_OVERLAP_Y);
        assert_eq!(vplan.len(), 5);
        for w in vplan.windows(2) {
            assert_eq!(w[0].2, w[1].1);
            let (prev_end, next_top) = ((w[0].0 + 1280) as f32, w[1].0 as f32);
            assert!(
                w[0].2 - next_top >= TILE_OVERLAP_Y as f32 / 2.0
                    && prev_end - w[0].2 >= TILE_OVERLAP_Y as f32 / 2.0
            );
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

    #[test]
    fn detect_next_chains_across_frames_and_skips_unchanged_tiles() {
        let (mut det, calls) = fake(Some([736, 768]));
        let opts = DetectOptions::default();
        let f1 = RgbImage::from_pixel(736, 1500, Rgb([10, 10, 10]));
        let (_, c1) = det.detect_next(None, &f1, &opts).unwrap();
        let first_calls = calls.load(Ordering::Relaxed);
        assert!(first_calls >= 2);

        // Identical frame 2 reuses every tile (0 backend calls).
        let f2 = f1.clone();
        let (_, c2) = det.detect_next(Some((&f1, &c1)), &f2, &opts).unwrap();
        assert_eq!(calls.load(Ordering::Relaxed), first_calls);

        // Frame 3 edits only the bottom tile; chained from c2, only that tile reruns.
        let mut f3 = f2.clone();
        f3.put_pixel(100, 1450, Rgb([250, 250, 250]));
        let (_, _c3) = det.detect_next(Some((&f2, &c2)), &f3, &opts).unwrap();
        let after_f3 = calls.load(Ordering::Relaxed);
        assert!(after_f3 > first_calls && after_f3 < first_calls * 2);
    }
}

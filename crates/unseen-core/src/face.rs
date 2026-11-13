//! Faces in photos and screenshots: YuNet (opencv_zoo, MIT), decoded as
//! OpenCV's `FaceDetectorYN`. Its boxes match WIDER FACE's (forehead to chin).

use image::RgbImage;
use ndarray::{Array4, ArrayView3, Ix3};

use crate::eval::iou;
use crate::{Backend, Error, Result};

/// Class name of face detections.
pub const FACE: &str = "face";

const STRIDES: [usize; 3] = [8, 16, 32];
const NMS_IOU: f32 = 0.3;
/// Candidates kept for NMS, as OpenCV's `FaceDetectorYN` `top_k`.
const TOP_K: usize = 5000;
/// YuNet finds faces of about 10-300 px, so one pass runs at the native size
/// (capped at this long side) for small faces and one at [`LARGE_PASS`] for
/// large ones. On WIDER FACE val at score 0.7 the second pass adds 3.3 points
/// of recall on faces taller than 100 px (docs/design.md, faces).
const NATIVE_CAP: u32 = 3072;
const LARGE_PASS: u32 = 640;

/// A face detector and its operating points.
pub struct FaceDetector {
    backend: Box<dyn Backend>,
    /// Pre-selected at or above this score.
    pub select: f32,
    /// Shown for review in [`FaceDetector::review`, `select`).
    pub review: f32,
}

impl FaceDetector {
    /// WIDER FACE val (docs/design.md, faces): score 0.7 covers 91.3% of
    /// faces taller than 100 px and 83.6% of 32-100 px ones at 0.23 boxes per
    /// image on no face; the review band down to 0.6 adds 1.9 / 3.4 points
    /// for 0.42 more.
    pub fn new(backend: Box<dyn Backend>) -> Self {
        Self {
            backend,
            select: 0.7,
            review: 0.6,
        }
    }

    pub fn backend_name(&self) -> String {
        self.backend.name()
    }

    /// Faces scoring at least `min_score` and [`FaceDetector::review`] (lower
    /// ones are never shown), xyxy in image pixels, after NMS across both
    /// passes, by descending score.
    pub fn detect(&mut self, img: &RgbImage, min_score: f32) -> Result<Vec<(f32, [f32; 4])>> {
        let min_score = min_score.max(self.review);
        let long = img.width().max(img.height());
        let mut found = self.pass(img, (NATIVE_CAP as f32 / long as f32).min(1.0), min_score)?;
        if long > LARGE_PASS {
            found.extend(self.pass(img, LARGE_PASS as f32 / long as f32, min_score)?);
        }
        found.sort_by(|a, b| b.0.total_cmp(&a.0));
        found.truncate(TOP_K);
        let mut keep: Vec<(f32, [f32; 4])> = Vec::new();
        for f in found {
            if keep.iter().all(|k| iou(&k.1, &f.1) <= NMS_IOU) {
                keep.push(f);
            }
        }
        Ok(keep)
    }

    /// One run at `scale`: BGR 0-255, zero-padded to a multiple of 32.
    fn pass(&mut self, img: &RgbImage, scale: f32, min_score: f32) -> Result<Vec<(f32, [f32; 4])>> {
        let (nw, nh) = (
            ((img.width() as f32 * scale).round() as u32).max(1),
            ((img.height() as f32 * scale).round() as u32).max(1),
        );
        let px = crate::model::resize(img, nw, nh);
        let (w, h) = (nw as usize, nh as usize);
        let (pw, ph) = (w.div_ceil(32) * 32, h.div_ceil(32) * 32);
        let mut t = Array4::<f32>::zeros((1, 3, ph, pw));
        let planes = t.as_slice_mut().expect("standard layout");
        for (c, plane) in planes.chunks_exact_mut(ph * pw).enumerate() {
            for (dst, src) in plane.chunks_exact_mut(pw).zip(px.chunks_exact(w * 3)) {
                for (o, p) in dst[..w].iter_mut().zip(src.as_chunks::<3>().0) {
                    *o = p[2 - c] as f32;
                }
            }
        }
        let out = self.backend.run(t.view())?;
        decode(&out.outputs, pw, ph, min_score).map(|v| v.into_iter().map(|(s, b)| (s, b.map(|x| x / scale))).collect())
    }
}

/// YuNet's outputs, `cls_*`, `obj_*`, `bbox_*`, `kps_*` per stride (8, 16,
/// 32), each `[1, anchors, k]`, into (score, xyxy) in input pixels.
fn decode(outputs: &[ndarray::ArrayD<f32>], pw: usize, ph: usize, min_score: f32) -> Result<Vec<(f32, [f32; 4])>> {
    if outputs.len() != 12 {
        return Err(Error::Shape(format!(
            "face detector: {} outputs, want 12",
            outputs.len()
        )));
    }
    let view = |i: usize, k: usize, n: usize| -> Result<ArrayView3<'_, f32>> {
        let a = outputs[i]
            .view()
            .into_dimensionality::<Ix3>()
            .map_err(|e| Error::Shape(format!("face output {i}: {e}")))?;
        if a.dim() != (1, n, k) {
            return Err(Error::Shape(format!(
                "face output {i}: {:?}, want (1, {n}, {k})",
                a.dim()
            )));
        }
        Ok(a)
    };
    let mut res = Vec::new();
    for (l, &s) in STRIDES.iter().enumerate() {
        let (cols, rows) = (pw / s, ph / s);
        let n = cols * rows;
        let (cls, obj, bbox) = (view(l, 1, n)?, view(3 + l, 1, n)?, view(6 + l, 4, n)?);
        for i in 0..n {
            let score = (cls[[0, i, 0]].clamp(0.0, 1.0) * obj[[0, i, 0]].clamp(0.0, 1.0)).sqrt();
            if score < min_score {
                continue;
            }
            let (r, c, s) = ((i / cols) as f32, (i % cols) as f32, s as f32);
            let (cx, cy) = ((c + bbox[[0, i, 0]]) * s, (r + bbox[[0, i, 1]]) * s);
            let (w, h) = (bbox[[0, i, 2]].exp() * s, bbox[[0, i, 3]].exp() * s);
            res.push((score, [cx - w / 2.0, cy - h / 2.0, cx + w / 2.0, cy + h / 2.0]));
        }
    }
    Ok(res)
}

#[cfg(test)]
pub(crate) mod tests {
    use std::sync::{Arc, Mutex};

    use ndarray::{Array3, ArrayView4};

    use super::*;
    use crate::RawOutput;

    /// One face per run, on the stride-16 cell at row 1, column 2, with a
    /// box two strides wide; records each input's (width, height).
    pub(crate) struct Fake(pub(crate) Sizes);

    /// Input (width, height) of every run.
    pub(crate) type Sizes = Arc<Mutex<Vec<(usize, usize)>>>;

    impl Backend for Fake {
        fn name(&self) -> String {
            "fake".into()
        }

        fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
            let (_, _, h, w) = input.dim();
            self.0.lock().unwrap().push((w, h));
            let n = |s: usize| (w / s) * (h / s);
            let mut outputs = vec![];
            for k in [1, 1, 4, 10] {
                for s in STRIDES {
                    let mut a = Array3::<f32>::zeros((1, n(s), k));
                    let i = w / 16 + 2;
                    match (s, k) {
                        (16, 1) => a[[0, i, 0]] = 0.81,
                        (16, 4) => {
                            a[[0, i, 2]] = 2f32.ln();
                            a[[0, i, 3]] = 2f32.ln();
                        }
                        _ => {}
                    }
                    outputs.push(a.into_dyn());
                }
            }
            Ok(RawOutput { outputs })
        }
    }

    fn fake() -> (FaceDetector, Sizes) {
        let sizes = Arc::default();
        (FaceDetector::new(Box::new(Fake(Arc::clone(&sizes)))), sizes)
    }

    #[test]
    fn decodes_both_passes_into_image_pixels() {
        let (mut f, _) = fake();
        let img = RgbImage::new(1280, 960);
        let mut faces = f.detect(&img, 0.5).unwrap();
        // Native: centre (32, 16), 32 px. The 640 pass runs at scale 0.5, so
        // its face maps to twice the size; IoU 0.11 keeps both.
        assert_eq!(faces.len(), 2);
        assert!(faces.iter().all(|f| (f.0 - 0.81).abs() < 1e-6));
        faces.sort_by(|a, b| a.1[2].total_cmp(&b.1[2]));
        for (f, want) in faces.iter().zip([[16.0, 0.0, 48.0, 32.0], [32.0, 0.0, 96.0, 64.0]]) {
            assert_eq!(f.1, want);
        }
        assert!(f.detect(&img, 0.9).unwrap().is_empty());
        // Below the review threshold nothing is decoded, whatever is asked.
        f.review = 0.85;
        assert!(f.detect(&img, 0.05).unwrap().is_empty());
    }

    #[test]
    fn native_pass_is_capped_and_small_images_run_once() {
        let (mut f, sizes) = fake();
        f.detect(&RgbImage::new(1290, 2796), 0.5).unwrap();
        f.detect(&RgbImage::new(4000, 6000), 0.5).unwrap();
        f.detect(&RgbImage::new(300, 200), 0.5).unwrap();
        assert_eq!(
            *sizes.lock().unwrap(),
            // Padded to multiples of 32: native, then the 640 pass.
            vec![(1312, 2816), (320, 640), (2048, 3072), (448, 640), (320, 224)]
        );
    }
}

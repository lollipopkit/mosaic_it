//! Detection metrics on a COCO-format dataset. Mirrors the training code's
//! evaluation so numbers from both sides compare.

use std::collections::BTreeMap;
use std::path::{Path, PathBuf};

use serde::{Deserialize, Serialize};

use crate::{Detection, Error, Result};

#[derive(Deserialize)]
struct CocoFile {
    images: Vec<CocoImage>,
    annotations: Vec<CocoAnn>,
    categories: Vec<CocoCat>,
}

#[derive(Deserialize)]
struct CocoImage {
    id: u64,
    file_name: String,
    #[serde(default)]
    template: Option<String>,
}

#[derive(Deserialize)]
struct CocoAnn {
    image_id: u64,
    category_id: usize,
    /// xywh
    bbox: [f32; 4],
}

#[derive(Deserialize)]
struct CocoCat {
    id: usize,
    name: String,
}

/// Ground truth of one image; boxes are xyxy in original-image pixels.
pub struct GtImage {
    pub path: PathBuf,
    /// Generator template, if recorded; the report is also split by it.
    pub template: Option<String>,
    pub labels: Vec<usize>,
    pub boxes: Vec<[f32; 4]>,
}

pub struct CocoDataset {
    /// Indexed by category id.
    pub classes: Vec<String>,
    pub images: Vec<GtImage>,
}

impl CocoDataset {
    /// Loads `<root>/coco.json`.
    pub fn load(root: &Path) -> Result<Self> {
        let p = root.join("coco.json");
        let s = std::fs::read_to_string(&p).map_err(|e| Error::Dataset(format!("{}: {e}", p.display())))?;
        let coco: CocoFile = serde_json::from_str(&s).map_err(|e| Error::Dataset(format!("{}: {e}", p.display())))?;
        let mut cats = coco.categories;
        cats.sort_by_key(|c| c.id);
        if cats.iter().enumerate().any(|(i, c)| c.id != i) {
            return Err(Error::Dataset("category ids must be 0..n".into()));
        }
        let index: BTreeMap<u64, usize> = coco.images.iter().enumerate().map(|(i, im)| (im.id, i)).collect();
        let mut images: Vec<GtImage> = coco
            .images
            .into_iter()
            .map(|im| GtImage {
                path: root.join(im.file_name),
                template: im.template,
                labels: Vec::new(),
                boxes: Vec::new(),
            })
            .collect();
        for a in coco.annotations {
            let i = *index
                .get(&a.image_id)
                .ok_or_else(|| Error::Dataset(format!("annotation for unknown image {}", a.image_id)))?;
            if a.category_id >= cats.len() {
                return Err(Error::Dataset(format!("unknown category {}", a.category_id)));
            }
            let [x, y, w, h] = a.bbox;
            images[i].labels.push(a.category_id);
            images[i].boxes.push([x, y, x + w, y + h]);
        }
        Ok(Self {
            classes: cats.into_iter().map(|c| c.name).collect(),
            images,
        })
    }
}

#[derive(Debug, Clone, Copy)]
pub struct EvalOptions {
    /// Detections at or above this score count for coverage.
    pub score: f32,
    /// A GT box is covered when at least this fraction of it lies inside
    /// the union of predicted boxes.
    pub cover: f32,
}

impl Default for EvalOptions {
    fn default() -> Self {
        Self { score: 0.3, cover: 0.9 }
    }
}

#[derive(Debug, Serialize)]
pub struct ClassReport {
    pub ap50: f64,
    pub cover_recall: f64,
    pub n: usize,
}

#[derive(Debug, Serialize)]
pub struct EvalReport {
    pub map50: f64,
    /// Mean over classes with ground truth.
    pub cover_recall: f64,
    pub classes: BTreeMap<String, ClassReport>,
    #[serde(rename = "dets_per_img@thr")]
    pub dets_per_img: f64,
    pub images: usize,
    /// The same report per generator template.
    #[serde(skip_serializing_if = "BTreeMap::is_empty")]
    pub templates: BTreeMap<String, EvalReport>,
}

/// Running totals for one group of images.
#[derive(Default)]
struct Acc {
    /// Per class: (score, is_tp) of every detection.
    dets: Vec<Vec<(f32, bool)>>,
    npos: Vec<usize>,
    covered: Vec<usize>,
    above_thr: usize,
    images: usize,
}

/// One image reduced to what the report needs.
struct ImageResult {
    /// (class, score, is_tp) per detection.
    dets: Vec<(usize, f32, bool)>,
    /// (class, covered) per ground-truth box.
    gts: Vec<(usize, bool)>,
    above_thr: usize,
}

impl Acc {
    fn new(n: usize) -> Self {
        Self {
            dets: vec![Vec::new(); n],
            npos: vec![0; n],
            covered: vec![0; n],
            ..Default::default()
        }
    }

    fn record(&mut self, r: &ImageResult) {
        self.images += 1;
        self.above_thr += r.above_thr;
        for &(c, s, tp) in &r.dets {
            self.dets[c].push((s, tp));
        }
        for &(c, cov) in &r.gts {
            self.npos[c] += 1;
            self.covered[c] += cov as usize;
        }
    }

    fn report(mut self, names: &[String]) -> EvalReport {
        let mut classes = BTreeMap::new();
        let mut valid = Vec::new();
        for (c, name) in names.iter().enumerate() {
            let n = self.npos[c];
            let (ap50, cover_recall) = if n == 0 {
                (f64::NAN, f64::NAN)
            } else {
                (ap50(&mut self.dets[c], n), self.covered[c] as f64 / n as f64)
            };
            if n > 0 {
                valid.push((ap50, cover_recall));
            }
            classes.insert(name.clone(), ClassReport { ap50, cover_recall, n });
        }
        let mean = |f: fn(&(f64, f64)) -> f64| {
            if valid.is_empty() {
                f64::NAN
            } else {
                valid.iter().map(f).sum::<f64>() / valid.len() as f64
            }
        };
        EvalReport {
            map50: mean(|v| v.0),
            cover_recall: mean(|v| v.1),
            classes,
            dets_per_img: self.above_thr as f64 / self.images.max(1) as f64,
            images: self.images,
            templates: BTreeMap::new(),
        }
    }
}

/// Accumulates per-image results; call [`Evaluator::finish`] for the report.
pub struct Evaluator {
    classes: Vec<String>,
    opts: EvalOptions,
    all: Acc,
    by_template: BTreeMap<String, Acc>,
}

impl Evaluator {
    pub fn new(classes: Vec<String>, opts: EvalOptions) -> Self {
        let all = Acc::new(classes.len());
        Self {
            classes,
            opts,
            all,
            by_template: BTreeMap::new(),
        }
    }

    /// Fails without recording anything if a label or class id is outside
    /// the evaluator's classes.
    pub fn add(&mut self, gt: &GtImage, dets: &[Detection]) -> Result<()> {
        let n = self.classes.len();
        if gt.labels.len() != gt.boxes.len() {
            return Err(Error::Dataset(format!(
                "{}: labels and boxes differ in length",
                gt.path.display()
            )));
        }
        if let Some(c) = gt
            .labels
            .iter()
            .copied()
            .chain(dets.iter().map(|d| d.class_id))
            .find(|&c| c >= n)
        {
            return Err(Error::Dataset(format!("class id {c} out of range for {n} classes")));
        }
        let r = self.score_image(gt, dets);
        self.all.record(&r);
        if let Some(t) = &gt.template {
            self.by_template
                .entry(t.clone())
                .or_insert_with(|| Acc::new(n))
                .record(&r);
        }
        Ok(())
    }

    fn score_image(&self, gt: &GtImage, dets: &[Detection]) -> ImageResult {
        // Greedy matching in descending score order, as in VOC. Ties in IoU
        // go to the first GT, as numpy argmax does.
        let mut order: Vec<&Detection> = dets.iter().collect();
        order.sort_by(|a, b| b.score.total_cmp(&a.score));
        let mut used = vec![false; gt.boxes.len()];
        let mut out = Vec::with_capacity(dets.len());
        for d in order {
            let mut best: Option<(usize, f32)> = None;
            for (j, (l, b)) in gt.labels.iter().zip(&gt.boxes).enumerate() {
                if *l == d.class_id {
                    let v = iou(&d.bbox, b);
                    if best.is_none_or(|(_, bv)| v > bv) {
                        best = Some((j, v));
                    }
                }
            }
            let tp = matches!(best, Some((j, v)) if v >= 0.5 && !used[j]);
            if let Some((j, _)) = best.filter(|_| tp) {
                used[j] = true;
            }
            out.push((d.class_id, d.score, tp));
        }

        let kept: Vec<[f32; 4]> = dets
            .iter()
            .filter(|d| d.score >= self.opts.score)
            .map(|d| d.bbox)
            .collect();
        let gts = gt
            .labels
            .iter()
            .zip(&gt.boxes)
            .map(|(&l, b)| (l, coverage(b, &kept) >= self.opts.cover))
            .collect();
        ImageResult {
            dets: out,
            gts,
            above_thr: kept.len(),
        }
    }

    pub fn finish(self) -> EvalReport {
        let mut r = self.all.report(&self.classes);
        r.templates = self
            .by_template
            .into_iter()
            .map(|(t, acc)| (t, acc.report(&self.classes)))
            .collect();
        r
    }
}

/// VOC all-point AP.
fn ap50(dets: &mut [(f32, bool)], npos: usize) -> f64 {
    dets.sort_by(|a, b| b.0.total_cmp(&a.0));
    let mut rec = vec![0.0];
    let mut prec = vec![0.0];
    let mut tp = 0usize;
    for (i, &(_, t)) in dets.iter().enumerate() {
        tp += t as usize;
        rec.push(tp as f64 / npos as f64);
        prec.push(tp as f64 / (i + 1) as f64);
    }
    rec.push(1.0);
    prec.push(0.0);
    for i in (0..prec.len() - 1).rev() {
        prec[i] = prec[i].max(prec[i + 1]);
    }
    (1..rec.len()).map(|i| (rec[i] - rec[i - 1]) * prec[i]).sum()
}

/// Fraction of `gt` inside the union of `preds`, sampled on a 16x4 grid.
pub(crate) fn coverage(gt: &[f32; 4], preds: &[[f32; 4]]) -> f32 {
    const GX: usize = 16;
    const GY: usize = 4;
    let mut hit = 0;
    for j in 0..GY {
        let y = gt[1] + (j as f32 + 0.5) / GY as f32 * (gt[3] - gt[1]);
        for i in 0..GX {
            let x = gt[0] + (i as f32 + 0.5) / GX as f32 * (gt[2] - gt[0]);
            hit += preds.iter().any(|p| x >= p[0] && x <= p[2] && y >= p[1] && y <= p[3]) as usize;
        }
    }
    hit as f32 / (GX * GY) as f32
}

pub(crate) fn iou(a: &[f32; 4], b: &[f32; 4]) -> f32 {
    let iw = (a[2].min(b[2]) - a[0].max(b[0])).max(0.0);
    let ih = (a[3].min(b[3]) - a[1].max(b[1])).max(0.0);
    let inter = iw * ih;
    let area = |r: &[f32; 4]| (r[2] - r[0]).max(0.0) * (r[3] - r[1]).max(0.0);
    inter / (area(a) + area(b) - inter + 1e-9)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn det(class_id: usize, score: f32, bbox: [f32; 4]) -> Detection {
        Detection {
            class: String::new(),
            class_id,
            score,
            bbox,
        }
    }

    fn gt(labels: Vec<usize>, boxes: Vec<[f32; 4]>) -> GtImage {
        GtImage {
            path: PathBuf::new(),
            template: None,
            labels,
            boxes,
        }
    }

    #[test]
    fn perfect_detections() {
        let mut e = Evaluator::new(vec!["a".into(), "b".into()], EvalOptions::default());
        let g = gt(vec![0, 1], vec![[0.0, 0.0, 10.0, 10.0], [20.0, 0.0, 40.0, 10.0]]);
        e.add(&g, &[det(0, 0.9, g.boxes[0]), det(1, 0.8, g.boxes[1])]).unwrap();
        let r = e.finish();
        assert_eq!(r.map50, 1.0);
        assert_eq!(r.cover_recall, 1.0);
        assert_eq!(r.classes["b"].cover_recall, 1.0);
        assert_eq!(r.dets_per_img, 2.0);
    }

    #[test]
    fn duplicate_is_false_positive() {
        let mut e = Evaluator::new(vec!["a".into()], EvalOptions::default());
        let g = gt(vec![0, 0], vec![[0.0, 0.0, 10.0, 10.0], [50.0, 0.0, 60.0, 10.0]]);
        // TP, duplicate FP of the same box, then TP of the second box:
        // precision drops to 2/3 at recall 1.
        e.add(
            &g,
            &[
                det(0, 0.9, g.boxes[0]),
                det(0, 0.8, g.boxes[0]),
                det(0, 0.7, g.boxes[1]),
            ],
        )
        .unwrap();
        let r = e.finish();
        assert!((r.map50 - (0.5 + 0.5 * 2.0 / 3.0)).abs() < 1e-9);
    }

    #[test]
    fn split_box_still_covers() {
        let mut e = Evaluator::new(vec!["a".into()], EvalOptions::default());
        let g = gt(vec![0], vec![[0.0, 0.0, 100.0, 10.0]]);
        // Three thirds: AP misses (IoU 1/3 each), coverage counts it.
        e.add(
            &g,
            &[
                det(0, 0.9, [0.0, 0.0, 34.0, 10.0]),
                det(0, 0.9, [33.0, 0.0, 67.0, 10.0]),
                det(0, 0.9, [66.0, 0.0, 100.0, 10.0]),
            ],
        )
        .unwrap();
        let r = e.finish();
        assert_eq!(r.map50, 0.0);
        assert_eq!(r.classes["a"].cover_recall, 1.0);
    }

    #[test]
    fn split_by_template() {
        let mut e = Evaluator::new(vec!["a".into()], EvalOptions::default());
        let b = [0.0, 0.0, 10.0, 10.0];
        let mut hit = gt(vec![0], vec![b]);
        hit.template = Some("x".into());
        let mut miss = gt(vec![0], vec![b]);
        miss.template = Some("y".into());
        e.add(&hit, &[det(0, 0.9, b)]).unwrap();
        e.add(&miss, &[]).unwrap();
        let r = e.finish();
        assert_eq!(r.cover_recall, 0.5);
        assert_eq!(r.templates["x"].cover_recall, 1.0);
        assert_eq!(r.templates["y"].cover_recall, 0.0);
        assert_eq!(r.templates["y"].images, 1);
    }

    #[test]
    fn out_of_range_class_is_an_error() {
        let mut e = Evaluator::new(vec!["a".into()], EvalOptions::default());
        let g = gt(vec![0], vec![[0.0, 0.0, 10.0, 10.0]]);
        assert!(e.add(&g, &[det(1, 0.9, g.boxes[0])]).is_err());
        assert!(e.add(&gt(vec![1], vec![g.boxes[0]]), &[]).is_err());
        assert_eq!(e.finish().images, 0);
    }

    #[test]
    fn class_without_gt_is_nan_and_excluded() {
        let mut e = Evaluator::new(vec!["a".into(), "b".into()], EvalOptions::default());
        let g = gt(vec![0], vec![[0.0, 0.0, 10.0, 10.0]]);
        e.add(&g, &[det(0, 0.9, g.boxes[0])]).unwrap();
        let r = e.finish();
        assert!(r.classes["b"].ap50.is_nan());
        assert_eq!(r.map50, 1.0);
    }
}

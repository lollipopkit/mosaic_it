//! Per-class pre-selection thresholds with a recall guarantee
//! (Learn-then-Test, fixed-sequence testing; see docs/design.md §6).
//!
//! For every ground-truth box we record `s*`, the highest threshold at which
//! same-class detections still cover it. A box is missed at threshold `λ`
//! exactly when `s* < λ`, so the miss count is monotone in `λ` and one pass
//! over a sorted list gives the risk at every candidate.
//!
//! Thresholds are tested from low (safe) to high and testing stops at the first
//! one that cannot be certified; with that order the family-wise error over
//! all tested thresholds stays at `δ` without a multiplicity correction.
//!
//! Boxes are treated as exchangeable samples. Boxes in one image are not
//! independent, so the calibration set should hold many images with few boxes
//! of a class each.

use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use statrs::distribution::{Binomial, DiscreteCDF};

use crate::eval::coverage;
use crate::model::UNCALIBRATED_SELECT;
use crate::{Detection, Error, GtImage, Result};

/// Candidate thresholds, ascending. Detections below the lowest are never
/// produced by [`crate::DetectOptions::default`].
fn grid() -> impl Iterator<Item = f32> {
    (5..=99).map(|i| i as f32 / 100.0)
}

/// Stored in the model metadata next to the weights.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Calibration {
    /// Input domain the guarantee holds for, e.g. `ui_screenshot`.
    pub domain: String,
    /// Target miss rate: recall ≥ 1 − alpha …
    pub alpha: f64,
    /// … with probability ≥ 1 − delta.
    pub delta: f64,
    /// Boxes between `review` and `select` are shown unselected but
    /// highlighted. A class gets a band only where at least this share of
    /// the band's detections lie on a real box of the class; otherwise
    /// `review == select`. Sidecars written before this field read as 0.
    #[serde(default)]
    pub review_precision: f64,
    /// False until the calibration set is human-verified real data; the UI
    /// must not present the guarantee as real while this is false.
    pub verified: bool,
    pub classes: BTreeMap<String, ClassThreshold>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ClassThreshold {
    pub select: f32,
    pub review: f32,
    /// Calibration boxes of this class.
    pub n: usize,
    /// False when even the lowest threshold could not be certified (too few
    /// boxes or too many misses); `select` is then the highest threshold that
    /// misses at most α/10 of the calibration boxes more than the lowest one.
    pub guaranteed: bool,
}

/// Collects `s*` per ground-truth box.
pub struct Calibrator {
    classes: Vec<String>,
    cover: f32,
    /// Per class: `s*` of every GT box (0 when never covered).
    s_star: Vec<Vec<f32>>,
    /// Per class: score of every detection and whether it lies on a GT box
    /// of its class.
    dets: Vec<Vec<(f32, bool)>>,
}

/// Fewest band detections a review threshold is estimated from.
const MIN_BAND: usize = 20;

/// Share of a detection lying on a GT box for it to count as a hit.
const ON_BOX: f32 = 0.5;

impl Calibrator {
    pub fn new(classes: Vec<String>, cover: f32) -> Self {
        let n = classes.len();
        Self {
            classes,
            cover,
            s_star: vec![Vec::new(); n],
            dets: vec![Vec::new(); n],
        }
    }

    pub fn add(&mut self, gt: &GtImage, dets: &[Detection]) -> Result<()> {
        let n = self.classes.len();
        if let Some(c) = gt
            .labels
            .iter()
            .copied()
            .chain(dets.iter().map(|d| d.class_id))
            .find(|&c| c >= n)
        {
            return Err(Error::Dataset(format!("class id {c} out of range for {n} classes")));
        }
        let mut by_class: Vec<Vec<&Detection>> = vec![Vec::new(); n];
        for d in dets {
            by_class[d.class_id].push(d);
            let hit = gt
                .labels
                .iter()
                .zip(&gt.boxes)
                .any(|(&c, b)| c == d.class_id && inside(&d.bbox, b) >= ON_BOX);
            self.dets[d.class_id].push((d.score, hit));
        }
        for v in &mut by_class {
            v.sort_by(|a, b| b.score.total_cmp(&a.score));
        }
        for (&c, b) in gt.labels.iter().zip(&gt.boxes) {
            // Lower the threshold one detection at a time until the box is
            // covered; the score of the detection that completed it is s*.
            let mut kept = Vec::new();
            let mut s = 0.0;
            for d in &by_class[c] {
                kept.push(d.bbox);
                if coverage(b, &kept) >= self.cover {
                    s = d.score;
                    break;
                }
            }
            self.s_star[c].push(s);
        }
        Ok(())
    }

    pub fn finish(&self, domain: &str, alpha: f64, delta: f64, review_precision: f64, verified: bool) -> Calibration {
        let classes = self
            .classes
            .iter()
            .zip(self.s_star.iter().zip(&self.dets))
            .map(|(name, (s, dets))| {
                let (select, guaranteed) = match certify(s, alpha, delta) {
                    (l, true) => (l, true),
                    // The lowest threshold buys little recall when the misses
                    // are boxes never detected at all, only false positives.
                    _ => (no_loss(s, alpha / 10.0), false),
                };
                let t = ClassThreshold {
                    select,
                    review: review(dets, select, review_precision),
                    n: s.len(),
                    guaranteed,
                };
                (name.clone(), t)
            })
            .collect();
        Calibration {
            domain: domain.into(),
            alpha,
            delta,
            review_precision,
            verified,
            classes,
        }
    }
}

/// Highest grid threshold certified by fixed-sequence testing, and whether
/// any was certified at all.
fn certify(s_star: &[f32], alpha: f64, delta: f64) -> (f32, bool) {
    let lowest = grid().next().unwrap_or(0.05);
    let n = s_star.len();
    if n == 0 {
        return (lowest, false);
    }
    let mut sorted = s_star.to_vec();
    sorted.sort_by(f32::total_cmp);
    let mut best = None;
    for lambda in grid() {
        let misses = sorted.partition_point(|&s| s < lambda);
        // H0: miss rate ≥ alpha. Reject when observing this few misses is
        // unlikely under the boundary case Binomial(n, alpha).
        if binom_cdf(misses, n, alpha) <= delta {
            best = Some(lambda);
        } else {
            break;
        }
    }
    match best {
        Some(l) => (l, true),
        None => (lowest, false),
    }
}

/// Highest grid threshold that misses at most a `slack` share of the boxes
/// more than the lowest one; the uncalibrated default without boxes.
fn no_loss(s_star: &[f32], slack: f64) -> f32 {
    if s_star.is_empty() {
        return UNCALIBRATED_SELECT;
    }
    let misses = |l: f32| s_star.iter().filter(|&&s| s < l).count();
    let budget = misses(grid().next().unwrap_or(0.05)) + (slack * s_star.len() as f64) as usize;
    grid().take_while(|&l| misses(l) <= budget).last().unwrap_or(0.05)
}

/// Lowest grid threshold below `select` whose band `[λ, select)` holds at
/// least [`MIN_BAND`] detections with a hit share of `precision`; `select`
/// (no band) when there is none.
fn review(dets: &[(f32, bool)], select: f32, precision: f64) -> f32 {
    grid()
        .take_while(|&l| l < select)
        .find(|&l| {
            let band: Vec<bool> = dets
                .iter()
                .filter(|(s, _)| (l..select).contains(s))
                .map(|&(_, h)| h)
                .collect();
            band.len() >= MIN_BAND && band.iter().filter(|&&h| h).count() as f64 >= precision * band.len() as f64
        })
        .unwrap_or(select)
}

/// Share of `a`'s area inside `b`.
fn inside(a: &[f32; 4], b: &[f32; 4]) -> f32 {
    let iw = (a[2].min(b[2]) - a[0].max(b[0])).max(0.0);
    let ih = (a[3].min(b[3]) - a[1].max(b[1])).max(0.0);
    iw * ih / ((a[2] - a[0]) * (a[3] - a[1])).max(1e-9)
}

/// P(X ≤ k) for X ~ Binomial(n, p).
fn binom_cdf(k: usize, n: usize, p: f64) -> f64 {
    Binomial::new(p, n as u64).map_or(1.0, |b| b.cdf(k as u64))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn binom_cdf_matches_closed_forms() {
        // P(X ≤ 0) = (1-p)^n
        assert!((binom_cdf(0, 150, 0.02) - 0.98f64.powi(150)).abs() < 1e-12);
        // Symmetric case: P(X ≤ 2) for n=5, p=0.5 is 0.5.
        assert!((binom_cdf(2, 5, 0.5) - 0.5).abs() < 1e-12);
        assert_eq!(binom_cdf(5, 5, 0.3), 1.0);
    }

    #[test]
    fn too_few_boxes_cannot_be_certified() {
        // 0.98^100 ≈ 0.13 > 0.05: even zero misses cannot reject.
        let (l, ok) = certify(&[0.9; 100], 0.02, 0.05);
        assert!(!ok);
        assert_eq!(l, 0.05);
    }

    #[test]
    fn threshold_stops_below_the_first_miss() {
        // 400 boxes at s* = 0.8 and none lower: everything up to 0.80 has no
        // misses; above it every box is missed.
        let (l, ok) = certify(&[0.8; 400], 0.02, 0.05);
        assert!(ok);
        assert_eq!(l, 0.8);
        // A few low boxes push the certified threshold down to keep recall.
        let mut s = vec![0.8; 400];
        s.extend([0.3; 20]);
        let (l, ok) = certify(&s, 0.02, 0.05);
        assert!(ok);
        assert!(l <= 0.3 + 1e-6, "{l}");
    }

    #[test]
    fn uncertified_select_keeps_every_hit_of_the_lowest_threshold() {
        // 10 boxes never detected, the rest found at 0.6 or higher.
        let mut s = vec![0.0; 10];
        s.extend([0.6; 50]);
        assert!(!certify(&s, 0.02, 0.05).1);
        assert_eq!(no_loss(&s, 0.0), 0.6);
        assert_eq!(no_loss(&[], 0.0), UNCALIBRATED_SELECT);
        // One box just above the floor out of 1000: no slack keeps the floor,
        // a 0.2 % slack steps over it.
        let mut s = vec![0.055];
        s.extend([0.0; 99]);
        s.extend([0.7; 900]);
        assert_eq!(no_loss(&s, 0.0), 0.05);
        assert_eq!(no_loss(&s, 0.002), 0.7);
    }

    #[test]
    fn review_band_needs_enough_hits() {
        // 30 misses at 0.1, 30 hits at 0.3: [0.1, 0.5) is half hits, [0.11, 0.5)
        // all hits; precision 0.6 starts the band above the misses.
        let mut d = vec![(0.1, false); 30];
        d.extend([(0.3, true); 30]);
        assert_eq!(review(&d, 0.5, 0.5), 0.05);
        assert_eq!(review(&d, 0.5, 0.6), 0.11);
        // No precise band: none at all.
        assert_eq!(review(&d[..30], 0.5, 0.5), 0.5);
        // Too few detections to judge.
        assert_eq!(review(&d[25..35], 0.5, 0.5), 0.5);
    }

    #[test]
    fn s_star_is_the_score_that_completes_coverage() {
        let mut c = Calibrator::new(vec!["a".into()], 0.9);
        let gt = GtImage {
            path: PathBuf::new(),
            template: None,
            labels: vec![0],
            boxes: vec![[0.0, 0.0, 100.0, 10.0]],
        };
        let d = |s, b| Detection {
            class: String::new(),
            class_id: 0,
            score: s,
            bbox: b,
        };
        // Left half at 0.9, right half at 0.4: covered only once both count.
        c.add(&gt, &[d(0.9, [0.0, 0.0, 50.0, 10.0]), d(0.4, [50.0, 0.0, 100.0, 10.0])])
            .unwrap();
        assert_eq!(c.s_star[0], vec![0.4]);
    }
}

//! Find-all propagation (docs/design.md §7): given one box, find regions that
//! look the same, in the same image or another one at the same scale.
//!
//! Identical strings render near-identically, so plain normalised
//! cross-correlation (NCC) on grey levels finds them without reading text.
//! NCC here is zero-mean (OpenCV's TM_CCOEFF_NORMED). `imageproc` only has
//! the plain normalised correlation, which scores any light background close
//! to 1 against dark-on-light text, so it is written out here.
//!
//! 1. Coarse: slide the query over the target downscaled so the query is
//!    ~8 px tall; keep local maxima.
//! 2. Mid: re-score each peak in a small neighbourhood at ~32 px.
//! 3. Verify at full resolution with a strided subset of template pixels.
//!    Downscaled planes sample the query and a match at different sub-pixel
//!    phases, which costs several points of NCC on thin text; at full
//!    resolution identical renders line up exactly.

use image::imageops::{self, FilterType};
use image::{GrayImage, RgbImage};
use serde::Serialize;

use crate::eval::iou;

#[derive(Debug, Clone, Copy)]
pub struct FindOptions {
    /// Full-resolution NCC a match needs.
    pub min_score: f32,
    /// NCC a coarse peak needs to be re-scored.
    pub coarse_score: f32,
    /// NCC a mid-scale candidate needs to be verified.
    pub mid_score: f32,
    /// Query height in pixels at the coarse scale.
    pub coarse_height: u32,
    /// Query height in pixels at the mid scale.
    pub mid_height: u32,
    pub max_matches: usize,
}

impl Default for FindOptions {
    fn default() -> Self {
        Self {
            min_score: 0.9,
            coarse_score: 0.6,
            mid_score: 0.7,
            coarse_height: 8,
            mid_height: 32,
            max_matches: 200,
        }
    }
}

#[derive(Debug, Clone, Copy, Serialize)]
pub struct Match {
    /// xyxy in target-image pixels.
    pub bbox: [f32; 4],
    /// Full-resolution NCC in [-1, 1].
    pub score: f32,
}

/// Grey image as f32.
struct Plane {
    w: usize,
    h: usize,
    px: Vec<f32>,
}

impl Plane {
    fn from_gray(g: &GrayImage) -> Self {
        Self {
            w: g.width() as usize,
            h: g.height() as usize,
            px: g.as_raw().iter().map(|&v| v as f32).collect(),
        }
    }

    fn scaled(g: &GrayImage, s: f32) -> Self {
        if s >= 1.0 {
            return Self::from_gray(g);
        }
        let w = ((g.width() as f32 * s).round() as u32).max(1);
        let h = ((g.height() as f32 * s).round() as u32).max(1);
        Self::from_gray(&imageops::resize(g, w, h, FilterType::Triangle))
    }
}

/// Zero-mean template samples `(dx, dy, value)` over a `w`×`h` window.
struct Template {
    w: usize,
    h: usize,
    pts: Vec<(usize, usize, f64)>,
    norm: f64,
}

impl Template {
    /// Every `step`-th pixel of `q` in both axes; `None` when flat.
    fn new(q: &Plane, step: usize) -> Option<Self> {
        let step = step.max(1);
        let raw: Vec<(usize, usize, f64)> = (0..q.h)
            .step_by(step)
            .flat_map(|y| (0..q.w).step_by(step).map(move |x| (x, y)))
            .map(|(x, y)| (x, y, q.px[y * q.w + x] as f64))
            .collect();
        let n = raw.len() as f64;
        let mean = raw.iter().map(|p| p.2).sum::<f64>() / n;
        let pts: Vec<_> = raw.into_iter().map(|(x, y, v)| (x, y, v - mean)).collect();
        let norm = pts.iter().map(|p| p.2 * p.2).sum::<f64>().sqrt();
        (norm > 1e-3 * n.sqrt()).then_some(Self {
            w: q.w,
            h: q.h,
            pts,
            norm,
        })
    }

    /// NCC with the window of `p` at `(x, y)`; 0 when the window is flat.
    /// Accumulates in f64: f32 sums of squared grey levels lose the variance
    /// of faint windows and can exceed 1.
    fn ncc(&self, p: &Plane, x: usize, y: usize) -> f32 {
        let n = self.pts.len() as f64;
        let (mut s, mut ss, mut st) = (0f64, 0f64, 0f64);
        for &(dx, dy, t) in &self.pts {
            let v = p.px[(y + dy) * p.w + x + dx] as f64;
            s += v;
            ss += v * v;
            st += v * t;
        }
        // Σ (v - mean_v) t = Σ v t, since t is zero-mean.
        let var = ss - s * s / n;
        if var <= 1e-3 * n {
            return 0.0;
        }
        (st / (var.sqrt() * self.norm)) as f32
    }

    /// Best NCC within `r` of `(cx, cy)`.
    fn best_near(&self, p: &Plane, cx: isize, cy: isize, r: isize) -> Option<(f32, usize, usize)> {
        let mut best: Option<(f32, usize, usize)> = None;
        for y in cy - r..=cy + r {
            for x in cx - r..=cx + r {
                if x < 0 || y < 0 || x as usize + self.w > p.w || y as usize + self.h > p.h {
                    continue;
                }
                let v = self.ncc(p, x as usize, y as usize);
                if best.is_none_or(|b| v > b.0) {
                    best = Some((v, x as usize, y as usize));
                }
            }
        }
        best
    }
}

/// Finds regions of `target` that look like `query` (a box in `src`).
/// Matches overlapping `exclude` (e.g. the query itself when `src` and
/// `target` are the same image) are dropped.
pub fn find_similar(
    src: &RgbImage,
    query: [f32; 4],
    target: &RgbImage,
    exclude: Option<[f32; 4]>,
    opts: &FindOptions,
) -> Vec<Match> {
    let (sw, sh) = (src.width() as f32, src.height() as f32);
    let x0 = query[0].clamp(0.0, sw).floor() as u32;
    let y0 = query[1].clamp(0.0, sh).floor() as u32;
    let x1 = query[2].clamp(0.0, sw).ceil() as u32;
    let y1 = query[3].clamp(0.0, sh).ceil() as u32;
    let (qw, qh) = (x1.saturating_sub(x0), y1.saturating_sub(y0));
    if qw < 4 || qh < 4 || qw > target.width() || qh > target.height() {
        return Vec::new();
    }
    let tgt_g = imageops::grayscale(target);
    let crop = imageops::crop_imm(&imageops::grayscale(src), x0, y0, qw, qh).to_image();
    let level = |s: f32| {
        let s = s.min(1.0);
        (s, Plane::scaled(&tgt_g, s), Plane::scaled(&crop, s))
    };

    // 1. Coarse: dense NCC map, local maxima.
    let (cs, ct, cq) = level(opts.coarse_height as f32 / qh as f32);
    let Some(ctpl) = Template::new(&cq, 1) else {
        return Vec::new();
    };
    if cq.w > ct.w || cq.h > ct.h {
        return Vec::new();
    }
    let (mw, mh) = (ct.w - cq.w + 1, ct.h - cq.h + 1);
    let map: Vec<f32> = (0..mh)
        .flat_map(|y| (0..mw).map(move |x| (x, y)))
        .map(|(x, y)| ctpl.ncc(&ct, x, y))
        .collect();
    let (rx, ry) = ((cq.w / 2).max(1), (cq.h / 2).max(1));
    let mut peaks: Vec<(usize, usize, f32)> = Vec::new();
    for y in 0..mh {
        for x in 0..mw {
            let v = map[y * mw + x];
            if v < opts.coarse_score {
                continue;
            }
            let is_max = (y.saturating_sub(ry)..(y + ry + 1).min(mh))
                .all(|yy| (x.saturating_sub(rx)..(x + rx + 1).min(mw)).all(|xx| map[yy * mw + xx] <= v));
            if is_max {
                peaks.push((x, y, v));
            }
        }
    }
    peaks.sort_by(|a, b| b.2.total_cmp(&a.2));
    peaks.truncate(opts.max_matches * 4);

    // 2. Mid: re-score near each peak.
    let (ms, mt, mq) = level(opts.mid_height as f32 / qh as f32);
    let Some(mtpl) = Template::new(&mq, 1) else {
        return Vec::new();
    };
    let r_mid = (ms / cs).ceil() as isize + 1;
    let mids: Vec<(usize, usize)> = peaks
        .iter()
        .filter_map(|&(x, y, _)| {
            let (cx, cy) = (
                (x as f32 / cs * ms).round() as isize,
                (y as f32 / cs * ms).round() as isize,
            );
            mtpl.best_near(&mt, cx, cy, r_mid)
        })
        .filter(|b| b.0 >= opts.mid_score)
        .map(|b| (b.1, b.2))
        .collect();

    // 3. Verify at full resolution on ~1024 template samples.
    let full = Plane::from_gray(&tgt_g);
    let fq = Plane::from_gray(&crop);
    let step = ((qw * qh) as f32 / 1024.0).sqrt().floor() as usize;
    let Some(ftpl) = Template::new(&fq, step) else {
        return Vec::new();
    };
    let r_full = (1.0 / ms).ceil() as isize + 1;
    let mut found: Vec<Match> = Vec::new();
    for (x, y) in mids {
        let (cx, cy) = ((x as f32 / ms).round() as isize, (y as f32 / ms).round() as isize);
        let Some((score, bx, by)) = ftpl.best_near(&full, cx, cy, r_full) else {
            continue;
        };
        if score < opts.min_score {
            continue;
        }
        let bbox = [bx as f32, by as f32, (bx as u32 + qw) as f32, (by as u32 + qh) as f32];
        if exclude.is_some_and(|e| iou(&e, &bbox) > 0.5) {
            continue;
        }
        if found.iter().all(|m| iou(&m.bbox, &bbox) <= 0.3) {
            found.push(Match { bbox, score });
        }
    }
    found.sort_by(|a, b| b.score.total_cmp(&a.score));
    found.truncate(opts.max_matches);
    found
}

#[cfg(test)]
mod tests {
    use super::*;
    use image::Rgb;

    /// A deterministic "word": noise from a seed, `w`×`h`.
    fn stamp(img: &mut RgbImage, seed: u64, x0: u32, y0: u32, w: u32, h: u32) {
        let mut s = seed;
        for y in 0..h {
            for x in 0..w {
                s = s.wrapping_mul(6364136223846793005).wrapping_add(1442695040888963407);
                let v = if (s >> 60) & 1 == 1 { 20 } else { 230 };
                img.put_pixel(x0 + x, y0 + y, Rgb([v, v, v]));
            }
        }
    }

    #[test]
    fn finds_repeats_and_ignores_others() {
        let mut img = RgbImage::from_pixel(600, 900, Rgb([245, 245, 245]));
        stamp(&mut img, 1, 40, 50, 160, 32);
        stamp(&mut img, 1, 300, 400, 160, 32);
        stamp(&mut img, 1, 120, 800, 160, 32);
        // Same size, different content.
        stamp(&mut img, 2, 300, 600, 160, 32);
        let q = [40.0, 50.0, 200.0, 82.0];
        let m = find_similar(&img, q, &img, Some(q), &FindOptions::default());
        let mut tops: Vec<(i32, i32)> = m
            .iter()
            .map(|m| (m.bbox[0].round() as i32, m.bbox[1].round() as i32))
            .collect();
        tops.sort();
        assert_eq!(m.len(), 2, "{m:?}");
        for ((x, y), (ex, ey)) in tops.iter().zip([(120, 800), (300, 400)]) {
            assert!((x - ex).abs() <= 2 && (y - ey).abs() <= 2, "{tops:?}");
        }
    }

    #[test]
    fn flat_query_finds_nothing() {
        let img = RgbImage::from_pixel(200, 200, Rgb([255, 255, 255]));
        let q = [10.0, 10.0, 60.0, 30.0];
        assert!(find_similar(&img, q, &img, Some(q), &FindOptions::default()).is_empty());
    }
}

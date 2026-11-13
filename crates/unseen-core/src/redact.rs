use image::{Rgb, RgbImage};
use rand::rngs::SmallRng;
use rand::{RngExt, SeedableRng};
use serde::Serialize;

use crate::eval::coverage;
use crate::{Candidates, DetectOptions, Detection, Detector, Result, Selection};

/// How a region is hidden. No style reads the original pixels inside the
/// region, so nothing inside can be recovered by de-pixelisation or
/// de-blurring; styles that match their surroundings sample only a ring of
/// pixels outside it.
#[derive(Debug, Clone, Copy)]
pub enum RedactStyle {
    Solid(Rgb<u8>),
    /// Mean colour of the ring around the region: blends into the background.
    Surround,
    /// Grey mosaic, a pattern derived from the block position only. `size`
    /// 0 picks a block size from the region's height.
    Blocks {
        size: u32,
    },
    /// Colour mosaic: each block takes a colour sampled from the ring around
    /// the region, from `seed`. `size` as for [`RedactStyle::Blocks`].
    Tinted {
        size: u32,
        seed: u64,
    },
    /// Random grey noise from `seed`.
    Noise {
        seed: u64,
    },
}

impl RedactStyle {
    /// Noise with a fresh seed from the OS.
    pub fn random_noise() -> Self {
        RedactStyle::Noise { seed: rand::random() }
    }

    /// Colour mosaic with a fresh seed from the OS.
    pub fn random_tinted() -> Self {
        RedactStyle::Tinted {
            size: 0,
            seed: rand::random(),
        }
    }
}

/// Width in pixels of the ring sampled around a region.
const RING: u32 = 4;

/// Pixel rectangle `[x0, y0, x1, y1)` that [`redact`] overwrites for a box;
/// empty for an inverted box (or one a negative `pad` inverts).
fn rect(b: &[f32; 4], pad: f32, w: u32, h: u32) -> [u32; 4] {
    let x0 = (b[0] - pad).floor().clamp(0.0, w as f32) as u32;
    let y0 = (b[1] - pad).floor().clamp(0.0, h as f32) as u32;
    let x1 = (b[2] + pad).ceil().clamp(0.0, w as f32) as u32;
    let y1 = (b[3] + pad).ceil().clamp(0.0, h as f32) as u32;
    [x0, y0, x1.max(x0), y1.max(y0)]
}

/// Pixels in a ring of [`RING`] around `r`, outside it.
fn ring(img: &RgbImage, r: [u32; 4]) -> Vec<Rgb<u8>> {
    let (w, h) = img.dimensions();
    let [x0, y0, x1, y1] = r;
    let (ox0, oy0) = (x0.saturating_sub(RING), y0.saturating_sub(RING));
    let (ox1, oy1) = ((x1 + RING).min(w), (y1 + RING).min(h));
    let mut v = Vec::new();
    for y in oy0..oy1 {
        for x in ox0..ox1 {
            if !(x >= x0 && x < x1 && y >= y0 && y < y1) {
                v.push(*img.get_pixel(x, y));
            }
        }
    }
    v
}

fn mean(px: &[Rgb<u8>]) -> Rgb<u8> {
    if px.is_empty() {
        return Rgb([128, 128, 128]);
    }
    let mut s = [0u64; 3];
    for p in px {
        for c in 0..3 {
            s[c] += p[c] as u64;
        }
    }
    let n = px.len() as u64;
    Rgb(s.map(|v| (v / n) as u8))
}

/// Block edge for a mosaic: `size`, or a third of the region's height.
fn block(size: u32, r: [u32; 4]) -> u32 {
    if size > 0 {
        size
    } else {
        ((r[3] - r[1]) / 3).clamp(4, 48)
    }
}

/// Where [`draw`] puts each box's pixels.
trait Canvas {
    /// Sets every pixel of `r` to `f(x, y)` (image coordinates), row by row.
    fn paint(&mut self, r: [u32; 4], f: impl FnMut(u32, u32) -> Rgb<u8>);
}

impl Canvas for RgbImage {
    fn paint(&mut self, [x0, y0, x1, y1]: [u32; 4], mut f: impl FnMut(u32, u32) -> Rgb<u8>) {
        let stride = self.width() as usize * 3;
        let buf: &mut [u8] = self;
        for y in y0..y1 {
            let row = &mut buf[y as usize * stride..][x0 as usize * 3..x1 as usize * 3];
            for (x, p) in (x0..).zip(row.as_chunks_mut::<3>().0) {
                *p = f(x, y).0;
            }
        }
    }
}

/// Each box's rectangle and the RGBA pixels drawn there, in drawing order.
#[derive(Default)]
struct Fills(Vec<([u32; 4], Vec<u8>)>);

impl Canvas for Fills {
    fn paint(&mut self, r: [u32; 4], mut f: impl FnMut(u32, u32) -> Rgb<u8>) {
        let [x0, y0, x1, y1] = r;
        let mut px = Vec::with_capacity(((x1 - x0) * (y1 - y0) * 4) as usize);
        for y in y0..y1 {
            for x in x0..x1 {
                let [r, g, b] = f(x, y).0;
                px.extend_from_slice(&[r, g, b, 255]);
            }
        }
        self.0.push((r, px));
    }
}

/// The rectangle of each box, grown by `pad` pixels, and the ring `style`
/// samples around it. Rings are sampled before any box is drawn, so one box
/// never takes its colours from a neighbour already redacted.
fn regions(img: &RgbImage, boxes: &[[f32; 4]], pad: f32, style: RedactStyle) -> Vec<([u32; 4], Vec<Rgb<u8>>)> {
    let (w, h) = img.dimensions();
    boxes
        .iter()
        .map(|b| {
            let r = rect(b, pad, w, h);
            match style {
                RedactStyle::Surround | RedactStyle::Tinted { .. } => (r, ring(img, r)),
                _ => (r, Vec::new()),
            }
        })
        .collect()
}

/// Draws each of `regions` in order.
fn draw(regions: &[([u32; 4], Vec<Rgb<u8>>)], style: RedactStyle, canvas: &mut impl Canvas) {
    let mut rng = match style {
        RedactStyle::Noise { seed } | RedactStyle::Tinted { seed, .. } => Some(SmallRng::seed_from_u64(seed)),
        _ => None,
    };
    for (r, ring) in regions {
        let r = *r;
        let [x0, y0, x1, y1] = r;
        match style {
            RedactStyle::Solid(c) => canvas.paint(r, |_, _| c),
            RedactStyle::Surround => {
                let c = mean(ring);
                canvas.paint(r, |_, _| c)
            }
            RedactStyle::Blocks { size } => {
                let s = block(size, r);
                canvas.paint(r, |x, y| {
                    let v = 96 + (((x / s) * 31 + (y / s) * 17) % 5) as u8 * 16;
                    Rgb([v, v, v])
                })
            }
            RedactStyle::Tinted { size, .. } => {
                let s = block(size, r);
                let rng = rng.as_mut().expect("seeded above");
                let base = mean(ring);
                let (bw, bh) = ((x1 - x0).div_ceil(s), (y1 - y0).div_ceil(s));
                let colours: Vec<Rgb<u8>> = (0..bw * bh)
                    .map(|_| {
                        let p = if ring.is_empty() {
                            base
                        } else {
                            ring[rng.random_range(0..ring.len())]
                        };
                        // Pull towards the mean so blocks read as one patch.
                        Rgb([0, 1, 2].map(|c| ((p[c] as u16 + base[c] as u16 * 2) / 3) as u8))
                    })
                    .collect();
                canvas.paint(r, |x, y| colours[(((y - y0) / s) * bw + (x - x0) / s) as usize])
            }
            RedactStyle::Noise { .. } => {
                let rng = rng.as_mut().expect("seeded above");
                canvas.paint(r, |_, _| {
                    let v: u8 = rng.random();
                    Rgb([v, v, v])
                })
            }
        }
    }
}

/// Copies the part of RGBA `src` covering rectangle `sr` that falls inside
/// RGBA `dst` covering `dr`.
fn blit(dst: &mut [u8], dr: [u32; 4], src: &[u8], sr: [u32; 4]) {
    let (x0, x1) = (dr[0].max(sr[0]), dr[2].min(sr[2]));
    let (y0, y1) = (dr[1].max(sr[1]), dr[3].min(sr[3]));
    if x0 >= x1 || y0 >= y1 {
        return;
    }
    let n = (x1 - x0) as usize * 4;
    let (dw, sw) = ((dr[2] - dr[0]) as usize * 4, (sr[2] - sr[0]) as usize * 4);
    for y in y0..y1 {
        let d = (y - dr[1]) as usize * dw + (x0 - dr[0]) as usize * 4;
        let s = (y - sr[1]) as usize * sw + (x0 - sr[0]) as usize * 4;
        dst[d..d + n].copy_from_slice(&src[s..s + n]);
    }
}

/// Overwrites each `[x0, y0, x1, y1]` box, grown by `pad` pixels, in place.
pub fn redact(img: &mut RgbImage, boxes: &[[f32; 4]], pad: f32, style: RedactStyle) {
    let regions = regions(img, boxes, pad, style);
    draw(&regions, style, img);
}

/// A redacted region for previews: its rectangle and RGBA pixels.
pub struct Patch {
    pub rect: [u32; 4],
    pub rgba: Vec<u8>,
}

/// What [`redact`] would draw for each box (including overlapping boxes drawn
/// over it), without copying the image.
pub fn redaction_patches(img: &RgbImage, boxes: &[[f32; 4]], pad: f32, style: RedactStyle) -> Vec<Patch> {
    let mut fills = Fills::default();
    draw(&regions(img, boxes, pad, style), style, &mut fills);
    let mut fills = fills.0;
    // A box's own fill covers its rectangle, so only later boxes show over it;
    // those are still unmodified when it is composed.
    for i in 0..fills.len() {
        let (head, later) = fills.split_at_mut(i + 1);
        let (r, px) = &mut head[i];
        for (o, top) in later.iter() {
            blit(px, *r, top, *o);
        }
    }
    fills.into_iter().map(|(rect, rgba)| Patch { rect, rgba }).collect()
}

/// Result of the pre-export self-check (docs/design.md §8).
#[derive(Debug, Serialize)]
pub struct ExportCheck {
    /// Pre-selected detections on the output that are not inside a redacted
    /// region: something private may still be visible.
    pub surviving: Vec<Detection>,
    /// Indices of boxes whose output pixels correlate with the source pixels.
    pub correlated: Vec<usize>,
}

impl ExportCheck {
    pub fn passed(&self) -> bool {
        self.surviving.is_empty() && self.correlated.is_empty()
    }
}

/// Correlation above this between source and output luma in a box fails the
/// check. Independent fills land near 0.
const MAX_CORRELATION: f64 = 0.2;

/// Correlation of an independent fill over `n` independent units has a
/// standard deviation of about 1/sqrt(n); a box fails only beyond this many
/// of them, so mosaics with few blocks do not fail by chance.
const SIGMAS: f64 = 4.0;

/// Independent units a style draws in `r`: blocks for mosaics, pixels else.
fn units(style: RedactStyle, r: [u32; 4]) -> f64 {
    let (w, h) = (r[2] - r[0], r[3] - r[1]);
    match style {
        RedactStyle::Blocks { size } | RedactStyle::Tinted { size, .. } => {
            let s = block(size, r);
            (w.div_ceil(s) * h.div_ceil(s)) as f64
        }
        _ => (w * h) as f64,
    }
}

/// Whether `r` in `out` still follows `src`: correlation beyond chance for
/// what `style` draws there.
fn correlated(src: &RgbImage, out: &RgbImage, r: [u32; 4], style: RedactStyle) -> bool {
    let limit = MAX_CORRELATION.max(SIGMAS / units(style, r).max(1.0).sqrt());
    correlation(src, out, r).is_some_and(|c| c.abs() > limit)
}

/// Re-runs the detector on `out` and compares it with `src` inside every
/// redacted box. `boxes`, `pad` and `style` must be what [`redact`] was given.
/// `prev`, candidates on `src` from [`Detector::candidates`], lets the
/// detector rerun only where `out` differs; the result is the same.
pub fn export_check(
    det: &mut Detector,
    src: &RgbImage,
    out: &RgbImage,
    prev: Option<&Candidates>,
    boxes: &[[f32; 4]],
    pad: f32,
    style: RedactStyle,
) -> Result<ExportCheck> {
    let (w, h) = out.dimensions();
    let regions: Vec<[f32; 4]> = boxes.iter().map(|b| rect(b, pad, w, h).map(|v| v as f32)).collect();
    let opts = DetectOptions::default();
    let cands = match prev {
        Some(p) if p.min_score() <= opts.min_score => det.redetect(p, src, out)?,
        _ => det.candidates(out, opts.min_score)?,
    };
    let surviving = det
        .detections(&cands, &opts)?
        .into_iter()
        .filter(|d| det.selection(d) == Selection::Selected && coverage(&d.bbox, &regions) < 0.9)
        .collect();
    let correlated = if src.dimensions() == out.dimensions() {
        boxes
            .iter()
            .enumerate()
            .filter(|(_, b)| correlated(src, out, rect(b, pad, w, h), style))
            .map(|(i, _)| i)
            .collect()
    } else {
        // A resized output cannot be compared pixel for pixel; every box is
        // reported so the caller cannot mistake this for a pass.
        (0..boxes.len()).collect()
    };
    Ok(ExportCheck { surviving, correlated })
}

/// Pearson correlation of luma inside `r`; `None` when either side is flat
/// (a constant fill carries no information about the source).
fn correlation(a: &RgbImage, b: &RgbImage, r: [u32; 4]) -> Option<f64> {
    let luma = |p: &Rgb<u8>| 0.299 * p[0] as f64 + 0.587 * p[1] as f64 + 0.114 * p[2] as f64;
    let (mut n, mut sa, mut sb, mut saa, mut sbb, mut sab) = (0f64, 0f64, 0f64, 0f64, 0f64, 0f64);
    for y in r[1]..r[3] {
        for x in r[0]..r[2] {
            let (u, v) = (luma(a.get_pixel(x, y)), luma(b.get_pixel(x, y)));
            n += 1.0;
            sa += u;
            sb += v;
            saa += u * u;
            sbb += v * v;
            sab += u * v;
        }
    }
    let va = saa - sa * sa / n;
    let vb = sbb - sb * sb / n;
    if n < 2.0 || va < 1e-6 * n || vb < 1e-6 * n {
        return None;
    }
    Some((sab - sa * sb / n) / (va * vb).sqrt())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn output_does_not_depend_on_source_pixels() {
        for style in [RedactStyle::Blocks { size: 8 }, RedactStyle::Noise { seed: 7 }] {
            check_independent(style);
        }
    }

    #[test]
    fn redacted_regions_do_not_correlate() {
        let src = RgbImage::from_fn(64, 64, |x, y| Rgb([(x * 4) as u8, (y * 4) as u8, 200]));
        let boxes = [[10.0, 10.0, 50.0, 30.0]];
        for style in [
            RedactStyle::Solid(Rgb([0, 0, 0])),
            RedactStyle::Noise { seed: 1 },
            RedactStyle::Surround,
            RedactStyle::Tinted { size: 0, seed: 1 },
        ] {
            let mut out = src.clone();
            redact(&mut out, &boxes, 2.0, style);
            assert!(
                !correlated(&src, &out, rect(&boxes[0], 2.0, 64, 64), style),
                "{style:?}"
            );
        }
        // Untouched pixels correlate perfectly and fail under every style.
        let r = correlation(&src, &src, rect(&boxes[0], 2.0, 64, 64)).unwrap();
        assert!((r - 1.0).abs() < 1e-9);
        for style in [RedactStyle::Noise { seed: 1 }, RedactStyle::Tinted { size: 0, seed: 1 }] {
            assert!(correlated(&src, &src, rect(&boxes[0], 2.0, 64, 64), style));
        }
    }

    #[test]
    fn surround_styles_read_only_outside_the_region() {
        let boxes = [[10.0, 10.0, 50.0, 30.0]];
        let outside = |x: u32, y: u32| Rgb([(x * 4) as u8, (y * 4) as u8, 200]);
        let r = rect(&boxes[0], 2.0, 64, 64);
        let inside = |x: u32, y: u32| x >= r[0] && x < r[2] && y >= r[1] && y < r[3];
        let mut a = RgbImage::from_fn(64, 64, |x, y| if inside(x, y) { Rgb([0, 0, 0]) } else { outside(x, y) });
        let mut b = RgbImage::from_fn(
            64,
            64,
            |x, y| if inside(x, y) { Rgb([255, 9, 77]) } else { outside(x, y) },
        );
        for style in [RedactStyle::Surround, RedactStyle::Tinted { size: 6, seed: 3 }] {
            redact(&mut a, &boxes, 2.0, style);
            redact(&mut b, &boxes, 2.0, style);
            assert_eq!(a, b, "{style:?}");
        }
    }

    /// The previous in-place [`redact`].
    fn reference(img: &mut RgbImage, boxes: &[[f32; 4]], pad: f32, style: RedactStyle) {
        let (w, h) = img.dimensions();
        let mut rng = match style {
            RedactStyle::Noise { seed } | RedactStyle::Tinted { seed, .. } => Some(SmallRng::seed_from_u64(seed)),
            _ => None,
        };
        // Rings are sampled from the image before any box is drawn, so one box
        // never takes its colours from a neighbour already redacted.
        let rects: Vec<[u32; 4]> = boxes.iter().map(|b| rect(b, pad, w, h)).collect();
        let rings: Vec<Vec<Rgb<u8>>> = match style {
            RedactStyle::Surround | RedactStyle::Tinted { .. } => rects.iter().map(|&r| ring(img, r)).collect(),
            _ => vec![Vec::new(); rects.len()],
        };
        for (&r, ring) in rects.iter().zip(&rings) {
            let [x0, y0, x1, y1] = r;
            match style {
                RedactStyle::Solid(c) => paint(img, r, |_, _| c),
                RedactStyle::Surround => {
                    let c = mean(ring);
                    paint(img, r, |_, _| c);
                }
                RedactStyle::Blocks { size } => {
                    let s = block(size, r);
                    paint(img, r, |x, y| {
                        let v = 96 + (((x / s) * 31 + (y / s) * 17) % 5) as u8 * 16;
                        Rgb([v, v, v])
                    });
                }
                RedactStyle::Tinted { size, .. } => {
                    let s = block(size, r);
                    let rng = rng.as_mut().expect("seeded above");
                    let base = mean(ring);
                    let (bw, bh) = ((x1 - x0).div_ceil(s), (y1 - y0).div_ceil(s));
                    let colours: Vec<Rgb<u8>> = (0..bw * bh)
                        .map(|_| {
                            let p = if ring.is_empty() {
                                base
                            } else {
                                ring[rng.random_range(0..ring.len())]
                            };
                            // Pull towards the mean so blocks read as one patch.
                            Rgb([0, 1, 2].map(|c| ((p[c] as u16 + base[c] as u16 * 2) / 3) as u8))
                        })
                        .collect();
                    paint(img, r, |x, y| colours[(((y - y0) / s) * bw + (x - x0) / s) as usize]);
                }
                RedactStyle::Noise { .. } => {
                    let rng = rng.as_mut().expect("seeded above");
                    paint(img, r, |_, _| {
                        let v: u8 = rng.random();
                        Rgb([v, v, v])
                    });
                }
            }
        }
    }
    fn paint(img: &mut RgbImage, [x0, y0, x1, y1]: [u32; 4], mut f: impl FnMut(u32, u32) -> Rgb<u8>) {
        for y in y0..y1 {
            for x in x0..x1 {
                img.put_pixel(x, y, f(x, y));
            }
        }
    }

    #[test]
    fn redact_and_patches_match_the_reference() {
        let src = RgbImage::from_fn(97, 80, |x, y| Rgb([(x * 4) as u8, (y * 3) as u8, (x ^ y) as u8]));
        // Overlapping, touching the edges, partly and wholly outside, empty.
        let boxes = [
            [10.0, 10.0, 50.0, 30.0],
            [40.0, 20.0, 70.0, 60.0],
            [5.0, 40.0, 20.0, 60.0],
            [-8.0, 70.0, 30.0, 95.0],
            [90.0, -3.0, 120.0, 12.0],
            [200.0, 200.0, 210.0, 210.0],
            [12.0, 12.0, 30.0, 25.0],
        ];
        for style in [
            RedactStyle::Solid(Rgb([1, 2, 3])),
            RedactStyle::Surround,
            RedactStyle::Blocks { size: 0 },
            RedactStyle::Blocks { size: 7 },
            RedactStyle::Tinted { size: 0, seed: 5 },
            RedactStyle::Tinted { size: 6, seed: 9 },
            RedactStyle::Noise { seed: 3 },
        ] {
            let mut want = src.clone();
            reference(&mut want, &boxes, 2.0, style);
            let mut got = src.clone();
            redact(&mut got, &boxes, 2.0, style);
            assert_eq!(got, want, "{style:?}");
            let patches = redaction_patches(&src, &boxes, 2.0, style);
            assert_eq!(patches.len(), boxes.len());
            for (p, b) in patches.iter().zip(&boxes) {
                let [x0, y0, x1, y1] = rect(b, 2.0, 97, 80);
                assert_eq!(p.rect, [x0, y0, x1, y1]);
                let old: Vec<u8> = (y0..y1)
                    .flat_map(|y| (x0..x1).map(move |x| (x, y)))
                    .flat_map(|(x, y)| {
                        let q = want.get_pixel(x, y);
                        [q[0], q[1], q[2], 255]
                    })
                    .collect();
                assert_eq!(p.rgba, old, "{style:?} {b:?}");
            }
        }
    }

    #[test]
    fn inverted_boxes_draw_nothing() {
        let src = RgbImage::from_fn(64, 64, |x, y| Rgb([(x * 4) as u8, (y * 4) as u8, 9]));
        let valid = [10.0, 10.0, 40.0, 30.0];
        // Inverted, and narrower than twice a negative pad.
        let with = [[50.0, 20.0, 30.0, 40.0], valid, [20.0, 40.0, 24.0, 44.0]];
        for style in [
            RedactStyle::Solid(Rgb([1, 2, 3])),
            RedactStyle::Surround,
            RedactStyle::Blocks { size: 0 },
            RedactStyle::Tinted { size: 0, seed: 5 },
            RedactStyle::Noise { seed: 3 },
        ] {
            let (mut a, mut b) = (src.clone(), src.clone());
            redact(&mut a, &with, -3.0, style);
            redact(&mut b, &[valid], -3.0, style);
            assert_eq!(a, b, "{style:?}");
            let p = redaction_patches(&src, &with, -3.0, style);
            assert!(p[0].rgba.is_empty() && p[2].rgba.is_empty(), "{style:?}");
            assert_eq!(p[1].rgba, redaction_patches(&src, &[valid], -3.0, style)[0].rgba);
            assert!(!correlated(&src, &a, rect(&with[0], -3.0, 64, 64), style));
        }
    }

    fn check_independent(style: RedactStyle) {
        let boxes = [[10.0, 10.0, 50.0, 30.0]];
        let mut a = RgbImage::from_pixel(64, 64, Rgb([0, 0, 0]));
        let mut b = RgbImage::from_fn(64, 64, |x, y| Rgb([(x * 4) as u8, (y * 4) as u8, 200]));
        redact(&mut a, &boxes, 2.0, style);
        redact(&mut b, &boxes, 2.0, style);
        for y in 8..32 {
            for x in 8..52 {
                assert_eq!(a.get_pixel(x, y), b.get_pixel(x, y));
            }
        }
    }
}

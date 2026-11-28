//! Input scale and graph shapes of a [`crate::Resolution::Pt2`] model:
//! phone screenshots are scaled to about 2 px per point, everything else
//! runs at its own pixels, and each image runs on the input shape that
//! processes the fewest pixels (`tests/scale_cases.json` pins the cases).

/// Long over short side from which a screenshot is a phone's.
const PHONE_ASPECT: f64 = 1.9;
/// Widest phone screen, in pixels (iPhone Pro Max): larger short sides are
/// tablets, desktops or ultrawide monitors, at 2 px per point or less.
const PHONE_MAX_SHORT: u32 = 1320;
/// Short side of a phone screenshot at 2 px per point (393 pt).
const PHONE_SHORT: u32 = 786;

/// Default input shapes, `[width, height]`.
pub const SHAPES: [[u32; 2]; 3] = [[896, 1280], [1280, 896], [1280, 1280]];

/// Factor (at most 1) a `w`x`h` image is scaled by before detection.
pub fn scale_for(w: u32, h: u32) -> f64 {
    let (short, long) = (w.min(h), w.max(h));
    if short > PHONE_SHORT && short <= PHONE_MAX_SHORT && long as f64 >= PHONE_ASPECT * short as f64 {
        PHONE_SHORT as f64 / short as f64
    } else {
        1.0
    }
}

/// `w`x`h` scaled by `s`, rounding half up.
pub fn scaled_size(w: u32, h: u32, s: f64) -> (u32, u32) {
    let r = |n: u32| ((n as f64 * s + 0.5).floor() as u32).max(1);
    (r(w), r(h))
}

/// Number of `t`-long tiles covering a `len`-long axis with `overlap`
/// (`crate::detect::tile_plan`).
fn tiles(len: usize, t: usize, overlap: usize) -> usize {
    if len <= t {
        return 1;
    }
    assert!(t > overlap, "tile {t} must exceed overlap {overlap}");
    let step = t - overlap;
    (len - t).div_ceil(step) + 1
}

/// The shape of `shapes` a `w`x`h` (already scaled) image runs on: the one
/// whose tiles process the fewest pixels, ties going to the orientation
/// closer to the image's.
pub fn shape_for(w: u32, h: u32, shapes: &[[u32; 2]]) -> [u32; 2] {
    let (w, h) = (w as usize, h as usize);
    let cost = |&[sw, sh]: &[u32; 2]| {
        let (sw, sh) = (sw as usize, sh as usize);
        let px = tiles(w, sw, crate::detect::TILE_OVERLAP_X) * tiles(h, sh, crate::detect::TILE_OVERLAP_Y) * sw * sh;
        let skew = ((sw * h) as f64 / (sh * w) as f64).ln().abs();
        (px, skew)
    };
    *shapes
        .iter()
        .min_by(|a, b| cost(a).partial_cmp(&cost(b)).expect("finite"))
        .expect("at least one shape")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[derive(serde::Deserialize)]
    struct Case {
        size: [u32; 2],
        scale: f64,
        scaled: [u32; 2],
        shape: [u32; 2],
        tiles: usize,
    }

    #[test]
    fn shared_cases() {
        let cases: Vec<Case> = serde_json::from_str(include_str!("../tests/scale_cases.json")).unwrap();
        for c in cases {
            let [w, h] = c.size;
            let s = scale_for(w, h);
            assert!((s - c.scale).abs() < 1e-9, "{w}x{h}: scale {s}");
            let (sw, sh) = scaled_size(w, h, s);
            assert_eq!([sw, sh], c.scaled, "{w}x{h}");
            let shape = shape_for(sw, sh, &SHAPES);
            assert_eq!(shape, c.shape, "{w}x{h}");
            let n = tiles(sw as usize, shape[0] as usize, crate::detect::TILE_OVERLAP_X)
                * tiles(sh as usize, shape[1] as usize, crate::detect::TILE_OVERLAP_Y);
            assert_eq!(n, c.tiles, "{w}x{h}");
        }
    }

    #[test]
    fn tile_count_matches_the_plan() {
        for len in [1, 895, 896, 897, 1280, 1281, 1700, 5120, 8000] {
            for t in [896, 1280] {
                for overlap in [crate::detect::TILE_OVERLAP_X, crate::detect::TILE_OVERLAP_Y] {
                    assert_eq!(
                        tiles(len, t, overlap),
                        crate::detect::tile_plan(len, t, overlap).len(),
                        "{len} {t} {overlap}"
                    );
                }
            }
        }
    }
}

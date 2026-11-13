use std::path::{Path, PathBuf};

use image::RgbImage;
use ndarray::Array4;
use serde::Deserialize;

use crate::{Calibration, Error, Result};

/// Width every image is resized to before inference. Phone screenshots are
/// 360-430 CSS px wide whatever the device scale, so a fixed width puts text at
/// a predictable pixel height. Must match the training code.
pub const INPUT_WIDTH: u32 = 720;

const MEAN: [f32; 3] = [0.485 * 255.0, 0.456 * 255.0, 0.406 * 255.0];
const STD: [f32; 3] = [0.229 * 255.0, 0.224 * 255.0, 0.225 * 255.0];

/// Sidecar `<model>.onnx.json` written by the export, extended by
/// `unseen calibrate`.
#[derive(Debug, Clone, Deserialize)]
pub struct ModelMeta {
    pub classes: Vec<String>,
    /// Output strides, in output order.
    pub strides: Vec<u32>,
    /// `[width, height]` of a fixed-size graph; tall images are then run in
    /// overlapping tiles. Absent for a graph with dynamic height.
    #[serde(default)]
    pub input_size: Option<[u32; 2]>,
    #[serde(default)]
    pub calibration: Option<Calibration>,
}

/// Thresholds used when a model has no calibration for a class.
pub const UNCALIBRATED_SELECT: f32 = 0.3;
pub const UNCALIBRATED_REVIEW: f32 = 0.1;

impl ModelMeta {
    pub fn sidecar(model: &Path) -> PathBuf {
        let mut p = model.as_os_str().to_owned();
        p.push(".json");
        p.into()
    }

    pub fn load(model: &Path) -> Result<Self> {
        let p = Self::sidecar(model);
        let s = std::fs::read_to_string(&p).map_err(|e| Error::Meta(format!("{}: {e}", p.display())))?;
        serde_json::from_str(&s).map_err(|e| Error::Meta(e.to_string()))
    }

    /// Writes `calibration` into the sidecar, keeping every other field.
    pub fn store_calibration(model: &Path, cal: &Calibration) -> Result<()> {
        let p = Self::sidecar(model);
        let meta = |e: &dyn std::fmt::Display| Error::Meta(format!("{}: {e}", p.display()));
        let s = std::fs::read_to_string(&p).map_err(|e| meta(&e))?;
        let mut v: serde_json::Value = serde_json::from_str(&s).map_err(|e| meta(&e))?;
        let obj = v.as_object_mut().ok_or_else(|| meta(&"not a JSON object"))?;
        obj.insert("calibration".into(), serde_json::to_value(cal).map_err(|e| meta(&e))?);
        let out = serde_json::to_string_pretty(&v).map_err(|e| meta(&e))?;
        std::fs::write(&p, out + "\n").map_err(|e| meta(&e))
    }

    /// (select, review) thresholds for a class.
    pub fn thresholds(&self, class: &str) -> (f32, f32) {
        self.calibration
            .as_ref()
            .and_then(|c| c.classes.get(class))
            .map_or((UNCALIBRATED_SELECT, UNCALIBRATED_REVIEW), |t| (t.select, t.review))
    }
}

/// Decodes an image, telling the format from its bytes rather than the file
/// name: pickers and share targets hand over files whose extension does not
/// match their content.
pub fn load_image(path: &Path) -> Result<RgbImage> {
    let fail = |e: &dyn std::fmt::Display| Error::Image(format!("{}: {e}", path.display()));
    let reader = image::ImageReader::open(path).map_err(|e| fail(&e))?;
    let reader = reader.with_guessed_format().map_err(|e| fail(&e))?;
    Ok(reader.decode().map_err(|e| fail(&e))?.to_rgb8())
}

/// The file carries a camera make or model in its EXIF, as photos do and
/// screenshots do not. Reads only the header. The detector is calibrated on
/// screenshots, so callers warn when this is true.
pub fn is_camera_photo(path: &Path) -> bool {
    use image::ImageDecoder;
    let exif = image::ImageReader::open(path)
        .and_then(|r| r.with_guessed_format())
        .ok()
        .and_then(|r| r.into_decoder().ok())
        .and_then(|mut d| d.exif_metadata().ok().flatten());
    let Some(raw) = exif else { return false };
    exif::Reader::new().read_raw(raw).is_ok_and(|e| {
        [exif::Tag::Make, exif::Tag::Model]
            .iter()
            .any(|&t| e.get_field(t, exif::In::PRIMARY).is_some())
    })
}

pub struct Preprocessed {
    pub tensor: Array4<f32>,
    /// Multiply model-space coordinates by this to get original-image pixels.
    pub scale: f32,
}

/// Resize to [`INPUT_WIDTH`] (bilinear with antialiasing, as PIL's
/// `BILINEAR` in training), normalise to ImageNet mean/std and pad both
/// sides to a multiple of 32 with zeros (the mean colour). Training pads
/// uint8 with the mean rounded, within a grey level of this.
pub fn preprocess(img: &RgbImage) -> Preprocessed {
    let s = INPUT_WIDTH as f32 / img.width() as f32;
    let h = resized_height(img.width(), img.height());
    let resized = resize(img, INPUT_WIDTH, h);
    let (w, h) = (INPUT_WIDTH as usize, h as usize);
    let (ph, pw) = (h.div_ceil(32) * 32, w.div_ceil(32) * 32);
    let mut t = Array4::<f32>::zeros((1, 3, ph, pw));
    let planes = t.as_slice_mut().expect("standard layout");
    for (c, plane) in planes.chunks_exact_mut(ph * pw).enumerate() {
        let (m, d) = (MEAN[c], STD[c]);
        for (dst, src) in plane.chunks_exact_mut(pw).zip(resized.chunks_exact(w * 3)) {
            for (o, p) in dst[..w].iter_mut().zip(src.as_chunks::<3>().0) {
                *o = (p[c] as f32 - m) / d;
            }
        }
    }
    Preprocessed {
        tensor: t,
        scale: 1.0 / s,
    }
}

/// Height of a `w`x`h` image resized to [`INPUT_WIDTH`], before padding:
/// `round(h * width / w)` as in training (Python rounds half to even).
pub(crate) fn resized_height(w: u32, h: u32) -> u32 {
    ((f64::from(h) * f64::from(INPUT_WIDTH) / f64::from(w)).round_ties_even() as u32).max(1)
}

/// Packed RGB pixels of `img` resized to `w`x`h`.
pub(crate) fn resize(img: &RgbImage, w: u32, h: u32) -> Vec<u8> {
    use fast_image_resize::{
        FilterType, PixelType, ResizeAlg, ResizeOptions, Resizer,
        images::{Image, ImageRef},
    };
    let src = ImageRef::new(img.width(), img.height(), img.as_raw(), PixelType::U8x3).expect("RgbImage is packed RGB");
    let mut dst = Image::new(w, h, PixelType::U8x3);
    Resizer::new()
        .resize(
            &src,
            &mut dst,
            &ResizeOptions::new().resize_alg(ResizeAlg::Convolution(FilterType::Bilinear)),
        )
        .expect("same pixel type, non-empty");
    dst.into_vec()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pads_both_sides_to_32() {
        let pre = preprocess(&RgbImage::new(390, 844));
        let (_, _, h, w) = pre.tensor.dim();
        assert_eq!((h % 32, w % 32), (0, 0));
        assert!(w >= INPUT_WIDTH as usize && h >= 1558);
    }

    #[test]
    fn resized_height_rounds_like_python() {
        // round(h * 720 / w) in Python: exact halves go to the even neighbour.
        assert_eq!(resized_height(1440, 5), 2); // 2.5
        assert_eq!(resized_height(1440, 7), 4); // 3.5
        assert_eq!(resized_height(1280, 2004), 1127); // 1127.25
        assert_eq!(resized_height(1290, 2796), 1561); // 1560.56
        assert_eq!(resized_height(1440, 4999), 2500); // 2499.5
        assert_eq!(resized_height(1440, 4997), 2498); // 2498.5
    }

    /// The previous implementation: `image`'s Triangle filter and 4-D indexing.
    fn reference(img: &RgbImage) -> Array4<f32> {
        let s = INPUT_WIDTH as f32 / img.width() as f32;
        let h = ((img.height() as f32 * s).round() as u32).max(1);
        let resized = image::imageops::resize(img, INPUT_WIDTH, h, image::imageops::FilterType::Triangle);
        let (ph, pw) = (h.div_ceil(32) * 32, INPUT_WIDTH.div_ceil(32) * 32);
        let mut t = Array4::<f32>::zeros((1, 3, ph as usize, pw as usize));
        for (x, y, p) in resized.enumerate_pixels() {
            for c in 0..3 {
                t[[0, c, y as usize, x as usize]] = (p[c] as f32 - MEAN[c]) / STD[c];
            }
        }
        t
    }

    #[test]
    fn matches_the_triangle_filter_within_a_grey_level() {
        for (w, h) in [(1290, 2796), (390, 844), (720, 1601), (1080, 333)] {
            let img = RgbImage::from_fn(w, h, |x, y| {
                let text = (y / 23) % 3 == 0 && (x / 5 + y / 7) % 4 != 0;
                if text {
                    image::Rgb([15, 15, 20])
                } else {
                    image::Rgb([(x * 7 % 256) as u8, (y * 3 % 256) as u8, ((x ^ y) % 256) as u8])
                }
            });
            let (a, b) = (preprocess(&img).tensor, reference(&img));
            assert_eq!(a.dim(), b.dim());
            for (c, std) in STD.iter().enumerate() {
                let (pa, pb) = (a.slice(ndarray::s![0, c, .., ..]), b.slice(ndarray::s![0, c, .., ..]));
                let grey = pa
                    .iter()
                    .zip(pb)
                    .map(|(x, y)| ((x - y) * std).abs())
                    .fold(0f32, f32::max);
                assert!(grey <= 1.0 + 1e-3, "{w}x{h} channel {c}: {grey} grey levels apart");
            }
        }
    }
}

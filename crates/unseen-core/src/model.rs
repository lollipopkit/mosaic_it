use std::path::{Path, PathBuf};

use image::RgbImage;
use ndarray::Array4;
use serde::Deserialize;

use crate::{Calibration, Error, Result};

const MEAN: [f32; 3] = [0.485 * 255.0, 0.456 * 255.0, 0.406 * 255.0];
const STD: [f32; 3] = [0.229 * 255.0, 0.224 * 255.0, 0.225 * 255.0];

/// Sidecar `<model>.onnx.json` written by the export, extended by
/// `unseen calibrate`.
#[derive(Debug, Clone, Deserialize)]
pub struct ModelMeta {
    pub classes: Vec<String>,
    /// Output strides, in output order.
    pub strides: Vec<u32>,
    /// `[width, height]` of a fixed-size graph; larger images are then run
    /// in overlapping tiles. Absent for a graph with dynamic input size.
    #[serde(default)]
    pub input_size: Option<[u32; 2]>,
    /// The input scale the model was trained at. Required, so a model trained
    /// on resized images fails to load instead of running at the wrong scale.
    pub resolution: Resolution,
    #[serde(default)]
    pub calibration: Option<Calibration>,
}

/// Images are never resized: the model sees original pixels.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Resolution {
    Native,
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
        let meta: Self = serde_json::from_str(&s).map_err(|e| Error::Meta(e.to_string()))?;
        meta.validate()?;
        Ok(meta)
    }

    /// Tiles must step forward ([`crate::detect::TILE_OVERLAP`]) and fit the
    /// strides, as the training code requires.
    fn validate(&self) -> Result<()> {
        let overlap = crate::detect::TILE_OVERLAP;
        if let Some(size) = self.input_size
            && size.iter().any(|&n| n as usize <= overlap || n % 32 != 0)
        {
            return Err(Error::Meta(format!(
                "input_size {size:?}: each side must be a multiple of 32 above {overlap}"
            )));
        }
        Ok(())
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

/// The `w`x`h` window of `img` at (`x`, `y`) normalised to ImageNet
/// mean/std; pixels outside the image are zeros (the mean colour), as the
/// training pads with the mean.
pub fn tensor(img: &RgbImage, x: usize, y: usize, w: usize, h: usize) -> Array4<f32> {
    let mut t = Array4::<f32>::zeros((1, 3, h, w));
    let (iw, ih) = (img.width() as usize, img.height() as usize);
    let (cols, rows) = (w.min(iw.saturating_sub(x)), h.min(ih.saturating_sub(y)));
    let raw = img.as_raw();
    if cols == 0 {
        return t;
    }
    let planes = t.as_slice_mut().expect("standard layout");
    for (c, plane) in planes.chunks_exact_mut(h * w).enumerate() {
        let (m, d) = (MEAN[c], STD[c]);
        for (r, dst) in plane.chunks_exact_mut(w).take(rows).enumerate() {
            let src = &raw[((y + r) * iw + x) * 3..][..cols * 3];
            for (o, p) in dst[..cols].iter_mut().zip(src.as_chunks::<3>().0) {
                *o = (p[c] as f32 - m) / d;
            }
        }
    }
    t
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn tensor_normalises_the_window_and_pads_with_the_mean() {
        let img = RgbImage::from_fn(5, 4, |x, y| image::Rgb([(x * 40) as u8, (y * 50) as u8, 7]));
        assert!(tensor(&img, 9, 3, 2, 2).iter().all(|&v| v == 0.0));
        let t = tensor(&img, 3, 1, 4, 4);
        assert_eq!(t.dim(), (1, 3, 4, 4));
        for (c, (m, d)) in MEAN.iter().zip(STD).enumerate() {
            for yy in 0..4 {
                for xx in 0..4 {
                    let (x, y) = (3 + xx, 1 + yy);
                    let want = if x < 5 && y < 4 {
                        (img.get_pixel(x as u32, y as u32)[c] as f32 - m) / d
                    } else {
                        0.0
                    };
                    assert_eq!(t[[0, c, yy, xx]], want, "c{c} ({x}, {y})");
                }
            }
        }
    }

    #[test]
    fn models_trained_on_resized_images_do_not_load() {
        let old = r#"{"classes": ["a"], "strides": [8]}"#;
        assert!(serde_json::from_str::<ModelMeta>(old).is_err());
        let new = r#"{"classes": ["a"], "strides": [8], "resolution": "native"}"#;
        assert_eq!(
            serde_json::from_str::<ModelMeta>(new).unwrap().resolution,
            Resolution::Native
        );
    }

    #[test]
    fn tiles_must_exceed_the_overlap() {
        let meta = |size: [u32; 2]| ModelMeta {
            classes: vec!["a".into()],
            strides: vec![8],
            input_size: Some(size),
            resolution: Resolution::Native,
            calibration: None,
        };
        assert!(meta([1280, 1280]).validate().is_ok());
        for bad in [[384, 1280], [1280, 352], [1290, 1280]] {
            assert!(meta(bad).validate().is_err(), "{bad:?}");
        }
    }
}

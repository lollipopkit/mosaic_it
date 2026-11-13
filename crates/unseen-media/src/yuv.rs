//! YUV 4:2:0 buffers as MediaCodec lays them out, converted with
//! `yuvutils-rs`. Each plane has an offset, a row stride and a column step
//! (1 for planar, 2 for interleaved chroma), which covers I420, YV12, NV12
//! and NV21 alike.

use image::RgbImage;
use yuvutils_rs::{BufferStoreMut, YuvPlanarImage, YuvPlanarImageMut, YuvRange, YuvStandardMatrix};

use crate::{Error, Result};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) struct Plane {
    pub offset: usize,
    pub row: usize,
    pub col: usize,
}

#[derive(Debug, Clone, Copy)]
pub(crate) struct Layout {
    pub y: Plane,
    pub u: Plane,
    pub v: Plane,
    /// Visible region: left, top, width, height.
    pub crop: (u32, u32, u32, u32),
    pub matrix: YuvStandardMatrix,
    pub range: YuvRange,
}

fn err(e: impl std::fmt::Debug) -> Error {
    Error::Platform(format!("yuv conversion: {e:?}"))
}

impl Layout {
    /// I420: Y, U, V planes; chroma rows `stride / 2` wide.
    pub fn i420(stride: usize, slice_height: usize, crop: (u32, u32, u32, u32)) -> Self {
        let c = stride * slice_height;
        let cs = stride / 2;
        Self {
            y: Plane {
                offset: 0,
                row: stride,
                col: 1,
            },
            u: Plane {
                offset: c,
                row: cs,
                col: 1,
            },
            v: Plane {
                offset: c + cs * slice_height.div_ceil(2),
                row: cs,
                col: 1,
            },
            crop,
            matrix: YuvStandardMatrix::Bt709,
            range: YuvRange::Limited,
        }
    }

    /// NV12: Y plane, then interleaved U, V rows `stride` wide.
    pub fn nv12(stride: usize, slice_height: usize, crop: (u32, u32, u32, u32)) -> Self {
        let c = stride * slice_height;
        Self {
            y: Plane {
                offset: 0,
                row: stride,
                col: 1,
            },
            u: Plane {
                offset: c,
                row: stride,
                col: 2,
            },
            v: Plane {
                offset: c + 1,
                row: stride,
                col: 2,
            },
            crop,
            matrix: YuvStandardMatrix::Bt709,
            range: YuvRange::Limited,
        }
    }

    /// From Android's `MediaImage2` (MediaFormat "image-data"): 8-bit YUV
    /// with 2×2-subsampled chroma, or None for anything else.
    pub fn from_media_image(raw: &[u8], crop: (u32, u32, u32, u32)) -> Option<Self> {
        let word = |i: usize| {
            raw.get(i * 4..i * 4 + 4)
                .map(|b| u32::from_ne_bytes(b.try_into().unwrap()))
        };
        // mType, mNumPlanes, mWidth, mHeight, mBitDepth, mBitDepthAllocated,
        // then per plane mOffset, mColInc, mRowInc, mHorizSubsampling,
        // mVertSubsampling.
        let (kind, planes, depth) = (word(0)?, word(1)?, word(4)?);
        const YUV: u32 = 1;
        if kind != YUV || planes != 3 || depth != 8 {
            return None;
        }
        let plane = |p: usize, sub: u32| {
            let b = 6 + p * 5;
            let (offset, col, row) = (word(b)?, word(b + 1)? as i32, word(b + 2)? as i32);
            (col > 0 && row > 0 && word(b + 3)? == sub && word(b + 4)? == sub).then_some(Plane {
                offset: offset as usize,
                row: row as usize,
                col: col as usize,
            })
        };
        Some(Self {
            y: plane(0, 1)?,
            u: plane(1, 2)?,
            v: plane(2, 2)?,
            crop,
            matrix: YuvStandardMatrix::Bt709,
            range: YuvRange::Limited,
        })
    }

    /// Bytes a buffer needs to hold the whole crop.
    pub fn len(&self) -> usize {
        let (l, t, w, h) = self.crop;
        let end = |p: Plane, x: u32, y: u32, cols: u32, rows: u32| {
            p.offset + (y + rows - 1) as usize * p.row + (x + cols - 1) as usize * p.col + 1
        };
        let (cw, ch) = (w.div_ceil(2), h.div_ceil(2));
        end(self.y, l, t, w, h)
            .max(end(self.u, l / 2, t / 2, cw, ch))
            .max(end(self.v, l / 2, t / 2, cw, ch))
    }

    fn check(&self, have: usize) -> Result<()> {
        let (l, t, _, _) = self.crop;
        if l % 2 != 0 || t % 2 != 0 {
            return Err(Error::Platform(format!("odd crop origin {l},{t}")));
        }
        if have < self.len() {
            return Err(Error::Platform(format!("frame buffer {have} < {}", self.len())));
        }
        Ok(())
    }

    /// Index of every sample of a plane's crop, row by row.
    fn samples(p: Plane, x: u32, y: u32, cols: u32, rows: u32) -> impl Iterator<Item = usize> {
        (y..y + rows).flat_map(move |r| {
            let row = p.offset + r as usize * p.row;
            (x..x + cols).map(move |c| row + c as usize * p.col)
        })
    }

    pub fn decode(&self, buf: &[u8]) -> Result<RgbImage> {
        self.check(buf.len())?;
        let (l, t, w, h) = self.crop;
        let (cw, ch) = (w.div_ceil(2), h.div_ceil(2));
        let gather = |p, x, y, cols, rows| Self::samples(p, x, y, cols, rows).map(|i| buf[i]).collect::<Vec<u8>>();
        let (y, u, v) = (
            gather(self.y, l, t, w, h),
            gather(self.u, l / 2, t / 2, cw, ch),
            gather(self.v, l / 2, t / 2, cw, ch),
        );
        let img = YuvPlanarImage {
            y_plane: &y,
            y_stride: w,
            u_plane: &u,
            u_stride: cw,
            v_plane: &v,
            v_stride: cw,
            width: w,
            height: h,
        };
        let mut rgb = vec![0u8; w as usize * h as usize * 3];
        yuvutils_rs::yuv420_to_rgb(&img, &mut rgb, w * 3, self.range, self.matrix).map_err(err)?;
        Ok(RgbImage::from_raw(w, h, rgb).expect("w * h * 3 bytes"))
    }

    /// Writes `img` (the crop size) into `out`, which must hold
    /// [`Layout::len`] bytes; bytes outside the planes are left as they are.
    pub fn encode(&self, img: &RgbImage, out: &mut [u8]) -> Result<()> {
        self.check(out.len())?;
        let (l, t, w, h) = self.crop;
        if img.dimensions() != (w, h) {
            return Err(Error::Platform(format!(
                "image {:?} for a {w}x{h} crop",
                img.dimensions()
            )));
        }
        let (cw, ch) = (w.div_ceil(2), h.div_ceil(2));
        let (mut y, mut u, mut v) = (
            vec![0u8; (w * h) as usize],
            vec![0u8; (cw * ch) as usize],
            vec![0u8; (cw * ch) as usize],
        );
        let mut planes = YuvPlanarImageMut {
            y_plane: BufferStoreMut::Borrowed(&mut y),
            y_stride: w,
            u_plane: BufferStoreMut::Borrowed(&mut u),
            u_stride: cw,
            v_plane: BufferStoreMut::Borrowed(&mut v),
            v_stride: cw,
            width: w,
            height: h,
        };
        yuvutils_rs::rgb_to_yuv420(
            &mut planes,
            img,
            w * 3,
            self.range,
            self.matrix,
            yuvutils_rs::YuvConversionMode::Balanced,
        )
        .map_err(err)?;
        for (p, src, x, y0, cols, rows) in [
            (self.y, &y, l, t, w, h),
            (self.u, &u, l / 2, t / 2, cw, ch),
            (self.v, &v, l / 2, t / 2, cw, ch),
        ] {
            for (i, &s) in Self::samples(p, x, y0, cols, rows).zip(src.iter()) {
                out[i] = s;
            }
        }
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use image::Rgb;

    use super::*;

    fn picture(w: u32, h: u32) -> RgbImage {
        RgbImage::from_fn(w, h, |x, y| {
            if (8..24).contains(&x) && (4..12).contains(&y) {
                Rgb([200, 40, 40])
            } else {
                Rgb([30, 140, 220])
            }
        })
    }

    fn close(a: &RgbImage, b: &RgbImage) -> bool {
        a.dimensions() == b.dimensions()
            && a.pixels()
                .zip(b.pixels())
                .all(|(p, q)| p.0.iter().zip(q.0).all(|(&u, v)| u.abs_diff(v) <= 12))
    }

    /// MediaImage2 bytes for a 3-plane 8-bit YUV layout.
    fn media_image(w: u32, h: u32, planes: [(u32, u32, u32); 3]) -> Vec<u8> {
        let mut v = vec![1u32, 3, w, h, 8, 8];
        for (i, (off, col, row)) in planes.into_iter().enumerate() {
            let sub = if i == 0 { 1 } else { 2 };
            v.extend([off, col, row, sub, sub]);
        }
        v.push(0);
        v.into_iter().flat_map(u32::to_ne_bytes).collect()
    }

    #[test]
    fn round_trip_padded_layouts_with_crop() {
        let (w, h) = (32, 16);
        let crop = (2, 2, w, h);
        // NV21 from MediaImage2: V before U, interleaved.
        let nv21 = Layout::from_media_image(
            &media_image(36, 20, [(0, 1, 48), (48 * 24 + 1, 2, 48), (48 * 24, 2, 48)]),
            crop,
        )
        .unwrap();
        for layout in [Layout::i420(48, 24, crop), Layout::nv12(48, 24, crop), nv21] {
            let mut buf = vec![0u8; layout.len()];
            layout.encode(&picture(w, h), &mut buf).unwrap();
            let back = layout.decode(&buf).unwrap();
            assert!(close(&back, &picture(w, h)), "{layout:?}");
        }
    }

    #[test]
    fn media_image_rejects_other_formats() {
        let mut raw = media_image(16, 16, [(0, 1, 16), (256, 1, 8), (320, 1, 8)]);
        assert!(Layout::from_media_image(&raw, (0, 0, 16, 16)).is_some());
        raw[16..20].copy_from_slice(&10u32.to_ne_bytes()); // 10-bit
        assert!(Layout::from_media_image(&raw, (0, 0, 16, 16)).is_none());
    }

    #[test]
    fn short_buffer_is_an_error() {
        assert!(Layout::i420(16, 16, (0, 0, 16, 16)).decode(&[0; 10]).is_err());
    }
}

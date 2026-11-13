//! Video decoding and encoding with the platform's own codecs (AVFoundation
//! on Apple platforms, MediaCodec on Android), so the app ships no FFmpeg.
//! Audio is carried over only when asked for (copied, not re-encoded): a
//! screen recording's sound can be as private as its pixels.

use std::path::Path;

use image::RgbImage;

#[cfg(target_os = "android")]
mod android;
#[cfg(target_vendor = "apple")]
mod apple;
#[cfg(any(target_os = "android", test))]
mod yuv;

#[cfg(target_os = "android")]
use android as platform;
#[cfg(target_vendor = "apple")]
use apple as platform;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("video is not supported on this platform")]
    Unsupported,
    #[error("no video track in {0}")]
    NoVideoTrack(String),
    #[error("unsupported orientation transform {0:?}")]
    Transform([f64; 4]),
    #[error("{0}")]
    Platform(String),
}

pub type Result<T> = std::result::Result<T, Error>;

/// A presentation time as `value / timescale` seconds, kept exact so the
/// output has the input's timing.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Timestamp {
    pub value: i64,
    pub timescale: i32,
}

impl Timestamp {
    pub fn seconds(self) -> f64 {
        self.value as f64 / self.timescale as f64
    }
}

/// One decoded frame, upright (the track's rotation applied).
pub struct Frame {
    pub image: RgbImage,
    pub time: Timestamp,
}

/// Frames of a video file's first video track, in presentation order.
pub struct VideoReader {
    #[cfg(any(target_vendor = "apple", target_os = "android"))]
    inner: platform::Reader,
}

impl VideoReader {
    pub fn open(path: &Path) -> Result<Self> {
        #[cfg(any(target_vendor = "apple", target_os = "android"))]
        return Ok(Self {
            inner: platform::Reader::open(path)?,
        });
        #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
        {
            let _ = path;
            Err(Error::Unsupported)
        }
    }

    /// Upright frame size.
    pub fn size(&self) -> (u32, u32) {
        #[cfg(any(target_vendor = "apple", target_os = "android"))]
        return self.inner.size();
        #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
        unreachable!()
    }

    /// Nominal frame rate from the container; may be 0 when unknown.
    pub fn fps(&self) -> f32 {
        #[cfg(any(target_vendor = "apple", target_os = "android"))]
        return self.inner.fps();
        #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
        unreachable!()
    }
}

impl Iterator for VideoReader {
    type Item = Result<Frame>;

    fn next(&mut self) -> Option<Self::Item> {
        #[cfg(any(target_vendor = "apple", target_os = "android"))]
        return self.inner.next();
        #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
        unreachable!()
    }
}

/// Whether the file has an audio track.
pub fn has_audio(path: &Path) -> Result<bool> {
    #[cfg(any(target_vendor = "apple", target_os = "android"))]
    return platform::has_audio(path);
    #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
    {
        let _ = path;
        Err(Error::Unsupported)
    }
}

/// Writes an H.264 MP4, with the audio of another file copied in if asked.
pub struct VideoWriter {
    #[cfg(any(target_vendor = "apple", target_os = "android"))]
    inner: platform::Writer,
}

impl VideoWriter {
    /// `audio_from`: copy that file's first audio track, if it has one.
    pub fn create(path: &Path, width: u32, height: u32, audio_from: Option<&Path>) -> Result<Self> {
        #[cfg(any(target_vendor = "apple", target_os = "android"))]
        return Ok(Self {
            inner: platform::Writer::create(path, width, height, audio_from)?,
        });
        #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
        {
            let _ = (path, width, height, audio_from);
            Err(Error::Unsupported)
        }
    }

    /// Frames must come in increasing time and at the size given to
    /// [`VideoWriter::create`].
    pub fn write(&mut self, image: &RgbImage, time: Timestamp) -> Result<()> {
        #[cfg(any(target_vendor = "apple", target_os = "android"))]
        return self.inner.write(image, time);
        #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
        {
            let _ = (image, time);
            unreachable!()
        }
    }

    /// Completes the file; without it the output is unreadable.
    pub fn finish(self) -> Result<()> {
        #[cfg(any(target_vendor = "apple", target_os = "android"))]
        return self.inner.finish();
        #[cfg(not(any(target_vendor = "apple", target_os = "android")))]
        unreachable!()
    }

    /// Stops writing without completing the file, and closes it.
    pub fn discard(self) {}
}

//! AVAssetReader / AVAssetWriter with 32BGRA pixel buffers.

use std::path::Path;
use std::ptr::NonNull;
use std::sync::mpsc;
use std::time::Duration;

use block2::RcBlock;
use image::{RgbImage, imageops};
use objc2::rc::Retained;
use objc2::runtime::AnyObject;
use objc2_av_foundation::{
    AVAsset, AVAssetReader, AVAssetReaderStatus, AVAssetReaderTrackOutput, AVAssetTrack, AVAssetWriter,
    AVAssetWriterInput, AVAssetWriterInputPixelBufferAdaptor, AVAssetWriterStatus, AVFileTypeMPEG4, AVMediaType,
    AVMediaTypeAudio, AVMediaTypeVideo, AVVideoCodecKey, AVVideoCodecTypeH264, AVVideoHeightKey, AVVideoWidthKey,
};
use objc2_core_foundation::CFString;
use objc2_core_media::{CMSampleBuffer, CMTime};
use objc2_core_video::{
    CVPixelBuffer, CVPixelBufferGetBaseAddress, CVPixelBufferGetBytesPerRow, CVPixelBufferGetHeight,
    CVPixelBufferGetWidth, CVPixelBufferLockBaseAddress, CVPixelBufferLockFlags, CVPixelBufferPool,
    CVPixelBufferUnlockBaseAddress, kCVPixelBufferHeightKey, kCVPixelBufferPixelFormatTypeKey, kCVPixelBufferWidthKey,
    kCVPixelFormatType_32BGRA, kCVReturnSuccess,
};
use objc2_foundation::{NSArray, NSDictionary, NSError, NSNumber, NSString, NSURL};

use crate::{Error, Frame, Result, Timestamp};

fn platform(e: &NSError) -> Error {
    Error::Platform(e.localizedDescription().to_string())
}

fn url(path: &Path) -> Retained<NSURL> {
    NSURL::fileURLWithPath(&NSString::from_str(&path.to_string_lossy()))
}

/// CoreFoundation keys are toll-free bridged to NSString.
fn ns(key: &CFString) -> &NSString {
    unsafe { &*(key as *const CFString).cast::<NSString>() }
}

fn bgra_attributes(size: Option<(u32, u32)>) -> Retained<NSDictionary<NSString, AnyObject>> {
    let mut keys = vec![ns(unsafe { kCVPixelBufferPixelFormatTypeKey })];
    let mut values = vec![NSNumber::new_u32(kCVPixelFormatType_32BGRA)];
    if let Some((w, h)) = size {
        keys.extend([
            ns(unsafe { kCVPixelBufferWidthKey }),
            ns(unsafe { kCVPixelBufferHeightKey }),
        ]);
        values.extend([NSNumber::new_u32(w), NSNumber::new_u32(h)]);
    }
    let values: Vec<&AnyObject> = values.iter().map(|v| v.as_ref()).collect();
    NSDictionary::from_slices(&keys, &values)
}

/// Rotation needed to show the stored frames upright, in quarter turns
/// clockwise, from the track's preferred transform.
fn quarter_turns(t: [f64; 4]) -> Result<u8> {
    match t.map(|v| v.round() as i8) {
        [1, 0, 0, 1] => Ok(0),
        [0, 1, -1, 0] => Ok(1),
        [-1, 0, 0, -1] => Ok(2),
        [0, -1, 1, 0] => Ok(3),
        _ => Err(Error::Transform(t)),
    }
}

/// Locked base address of a 32BGRA buffer, unlocked on drop.
struct Locked<'a> {
    buf: &'a CVPixelBuffer,
    flags: CVPixelBufferLockFlags,
}

impl<'a> Locked<'a> {
    fn new(buf: &'a CVPixelBuffer, flags: CVPixelBufferLockFlags) -> Result<Self> {
        if unsafe { CVPixelBufferLockBaseAddress(buf, flags) } != kCVReturnSuccess {
            return Err(Error::Platform("CVPixelBufferLockBaseAddress failed".into()));
        }
        Ok(Self { buf, flags })
    }

    /// Rows of `width * 4` bytes, `bytes_per_row` apart.
    fn rows(&self) -> (*mut u8, usize, u32, u32) {
        (
            CVPixelBufferGetBaseAddress(self.buf).cast(),
            CVPixelBufferGetBytesPerRow(self.buf),
            CVPixelBufferGetWidth(self.buf) as u32,
            CVPixelBufferGetHeight(self.buf) as u32,
        )
    }
}

impl Drop for Locked<'_> {
    fn drop(&mut self) {
        unsafe { CVPixelBufferUnlockBaseAddress(self.buf, self.flags) };
    }
}

pub(crate) struct Reader {
    reader: Retained<AVAssetReader>,
    output: Retained<AVAssetReaderTrackOutput>,
    turns: u8,
    size: (u32, u32),
    fps: f32,
}

/// The asset's first track of `kind`, if any.
fn first_track(asset: &AVAsset, kind: &AVMediaType) -> Result<Option<Retained<AVAssetTrack>>> {
    let (tx, rx) = mpsc::channel();
    let done = RcBlock::new(move |tracks: *mut NSArray<AVAssetTrack>, err: *mut NSError| {
        let r = match (unsafe { tracks.as_ref() }, unsafe { err.as_ref() }) {
            (_, Some(e)) => Err(platform(e)),
            (t, None) => Ok(t.and_then(|t| t.firstObject())),
        };
        let _ = tx.send(r);
    });
    unsafe { asset.loadTracksWithMediaType_completionHandler(kind, &done) };
    rx.recv()
        .map_err(|_| Error::Platform("track loading was cancelled".into()))?
}

fn asset(path: &Path) -> Result<Retained<AVAsset>> {
    if !path.is_file() {
        return Err(Error::Platform(format!("{} is not a file", path.display())));
    }
    Ok(unsafe { AVAsset::assetWithURL(&url(path)) })
}

pub(crate) fn has_audio(path: &Path) -> Result<bool> {
    let asset = asset(path)?;
    Ok(first_track(&asset, unsafe { AVMediaTypeAudio }.expect("AVMediaTypeAudio"))?.is_some())
}

fn seconds(t: CMTime) -> f64 {
    t.value as f64 / t.timescale as f64
}

/// Compressed audio samples copied unchanged from another file.
struct AudioCopy {
    // Owns the output's sample production.
    _reader: Retained<AVAssetReader>,
    output: Retained<AVAssetReaderTrackOutput>,
    input: Retained<AVAssetWriterInput>,
    pending: Option<Retained<CMSampleBuffer>>,
    done: bool,
}

impl AudioCopy {
    /// None when `path` has no audio track.
    fn open(path: &Path) -> Result<Option<Self>> {
        let asset = asset(path)?;
        let Some(track) = first_track(&asset, unsafe { AVMediaTypeAudio }.expect("AVMediaTypeAudio"))? else {
            return Ok(None);
        };
        // No output settings: samples pass through compressed.
        let output = unsafe { AVAssetReaderTrackOutput::assetReaderTrackOutputWithTrack_outputSettings(&track, None) };
        let reader = unsafe { AVAssetReader::assetReaderWithAsset_error(&asset) }.map_err(|e| platform(&e))?;
        unsafe {
            reader.addOutput(&output);
            if !reader.startReading() {
                return Err(reader
                    .error()
                    .map_or(Error::Platform("startReading failed".into()), |e| platform(&e)));
            }
        }
        let Some(first) = (unsafe { output.copyNextSampleBuffer() }) else {
            return Ok(None);
        };
        // Pass-through into MP4 needs the source format as a hint.
        let hint = unsafe { first.format_description() };
        let input = unsafe {
            AVAssetWriterInput::assetWriterInputWithMediaType_outputSettings_sourceFormatHint(
                AVMediaTypeAudio.expect("AVMediaTypeAudio"),
                None,
                hint.as_deref(),
            )
        };
        unsafe { input.setExpectsMediaDataInRealTime(false) };
        Ok(Some(Self {
            _reader: reader,
            output,
            input,
            pending: Some(first),
            done: false,
        }))
    }

    /// Appends samples that start before `until` (all with None) while
    /// the input takes them, so audio and video stay interleaved.
    fn pump(&mut self, until: Option<f64>) -> Result<()> {
        while !self.done {
            let Some(s) = self
                .pending
                .take()
                .or_else(|| unsafe { self.output.copyNextSampleBuffer() })
            else {
                self.done = true;
                unsafe { self.input.markAsFinished() };
                break;
            };
            let late = until.is_some_and(|u| seconds(unsafe { s.presentation_time_stamp() }) > u);
            if late || !unsafe { self.input.isReadyForMoreMediaData() } {
                self.pending = Some(s);
                break;
            }
            if !unsafe { self.input.appendSampleBuffer(&s) } {
                return Err(Error::Platform("appending audio failed".into()));
            }
        }
        Ok(())
    }
}

impl Reader {
    pub(crate) fn open(path: &Path) -> Result<Self> {
        let asset = asset(path)?;
        let track = first_track(&asset, unsafe { AVMediaTypeVideo }.expect("AVMediaTypeVideo"))?
            .ok_or_else(|| Error::NoVideoTrack(path.display().to_string()))?;
        let t = unsafe { track.preferredTransform() };
        let turns = quarter_turns([t.a, t.b, t.c, t.d])?;
        let n = unsafe { track.naturalSize() };
        let (w, h) = (n.width.round() as u32, n.height.round() as u32);
        let size = if turns % 2 == 1 { (h, w) } else { (w, h) };
        let fps = unsafe { track.nominalFrameRate() };
        let output = unsafe {
            AVAssetReaderTrackOutput::assetReaderTrackOutputWithTrack_outputSettings(
                &track,
                Some(&bgra_attributes(None)),
            )
        };
        unsafe { output.setAlwaysCopiesSampleData(false) };
        let reader = unsafe { AVAssetReader::assetReaderWithAsset_error(&asset) }.map_err(|e| platform(&e))?;
        unsafe {
            reader.addOutput(&output);
            if !reader.startReading() {
                return Err(reader
                    .error()
                    .map_or(Error::Platform("startReading failed".into()), |e| platform(&e)));
            }
        }
        Ok(Self {
            reader,
            output,
            turns,
            size,
            fps,
        })
    }

    pub(crate) fn size(&self) -> (u32, u32) {
        self.size
    }

    pub(crate) fn fps(&self) -> f32 {
        self.fps
    }

    fn decode(&self, buf: &CVPixelBuffer) -> Result<RgbImage> {
        let lock = Locked::new(buf, CVPixelBufferLockFlags::ReadOnly)?;
        let (base, stride, w, h) = lock.rows();
        let mut rgb = Vec::with_capacity(w as usize * h as usize * 3);
        for y in 0..h as usize {
            let row = unsafe { std::slice::from_raw_parts(base.add(y * stride), w as usize * 4) };
            rgb.extend(row.as_chunks::<4>().0.iter().flat_map(|&[b, g, r, _]| [r, g, b]));
        }
        drop(lock);
        let img = RgbImage::from_raw(w, h, rgb).expect("w * h * 3 bytes");
        Ok(match self.turns {
            1 => imageops::rotate90(&img),
            2 => imageops::rotate180(&img),
            3 => imageops::rotate270(&img),
            _ => img,
        })
    }

    pub(crate) fn next(&mut self) -> Option<Result<Frame>> {
        loop {
            let Some(sample) = (unsafe { self.output.copyNextSampleBuffer() }) else {
                return match unsafe { self.reader.status() } {
                    AVAssetReaderStatus::Failed => Some(Err(unsafe { self.reader.error() }
                        .map_or(Error::Platform("decoding failed".into()), |e| platform(&e)))),
                    _ => None,
                };
            };
            // Samples without pixels (markers) are skipped.
            let Some(buf) = (unsafe { sample.image_buffer() }) else {
                continue;
            };
            let pts = unsafe { sample.presentation_time_stamp() };
            return Some(self.decode(&buf).map(|image| Frame {
                image,
                time: Timestamp {
                    value: pts.value,
                    timescale: pts.timescale,
                },
            }));
        }
    }
}

pub(crate) struct Writer {
    writer: Retained<AVAssetWriter>,
    input: Retained<AVAssetWriterInput>,
    adaptor: Retained<AVAssetWriterInputPixelBufferAdaptor>,
    audio: Option<AudioCopy>,
    size: (u32, u32),
    started: bool,
}

impl Writer {
    pub(crate) fn create(path: &Path, width: u32, height: u32, audio_from: Option<&Path>) -> Result<Self> {
        let audio = audio_from.map(AudioCopy::open).transpose()?.flatten();
        // AVAssetWriter refuses to overwrite.
        if path.exists() {
            std::fs::remove_file(path).map_err(|e| Error::Platform(e.to_string()))?;
        }
        let file_type = unsafe { AVFileTypeMPEG4 }.expect("AVFileTypeMPEG4");
        let writer = unsafe { AVAssetWriter::assetWriterWithURL_fileType_error(&url(path), file_type) }
            .map_err(|e| platform(&e))?;
        let (w, h) = (NSNumber::new_u32(width), NSNumber::new_u32(height));
        let settings: Retained<NSDictionary<NSString, AnyObject>> = unsafe {
            NSDictionary::from_slices(
                &[
                    AVVideoCodecKey.expect("AVVideoCodecKey"),
                    AVVideoWidthKey.expect("AVVideoWidthKey"),
                    AVVideoHeightKey.expect("AVVideoHeightKey"),
                ],
                &[
                    AVVideoCodecTypeH264.expect("AVVideoCodecTypeH264").as_ref(),
                    w.as_ref(),
                    h.as_ref(),
                ],
            )
        };
        let video = unsafe { AVMediaTypeVideo }.expect("AVMediaTypeVideo");
        let input = unsafe { AVAssetWriterInput::assetWriterInputWithMediaType_outputSettings(video, Some(&settings)) };
        unsafe { input.setExpectsMediaDataInRealTime(false) };
        let adaptor = unsafe {
            AVAssetWriterInputPixelBufferAdaptor::assetWriterInputPixelBufferAdaptorWithAssetWriterInput_sourcePixelBufferAttributes(
                &input,
                Some(&bgra_attributes(Some((width, height)))),
            )
        };
        unsafe {
            if !writer.canAddInput(&input) {
                return Err(Error::Platform("the writer cannot take an H.264 input".into()));
            }
            writer.addInput(&input);
            if let Some(a) = &audio {
                if !writer.canAddInput(&a.input) {
                    return Err(Error::Platform("the writer cannot take the audio track".into()));
                }
                writer.addInput(&a.input);
            }
            if !writer.startWriting() {
                return Err(writer
                    .error()
                    .map_or(Error::Platform("startWriting failed".into()), |e| platform(&e)));
            }
        }
        Ok(Self {
            writer,
            input,
            adaptor,
            audio,
            size: (width, height),
            started: false,
        })
    }

    fn failed(&self, what: &str) -> Error {
        unsafe { self.writer.error() }.map_or(Error::Platform(what.into()), |e| platform(&e))
    }

    fn buffer(pool: &CVPixelBufferPool) -> Result<objc2_core_foundation::CFRetained<CVPixelBuffer>> {
        let mut out: *mut CVPixelBuffer = std::ptr::null_mut();
        let r = unsafe { CVPixelBufferPool::create_pixel_buffer(None, pool, NonNull::from(&mut out)) };
        match NonNull::new(out) {
            Some(p) if r == kCVReturnSuccess => Ok(unsafe { objc2_core_foundation::CFRetained::from_raw(p) }),
            _ => Err(Error::Platform(format!("CVPixelBufferPoolCreatePixelBuffer: {r}"))),
        }
    }

    pub(crate) fn write(&mut self, image: &RgbImage, time: Timestamp) -> Result<()> {
        if image.dimensions() != self.size {
            return Err(Error::Platform(format!(
                "frame is {:?}, the video {:?}",
                image.dimensions(),
                self.size
            )));
        }
        let t = unsafe { CMTime::new(time.value, time.timescale) };
        if !self.started {
            unsafe { self.writer.startSessionAtSourceTime(t) };
            self.started = true;
        }
        // The writer may hold video back until audio up to this time arrives.
        let until = Some(time.seconds());
        if let Some(a) = &mut self.audio {
            a.pump(until)?;
        }
        while !unsafe { self.input.isReadyForMoreMediaData() } {
            // Interleaving can want audio ahead of this frame; the audio
            // input stops taking it once it is far enough ahead.
            if let Some(a) = &mut self.audio {
                a.pump(None)?;
            }
            if unsafe { self.writer.status() } != AVAssetWriterStatus::Writing {
                return Err(self.failed("encoding failed"));
            }
            std::thread::sleep(Duration::from_millis(1));
        }
        let pool = unsafe { self.adaptor.pixelBufferPool() }.ok_or_else(|| self.failed("no pixel buffer pool"))?;
        let buf = Self::buffer(&pool)?;
        {
            let lock = Locked::new(&buf, CVPixelBufferLockFlags::empty())?;
            let (base, stride, w, h) = lock.rows();
            debug_assert_eq!((w, h), self.size);
            for (y, src) in image.rows().enumerate() {
                let row = unsafe { std::slice::from_raw_parts_mut(base.add(y * stride), w as usize * 4) };
                for (d, p) in row.as_chunks_mut::<4>().0.iter_mut().zip(src) {
                    *d = [p[2], p[1], p[0], 255];
                }
            }
        }
        if unsafe { self.adaptor.appendPixelBuffer_withPresentationTime(&buf, t) } {
            Ok(())
        } else {
            Err(self.failed("appendPixelBuffer failed"))
        }
    }

    pub(crate) fn finish(mut self) -> Result<()> {
        unsafe { self.input.markAsFinished() };
        if let Some(a) = &mut self.audio {
            while !a.done {
                a.pump(None)?;
                if unsafe { self.writer.status() } != AVAssetWriterStatus::Writing {
                    return Err(self.failed("writing audio failed"));
                }
                std::thread::sleep(Duration::from_millis(1));
            }
        }
        let (tx, rx) = mpsc::channel();
        let done = RcBlock::new(move || {
            let _ = tx.send(());
        });
        unsafe { self.writer.finishWritingWithCompletionHandler(&done) };
        rx.recv()
            .map_err(|_| Error::Platform("finishWriting never completed".into()))?;
        match unsafe { self.writer.status() } {
            AVAssetWriterStatus::Completed => Ok(()),
            _ => Err(self.failed("finishWriting failed")),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn orientation() {
        assert_eq!(quarter_turns([1.0, 0.0, 0.0, 1.0]).unwrap(), 0);
        assert_eq!(quarter_turns([0.0, 1.0, -1.0, 0.0]).unwrap(), 1);
        assert_eq!(quarter_turns([-1.0, 0.0, 0.0, -1.0]).unwrap(), 2);
        assert!(quarter_turns([-1.0, 0.0, 0.0, 1.0]).is_err());
    }
}

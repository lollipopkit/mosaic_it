//! AMediaExtractor + AMediaCodec decoding, AMediaCodec + AMediaMuxer
//! encoding, with byte buffers in the layout the codec reports.

use std::collections::{BTreeMap, VecDeque};
use std::fs::File;
use std::os::fd::AsRawFd;
use std::path::Path;
use std::ptr::NonNull;
use std::time::Duration;

use image::{RgbImage, imageops};
use ndk::media::media_codec::{
    DequeuedInputBufferResult, DequeuedOutputBufferInfoResult, MediaCodec, MediaCodecDirection,
};
use ndk::media::media_format::MediaFormat;
use ndk_sys as ffi;
use yuvutils_rs::{YuvRange, YuvStandardMatrix};

use crate::yuv::Layout;
use crate::{Error, Frame, Result, Timestamp};

// MediaCodecInfo.CodecCapabilities colour formats.
const COLOR_I420: i32 = 19;
const COLOR_NV12: i32 = 21;
const COLOR_FLEXIBLE: i32 = 0x7F42_0888;
// MediaFormat colour keys.
const STANDARD_BT709: i32 = 1;
const STANDARD_BT601_PAL: i32 = 2;
const STANDARD_BT601_NTSC: i32 = 4;
const RANGE_FULL: i32 = 1;
const RANGE_LIMITED: i32 = 2;

const EOS: u32 = ffi::AMEDIACODEC_BUFFER_FLAG_END_OF_STREAM;
const CODEC_CONFIG: u32 = ffi::AMEDIACODEC_BUFFER_FLAG_CODEC_CONFIG;
const POLL: Duration = Duration::from_millis(10);
/// Polls without progress before giving up on a stuck codec.
const STALL: u32 = 1000;
/// Decoded frames held for reordering before a missing one is given up on.
const MAX_REORDER: usize = 32;

fn media(what: &str, e: impl std::fmt::Debug) -> Error {
    Error::Platform(format!("{what}: {e:?}"))
}

fn check(what: &str, status: ffi::media_status_t) -> Result<()> {
    if status == ffi::media_status_t::AMEDIA_OK {
        Ok(())
    } else {
        Err(media(what, status))
    }
}

/// The codec's buffer layout from its input or output format: Android's
/// MediaImage2 description when present, else the stride of a known
/// colour format.
fn layout(f: &MediaFormat, width: u32, height: u32) -> Result<Layout> {
    let w = f.i32("width").map_or(width, |v| v as u32);
    let h = f.i32("height").map_or(height, |v| v as u32);
    let crop = match (
        f.i32("crop-left"),
        f.i32("crop-top"),
        f.i32("crop-right"),
        f.i32("crop-bottom"),
    ) {
        (Some(l), Some(t), Some(r), Some(b)) => (l as u32, t as u32, (r - l + 1) as u32, (b - t + 1) as u32),
        _ => (0, 0, w, h),
    };
    let mut l = match f
        .buffer("image-data")
        .and_then(|raw| Layout::from_media_image(raw, crop))
    {
        Some(l) => l,
        None => {
            let stride = f.i32("stride").filter(|&s| s > 0).map_or(w as usize, |s| s as usize);
            let slice = f
                .i32("slice-height")
                .filter(|&s| s > 0)
                .map_or(h as usize, |s| s as usize);
            match f.i32("color-format") {
                Some(COLOR_I420) => Layout::i420(stride, slice, crop),
                Some(COLOR_NV12) => Layout::nv12(stride, slice, crop),
                other => {
                    return Err(Error::Platform(format!(
                        "unsupported codec colour format {other:?} in {f}"
                    )));
                }
            }
        }
    };
    l.matrix = match f.i32("color-standard") {
        Some(STANDARD_BT601_PAL | STANDARD_BT601_NTSC) => YuvStandardMatrix::Bt601,
        Some(STANDARD_BT709) => YuvStandardMatrix::Bt709,
        // Unspecified: HD content is BT.709 in practice.
        _ if h >= 720 => YuvStandardMatrix::Bt709,
        _ => YuvStandardMatrix::Bt601,
    };
    l.range = match f.i32("color-range") {
        Some(RANGE_FULL) => YuvRange::Full,
        _ => YuvRange::Limited,
    };
    Ok(l)
}

struct Extractor(NonNull<ffi::AMediaExtractor>);

impl Drop for Extractor {
    fn drop(&mut self) {
        unsafe { ffi::AMediaExtractor_delete(self.0.as_ptr()) };
    }
}

pub(crate) struct Reader {
    // The extractor reads from the file's descriptor; keep it open.
    _file: File,
    ex: Extractor,
    codec: MediaCodec,
    layout: Option<Layout>,
    coded: (u32, u32),
    turns: u8,
    size: (u32, u32),
    fps: f32,
    input_done: bool,
    output_done: bool,
    /// Every sample's presentation time, ascending, not yet returned.
    order: VecDeque<i64>,
    /// Decoded frames waiting for an earlier one, by presentation time.
    pending: BTreeMap<i64, Frame>,
}

/// An extractor over `path`, with the file it reads through.
fn extractor(path: &Path) -> Result<(File, Extractor)> {
    let file = File::open(path).map_err(|e| Error::Platform(format!("{}: {e}", path.display())))?;
    let len = file.metadata().map_err(|e| Error::Platform(e.to_string()))?.len();
    let ex = Extractor(
        NonNull::new(unsafe { ffi::AMediaExtractor_new() })
            .ok_or_else(|| Error::Platform("AMediaExtractor_new failed".into()))?,
    );
    check("setDataSourceFd", unsafe {
        ffi::AMediaExtractor_setDataSourceFd(ex.0.as_ptr(), file.as_raw_fd(), 0, len as i64)
    })?;
    Ok((file, ex))
}

/// The first track whose MIME type starts with `kind` ("video/", "audio/").
fn find_track(ex: &Extractor, kind: &str) -> Option<(usize, MediaFormat)> {
    let n = unsafe { ffi::AMediaExtractor_getTrackCount(ex.0.as_ptr()) };
    (0..n).find_map(|i| {
        let f = NonNull::new(unsafe { ffi::AMediaExtractor_getTrackFormat(ex.0.as_ptr(), i) })?;
        let mut f = unsafe { MediaFormat::from_ptr(f) };
        f.str("mime").is_some_and(|m| m.starts_with(kind)).then_some((i, f))
    })
}

pub(crate) fn has_audio(path: &Path) -> Result<bool> {
    Ok(find_track(&extractor(path)?.1, "audio/").is_some())
}

/// Compressed audio samples copied unchanged from another file.
struct AudioCopy {
    _file: File,
    ex: Extractor,
    format: MediaFormat,
    /// The muxer's track, once added.
    track: Option<usize>,
    buf: Vec<u8>,
    done: bool,
}

impl AudioCopy {
    /// None when `path` has no audio track.
    fn open(path: &Path) -> Result<Option<Self>> {
        let (file, ex) = extractor(path)?;
        let Some((index, format)) = find_track(&ex, "audio/") else {
            return Ok(None);
        };
        check("selectTrack", unsafe {
            ffi::AMediaExtractor_selectTrack(ex.0.as_ptr(), index)
        })?;
        let cap = format
            .i32("max-input-size")
            .filter(|&n| n > 0)
            .map_or(1 << 20, |n| n as usize);
        Ok(Some(Self {
            _file: file,
            ex,
            format,
            track: None,
            buf: vec![0; cap],
            done: false,
        }))
    }

    /// Writes samples that start at or before `until_us` (all with None).
    fn pump(&mut self, muxer: &Muxer, until_us: Option<i64>) -> Result<()> {
        let Some(track) = self.track else { return Ok(()) };
        let ex = self.ex.0.as_ptr();
        while !self.done {
            let t = unsafe { ffi::AMediaExtractor_getSampleTime(ex) };
            if t < 0 {
                self.done = true;
                break;
            }
            if until_us.is_some_and(|u| t > u) {
                break;
            }
            let n = unsafe { ffi::AMediaExtractor_readSampleData(ex, self.buf.as_mut_ptr(), self.buf.len()) };
            if n < 0 {
                return Err(media("readSampleData (audio)", n));
            }
            let sync = unsafe { ffi::AMediaExtractor_getSampleFlags(ex) } & ffi::AMEDIAEXTRACTOR_SAMPLE_FLAG_SYNC != 0;
            let info = ffi::AMediaCodecBufferInfo {
                offset: 0,
                size: n as i32,
                presentationTimeUs: t,
                flags: if sync {
                    ffi::AMEDIACODEC_BUFFER_FLAG_KEY_FRAME
                } else {
                    0
                },
            };
            check("writeSampleData (audio)", unsafe {
                ffi::AMediaMuxer_writeSampleData(muxer.0.as_ptr(), track, self.buf.as_ptr(), &info)
            })?;
            unsafe { ffi::AMediaExtractor_advance(ex) };
        }
        Ok(())
    }
}

impl Reader {
    pub(crate) fn open(path: &Path) -> Result<Self> {
        let (file, ex) = extractor(path)?;
        let (index, mut format) =
            find_track(&ex, "video/").ok_or_else(|| Error::NoVideoTrack(path.display().to_string()))?;
        check("selectTrack", unsafe {
            ffi::AMediaExtractor_selectTrack(ex.0.as_ptr(), index)
        })?;
        // Some decoders return frames in decode order (B-frames out of
        // place), so read the presentation order from the index up front.
        let mut order = Vec::new();
        loop {
            let t = unsafe { ffi::AMediaExtractor_getSampleTime(ex.0.as_ptr()) };
            if t < 0 {
                break;
            }
            order.push(t);
            if !unsafe { ffi::AMediaExtractor_advance(ex.0.as_ptr()) } {
                break;
            }
        }
        order.sort_unstable();
        order.dedup();
        check("seekTo", unsafe {
            ffi::AMediaExtractor_seekTo(ex.0.as_ptr(), 0, ffi::SeekMode::AMEDIAEXTRACTOR_SEEK_PREVIOUS_SYNC)
        })?;
        let mime = format.str("mime").unwrap_or_default().to_string();
        let w = format.i32("width").unwrap_or(0) as u32;
        let h = format.i32("height").unwrap_or(0) as u32;
        let turns = match format.i32("rotation-degrees").unwrap_or(0).rem_euclid(360) {
            0 => 0,
            90 => 1,
            180 => 2,
            270 => 3,
            d => return Err(Error::Transform([d as f64, 0.0, 0.0, 0.0])),
        };
        let fps = format
            .i32("frame-rate")
            .map(|v| v as f32)
            .or_else(|| format.f32("frame-rate"))
            .unwrap_or(0.0);
        let codec =
            MediaCodec::from_decoder_type(&mime).ok_or_else(|| Error::Platform(format!("no decoder for {mime}")))?;
        format.set_i32("color-format", COLOR_FLEXIBLE);
        codec
            .configure(&format, None, MediaCodecDirection::Decoder)
            .map_err(|e| media("configure decoder", e))?;
        codec.start().map_err(|e| media("start decoder", e))?;
        Ok(Self {
            _file: file,
            ex,
            codec,
            layout: None,
            coded: (w, h),
            turns,
            size: if turns % 2 == 1 { (h, w) } else { (w, h) },
            fps,
            input_done: false,
            output_done: false,
            order: order.into(),
            pending: BTreeMap::new(),
        })
    }

    pub(crate) fn size(&self) -> (u32, u32) {
        self.size
    }

    pub(crate) fn fps(&self) -> f32 {
        self.fps
    }

    fn feed(&mut self) -> Result<()> {
        if self.input_done {
            return Ok(());
        }
        let DequeuedInputBufferResult::Buffer(mut buf) = self
            .codec
            .dequeue_input_buffer(Duration::ZERO)
            .map_err(|e| media("dequeue input", e))?
        else {
            return Ok(());
        };
        let dst = buf.buffer_mut();
        let ex = self.ex.0.as_ptr();
        let n = unsafe { ffi::AMediaExtractor_readSampleData(ex, dst.as_mut_ptr().cast(), dst.len()) };
        let r = if n < 0 {
            self.input_done = true;
            self.codec.queue_input_buffer(buf, 0, 0, 0, EOS)
        } else {
            let pts = unsafe { ffi::AMediaExtractor_getSampleTime(ex) }.max(0) as u64;
            unsafe { ffi::AMediaExtractor_advance(ex) };
            self.codec.queue_input_buffer(buf, 0, n as usize, pts, 0)
        };
        r.map_err(|e| media("queue input", e))
    }

    /// Frames in presentation order.
    pub(crate) fn next(&mut self) -> Option<Result<Frame>> {
        loop {
            if let Some(&want) = self.order.front() {
                if let Some(f) = self.pending.remove(&want) {
                    self.order.pop_front();
                    return Some(Ok(f));
                }
                if self.pending.len() > MAX_REORDER || self.output_done {
                    // The decoder never produced `want`.
                    self.order.pop_front();
                    continue;
                }
            }
            match self.decoded() {
                Some(Ok(f)) => {
                    self.pending.insert(f.time.value, f);
                }
                Some(Err(e)) => return Some(Err(e)),
                // Times the index did not list are returned last, in order.
                None => return self.pending.pop_first().map(|(_, f)| Ok(f)),
            }
        }
    }

    /// The decoder's next frame, in whatever order it produces them.
    fn decoded(&mut self) -> Option<Result<Frame>> {
        if self.output_done {
            return None;
        }
        let mut idle = 0;
        loop {
            if let Err(e) = self.feed() {
                return Some(Err(e));
            }
            let out = match self.codec.dequeue_output_buffer(POLL) {
                Ok(o) => o,
                Err(e) => return Some(Err(media("dequeue output", e))),
            };
            match out {
                DequeuedOutputBufferInfoResult::Buffer(b) => {
                    let info = *b.info();
                    let (off, len) = (info.offset() as usize, info.size() as usize);
                    let frame = (len > 0).then(|| {
                        let layout = match self.layout {
                            Some(l) => l,
                            None => layout(&self.codec.output_format(), self.coded.0, self.coded.1)?,
                        };
                        let image = layout.decode(&b.buffer()[off..off + len])?;
                        Ok(Frame {
                            image: match self.turns {
                                1 => imageops::rotate90(&image),
                                2 => imageops::rotate180(&image),
                                3 => imageops::rotate270(&image),
                                _ => image,
                            },
                            time: Timestamp {
                                value: info.presentation_time_us(),
                                timescale: 1_000_000,
                            },
                        })
                    });
                    if let Err(e) = self.codec.release_output_buffer(b, false) {
                        return Some(Err(media("release output", e)));
                    }
                    if frame.is_some() {
                        return frame;
                    }
                    if info.flags() & EOS != 0 {
                        self.output_done = true;
                        return None;
                    }
                }
                DequeuedOutputBufferInfoResult::OutputFormatChanged => {
                    match layout(&self.codec.output_format(), self.coded.0, self.coded.1) {
                        Ok(l) => self.layout = Some(l),
                        Err(e) => return Some(Err(e)),
                    }
                }
                DequeuedOutputBufferInfoResult::OutputBuffersChanged => {}
                DequeuedOutputBufferInfoResult::TryAgainLater => {
                    idle += 1;
                    if idle > STALL {
                        return Some(Err(Error::Platform("decoder stalled".into())));
                    }
                    continue;
                }
            }
            idle = 0;
        }
    }
}

impl Drop for Reader {
    fn drop(&mut self) {
        let _ = self.codec.stop();
    }
}

struct Muxer(NonNull<ffi::AMediaMuxer>);

impl Drop for Muxer {
    fn drop(&mut self) {
        unsafe { ffi::AMediaMuxer_delete(self.0.as_ptr()) };
    }
}

pub(crate) struct Writer {
    codec: MediaCodec,
    muxer: Muxer,
    // The muxer writes through the file's descriptor; keep it open.
    _file: File,
    layout: Layout,
    track: Option<usize>,
    audio: Option<AudioCopy>,
    size: (u32, u32),
}

impl Writer {
    pub(crate) fn create(path: &Path, width: u32, height: u32, audio_from: Option<&Path>) -> Result<Self> {
        let audio = audio_from.map(AudioCopy::open).transpose()?.flatten();
        let file = File::options()
            .read(true)
            .write(true)
            .create(true)
            .truncate(true)
            .open(path)
            .map_err(|e| Error::Platform(format!("{}: {e}", path.display())))?;
        let muxer = Muxer(
            NonNull::new(unsafe {
                ffi::AMediaMuxer_new(file.as_raw_fd(), ffi::OutputFormat::AMEDIAMUXER_OUTPUT_FORMAT_MPEG_4)
            })
            .ok_or_else(|| Error::Platform("AMediaMuxer_new failed".into()))?,
        );
        let mut f = MediaFormat::new();
        f.set_str("mime", "video/avc");
        f.set_i32("width", width as i32);
        f.set_i32("height", height as i32);
        // Screen content at ~4 bits per pixel per second keeps text sharp.
        f.set_i32(
            "bitrate",
            (width as i64 * height as i64 * 4).clamp(1_000_000, 40_000_000) as i32,
        );
        f.set_i32("frame-rate", 30);
        f.set_i32("i-frame-interval", 1);
        f.set_i32("color-standard", STANDARD_BT709);
        f.set_i32("color-range", RANGE_LIMITED);
        // Explicit layouts first: an encoder taking "flexible" byte buffers
        // need not say how it lays them out.
        let mut failure = Error::Platform("no H.264 encoder".into());
        let mut chosen = None;
        for color in [COLOR_I420, COLOR_NV12, COLOR_FLEXIBLE] {
            let Some(codec) = MediaCodec::from_encoder_type("video/avc") else {
                break;
            };
            f.set_i32("color-format", color);
            if let Err(e) = codec.configure(&f, None, MediaCodecDirection::Encoder) {
                failure = media("configure encoder", e);
                continue;
            }
            match layout(&codec.input_format(), width, height) {
                Ok(l) => {
                    chosen = Some((codec, l));
                    break;
                }
                Err(e) => failure = e,
            }
        }
        let (codec, mut layout) = chosen.ok_or(failure)?;
        layout.matrix = YuvStandardMatrix::Bt709;
        layout.range = YuvRange::Limited;
        layout.crop = (0, 0, width, height);
        codec.start().map_err(|e| media("start encoder", e))?;
        Ok(Self {
            codec,
            muxer,
            _file: file,
            layout,
            track: None,
            audio,
            size: (width, height),
        })
    }

    /// Moves encoded output to the muxer; with `until_eos`, until the end
    /// of stream, otherwise until the encoder has nothing ready.
    fn drain(&mut self, until_eos: bool) -> Result<()> {
        let mut idle = 0;
        loop {
            let out = self
                .codec
                .dequeue_output_buffer(if until_eos { POLL } else { Duration::ZERO })
                .map_err(|e| media("dequeue output", e))?;
            match out {
                DequeuedOutputBufferInfoResult::Buffer(b) => {
                    let info = *b.info();
                    if info.size() > 0 && info.flags() & CODEC_CONFIG == 0 {
                        let track = self
                            .track
                            .ok_or_else(|| Error::Platform("sample before format".into()))?;
                        let raw = ffi::AMediaCodecBufferInfo {
                            offset: 0,
                            size: info.size(),
                            presentationTimeUs: info.presentation_time_us(),
                            flags: info.flags(),
                        };
                        let data = &b.buffer()[info.offset() as usize..];
                        check("writeSampleData", unsafe {
                            ffi::AMediaMuxer_writeSampleData(self.muxer.0.as_ptr(), track, data.as_ptr(), &raw)
                        })?;
                    }
                    self.codec
                        .release_output_buffer(b, false)
                        .map_err(|e| media("release output", e))?;
                    if info.flags() & EOS != 0 {
                        return Ok(());
                    }
                    idle = 0;
                }
                DequeuedOutputBufferInfoResult::OutputFormatChanged => {
                    let f = self.codec.output_format();
                    let t = unsafe { ffi::AMediaMuxer_addTrack(self.muxer.0.as_ptr(), f.as_ptr()) };
                    if t < 0 {
                        return Err(media("addTrack", t));
                    }
                    // Every track must be added before the muxer starts.
                    if let Some(a) = &mut self.audio {
                        let at = unsafe { ffi::AMediaMuxer_addTrack(self.muxer.0.as_ptr(), a.format.as_ptr()) };
                        if at < 0 {
                            return Err(media("addTrack (audio)", at));
                        }
                        a.track = Some(at as usize);
                    }
                    check("muxer start", unsafe { ffi::AMediaMuxer_start(self.muxer.0.as_ptr()) })?;
                    self.track = Some(t as usize);
                }
                DequeuedOutputBufferInfoResult::OutputBuffersChanged => {}
                DequeuedOutputBufferInfoResult::TryAgainLater => {
                    if !until_eos {
                        return Ok(());
                    }
                    idle += 1;
                    if idle > STALL {
                        return Err(Error::Platform("encoder stalled".into()));
                    }
                }
            }
        }
    }

    /// An input buffer, draining output while the encoder is full.
    fn queue(
        &mut self,
        fill: impl FnOnce(&mut [std::mem::MaybeUninit<u8>]) -> Result<usize>,
        pts: u64,
        flags: u32,
    ) -> Result<()> {
        for _ in 0..STALL {
            match self
                .codec
                .dequeue_input_buffer(POLL)
                .map_err(|e| media("dequeue input", e))?
            {
                DequeuedInputBufferResult::Buffer(mut buf) => {
                    let n = fill(buf.buffer_mut())?;
                    return self
                        .codec
                        .queue_input_buffer(buf, 0, n, pts, flags)
                        .map_err(|e| media("queue input", e));
                }
                DequeuedInputBufferResult::TryAgainLater => self.drain(false)?,
            }
        }
        Err(Error::Platform("encoder stalled".into()))
    }

    pub(crate) fn write(&mut self, image: &RgbImage, time: Timestamp) -> Result<()> {
        if image.dimensions() != self.size {
            return Err(Error::Platform(format!(
                "frame is {:?}, the video {:?}",
                image.dimensions(),
                self.size
            )));
        }
        let mut yuv = vec![0u8; self.layout.len()];
        self.layout.encode(image, &mut yuv)?;
        let pts = (time.value as i128 * 1_000_000 / time.timescale as i128).max(0) as u64;
        self.queue(
            |dst| {
                let have = dst.len();
                let dst = dst
                    .get_mut(..yuv.len())
                    .ok_or_else(|| Error::Platform(format!("input buffer {have} < {}", yuv.len())))?;
                dst.write_copy_of_slice(&yuv);
                Ok(yuv.len())
            },
            pts,
            0,
        )?;
        self.drain(false)?;
        if let Some(a) = &mut self.audio {
            a.pump(&self.muxer, Some(pts as i64))?;
        }
        Ok(())
    }

    pub(crate) fn finish(mut self) -> Result<()> {
        self.queue(|_| Ok(0), 0, EOS)?;
        self.drain(true)?;
        self.codec.stop().map_err(|e| media("stop encoder", e))?;
        if self.track.is_none() {
            return Err(Error::Platform("no frames were encoded".into()));
        }
        if let Some(a) = &mut self.audio {
            a.pump(&self.muxer, None)?;
        }
        check("muxer stop", unsafe { ffi::AMediaMuxer_stop(self.muxer.0.as_ptr()) })
    }
}

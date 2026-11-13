use std::collections::VecDeque;
use std::path::{Path, PathBuf};
use std::sync::Mutex;

use anyhow::{Context, Result};
use flutter_rust_bridge::frb;
use image::Rgb;
use unseen_core::{
    Candidates, DetectOptions, Detection, Detector, FindOptions, KeyframeOptions, Keyframes, Manifest, ModelMeta,
    PUBLIC_KEY, RedactStyle, Selection, Threshold, Timeline, Tracker, blake3_file, export_check, find_similar,
    is_camera_photo, load_image, redact, redaction_patches,
};
use unseen_infer::{OrtBackend, OrtOptions, face_detector};
use unseen_media::{Timestamp, VideoReader, VideoWriter};

use crate::frb_generated::StreamSink;

/// Images whose candidates a [`Session`] keeps for the export check.
const RECENT_CANDIDATES: usize = 32;

/// A loaded detector. The backend is not `Sync`, so calls are serialised.
#[frb(opaque)]
pub struct Session {
    det: Mutex<Detector>,
    /// Classes off by default, applied to `det` whenever it is locked: setting
    /// them never waits for a running detection.
    off: Mutex<Vec<String>>,
    threshold: Mutex<ThresholdPreset>,
    /// Candidates of the images detected on most recently, by path, so the
    /// export check reruns the detector only where redaction changed them.
    recent: Mutex<VecDeque<(String, Candidates)>>,
    path: PathBuf,
    /// Computed on first use: reading the weights again costs startup time.
    hashes: std::sync::OnceLock<ModelHashes>,
}

/// BLAKE3 of the weights and of the sidecar: which release
/// (models/manifest.toml) made the boxes.
#[derive(Clone)]
pub struct ModelHashes {
    pub model: String,
    pub sidecar: String,
}

pub struct ModelInfo {
    pub classes: Vec<String>,
    pub backend: String,
    /// Calibration domain, if the model is calibrated.
    pub domain: Option<String>,
    /// The calibration data was human-verified; only then is the recall
    /// guarantee real.
    pub verified: bool,
}

/// The user's threshold preset; medium is the model's own thresholds.
#[derive(Clone, Copy)]
pub enum ThresholdPreset {
    Low,
    Medium,
    High,
}

#[derive(Clone, Copy)]
pub enum RegionState {
    Selected,
    /// Of a class off by default: shown unselected, not highlighted.
    Suggested,
    Review,
    /// Below the review threshold: only in [`Detected::hidden`].
    Hidden,
}

pub struct Region {
    pub class_name: String,
    pub score: f32,
    pub state: RegionState,
    pub rect: PixelRect,
}

/// xyxy in image pixels.
#[derive(Clone, Copy, Debug)]
pub struct PixelRect {
    pub left: f32,
    pub top: f32,
    pub right: f32,
    pub bottom: f32,
}

pub struct Detected {
    pub width: u32,
    pub height: u32,
    pub regions: Vec<Region>,
    /// Detections below the review threshold: outlined, and selected by a
    /// tap, so a missed value needs no hand-drawn box.
    pub hidden: Vec<Region>,
    /// The image has camera EXIF: a photo, outside the screenshot domain the
    /// model is calibrated on.
    pub camera_photo: bool,
}

pub enum FillStyle {
    /// One colour, [`Fill::color`].
    Solid,
    /// The mean colour around each region.
    Surround,
    /// Grey mosaic.
    Blocks,
    /// Colour mosaic sampled around each region.
    Tinted,
    Noise,
}

/// How regions are hidden. The app keeps one `seed` per image or video, so
/// the preview shows exactly what export writes and a video does not flicker.
pub struct Fill {
    pub style: FillStyle,
    /// 0xRRGGBB, for [`FillStyle::Solid`].
    pub color: u32,
    pub seed: u64,
}

/// A redacted region's pixels for previews: `width` x `height` RGBA at
/// (`left`, `top`) in image pixels.
pub struct PreviewPatch {
    pub left: u32,
    pub top: u32,
    pub width: u32,
    pub height: u32,
    pub rgba: Vec<u8>,
}

pub struct ExportOutcome {
    /// The file was written: the check passed or `force` was set.
    pub written: bool,
    /// Pre-selected detections still visible in the output.
    pub surviving: Vec<Region>,
    /// Indices into the given rects whose output correlates with the source.
    pub correlated: Vec<u32>,
}

/// Pixels added around every redacted rect.
const PAD: f32 = 4.0;

fn region(d: &Detection, state: RegionState) -> Region {
    Region {
        class_name: d.class.clone(),
        score: d.score,
        state,
        rect: pixel_rect(d.bbox),
    }
}

impl From<Fill> for RedactStyle {
    fn from(f: Fill) -> Self {
        match f.style {
            FillStyle::Solid => RedactStyle::Solid(Rgb([(f.color >> 16) as u8, (f.color >> 8) as u8, f.color as u8])),
            FillStyle::Surround => RedactStyle::Surround,
            FillStyle::Blocks => RedactStyle::Blocks { size: 0 },
            FillStyle::Tinted => RedactStyle::Tinted { size: 0, seed: f.seed },
            FillStyle::Noise => RedactStyle::Noise { seed: f.seed },
        }
    }
}

fn boxes_of(rects: &[PixelRect]) -> Vec<[f32; 4]> {
    rects.iter().map(|r| [r.left, r.top, r.right, r.bottom]).collect()
}

/// What export would draw over each of `rects`, for the editor to overlay.
pub fn redaction_preview(image_path: String, rects: Vec<PixelRect>, fill: Fill) -> Result<Vec<PreviewPatch>> {
    let img = open(&image_path)?;
    Ok(redaction_patches(&img, &boxes_of(&rects), PAD, fill.into())
        .into_iter()
        .map(|p| PreviewPatch {
            left: p.rect[0],
            top: p.rect[1],
            width: p.rect[2] - p.rect[0],
            height: p.rect[3] - p.rect[1],
            rgba: p.rgba,
        })
        .collect())
}

fn pixel_rect(b: [f32; 4]) -> PixelRect {
    PixelRect {
        left: b[0],
        top: b[1],
        right: b[2],
        bottom: b[3],
    }
}

fn open(path: &str) -> Result<image::RgbImage> {
    Ok(load_image(Path::new(path))?)
}

impl Session {
    /// `cache_dir` keeps compiled hardware models between loads. Faces come
    /// from the built-in face detector, whatever the model.
    pub fn load(model_path: String, cache_dir: Option<String>) -> Result<Session> {
        let path = Path::new(&model_path);
        let meta = ModelMeta::load(path)?;
        let opts = OrtOptions {
            cache_dir: cache_dir.map(PathBuf::from),
            ..Default::default()
        };
        let backend = OrtBackend::load_with(path, opts).with_context(|| format!("loading {model_path}"))?;
        Ok(Session {
            det: Mutex::new(Detector::new(meta, Box::new(backend)).with_faces(face_detector()?)),
            off: Mutex::default(),
            threshold: Mutex::new(ThresholdPreset::Medium),
            recent: Mutex::default(),
            path: path.to_path_buf(),
            hashes: Default::default(),
        })
    }

    fn lock(&self) -> std::sync::MutexGuard<'_, Detector> {
        // A panic mid-call leaves the detector itself intact.
        let mut det = self.det.lock().unwrap_or_else(|e| e.into_inner());
        det.set_off(self.off.lock().unwrap_or_else(|e| e.into_inner()).iter().cloned());
        det.set_threshold(match *self.threshold.lock().unwrap_or_else(|e| e.into_inner()) {
            ThresholdPreset::Low => Threshold::Low,
            ThresholdPreset::Medium => Threshold::Medium,
            ThresholdPreset::High => Threshold::High,
        });
        det
    }

    #[frb(sync)]
    pub fn info(&self) -> ModelInfo {
        let det = self.lock();
        let cal = det.meta.calibration.as_ref();
        ModelInfo {
            classes: det.classes(),
            backend: det.backend_name(),
            domain: cal.map(|c| c.domain.clone()),
            verified: cal.is_some_and(|c| c.verified),
        }
    }

    /// Classes detected but not pre-selected, and skipped by the export check.
    #[frb(sync)]
    pub fn set_off_classes(&self, classes: Vec<String>) {
        *self.off.lock().unwrap_or_else(|e| e.into_inner()) = classes;
    }

    /// Scales every class's thresholds: low pre-selects more, high less.
    #[frb(sync)]
    pub fn set_threshold(&self, preset: ThresholdPreset) {
        *self.threshold.lock().unwrap_or_else(|e| e.into_inner()) = preset;
    }

    /// The model files' hashes, read from disk on first call. The app replaces
    /// the files only together with the session, so they match what was loaded.
    pub fn hashes(&self) -> Result<ModelHashes> {
        if let Some(h) = self.hashes.get() {
            return Ok(h.clone());
        }
        let h = ModelHashes {
            model: blake3_file(&self.path)?,
            sidecar: blake3_file(&ModelMeta::sidecar(&self.path))?,
        };
        Ok(self.hashes.get_or_init(|| h).clone())
    }

    /// Detections to show (pre-selected ones and the review band) and the
    /// hidden ones below it.
    pub fn detect(&self, image_path: String) -> Result<Detected> {
        let img = open(&image_path)?;
        let (cands, regions, hidden) = {
            let mut det = self.lock();
            let opts = DetectOptions::default();
            let cands = det.candidates(&img, opts.min_score)?;
            let (hidden, regions) = det
                .detections(&cands, &opts)?
                .iter()
                .map(|d| match det.selection(d) {
                    Selection::Selected => region(d, RegionState::Selected),
                    Selection::Suggested => region(d, RegionState::Suggested),
                    Selection::Review => region(d, RegionState::Review),
                    Selection::Hidden => region(d, RegionState::Hidden),
                })
                .partition(|r| matches!(r.state, RegionState::Hidden));
            (cands, regions, hidden)
        };
        let mut recent = self.recent.lock().unwrap_or_else(|e| e.into_inner());
        recent.retain(|(p, _)| *p != image_path);
        if recent.len() == RECENT_CANDIDATES {
            recent.pop_front();
        }
        recent.push_back((image_path.clone(), cands));
        drop(recent);
        Ok(Detected {
            width: img.width(),
            height: img.height(),
            regions,
            hidden,
            camera_photo: is_camera_photo(Path::new(&image_path)),
        })
    }

    /// Redacts `rects`, runs the export self-check and writes `out_path`
    /// (format from its extension, no metadata) if the check passes or
    /// `force` is set. `max_side` scales the written image down so its longer
    /// side is at most that many pixels; the check runs at full size.
    pub fn redact_and_export(
        &self,
        image_path: String,
        out_path: String,
        rects: Vec<PixelRect>,
        fill: Fill,
        force: bool,
        max_side: Option<u32>,
    ) -> Result<ExportOutcome> {
        let src = open(&image_path)?;
        let boxes = boxes_of(&rects);
        let style: RedactStyle = fill.into();
        let mut out = src.clone();
        redact(&mut out, &boxes, PAD, style);
        let prev = self
            .recent
            .lock()
            .unwrap_or_else(|e| e.into_inner())
            .iter()
            .find(|(p, _)| *p == image_path)
            .map(|(_, c)| c.clone());
        let check = export_check(&mut self.lock(), &src, &out, prev.as_ref(), &boxes, PAD, style)?;
        let written = check.passed() || force;
        if written {
            write_image(&out, Path::new(&out_path), max_side).with_context(|| format!("writing {out_path}"))?;
        }
        Ok(ExportOutcome {
            written,
            surviving: check
                .surviving
                .iter()
                .map(|d| region(d, RegionState::Selected))
                .collect(),
            correlated: check.correlated.iter().map(|&i| i as u32).collect(),
        })
    }
}

/// JPEG quality of exported images: no visible artefacts on UI text.
const JPEG_QUALITY: u8 = 92;

/// Writes `img` in the format of `path`'s extension, scaled down to `max_side`.
fn write_image(img: &image::RgbImage, path: &Path, max_side: Option<u32>) -> Result<()> {
    let scaled;
    let img = match max_side {
        Some(m) if img.width().max(img.height()) > m => {
            let k = m as f64 / img.width().max(img.height()) as f64;
            let (w, h) = (
                ((img.width() as f64 * k).round() as u32).max(1),
                ((img.height() as f64 * k).round() as u32).max(1),
            );
            scaled = image::imageops::resize(img, w, h, image::imageops::FilterType::Lanczos3);
            &scaled
        }
        _ => img,
    };
    let jpeg = path
        .extension()
        .and_then(|e| e.to_str())
        .is_some_and(|e| e.eq_ignore_ascii_case("jpg") || e.eq_ignore_ascii_case("jpeg"));
    if jpeg {
        let out = std::io::BufWriter::new(std::fs::File::create(path)?);
        image::codecs::jpeg::JpegEncoder::new_with_quality(out, JPEG_QUALITY).encode_image(img)?;
    } else {
        img.save(path)?;
    }
    Ok(())
}

/// Every class a box can have, in id order: models/classes.json, the list
/// training labels use. Annotation mode offers these without a model.
#[frb(sync)]
pub fn label_classes() -> Vec<String> {
    let v: serde_json::Value =
        serde_json::from_str(include_str!("../../../models/classes.json")).expect("models/classes.json is valid JSON");
    v["classes"]
        .as_array()
        .expect("classes array")
        .iter()
        .map(|c| c["name"].as_str().expect("class name").to_string())
        .collect()
}

/// A published release newer than the installed model.
pub struct ModelUpdate {
    pub version: String,
    /// File name to install the model under; the sidecar is `<file>.json`.
    pub file: String,
    pub model_url: String,
    pub sidecar_url: String,
    pub blake3: String,
    pub sidecar_blake3: String,
}

/// The newest release this app can run in a downloaded `manifest`, if it is
/// newer than the model at `installed`. Fails unless the manifest carries the
/// publisher's signature; an installed model that is not a listed tiled
/// release is the user's own and gets no update.
pub fn model_update(manifest: Vec<u8>, installed: Option<String>) -> Result<Option<ModelUpdate>> {
    let m = Manifest::signed(&manifest, PUBLIC_KEY)?;
    Ok(m.update("tiled", installed.as_deref().map(Path::new))?
        .map(|e| ModelUpdate {
            version: e.version.clone(),
            file: e.file.clone(),
            model_url: e.model_url(),
            sidecar_url: e.sidecar_url(),
            blake3: e.blake3.clone(),
            sidecar_blake3: e.sidecar_blake3.clone(),
        }))
}

/// An image's size and domain without detection (annotation mode), read from
/// its header by the decoder `detect` uses.
pub fn open_image(image_path: String) -> Result<Detected> {
    let path = Path::new(&image_path);
    let (width, height) = image::ImageReader::open(path)?
        .with_guessed_format()?
        .into_dimensions()
        .with_context(|| format!("reading {image_path}"))?;
    Ok(Detected {
        width,
        height,
        regions: vec![],
        hidden: vec![],
        camera_photo: is_camera_photo(path),
    })
}

/// Text line boxes on an image, in pixels, from the platform's on-device text
/// recognition (Apple Vision). Only positions leave this function; the text is
/// dropped. Annotation mode turns a tapped line into a box.
pub fn text_lines(image_path: String) -> Result<Vec<PixelRect>> {
    let (width, height) = image::ImageReader::open(&image_path)?
        .with_guessed_format()?
        .into_dimensions()
        .with_context(|| format!("reading {image_path}"))?;
    #[cfg(target_vendor = "apple")]
    {
        crate::vision::text_lines(&image_path, width as f32, height as f32)
    }
    #[cfg(not(target_vendor = "apple"))]
    {
        let _ = (width, height);
        anyhow::bail!("text recognition is not available on this platform")
    }
}

/// Hex BLAKE3 of a file's content.
pub fn file_blake3(path: String) -> Result<String> {
    Ok(blake3_file(Path::new(&path))?)
}

/// Keeps `path` (a file or directory) out of iCloud and device backups. A
/// no-op off Apple platforms; Android excludes paths in its backup rules.
pub fn exclude_from_backup(path: String) -> Result<()> {
    #[cfg(target_vendor = "apple")]
    {
        use objc2_foundation::{NSNumber, NSString, NSURL, NSURLIsExcludedFromBackupKey};
        let url = NSURL::fileURLWithPath(&NSString::from_str(&path));
        // SAFETY: the key takes an NSNumber holding a BOOL.
        unsafe {
            url.setResourceValue_forKey_error(Some(&NSNumber::numberWithBool(true)), NSURLIsExcludedFromBackupKey)
        }
        .map_err(|e| anyhow::anyhow!("{path}: {}", e.localizedDescription()))?;
    }
    #[cfg(not(target_vendor = "apple"))]
    let _ = path;
    Ok(())
}

/// Regions that look like `rect` of `image_path`, searched in `target_path`
/// (same scale assumed) or, without one, in the same image excluding `rect`.
pub fn find_similar_regions(
    image_path: String,
    rect: PixelRect,
    target_path: Option<String>,
) -> Result<Vec<PixelRect>> {
    let img = open(&image_path)?;
    let q = [rect.left, rect.top, rect.right, rect.bottom];
    let found = match target_path.filter(|t| *t != image_path) {
        Some(t) => find_similar(&img, q, &open(&t)?, None, &FindOptions::default()),
        None => find_similar(&img, q, &img, Some(q), &FindOptions::default()),
    };
    Ok(found.into_iter().map(|m| pixel_rect(m.bbox)).collect())
}

/// One object across a video (`unseen_core::Track`), indexed by its
/// position in [`VideoSummary::tracks`].
pub struct VideoTrack {
    pub class_name: String,
    pub state: RegionState,
    /// Frames of the keyframes it was detected on, ascending.
    pub frames: Vec<u32>,
}

pub struct VideoSummary {
    pub width: u32,
    pub height: u32,
    pub frames: u32,
    /// Seconds per frame index, as decoded.
    pub times: Vec<f64>,
    pub keyframes: Vec<u32>,
    pub tracks: Vec<VideoTrack>,
    /// The source has sound, which export can copy (off by default).
    pub has_audio: bool,
}

pub struct TrackBox {
    pub track: u32,
    pub rect: PixelRect,
}

pub struct FrameCheck {
    pub frame: u32,
    pub surviving: Vec<Region>,
}

pub struct VideoExportOptions {
    /// Indices into [`VideoSummary::tracks`] to redact.
    pub tracks: Vec<u32>,
    pub fill: Fill,
    /// Copy the source's audio (it is dropped otherwise).
    pub keep_audio: bool,
    /// Write even if the self-check fails.
    pub force: bool,
}

pub struct ExportResult {
    /// Written: the check passed on every keyframe, or `force` was set.
    pub written: bool,
    /// The first keyframe whose self-check failed.
    pub failed: Option<FrameCheck>,
}

pub struct ExportProgress {
    /// Frames processed so far.
    pub frames: u32,
    /// Set on the last event only.
    pub result: Option<ExportResult>,
}

/// A video under analysis and export. Analysis keeps one JPEG per
/// keyframe in `cache_dir`: frames between two keyframes show the first
/// one's content, so those images are the preview for every frame.
#[frb(opaque)]
pub struct VideoProject {
    path: PathBuf,
    cache_dir: PathBuf,
    analysed: Option<(Timeline, Vec<Timestamp>, (u32, u32))>,
}

fn keyframe_file(dir: &Path, frame: usize) -> PathBuf {
    dir.join(format!("kf{frame:06}.jpg"))
}

/// Class name of tracks the user added.
const MANUAL: &str = "manual";

impl VideoProject {
    #[frb(sync)]
    pub fn new(video_path: String, cache_dir: String) -> Result<VideoProject> {
        std::fs::create_dir_all(&cache_dir).with_context(|| format!("creating {cache_dir}"))?;
        Ok(VideoProject {
            path: video_path.into(),
            cache_dir: cache_dir.into(),
            analysed: None,
        })
    }

    fn keyframe_file(&self, frame: usize) -> PathBuf {
        keyframe_file(&self.cache_dir, frame)
    }

    /// Decodes the video, detects on keyframes and links tracks; reports
    /// frames decoded to `progress`.
    pub fn analyze(&mut self, session: &Session, progress: StreamSink<u32>) -> Result<()> {
        let reader = VideoReader::open(&self.path).with_context(|| format!("opening {}", self.path.display()))?;
        let size = reader.size();
        let mut keys = Keyframes::new(KeyframeOptions::default());
        let mut tracker = Tracker::new();
        let mut times = Vec::new();
        for (i, frame) in reader.enumerate() {
            let frame = frame?;
            if keys.push(i, &frame.image) {
                let mut det = session.lock();
                let dets = det
                    .detect(&frame.image, &DetectOptions::default())?
                    .into_iter()
                    .map(|d| {
                        let s = det.selection(&d);
                        (d, s)
                    })
                    .collect();
                drop(det);
                tracker.add(i, dets);
                let f = std::fs::File::create(self.keyframe_file(i))?;
                image::codecs::jpeg::JpegEncoder::new_with_quality(std::io::BufWriter::new(f), 90)
                    .encode_image(&frame.image)?;
            }
            times.push(frame.time);
            // A closed stream means nobody is listening; keep going.
            let _ = progress.add(times.len() as u32);
        }
        anyhow::ensure!(!times.is_empty(), "no frames in {}", self.path.display());
        self.analysed = Some((tracker.finish(times.len()), times, size));
        Ok(())
    }

    fn analysed(&self) -> Result<&(Timeline, Vec<Timestamp>, (u32, u32))> {
        self.analysed.as_ref().context("the video has not been analysed")
    }

    #[frb(sync)]
    pub fn summary(&self) -> Result<VideoSummary> {
        let (tl, times, (w, h)) = self.analysed()?;
        Ok(VideoSummary {
            width: *w,
            height: *h,
            frames: tl.frames as u32,
            times: times.iter().map(|t| t.seconds()).collect(),
            keyframes: tl.keyframes.iter().map(|&k| k as u32).collect(),
            has_audio: unseen_media::has_audio(&self.path)?,
            tracks: tl
                .tracks
                .iter()
                .map(|t| VideoTrack {
                    class_name: t.class.clone(),
                    state: match t.selection {
                        Selection::Selected => RegionState::Selected,
                        Selection::Suggested => RegionState::Suggested,
                        Selection::Review | Selection::Hidden => RegionState::Review,
                    },
                    frames: t.observations.iter().map(|o| o.frame as u32).collect(),
                })
                .collect(),
        })
    }

    /// The image showing `frame`: the JPEG of the last keyframe at or before it.
    #[frb(sync)]
    pub fn preview_path(&self, frame: u32) -> Result<String> {
        let (tl, _, _) = self.analysed()?;
        let i = tl.keyframes.partition_point(|&k| k <= frame as usize);
        let k = tl.keyframes[i.max(1) - 1];
        Ok(self.keyframe_file(k).to_string_lossy().into_owned())
    }

    /// Adds a track for a region the user drew on `frame`, followed across
    /// keyframes by template matching. Returns its index in the summary.
    pub fn add_manual(&mut self, frame: u32, rect: PixelRect) -> Result<u32> {
        let cache = self.cache_dir.clone();
        let (tl, _, _) = self.analysed.as_mut().context("the video has not been analysed")?;
        let i = tl.add_manual(
            frame as usize,
            [rect.left, rect.top, rect.right, rect.bottom],
            MANUAL,
            |k| load_image(&keyframe_file(&cache, k)),
        )?;
        Ok(i as u32)
    }

    /// Every track's box in `frame`.
    #[frb(sync)]
    pub fn boxes_at(&self, frame: u32) -> Result<Vec<TrackBox>> {
        let (tl, _, _) = self.analysed()?;
        Ok(tl
            .tracks
            .iter()
            .enumerate()
            .filter_map(|(i, t)| {
                tl.box_at(t, frame as usize).map(|b| TrackBox {
                    track: i as u32,
                    rect: pixel_rect(b),
                })
            })
            .collect())
    }

    /// Redacts the chosen tracks in every frame and writes an H.264 MP4.
    /// The export self-check runs on each keyframe; on the first failure
    /// the export stops and writes nothing, unless forced.
    pub fn export(
        &self,
        session: &Session,
        out_path: String,
        opts: VideoExportOptions,
        events: StreamSink<ExportProgress>,
    ) -> Result<()> {
        let VideoExportOptions {
            tracks,
            fill,
            keep_audio,
            force,
        } = opts;
        let (tl, _, (w, h)) = self.analysed()?;
        let keep: Vec<&unseen_core::Track> = tracks.iter().filter_map(|&i| tl.tracks.get(i as usize)).collect();
        let style: RedactStyle = fill.into();
        let out = PathBuf::from(&out_path);
        // Written beside the target and renamed at the end, so a failed or
        // interrupted export never leaves a partial file under the name.
        let partial = out.with_extension("partial.mp4");
        let mut writer = VideoWriter::create(&partial, *w, *h, keep_audio.then_some(self.path.as_path()))?;
        let reader = VideoReader::open(&self.path)?;
        let (mut failed, mut done) = (None, 0);
        for (i, frame) in reader.enumerate() {
            let frame = frame?;
            let boxes: Vec<[f32; 4]> = keep.iter().filter_map(|t| tl.box_at(t, i)).collect();
            let mut img = frame.image.clone();
            redact(&mut img, &boxes, PAD, style);
            if tl.keyframes.binary_search(&i).is_ok() {
                let check = export_check(&mut session.lock(), &frame.image, &img, None, &boxes, PAD, style)?;
                if !check.passed() && failed.is_none() {
                    failed = Some(FrameCheck {
                        frame: i as u32,
                        surviving: check
                            .surviving
                            .iter()
                            .map(|d| region(d, RegionState::Selected))
                            .collect(),
                    });
                    if !force {
                        break;
                    }
                }
            }
            writer.write(&img, frame.time)?;
            done = i as u32 + 1;
            let _ = events.add(ExportProgress {
                frames: done,
                result: None,
            });
        }
        let written = failed.is_none() || force;
        if written {
            writer.finish()?;
            std::fs::rename(&partial, &out).with_context(|| format!("writing {out_path}"))?;
        } else {
            writer.discard();
            let _ = std::fs::remove_file(&partial);
        }
        let _ = events.add(ExportProgress {
            frames: done,
            result: Some(ExportResult { written, failed }),
        });
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn label_classes_are_the_dataset_list_in_id_order() {
        let c = super::label_classes();
        assert_eq!(c.first().map(String::as_str), Some("person_name"));
        assert!(c.contains(&"finance".to_string()));
    }

    #[test]
    fn write_image_scales_down_and_encodes_by_extension() {
        let dir = std::env::temp_dir().join(format!("unseen-write-{}", std::process::id()));
        std::fs::create_dir_all(&dir).unwrap();
        let img = image::RgbImage::from_pixel(400, 100, image::Rgb([10, 200, 30]));
        for (name, max, size, format) in [
            ("a.png", None, (400, 100), image::ImageFormat::Png),
            ("b.JPG", Some(200), (200, 50), image::ImageFormat::Jpeg),
            ("c.png", Some(1000), (400, 100), image::ImageFormat::Png),
        ] {
            let p = dir.join(name);
            super::write_image(&img, &p, max).unwrap();
            let r = image::ImageReader::open(&p).unwrap().with_guessed_format().unwrap();
            assert_eq!(r.format(), Some(format), "{name}");
            assert_eq!(r.into_dimensions().unwrap(), size, "{name}");
        }
        std::fs::remove_dir_all(dir).unwrap();
    }
}

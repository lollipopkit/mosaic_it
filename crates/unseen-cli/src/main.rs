use std::path::{Path, PathBuf};

use anyhow::{Context, Result, bail};
use clap::{Args, Parser, Subcommand, ValueEnum};
use image::{Rgb, RgbImage};
use serde::Serialize;
use unseen_core::{
    Calibrator, CocoDataset, DetectOptions, Detection, Detector, EvalOptions, Evaluator, FindOptions, GtImage,
    KeyframeOptions, Keyframes, Manifest, ModelEntry, ModelMeta, RedactStyle, Selection, Tracker, export_check,
    find_similar, is_camera_photo, load_image, redact,
};
use unseen_infer::{OrtBackend, OrtOptions, face_detector};
use unseen_media::{Timestamp, VideoReader, VideoWriter};

#[derive(Parser)]
#[command(name = "unseen", version, about = "Detect and redact private information in images")]
struct Cli {
    #[command(subcommand)]
    cmd: Cmd,
}

#[derive(Clone, Copy, ValueEnum)]
enum Style {
    /// One colour (--color).
    Solid,
    /// The mean colour around each box.
    Surround,
    /// Grey mosaic.
    Blocks,
    /// Colour mosaic sampled around each box.
    Tinted,
    Noise,
}

/// `RRGGBB` or `#RRGGBB`.
fn hex_colour(s: &str) -> Result<Rgb<u8>, String> {
    let h = s.trim_start_matches('#');
    let v = u32::from_str_radix(h, 16).map_err(|e| e.to_string())?;
    if h.len() != 6 {
        return Err(format!("{s}: expected RRGGBB"));
    }
    Ok(Rgb([(v >> 16) as u8, (v >> 8) as u8, v as u8]))
}

/// One seed for the whole run, so a video's noise and mosaic do not flicker.
fn redact_style(s: Style, colour: Rgb<u8>) -> RedactStyle {
    match s {
        Style::Solid => RedactStyle::Solid(colour),
        Style::Surround => RedactStyle::Surround,
        Style::Blocks => RedactStyle::Blocks { size: 0 },
        Style::Tinted => RedactStyle::random_tinted(),
        Style::Noise => RedactStyle::random_noise(),
    }
}

#[derive(Args)]
struct Faces {
    /// Also detect faces (YuNet, built in). Off by default: scripts compare
    /// detections with the model's classes.
    #[arg(long = "faces")]
    on: bool,
}

#[derive(Subcommand)]
enum Cmd {
    /// Print detections with their pre-selection state as JSON.
    Detect {
        #[arg(long)]
        model: PathBuf,
        /// Also print detections below the review threshold.
        #[arg(long)]
        all: bool,
        #[command(flatten)]
        faces: Faces,
        /// One JSON line per image: file_name, width, height, boxes
        /// with xywh bbox, category, score and selection.
        #[arg(long)]
        jsonl: bool,
        #[arg(required = true)]
        images: Vec<PathBuf>,
    },
    /// Write a redacted copy of the image after the export self-check.
    /// Metadata is not carried over.
    Redact {
        #[arg(long)]
        model: PathBuf,
        /// Redact detections at or above this score instead of the model's
        /// calibrated selection.
        #[arg(long)]
        score: Option<f32>,
        /// Pixels added around each box.
        #[arg(long, default_value_t = 4.0)]
        pad: f32,
        #[arg(long, value_enum, default_value_t = Style::Solid)]
        style: Style,
        /// Fill colour for --style solid, RRGGBB.
        #[arg(long, value_parser = hex_colour, default_value = "000000")]
        color: Rgb<u8>,
        /// Write the output even if the self-check fails.
        #[arg(long)]
        force: bool,
        #[command(flatten)]
        faces: Faces,
        image: PathBuf,
        out: PathBuf,
    },
    /// Redact a video: detection on keyframes, ByteTrack across them. The
    /// input is a video file (written as H.264 MP4, with audio only given
    /// --keep-audio, plus `<out>.timeline.json`) or a directory of frames
    /// sorted by name (written as PNGs with timeline.json into `out`).
    Video {
        #[arg(long)]
        model: PathBuf,
        #[arg(long, default_value_t = 4.0)]
        pad: f32,
        #[arg(long, value_enum, default_value_t = Style::Solid)]
        style: Style,
        /// Fill colour for --style solid, RRGGBB.
        #[arg(long, value_parser = hex_colour, default_value = "000000")]
        color: Rgb<u8>,
        /// Redact review tracks too, not only selected ones.
        #[arg(long)]
        review: bool,
        /// Copy the input video's audio into the output (dropped by default).
        #[arg(long)]
        keep_audio: bool,
        /// Write the output even if the self-check fails on a keyframe.
        #[arg(long)]
        force: bool,
        #[command(flatten)]
        faces: Faces,
        input: PathBuf,
        out: PathBuf,
    },
    /// Evaluate on a COCO dataset (AP@0.5 and coverage recall) and print JSON.
    Eval {
        #[arg(long)]
        model: PathBuf,
        /// Directory containing coco.json.
        #[arg(long)]
        data: PathBuf,
        /// Only the first N images.
        #[arg(long)]
        limit: Option<usize>,
        /// Detections at or above this score count for coverage.
        #[arg(long, default_value_t = 0.3)]
        score: f32,
        /// Fraction of a box that must be covered.
        #[arg(long, default_value_t = 0.9)]
        cover: f32,
    },
    /// Find regions that look like a box (same image or another at the same
    /// scale) and print them as JSON.
    Find {
        image: PathBuf,
        /// x0,y0,x1,y1 in pixels of `image`.
        #[arg(long, value_delimiter = ',', required = true)]
        r#box: Vec<f32>,
        /// Search here instead of in `image`.
        #[arg(long)]
        target: Option<PathBuf>,
    },
    /// Time end-to-end detection and report how ONNX Runtime placed the graph
    /// on execution providers.
    Bench {
        #[arg(long)]
        model: PathBuf,
        #[arg(long, default_value_t = 20)]
        runs: usize,
        /// CPU only, skipping hardware execution providers.
        #[arg(long)]
        cpu: bool,
        #[command(flatten)]
        faces: Faces,
        image: PathBuf,
    },
    /// Model files against models/manifest.toml.
    #[command(subcommand)]
    Models(ModelsCmd),
    /// Pick per-class thresholds with a recall guarantee on a COCO dataset
    /// and store them in the model metadata.
    Calibrate {
        #[arg(long)]
        model: PathBuf,
        #[arg(long)]
        data: PathBuf,
        #[arg(long)]
        limit: Option<usize>,
        /// Input domain the guarantee is for.
        #[arg(long, default_value = "ui_screenshot")]
        domain: String,
        /// Target miss rate for pre-selected boxes.
        #[arg(long, default_value_t = 0.02)]
        alpha: f64,
        /// Allowed probability that the guarantee fails.
        #[arg(long, default_value_t = 0.05)]
        delta: f64,
        /// Least share of review-band boxes that must lie on a real box of
        /// their class for the class to get a band.
        #[arg(long, default_value_t = 0.5)]
        review_precision: f64,
        /// The dataset is human-verified real data.
        #[arg(long)]
        verified: bool,
        #[arg(long, default_value_t = 0.9)]
        cover: f32,
    },
}

#[derive(Subcommand)]
enum ModelsCmd {
    /// Print a `[[model]]` entry for the files as they are now.
    Hash {
        model: PathBuf,
        #[arg(long, default_value = "unseen-det")]
        name: String,
        #[arg(long = "model-version")]
        version: String,
        /// tiled or dynamic
        #[arg(long)]
        variant: String,
    },
    /// Check models and their sidecars against the manifest.
    Verify {
        #[arg(long, default_value = "models/manifest.toml")]
        manifest: PathBuf,
        #[arg(required = true)]
        models: Vec<PathBuf>,
    },
    /// Sign the manifest for publishing: writes `<manifest>.signed`. The hex
    /// Ed25519 secret key comes from UNSEEN_MANIFEST_KEY.
    Sign {
        #[arg(long, default_value = "models/manifest.toml")]
        manifest: PathBuf,
    },
    /// Print the public key of UNSEEN_MANIFEST_KEY (unseen-core's PUBLIC_KEY).
    Pubkey,
}

/// The manifest signing key, kept out of the arguments.
fn manifest_key() -> Result<String> {
    std::env::var("UNSEEN_MANIFEST_KEY").context("UNSEEN_MANIFEST_KEY is not set")
}

/// Where a frame came from: its file stem, or its time in a video.
enum FrameTag {
    Name(String),
    Time(Timestamp),
}

type Frames<'a> = Box<dyn Iterator<Item = Result<(RgbImage, FrameTag)>> + 'a>;

/// A video file, or a directory of frames sorted by name.
enum VideoInput {
    File(PathBuf),
    Dir(PathBuf, Vec<PathBuf>),
}

impl VideoInput {
    fn new(path: &Path) -> Result<Self> {
        if !path.is_dir() {
            return Ok(Self::File(path.to_path_buf()));
        }
        let mut files: Vec<_> = std::fs::read_dir(path)?
            .map(|e| e.map(|e| e.path()))
            .collect::<std::io::Result<_>>()?;
        files.retain(|p| {
            p.extension()
                .and_then(|e| e.to_str())
                .is_some_and(|e| ["png", "jpg", "jpeg", "webp"].contains(&e.to_ascii_lowercase().as_str()))
        });
        files.sort();
        Ok(Self::Dir(path.to_path_buf(), files))
    }

    fn path(&self) -> &Path {
        match self {
            Self::File(p) | Self::Dir(p, _) => p,
        }
    }

    /// Decodes from the start; called once per pass.
    fn frames(&self) -> Result<Frames<'_>> {
        Ok(match self {
            Self::File(p) => Box::new(
                VideoReader::open(p)
                    .with_context(|| format!("opening {}", p.display()))?
                    .map(|f| f.map(|f| (f.image, FrameTag::Time(f.time))).map_err(Into::into)),
            ),
            Self::Dir(_, files) => Box::new(files.iter().map(|f| {
                let name = f.file_stem().unwrap_or_default().to_string_lossy().into_owned();
                Ok((load_image(f)?, FrameTag::Name(name)))
            })),
        })
    }
}

enum VideoOutput {
    /// Target, audio source, and the writer once the frame size is known.
    File(PathBuf, Option<PathBuf>, Option<VideoWriter>),
    Dir(PathBuf),
}

impl VideoOutput {
    fn new(input: &VideoInput, out: &Path, keep_audio: bool) -> Result<Self> {
        Ok(match input {
            VideoInput::File(src) => Self::File(out.to_path_buf(), keep_audio.then(|| src.clone()), None),
            VideoInput::Dir(..) => {
                std::fs::create_dir_all(out)?;
                Self::Dir(out.to_path_buf())
            }
        })
    }

    fn timeline_path(&self) -> PathBuf {
        match self {
            Self::File(p, ..) => p.with_extension("timeline.json"),
            Self::Dir(d) => d.join("timeline.json"),
        }
    }

    fn write(&mut self, img: &RgbImage, tag: FrameTag) -> Result<()> {
        match (self, tag) {
            (Self::File(p, audio, w), FrameTag::Time(t)) => {
                let w = match w {
                    Some(w) => w,
                    None => w.insert(VideoWriter::create(p, img.width(), img.height(), audio.as_deref())?),
                };
                w.write(img, t)?;
            }
            (Self::Dir(d), FrameTag::Name(n)) => img.save(d.join(format!("{n}.png")))?,
            _ => unreachable!("output kind follows the input kind"),
        }
        Ok(())
    }

    fn finish(self) -> Result<()> {
        if let Self::File(_, _, Some(w)) = self {
            w.finish()?;
        }
        Ok(())
    }
}

#[derive(Serialize)]
struct Shown<'a> {
    #[serde(flatten)]
    det: &'a Detection,
    selection: Selection,
}

fn detector(model: &Path, faces: &Faces) -> Result<Detector> {
    let meta = ModelMeta::load(model)?;
    let opts = OrtOptions {
        cache_dir: dirs::cache_dir().map(|d| d.join("unseen")),
        ..Default::default()
    };
    let backend = OrtBackend::load_with(model, opts).with_context(|| format!("loading {}", model.display()))?;
    with_faces(Detector::new(meta, Box::new(backend)), faces)
}

fn with_faces(det: Detector, faces: &Faces) -> Result<Detector> {
    Ok(if faces.on {
        det.with_faces(face_detector()?)
    } else {
        det
    })
}

/// Runs the detector over the first `limit` images of a COCO dataset.
fn run_dataset(
    det: &mut Detector,
    data: &Path,
    limit: Option<usize>,
    mut f: impl FnMut(&GtImage, &[Detection]) -> unseen_core::Result<()>,
) -> Result<()> {
    let ds = CocoDataset::load(data)?;
    anyhow::ensure!(
        ds.classes == det.meta.classes,
        "dataset classes {:?} differ from model classes {:?}",
        ds.classes,
        det.meta.classes
    );
    let images = &ds.images[..limit.unwrap_or(usize::MAX).min(ds.images.len())];
    let t = std::time::Instant::now();
    for (i, gt) in images.iter().enumerate() {
        let img = load_image(&gt.path)?;
        f(gt, &det.detect(&img, &DetectOptions::default())?)?;
        if (i + 1) % 100 == 0 {
            eprintln!("{}/{}", i + 1, images.len());
        }
    }
    eprintln!("{} images in {:?} ({})", images.len(), t.elapsed(), det.backend_name());
    Ok(())
}

fn main() -> Result<()> {
    match Cli::parse().cmd {
        Cmd::Detect {
            model,
            all,
            jsonl,
            faces,
            images,
        } => {
            if !jsonl && images.len() > 1 {
                bail!("several images need --jsonl");
            }
            let mut det = detector(&model, &faces)?;
            for image in &images {
                let img = load_image(image)?;
                if is_camera_photo(image) {
                    eprintln!(
                        "{}: camera photo; the detector is calibrated on screenshots",
                        image.display()
                    );
                }
                let t = std::time::Instant::now();
                let dets = det.detect(&img, &DetectOptions::default())?;
                eprintln!(
                    "{}: {} detections in {:?} ({})",
                    image.display(),
                    dets.len(),
                    t.elapsed(),
                    det.backend_name()
                );
                let shown: Vec<_> = dets
                    .iter()
                    .map(|d| Shown {
                        det: d,
                        selection: det.selection(d),
                    })
                    .filter(|s| all || s.selection != Selection::Hidden)
                    .collect();
                if !jsonl {
                    println!("{}", serde_json::to_string_pretty(&shown)?);
                    continue;
                }
                let boxes: Vec<_> = shown
                    .iter()
                    .map(|s| {
                        let [x0, y0, x1, y1] = s.det.bbox;
                        serde_json::json!({
                            "bbox": [x0, y0, x1 - x0, y1 - y0],
                            "category": s.det.class,
                            "score": s.det.score,
                            "selection": s.selection,
                        })
                    })
                    .collect();
                let name = image.file_name().map(|n| n.to_string_lossy()).unwrap_or_default();
                let line = serde_json::json!({
                    "file_name": name,
                    "width": img.width(),
                    "height": img.height(),
                    "boxes": boxes,
                });
                println!("{line}");
            }
        }
        Cmd::Redact {
            model,
            score,
            pad,
            style,
            color,
            force,
            faces,
            image,
            out,
        } => {
            let mut det = detector(&model, &faces)?;
            // Decoding to raw pixels and re-encoding drops EXIF/XMP/GPS.
            let src = load_image(&image)?;
            let opts = DetectOptions::default();
            let cands = det.candidates(&src, opts.min_score)?;
            let boxes: Vec<_> = det
                .detections(&cands, &opts)?
                .into_iter()
                .filter(|d| match score {
                    Some(s) => d.score >= s,
                    None => det.selection(d) == Selection::Selected,
                })
                .map(|d| d.bbox)
                .collect();
            let style = redact_style(style, color);
            let mut img = src.clone();
            redact(&mut img, &boxes, pad, style);
            let check = export_check(&mut det, &src, &img, Some(&cands), &boxes, pad, style)?;
            if !check.passed() {
                eprintln!("{}", serde_json::to_string_pretty(&check)?);
                anyhow::ensure!(force, "self-check failed; rerun with --force to write anyway");
                eprintln!("self-check failed; writing anyway (--force)");
            }
            img.save(&out)?;
            eprintln!("redacted {} regions -> {}", boxes.len(), out.display());
        }
        Cmd::Video {
            model,
            pad,
            style,
            color,
            review,
            keep_audio,
            force,
            faces,
            input,
            out,
        } => {
            let mut det = detector(&model, &faces)?;
            let input = VideoInput::new(&input)?;
            let t = std::time::Instant::now();
            let mut keys = Keyframes::new(KeyframeOptions::default());
            let mut tracker = Tracker::new();
            let mut n = 0;
            for frame in input.frames()? {
                let (img, _) = frame?;
                if keys.push(n, &img) {
                    let dets = det.detect(&img, &DetectOptions::default())?;
                    let dets = dets
                        .into_iter()
                        .map(|d| {
                            let s = det.selection(&d);
                            (d, s)
                        })
                        .collect();
                    tracker.add(n, dets);
                }
                n += 1;
            }
            anyhow::ensure!(n > 0, "no frames in {}", input.path().display());
            let tl = tracker.finish(n);
            eprintln!(
                "{} frames, {} keyframes, {} tracks in {:?} ({})",
                tl.frames,
                tl.keyframes.len(),
                tl.tracks.len(),
                t.elapsed(),
                det.backend_name()
            );
            let mut output = VideoOutput::new(&input, &out, keep_audio)?;
            std::fs::write(output.timeline_path(), serde_json::to_string_pretty(&tl)?)?;
            let keep = |t: &unseen_core::Track| review || t.selection == Selection::Selected;
            let style = redact_style(style, color);
            for (i, frame) in input.frames()?.enumerate() {
                let (src, tag) = frame?;
                let boxes = tl.boxes_at(i, keep);
                let mut img = src.clone();
                redact(&mut img, &boxes, pad, style);
                if tl.keyframes.binary_search(&i).is_ok() {
                    let check = export_check(&mut det, &src, &img, None, &boxes, pad, style)?;
                    if !check.passed() {
                        eprintln!("frame {i}: {}", serde_json::to_string(&check)?);
                        anyhow::ensure!(
                            force,
                            "self-check failed at frame {i}; rerun with --force to write anyway"
                        );
                    }
                }
                output.write(&img, tag)?;
            }
            output.finish()?;
            eprintln!("redacted {n} frames -> {}", out.display());
        }
        Cmd::Eval {
            model,
            data,
            limit,
            score,
            cover,
        } => {
            let mut det = detector(&model, &Faces { on: false })?;
            let mut ev = Evaluator::new(det.meta.classes.clone(), EvalOptions { score, cover });
            run_dataset(&mut det, &data, limit, |gt, d| ev.add(gt, d))?;
            println!("{}", serde_json::to_string_pretty(&ev.finish())?);
        }
        Cmd::Find { image, r#box, target } => {
            let q: [f32; 4] = r#box
                .try_into()
                .map_err(|_| anyhow::anyhow!("--box takes exactly four numbers"))?;
            let src = load_image(&image)?;
            let t = std::time::Instant::now();
            let matches = match &target {
                Some(p) => find_similar(&src, q, &load_image(p)?, None, &FindOptions::default()),
                None => find_similar(&src, q, &src, Some(q), &FindOptions::default()),
            };
            eprintln!("{} matches in {:?}", matches.len(), t.elapsed());
            println!("{}", serde_json::to_string_pretty(&matches)?);
        }
        Cmd::Bench {
            model,
            runs,
            cpu,
            faces,
            image,
        } => {
            // No cache: the load time reported includes compilation.
            let opts = OrtOptions {
                cpu_only: cpu,
                record_placement: true,
                cache_dir: None,
            };
            let t = std::time::Instant::now();
            let backend =
                OrtBackend::load_with(&model, opts).with_context(|| format!("loading {}", model.display()))?;
            let load_ms = t.elapsed().as_secs_f64() * 1e3;
            let placement = backend.placement().to_vec();
            let mut det = with_faces(Detector::new(ModelMeta::load(&model)?, Box::new(backend)), &faces)?;
            let img = load_image(&image)?;
            // The first runs include provider compilation and allocation.
            for _ in 0..3 {
                det.detect(&img, &DetectOptions::default())?;
            }
            let mut ms: Vec<f64> = (0..runs.max(1))
                .map(|_| {
                    let t = std::time::Instant::now();
                    det.detect(&img, &DetectOptions::default())
                        .map(|_| t.elapsed().as_secs_f64() * 1e3)
                })
                .collect::<unseen_core::Result<_>>()?;
            ms.sort_by(f64::total_cmp);
            let q = |f: f64| ms[((ms.len() - 1) as f64 * f).round() as usize];
            let report = serde_json::json!({
                "backend": det.backend_name(),
                "image": [img.width(), img.height()],
                "load_ms": load_ms,
                "detect_ms": { "min": ms[0], "p50": q(0.5), "p90": q(0.9), "max": ms[ms.len() - 1] },
                "placement": placement,
            });
            println!("{}", serde_json::to_string_pretty(&report)?);
        }
        Cmd::Models(ModelsCmd::Hash {
            model,
            name,
            version,
            variant,
            // Leading blank line: the output is appended to the manifest.
        }) => print!(
            "\n{}",
            ModelEntry::describe(&model, &name, &version, &variant)?.to_toml()?
        ),
        Cmd::Models(ModelsCmd::Verify { manifest, models }) => {
            let m = Manifest::load(&manifest)?;
            for model in &models {
                let e = m.verify(model)?;
                eprintln!("ok {} ({} {} {})", model.display(), e.name, e.version, e.variant);
            }
        }
        Cmd::Models(ModelsCmd::Sign { manifest }) => {
            let bytes = std::fs::read(&manifest)?;
            let (published, public) = unseen_core::sign(&bytes, &manifest_key()?)?;
            // Apps would reject it: they verify with the built-in key.
            anyhow::ensure!(
                public == unseen_core::PUBLIC_KEY,
                "UNSEEN_MANIFEST_KEY is not the key of unseen-core's PUBLIC_KEY"
            );
            let out = PathBuf::from(format!("{}.signed", manifest.display()));
            std::fs::write(&out, published)?;
            eprintln!("wrote {}", out.display());
        }
        Cmd::Models(ModelsCmd::Pubkey) => println!("{}", unseen_core::sign(&[], &manifest_key()?)?.1),
        Cmd::Calibrate {
            model,
            data,
            limit,
            domain,
            alpha,
            delta,
            review_precision,
            verified,
            cover,
        } => {
            let mut det = detector(&model, &Faces { on: false })?;
            let mut cal = Calibrator::new(det.meta.classes.clone(), cover);
            run_dataset(&mut det, &data, limit, |gt, d| cal.add(gt, d))?;
            let c = cal.finish(&domain, alpha, delta, review_precision, verified);
            ModelMeta::store_calibration(&model, &c)?;
            for (name, t) in &c.classes {
                eprintln!(
                    "{name:12} select {:.2} review {:.2} n {:5}{}",
                    t.select,
                    t.review,
                    t.n,
                    if t.guaranteed { "" } else { "  (not certified)" }
                );
            }
            eprintln!("stored in {}", ModelMeta::sidecar(&model).display());
        }
    }
    Ok(())
}

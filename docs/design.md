# MosaicIt — Design

MosaicIt finds private information in images (later: video) and redacts it.
It proposes boxes, pre-selects the ones it is confident about, and lets the user
toggle the rest before export. Everything runs on device.

## 1. Goals and non-goals

Goals

- Detect privacy regions in screenshots and photos **without OCR**: person name,
  address, ID number, phone, email, bank card, plate, face, avatar, QR/barcode.
- Pre-select boxes with a **per-class recall guarantee** (conformal calibration),
  not a hand-tuned threshold.
- Redaction that cannot be reversed, verified before export.
- One Rust core shared by every frontend; inference backends are pluggable.
- Platforms, first batch: macOS, iOS, Android. Video is milestone 2.

Non-goals

- No OCR anywhere in the shipped product (no text recognition, no NER).
- No cloud dependency. A remote backend is optional and self-hosted.
- No third-party AGPL/GPL code or weights in shipped artifacts (see §9).

## 2. Repository layout

```
unseen/
  crates/
    unseen-core/     Session facade, types, redaction, calibration, propagation
    unseen-infer/    Detector / Embedder traits + backends (ort, tract, remote)
    unseen-ffi/      flutter_rust_bridge v2 API surface
    unseen-cli/      `unseen` binary: detect, redact, eval, calibrate, bench
    unseen-server/   (later) axum server exposing the remote backend
  app/               Flutter app (macOS, iOS, Android)
  models/            classes.json, manifest.toml (name, version, BLAKE3, url); weights not committed
  docs/
```

Flutter talks to Rust through flutter_rust_bridge 2.13 (pinned exactly on all
three sides). Images cross the boundary as file paths or zero-copy buffers;
progress and results come back as Streams.

## 3. Class taxonomy

Canonical list: [models/classes.json](../models/classes.json). Ids are append-only.

| Group | Classes | Main cue |
|---|---|---|
| Format | `phone`, `email`, `id_number`, `bank_card`, `plate`, `account_id`, `device_id`, `secret` | glyph shape and length of the string |
| Context | `person_name`, `address`, `finance`, `organization` | neighbouring labels and layout ("收件人：", chat header) |
| Visual | `avatar`, `qr`, `barcode` | object appearance |
| Face (separate detector) | `face` | YuNet |

`account_id` covers user handles, UIDs, WeChat IDs and tracking numbers.
`secret` covers credentials in clear text: passwords, API keys and tokens,
private keys, seed phrases and recovery keys, 2FA setup and backup codes,
one-time codes. Masked passwords, public keys, hashes and gift-card codes are
negatives.
Partially masked values (`138****5678`) keep their class.

Planned, not in v1: `signature`, `id_card` (whole document), `text_sensitive`
(fallback, never auto-selected), location-leak classes (street sign, storefront).
`face` comes from YuNet (opencv_zoo, MIT), built into `unseen-infer`; see
"Faces" below. It may later merge into our own detector.
QR/barcode boxes come from the detector; rxing decoding only refines them.

### Faces (2026-11-12)

`face` boxes come from YuNet's dynamic-shape export
(`face_detection_yunet_2026may.onnx`, 230 KB, compiled into `unseen-infer`
with its licence). It runs on the CPU, since its input follows each image's
size and hardware providers compile per shape. It adds about 5 ms to a
1206x2622 screenshot. YuNet finds faces of about 10-300 px, so it runs twice:
at native size (long side capped at 3072) and at long side 640, merged by NMS
at IoU 0.3, decoding only candidates at or above the review threshold (top
5000). A face inside an `avatar` keeps its own box, so unselecting the avatar
leaves the face selected. The app always detects faces; the CLI does so only with `--faces`,
because evaluation scripts compare detections with the model's classes.

Settings > Redaction > Selected by default lists the classes pre-selected
after detection; `face` is off by default. A class that is off is still
detected: its boxes above `review` are shown unselected and not highlighted
(`Selection::Suggested`, recorded as `suggested` in collected data), and the
export check does not report them.

WIDER FACE val (3226 images; internal evaluation only, its licence is
non-commercial): recall is a face covered at least 70% by boxes grown 4 px,
by face height; off-face boxes overlap no face (any size, IoA < 0.3).

| Detector | Score | Off-face boxes per image | 16-32 px | 32-100 px | > 100 px |
|---|---|---|---|---|---|
| Apple Vision (`VNDetectFaceRectanglesRequest` rev 3) | all | 0.01 | 0.011 | 0.413 | 0.737 |
| YuNet, native only | 0.7 | 0.18 | 0.641 | 0.824 | 0.880 |
| YuNet, native + 640 | 0.7 (select) | 0.23 | 0.649 | 0.836 | 0.913 |
| YuNet, native + 640 | 0.6 (review) | 0.65 | 0.737 | 0.870 | 0.932 |

Apple Vision is not used on Apple platforms: it misses most faces under
100 px, and its boxes sit low (median height 0.82 of the face's, top 0.17
of a height below it), leaving the forehead uncovered. YuNet's boxes match the
labels (width and height ratio 1.0).

On 298 private iPhone screenshots, 0.27 faces per screen are pre-selected and 0.11
shown for review, on 44 screens. Most are faces in videos, photos and
thumbnails. False ones are cartoon and animal faces (0.6-0.8), one
whole-screen box on a close-up of skin (0.72) and stylised logo text.

## 4. Detector

MosaicIt runs its own detector, `unseen-det`: a convolutional network with a
stride-4 level for thin text lines (screenshot text is 10–20 px tall). Its
architecture is not derived from third-party detector code, and the weights
are trained by the maintainer, so both can be relicensed under the CLA. The
released weights, their classes, training data sources and limits are
described in [model.md](model.md). The training code and the datasets are
not part of this repository.

**Export-safe operators.** The exported graph holds only operators that run
on CoreML and NNAPI without graph partitioning: per-stride sigmoid scores and
raw box outputs. Softplus, cell centres and box decoding are in the Rust core
(`unseen-core::detect`). `unseen bench` prints ONNX Runtime's node placement.
An export with dynamic height and width splits into 8 CoreML partitions with
121 of 478 nodes on the CPU and runs slower than the CPU alone, so
`OrtBackend` falls back to the CPU whenever a hardware provider leaves nodes
there. The tiled export fixes the input at 1280×736, so all shape arithmetic
folds away, and the core runs tall images in tiles overlapping by 384 px
(each detection is kept by the tile owning its centre). On a 720×1994
screenshot (M-series):

| Export / provider | Placement | p50 |
|---|---|---|
| dynamic / CPU | all CPU | 170 ms |
| tiled / CPU | all CPU | 249 ms |
| tiled / CoreML | 281 of 281 nodes, 1 partition | 32 ms |

Apple and mobile builds use the tiled export; CPU-only builds the dynamic
one. Both decode to identical detections.

**Input.** RGB, resized to width 720 (`unseen-core::model`), normalised with
the ImageNet mean and deviation and zero-padded to a multiple of 32. Each model file has a sidecar
`<model>.onnx.json` with its classes and calibrated thresholds (§6).

## 5. Training data

Not published. [model.md](model.md) lists the sources and their licences.
Generated identifiers are impossible to issue (unassigned ID regions,
Luhn-failing card numbers, reserved email domains).

## 6. Calibration and pre-selection

Per class `c`, pick threshold `λ_c` on a human-verified calibration set with
conformal risk control (Learn-then-Test / sequential risk control), so that

```
P( recall_c ≥ 1 − α ) ≥ 1 − δ        e.g. α = 0.02, δ = 0.05
```

- Score ≥ `λ_c` → box shown selected.
- Score in `[λ_c_low, λ_c)` → shown unselected, highlighted for review.
- Calibrated separately per domain (UI screenshot, photo, document); the
  guarantee only holds when the input matches the calibration distribution, and
  the UI says which domain was assumed.
- `λ` tables ship inside the model package and are versioned with the weights.

Implementation (`unseen calibrate`, `unseen-core::calibrate`): for each GT box,
`s*` is the highest threshold at which same-class detections still cover it
(≥ 90 % of its area), so a box is missed at `λ` exactly when `s* < λ`.
Candidates `λ ∈ {0.05, 0.06, …, 0.99}` are tested in ascending order with an
exact binomial test of `H0: miss rate ≥ α` and testing stops at the first
failure (fixed-sequence testing, FWER `δ` without correction). If no `λ`
passes, the class is marked not certified and takes the highest `λ` that
misses at most `α/10` of the calibration boxes more than `λ = 0.05` does: when
the misses are boxes the detector never finds, lowering the threshold only
adds false positives. Calibration records whether its data was human-verified;
until it is, the UI must not present the guarantee as real.

Review band: the lowest `λ_low < λ` whose band `[λ_low, λ)` holds at least 20
calibration detections, at least half of them lying (≥ 50 % of their area) on
a box of their class; without such a `λ_low` the class has no band. An
earlier rule tested the band at `α_review = 0.005`. That target cannot be
certified with a few thousand boxes, so every class fell to `λ_low = 0.05`.
On 298 private iPhone screenshots this showed 98 review boxes per
image (0.3.1). With the current rule it shows 0.3, and pre-selected boxes drop
from 41.7 to 30.9 per image (id_number from 10.6 to 0.01). How many of the
remaining 30.9 are correct is not known without labels.

Inputs whose EXIF names a camera make or model are camera photos, outside the
`ui_screenshot` domain; the CLI and the app say so.

## 7. Find-all propagation

The user taps one box; MosaicIt finds the same content elsewhere in the image, the
batch, or (M2) the video.

1. Candidates: all detector boxes plus a sliding-window search near the box's
   size.
2. Coarse filter: perceptual hash of the normalised crop.
3. Verify: cosine similarity of crop embeddings (SigLIP2, Apache-2.0, or the
   detector's own RoI features if good enough).

Identical strings render near-identically, so this works without reading them.

Implemented (`unseen-core::propagate`, `unseen find [--target]`, the app's "Find similar",
which searches every image of the opened batch):
NCC on grey levels in three passes — dense at query height 8 px, re-scored
near each peak at 32 px, then verified at full resolution on ≤ 1024 template
samples (downscaled planes sample the query and a match at different
sub-pixel phases, which costs several points of NCC on thin text). On 60
synthetic validation screenshots with repeated values: precision 1.000,
recall 0.995 over 252 queries, median 57 ms per query on an M-series CPU.
Same-string-different-size cases are left to the embedding step, which is
not built yet.

## 8. Redaction and export check

- Default is a solid fill. "Mosaic" and "blur" styles are drawn on top of a
  solid or random-noise fill and never use the original pixels, which defeats
  Depix-style and diffusion de-blurring attacks.
- Export strips EXIF/XMP/GPS and re-encodes the image.
- Before export, a self-check runs:
  - re-run the detector on the output; any surviving high-score box blocks export
    until the user confirms;
  - verify that no output pixel inside a box correlates with the source pixels;
  - (M2) in video, every track is covered on every frame, including the frames
    before the first and after the last detection.

Video (M5, `unseen-core::video`, `unseen video FRAMES OUT`): a frame is a
keyframe when any 8×8-pixel cell's mean grey level moved by more than 6 from
the last keyframe, or 30 frames after it; only keyframes are detected, so
between two keyframes the content equals the first one's and its boxes hold.
ByteTrack (`trackforge`, MIT) links keyframe detections into tracks (lost
tracks kept 5 keyframes); a keyframe where the detector missed a tracked
object gets a box interpolated between the observations around it.
Detections ByteTrack does not keep (score below its start threshold) become
single-observation tracks, so tracking never drops a box. The CLI runs the
export check on every keyframe and writes `timeline.json` (tracks with
per-keyframe observations). Synthetic scroll (60 frames, 720×1280, 404 px
scroll): 30 keyframes, 13 multi-keyframe tracks, 0.9 s with CoreML.
`unseen-media` decodes and encodes with the platform's codecs (no FFmpeg):
on Apple, AVAssetReader to 32BGRA (rotated upright from the track's
preferred transform) and AVAssetWriter to H.264 MP4 at the source
timestamps, via objc2 bindings. On Android, AMediaExtractor + AMediaCodec
with byte buffers in the layout the codec reports (MediaImage2 "image-data",
else I420/NV12 stride and slice height; `yuvutils-rs` converts), and
AMediaCodec + AMediaMuxer to H.264 MP4. Some decoders return frames in
decode order (seen on the emulator's software AVC decoder with B-frames),
so the reader takes the presentation order from the extractor's index and
reorders. Audio is dropped unless the user keeps it (`--keep-audio`, the
app's "Keep audio" switch): compressed samples are copied unchanged
(AVAssetReader pass-through into AVAssetWriter, interleaved by time;
AMediaExtractor into AMediaMuxer). Nothing checks audio for private
content. `unseen video` takes a video file (→ MP4 plus
`<out>.timeline.json`) or a frame directory. The app's video page scrubs
keyframe previews, toggles tracks and exports. A region the detector missed
can be drawn on any frame; `Timeline::add_manual` follows it keyframe by
keyframe in both directions with `find_similar` (NCC ≥ 0.85, nearest match to
the last position) until it is lost, which also follows scrolled content.

## 9. Inference backends

```rust
trait Detector { fn detect(&self, img: &Image, opts: &DetectOpts) -> Result<Vec<Det>>; }
trait Embedder { fn embed(&self, crops: &[Image]) -> Result<Vec<Vec<f32>>>; }
```

| Backend | Feature | Platforms |
|---|---|---|
| ort 2.0 (ORT 1.28) | `ort-coreml`, `ort-nnapi`, `ort-qnn`, `ort-xnnpack`, `ort-cuda`, `ort-directml` | all; EP chosen at runtime with `is_available()`, falling back to CPU. The app uses CoreML on Apple and NNAPI on Android (the only EP in ORT's prebuilt Android binaries); XNNPACK and QNN need ONNX Runtime built from source |
| tract | `tract` | all; pure-Rust CPU fallback, no native libs |
| remote | `remote` | any; HTTP to a self-hosted `unseen-server` |

The config value `platform` resolves per target;
missing model files fall back to the next backend.

License policy for shipped artifacts: Apache-2.0 / MIT / BSD / ISC / Zlib /
MPL-2.0 only, enforced with `cargo deny` (`deny.toml`) and
`license_checker` with `app/license_config.yaml` for Dart packages, both in CI. No
Ultralytics, no InsightFace weights, no GPL FFmpeg.
First-party exception: `fl_lib` (lollipopkit's own Flutter library, GPL-3.0,
theme and shared components; submodule `app/packages/fl_lib`) is approved by
name. GPL-3.0 may be combined with this AGPL-3.0 app (GPLv3 §13).

## 10. Milestones

| M | Scope |
|---|---|
| M0 | Repo, license, CLA, CI, design (this document) |
| M1 | Synthetic dataset v1, baseline detector, `unseen-cli detect/eval`, ort backend on macOS |
| M2 | Calibration, redaction + export check, Flutter app (macOS) with box editor |
| M3 | iOS + Android (CoreML / QNN / XNNPACK), find-all propagation |
| M4 | Real-screenshot labeling loop (two teachers + human), key–value relation module |
| M5 | Video: platform decoders, keyframe detection + ByteTrack, timeline editor |
| M6 | Global: 44 locales and their scripts in the training data; app UI in 38 languages |

## 11. Risks

- Recall for Chinese names and addresses outside forms (chat bodies). Measured
  per class from M1.
- CoreML / NNAPI graph partitioning. Mitigated by the export-safe operator rule.
- Synthetic-to-real gap. Mitigated by the real-screenshot loop and by never
  using synthetic numbers as release gates.

## 12. Decisions

- The key-value relation module (M4) is not used: as built it lowers
  person_name coverage by ~10 points. (2026-10-23)
- Offline dataset labeling may use a VLM that reads text (Qwen3-VL). The shipped
  product stays OCR-free. (2026-10-09)
- Minimum OS: iOS 17, Android 10 (API 29), macOS 14. (2026-10-09)
- Checkpoints are selected by mean coverage recall, then fewer detections per
  image; AP@0.5 saturates on synthetic validation data. (2026-10-22)
- Generated identifiers must be impossible to issue (unassigned ID regions,
  Luhn-failing cards, reserved email domains) instead of spec-valid; the
  detector reads glyphs, not checksums. (2026-10-23)
- Evaluation uses layouts that never appear in training, reported per
  template; a second held-out set, written without looking at model errors,
  decides whether a data change ships. (2026-10-24)

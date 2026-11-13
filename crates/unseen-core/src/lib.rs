//! Shared core: model metadata, pre/post-processing, redaction, and the
//! [`Backend`] trait that inference implementations plug into.

mod backend;
mod calibrate;
mod detect;
mod eval;
mod face;
mod manifest;
mod model;
mod propagate;
mod redact;
mod video;

pub use backend::{Backend, RawOutput};
pub use calibrate::{Calibration, Calibrator, ClassThreshold};
pub use detect::{Candidates, DetectOptions, Detection, Detector, Selection, Threshold, nms};
pub use eval::{ClassReport, CocoDataset, EvalOptions, EvalReport, Evaluator, GtImage};
pub use face::{FACE, FaceDetector};
pub use manifest::{FORMAT, Manifest, ModelEntry, PUBLIC_KEY, blake3_file, default_manifest, sign};
pub use model::{
    INPUT_WIDTH, ModelMeta, Preprocessed, UNCALIBRATED_REVIEW, UNCALIBRATED_SELECT, is_camera_photo, load_image,
    preprocess,
};
pub use propagate::{FindOptions, Match, find_similar};
pub use redact::{ExportCheck, Patch, RedactStyle, export_check, redact, redaction_patches};
pub use video::{KeyframeOptions, Keyframes, Observation, Timeline, Track, Tracker};

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("backend: {0}")]
    Backend(String),
    #[error("model output shape: {0}")]
    Shape(String),
    #[error("model metadata: {0}")]
    Meta(String),
    #[error("dataset: {0}")]
    Dataset(String),
    #[error("image: {0}")]
    Image(String),
}

pub type Result<T> = std::result::Result<T, Error>;

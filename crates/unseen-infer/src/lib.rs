//! Inference backends implementing [`unseen_core::Backend`].

#[cfg(feature = "ort")]
mod onnx;

#[cfg(feature = "ort")]
pub use onnx::{OrtBackend, OrtOptions, face_detector};

#[cfg(feature = "litert")]
mod litert;

#[cfg(feature = "litert")]
pub use litert::{
    LIBRARY as LITERT_LIBRARY, LiteRtBackend, LiteRtModel, LiteRtOptions, face_detector as litert_face_detector,
};

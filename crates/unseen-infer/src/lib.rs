//! Inference backends implementing [`unseen_core::Backend`].

#[cfg(feature = "ort")]
mod onnx;

#[cfg(feature = "ort")]
pub use onnx::{OrtBackend, OrtOptions, face_detector};

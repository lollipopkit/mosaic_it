use ndarray::{ArrayD, ArrayView4};

use crate::Result;

/// Raw graph outputs, in the graph's output order. For the region detector:
/// per stride (see [`crate::ModelMeta::strides`]) scores `[1, classes, h, w]`
/// after sigmoid, then raw box outputs `[1, 4, h, w]`.
pub struct RawOutput {
    pub outputs: Vec<ArrayD<f32>>,
}

/// An inference engine able to run an exported graph (the region detector,
/// the face detector).
///
/// Implementations live outside the core (ONNX Runtime, tract, a remote
/// server, a platform runtime) so the core carries no native dependency.
pub trait Backend: Send {
    /// Human-readable name, including the execution provider actually in use.
    fn name(&self) -> String;

    /// Runs the graph on a `[1, 3, height, width]` tensor.
    fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput>;
}

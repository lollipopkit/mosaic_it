use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};

use ndarray::ArrayView4;
use ort::{
    ep::{ExecutionProvider, ExecutionProviderDispatch},
    logging::LogLevel,
    session::Session,
    value::TensorRef,
};
use unseen_core::{Backend, Error, FaceDetector, RawOutput, Result, blake3_file};

/// ONNX Runtime backend. Tries the hardware execution providers compiled in,
/// in order, and falls back to CPU.
pub struct OrtBackend {
    session: Session,
    /// The graph's only input: `image` (region detector), `input` (YuNet).
    input: String,
    provider: String,
    placement: Vec<String>,
}

#[derive(Debug, Clone, Default)]
pub struct OrtOptions {
    /// Skip hardware execution providers.
    pub cpu_only: bool,
    /// Keep ONNX Runtime's node placement messages (see
    /// [`OrtBackend::placement`]). They are always collected when a hardware
    /// provider is tried, to detect a split graph.
    pub record_placement: bool,
    /// Where hardware providers keep compiled models between loads (CoreML
    /// compiles for ~20 s otherwise). One subdirectory per model file hash,
    /// since ONNX Runtime reuses a cache whose graph matches even when the
    /// weights differ; other models' subdirectories are removed.
    pub cache_dir: Option<PathBuf>,
}

/// YuNet face detector (opencv_zoo, MIT: `models/yunet/LICENSE`), the
/// dynamic-shape export.
const YUNET: &[u8] = include_bytes!("../models/yunet/face_detection_yunet_2026may.onnx");

/// The bundled face detector. It runs on the CPU: its input follows each
/// image's size, and hardware providers compile a model per input shape.
pub fn face_detector() -> Result<FaceDetector> {
    let (session, _) = commit(Model::Memory(YUNET), None, false)?;
    Ok(FaceDetector::new(Box::new(OrtBackend {
        input: input_name(&session),
        session,
        provider: "cpu".into(),
        placement: Vec::new(),
    })))
}

fn input_name(session: &Session) -> String {
    session
        .inputs()
        .first()
        .map(|i| i.name().to_string())
        .unwrap_or_default()
}

/// Where a graph is read from.
#[derive(Clone, Copy)]
enum Model<'a> {
    File(&'a Path),
    Memory(&'a [u8]),
}

fn err(e: impl std::fmt::Display) -> Error {
    Error::Backend(e.to_string())
}

impl OrtBackend {
    pub fn load(model: &Path) -> Result<Self> {
        Self::load_with(model, OrtOptions::default())
    }

    /// Loads with the first available hardware provider. If that provider
    /// leaves nodes on the CPU (a split graph, which pays a copy at every
    /// boundary and was slower than plain CPU in practice), loads again on the
    /// CPU alone and says so in [`Backend::name`].
    pub fn load_with(model: &Path, opts: OrtOptions) -> Result<Self> {
        let hw = if opts.cpu_only {
            None
        } else {
            hardware_providers(model_cache(model, opts.cache_dir.as_deref())?.as_deref())
                .into_iter()
                .find(|(_, ep)| ep.is_available().unwrap_or(false))
        };
        let Some((name, ep)) = hw else {
            let (session, placement) = commit(Model::File(model), None, opts.record_placement)?;
            return Ok(Self {
                input: input_name(&session),
                session,
                provider: "cpu".into(),
                placement,
            });
        };
        let (session, placement) = commit(Model::File(model), Some(ep.build()), true)?;
        if !placement.iter().any(|m| m.contains("placed on [CPUExecutionProvider]")) {
            return Ok(Self {
                input: input_name(&session),
                session,
                provider: name.into(),
                placement: if opts.record_placement { placement } else { Vec::new() },
            });
        }
        drop(session);
        let (session, mut cpu) = commit(Model::File(model), None, opts.record_placement)?;
        let mut all = placement;
        all.append(&mut cpu);
        Ok(Self {
            input: input_name(&session),
            session,
            provider: format!("cpu ({name} split the graph)"),
            placement: if opts.record_placement { all } else { Vec::new() },
        })
    }

    /// Placement messages recorded during load, if requested: which
    /// execution provider got how many nodes. More than one hardware
    /// partition, or nodes falling back to CPU, means the graph is split.
    pub fn placement(&self) -> &[String] {
        &self.placement
    }
}

/// Builds a session, optionally on `ep`, returning ONNX Runtime's node
/// placement messages when `record` is set.
fn commit(model: Model<'_>, ep: Option<ExecutionProviderDispatch>, record: bool) -> Result<(Session, Vec<String>)> {
    let mut builder = Session::builder().map_err(err)?;
    let placement = Arc::new(Mutex::new(Vec::new()));
    if record {
        let sink = Arc::clone(&placement);
        builder = builder
            .with_logger(Arc::new(move |_: LogLevel, _: &str, _: &str, _: &str, msg: &str| {
                // Node counts per provider, and hardware providers' own
                // partitioning summaries.
                if msg.contains("placed on [") || msg.contains("GetCapability") {
                    sink.lock()
                        .unwrap_or_else(|e| e.into_inner())
                        .push(msg.trim().to_string());
                }
            }))
            .map_err(err)?
            .with_log_level(LogLevel::Verbose)
            .map_err(err)?;
    }
    if let Some(ep) = ep {
        builder = builder.with_execution_providers([ep]).map_err(err)?;
    }
    let session = match model {
        Model::File(p) => builder.commit_from_file(p),
        Model::Memory(b) => builder.commit_from_memory(b),
    }
    .map_err(err)?;
    let placement = std::mem::take(&mut *placement.lock().unwrap_or_else(|e| e.into_inner()));
    Ok((session, placement))
}

/// `root/coreml-<blake3 of model>`, created, with other models' caches
/// under `root` removed.
fn model_cache(model: &Path, root: Option<&Path>) -> Result<Option<PathBuf>> {
    let Some(root) = root else { return Ok(None) };
    let name = format!("coreml-{}", blake3_file(model)?);
    if let Ok(entries) = std::fs::read_dir(root) {
        for e in entries.flatten() {
            let n = e.file_name();
            if n.to_string_lossy().starts_with("coreml-") && n != name.as_str() {
                // A failed removal only costs disk space.
                let _ = std::fs::remove_dir_all(e.path());
            }
        }
    }
    let dir = root.join(name);
    std::fs::create_dir_all(&dir).map_err(|e| err(format!("{}: {e}", dir.display())))?;
    Ok(Some(dir))
}

/// Hardware execution providers compiled in, in order of preference.
// Each push is behind its own feature, so neither lint applies.
#[allow(unused_mut, unused_variables, clippy::vec_init_then_push)]
fn hardware_providers(cache: Option<&Path>) -> Vec<(&'static str, Box<dyn Provider>)> {
    let mut v: Vec<(&'static str, Box<dyn Provider>)> = Vec::new();
    #[cfg(feature = "coreml")]
    // MLProgram (iOS 15 / macOS 12) runs MatMul with two dynamic inputs (the
    // relation module's attention); the older NeuralNetwork format does not.
    v.push(("coreml", {
        let ep = ort::ep::CoreML::default().with_model_format(ort::ep::coreml::ModelFormat::MLProgram);
        Box::new(match cache {
            Some(d) => ep.with_model_cache_dir(d.display()),
            None => ep,
        })
    }));
    #[cfg(feature = "cuda")]
    v.push(("cuda", Box::new(ort::ep::CUDA::default())));
    #[cfg(feature = "directml")]
    v.push(("directml", Box::new(ort::ep::DirectML::default())));
    #[cfg(feature = "qnn")]
    v.push(("qnn", Box::new(ort::ep::QNN::default())));
    #[cfg(feature = "nnapi")]
    v.push(("nnapi", Box::new(ort::ep::NNAPI::default())));
    #[cfg(feature = "xnnpack")]
    v.push(("xnnpack", Box::new(ort::ep::XNNPACK::default())));
    v
}

/// Object-safe view of an execution provider.
trait Provider {
    fn is_available(&self) -> ort::Result<bool>;
    fn build(&self) -> ExecutionProviderDispatch;
}

impl<T: ExecutionProvider + Clone + Into<ExecutionProviderDispatch>> Provider for T {
    fn is_available(&self) -> ort::Result<bool> {
        ExecutionProvider::is_available(self)
    }
    fn build(&self) -> ExecutionProviderDispatch {
        self.clone().into()
    }
}

impl Backend for OrtBackend {
    fn name(&self) -> String {
        format!("onnxruntime/{}", self.provider)
    }

    fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
        let input = TensorRef::from_array_view(input).map_err(err)?;
        let outputs = self
            .session
            .run(ort::inputs![self.input.as_str() => input])
            .map_err(err)?;
        let outputs = outputs
            .iter()
            .map(|(name, v)| {
                v.try_extract_array::<f32>()
                    .map(|a| a.to_owned())
                    .map_err(|e| Error::Shape(format!("{name}: {e}")))
            })
            .collect::<Result<_>>()?;
        Ok(RawOutput { outputs })
    }
}

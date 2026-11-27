use std::collections::BTreeMap;
use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};

use ndarray::ArrayView4;
use ort::{
    environment::Environment,
    ep::{ExecutionProvider, ExecutionProviderDispatch},
    logging::LogLevel,
    session::Session,
    value::TensorRef,
};
#[cfg(feature = "coreml")]
use unseen_core::blake3_file;
use unseen_core::{Backend, Error, FaceDetector, RawOutput, Result};

/// ONNX Runtime backend. Tries the hardware execution providers compiled in,
/// in order, and falls back to CPU.
pub struct OrtBackend {
    /// Runs every input when `per_shape` is `None`; with `PerShape`, lazily
    /// built only if a shape falls back to CPU (avoids holding a full idle
    /// CPU copy of the weights in memory).
    session: Option<Session>,
    /// The graph's only input: `image` (region detector), `input` (YuNet).
    input: String,
    provider: String,
    placement: Vec<String>,
    per_shape: Option<PerShape>,
}

/// A dynamic graph on a hardware provider, which compiles for fixed shapes:
/// keeps at most one active hardware session in memory (the most recently used
/// shape) to bound iOS `phys_footprint`; switching shapes reloads from the
/// on-disk compile cache.
struct PerShape {
    model: PathBuf,
    provider: &'static str,
    /// The model's cache directory; each shape gets a subdirectory.
    cache: Option<PathBuf>,
    /// Name of each input axis's free dimension, `None` where fixed.
    symbols: Vec<Option<String>>,
    record: bool,
    /// Currently resident hardware session, if any.
    active: Option<(Vec<usize>, Session)>,
    /// Shapes that fell back to CPU and why, so they are not re-attempted.
    cpu_shapes: BTreeMap<Vec<usize>, String>,
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
    /// Compile a dynamic graph for each input shape it runs on, for a model
    /// that runs on a few fixed shapes (`Resolution::Pt2`). Without it a
    /// hardware provider gets the dynamic graph as it is.
    pub per_shape: bool,
}

/// YuNet face detector (opencv_zoo, MIT: `models/yunet/LICENSE`), the
/// dynamic-shape export.
const YUNET: &[u8] = include_bytes!("../models/yunet/face_detection_yunet_2026may.onnx");

/// The bundled face detector. It runs on the CPU: its input follows each
/// image's size, and hardware providers compile a model per input shape.
pub fn face_detector() -> Result<FaceDetector> {
    let (session, _) = commit(Model::Memory(YUNET), None, false, &[])?;
    Ok(FaceDetector::new(Box::new(OrtBackend::cpu(
        session,
        "cpu".into(),
        Vec::new(),
    ))))
}

fn input_name(session: &Session) -> String {
    session
        .inputs()
        .first()
        .map(|i| i.name().to_string())
        .unwrap_or_default()
}

/// The free dimension names of the session's input, per axis.
fn input_symbols(session: &Session) -> Vec<Option<String>> {
    match session.inputs().first().map(|i| i.dtype()) {
        Some(ort::value::ValueType::Tensor {
            shape,
            dimension_symbols,
            ..
        }) => shape
            .iter()
            .zip(dimension_symbols.iter())
            .map(|(&n, s)| (n < 0 && !s.is_empty()).then(|| s.to_string()))
            .collect(),
        _ => Vec::new(),
    }
}

/// A session on hardware provider `ep` that keeps every node, or why not
/// (with the placement messages that tell).
fn on_hardware(
    model: &Path,
    name: &str,
    ep: ExecutionProviderDispatch,
    dims: &[(String, i64)],
) -> std::result::Result<(Session, Vec<String>), (String, Vec<String>)> {
    match commit(Model::File(model), Some(ep), true, dims) {
        Ok((session, placement)) if !placement.iter().any(|m| m.contains("placed on [CPUExecutionProvider]")) => {
            Ok((session, placement))
        }
        Ok((_, placement)) => Err((format!("{name} split the graph"), placement)),
        Err(e) => Err((format!("{name} unavailable"), vec![format!("{name} failed: {e}")])),
    }
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
    /// fails to build a session or leaves nodes on the CPU (a split graph,
    /// which pays a copy at every boundary and was slower than plain CPU in
    /// practice), loads again on the CPU alone and says so in
    /// [`Backend::name`].
    pub fn load_with(model: &Path, opts: OrtOptions) -> Result<Self> {
        let hw = if opts.cpu_only {
            None
        } else {
            #[cfg(feature = "coreml")]
            let cache = model_cache(model, opts.cache_dir.as_deref())?;
            #[cfg(not(feature = "coreml"))]
            let cache: Option<PathBuf> = None;
            hardware_providers(cache.as_deref())
                .into_iter()
                .find(|(_, ep)| ep.is_available().unwrap_or(false))
                .map(|(name, ep)| (name, ep, cache))
        };
        let Some((name, ep, cache)) = hw else {
            let (session, placement) = commit(Model::File(model), None, opts.record_placement, &[])?;
            return Ok(Self::cpu(session, "cpu".into(), placement));
        };
        if opts.per_shape {
            let (probe, placement) = commit(Model::File(model), None, opts.record_placement, &[])?;
            let symbols = input_symbols(&probe);
            if symbols.iter().any(Option::is_some) {
                let input = input_name(&probe);
                drop(probe);
                return Ok(Self {
                    session: None,
                    input,
                    provider: name.into(),
                    placement,
                    per_shape: Some(PerShape {
                        model: model.to_path_buf(),
                        provider: name,
                        cache,
                        symbols,
                        record: opts.record_placement,
                        active: None,
                        cpu_shapes: BTreeMap::new(),
                    }),
                });
            }
        }
        let keep = |p: Vec<String>| if opts.record_placement { p } else { Vec::new() };
        let (reason, mut prefix) = match on_hardware(model, name, ep.build(), &[]) {
            Ok((session, placement)) => return Ok(Self::cpu(session, name.into(), keep(placement))),
            Err(e) => e,
        };
        let (session, mut cpu) = commit(Model::File(model), None, opts.record_placement, &[])?;
        prefix.append(&mut cpu);
        Ok(Self::cpu(session, format!("cpu ({reason})"), keep(prefix)))
    }

    fn cpu(session: Session, provider: String, placement: Vec<String>) -> Self {
        Self {
            input: input_name(&session),
            session: Some(session),
            provider,
            placement,
            per_shape: None,
        }
    }

    /// Placement messages recorded during load, if requested: which
    /// execution provider got how many nodes. More than one hardware
    /// partition, or nodes falling back to CPU, means the graph is split.
    pub fn placement(&self) -> &[String] {
        &self.placement
    }
}

/// Process-wide ONNX Runtime environment, kept alive so sessions can be created
/// repeatedly without triggering `ort`'s single-environment restriction.
static ORT_ENV: Mutex<Option<Environment>> = Mutex::new(None);

fn ort_env() -> Result<Environment> {
    let mut guard = ORT_ENV.lock().unwrap_or_else(|e| e.into_inner());
    if let Some(env) = guard.as_ref() {
        return Ok(env.clone());
    }
    let env = ort::init().with_telemetry(false).build().map_err(err)?;
    *guard = Some(env.clone());
    Ok(env)
}

/// Builds a session, optionally on `ep` and with free dimensions fixed to
/// `dims`, returning ONNX Runtime's node placement messages when `record`
/// is set.
fn commit(
    model: Model<'_>,
    ep: Option<ExecutionProviderDispatch>,
    record: bool,
    dims: &[(String, i64)],
) -> Result<(Session, Vec<String>)> {
    let env = ort_env()?;
    let mut builder = Session::builder(&env).map_err(err)?;
    for (name, n) in dims {
        builder = builder.with_dimension_override(name, *n).map_err(err)?;
    }
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
    match ep {
        Some(ep) => builder = builder.with_execution_providers([ep]).map_err(err)?,
        #[cfg(target_os = "android")]
        None => {
            if let Ok(n) = std::thread::available_parallelism() {
                builder = builder.with_intra_threads(n.get()).map_err(err)?;
            }
        }
        #[cfg(not(target_os = "android"))]
        None => {}
    }
    let session = match model {
        Model::File(p) => builder.commit_from_file(p),
        Model::Memory(b) => builder.commit_from_memory(b),
    }
    .map_err(err)?;
    let placement = std::mem::take(&mut *placement.lock().unwrap_or_else(|e| e.into_inner()));
    Ok((session, placement))
}

/// `root/coreml-mlprogram-v1-<blake3 of model>`, created, with older or other
/// models' `coreml-*` caches under `root` removed.
#[cfg(feature = "coreml")]
fn model_cache(model: &Path, root: Option<&Path>) -> Result<Option<PathBuf>> {
    let Some(root) = root else { return Ok(None) };
    let name = format!("coreml-mlprogram-v1-{}", blake3_file(model)?);
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
        let ep = ort::ep::CoreML::default()
            .with_model_format(ort::ep::coreml::ModelFormat::MLProgram)
            .with_static_input_shapes(true);
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
        T::is_available()
    }
    fn build(&self) -> ExecutionProviderDispatch {
        self.clone().into()
    }
}

impl PerShape {
    /// The hardware session for `shape`, built on first use (evicting any
    /// previous shape to keep memory bounded); `None` when the shape runs on
    /// the CPU.
    fn session(&mut self, shape: &[usize], placement: &mut Vec<String>) -> Result<Option<&mut Session>> {
        if self.cpu_shapes.contains_key(shape) {
            return Ok(None);
        }
        if self.active.as_ref().is_none_or(|(s, _)| s.as_slice() != shape) {
            // Release the previous hardware session before compiling/loading
            // the new one so peak memory stays at one session.
            self.active = None;
            let dims: Vec<(String, i64)> = self
                .symbols
                .iter()
                .zip(shape)
                .filter_map(|(s, &n)| s.clone().map(|s| (s, n as i64)))
                .collect();
            let cache = match &self.cache {
                Some(c) => {
                    let d = c.join(shape.iter().map(usize::to_string).collect::<Vec<_>>().join("x"));
                    std::fs::create_dir_all(&d).map_err(|e| err(format!("{}: {e}", d.display())))?;
                    Some(d)
                }
                None => None,
            };
            let (_, ep) = hardware_providers(cache.as_deref())
                .into_iter()
                .find(|(n, _)| *n == self.provider)
                .expect("the provider chosen at load");
            let mut msgs = match on_hardware(&self.model, self.provider, ep.build(), &dims) {
                Ok((s, m)) => {
                    self.active = Some((shape.to_vec(), s));
                    m
                }
                Err((reason, m)) => {
                    self.cpu_shapes.insert(shape.to_vec(), reason);
                    m
                }
            };
            if self.record {
                placement.push(format!("input {shape:?}:"));
                placement.append(&mut msgs);
            }
        }
        Ok(self.active.as_mut().map(|(_, s)| s))
    }
}

impl Backend for OrtBackend {
    fn name(&self) -> String {
        let Some(p) = &self.per_shape else {
            return format!("onnxruntime/{}", self.provider);
        };
        // Shapes on the CPU, and why.
        let cpu: Vec<String> = p
            .cpu_shapes
            .iter()
            .map(|(shape, r)| format!("{shape:?}: {r}"))
            .collect();
        if cpu.is_empty() {
            format!("onnxruntime/{}", self.provider)
        } else {
            format!("onnxruntime/{} (cpu for {})", self.provider, cpu.join(", "))
        }
    }

    fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
        let hw = match &mut self.per_shape {
            Some(p) => p.session(input.shape(), &mut self.placement)?,
            None => None,
        };
        let session = match hw {
            Some(s) => s,
            None => {
                if self.session.is_none() {
                    let p = self.per_shape.as_ref().expect("per_shape present when session is None");
                    let (s, mut msgs) = commit(Model::File(&p.model), None, p.record, &[])?;
                    if p.record {
                        self.placement.append(&mut msgs);
                    }
                    self.session = Some(s);
                }
                self.session.as_mut().expect("session initialized above")
            }
        };
        let input = TensorRef::from_array_view(input).map_err(err)?;
        let outputs = session.run(ort::inputs![self.input.as_str() => input]).map_err(err)?;
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

#[cfg(all(test, feature = "coreml"))]
mod tests {
    use super::*;

    #[test]
    fn model_cache_uses_versioned_prefix_and_prunes_old_entries() {
        let root = std::env::temp_dir().join(format!("unseen-coreml-cache-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&root);
        std::fs::create_dir_all(&root).unwrap();

        let model = root.join("model.onnx");
        std::fs::write(&model, b"dummy onnx bytes").unwrap();
        let stale = root.join("coreml-legacy-entry");
        let keep_other = root.join("other-dir");
        std::fs::create_dir_all(&stale).unwrap();
        std::fs::create_dir_all(&keep_other).unwrap();

        let dir = model_cache(&model, Some(&root)).unwrap().unwrap();
        let expected_prefix = format!("coreml-mlprogram-v1-{}", blake3_file(&model).unwrap());
        assert_eq!(dir.file_name().unwrap().to_string_lossy(), expected_prefix);
        assert!(dir.is_dir());
        assert!(!stale.exists());
        assert!(keep_other.is_dir());

        let _ = std::fs::remove_dir_all(&root);
    }
}

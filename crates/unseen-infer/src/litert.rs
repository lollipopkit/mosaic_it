//! LiteRT (CompiledModel API) backend for `.tflite` models with one
//! signature per input shape, or a single signature (resized per input). Runs on the GPU accelerator when it takes the whole
//! graph, else on the CPU. `libLiteRt` is loaded at run time (the
//! Android app bundles it from the `com.google.ai.edge.litert` AARs), so
//! nothing links against it. Declarations follow LiteRT 2.3.2 `litert/c`.

use std::ffi::{CStr, CString, c_char, c_int, c_void};
use std::path::{Path, PathBuf};
use std::sync::mpsc;
use std::thread::JoinHandle;

use libloading::Library;
use ndarray::{Array4, ArrayD, ArrayView4, IxDyn};
use unseen_core::{Backend, Error, FaceDetector, RawOutput, Result};

type Status = c_int;
type Handle = *mut c_void;

const OK: Status = 0;
const F32: c_int = 1;
const CPU: c_int = 1;
const GPU: c_int = 1 << 1;
const LOCK_READ: c_int = 0;
const LOCK_WRITE: c_int = 1;
const MAX_RANK: usize = 8;
const ANY_STRING: c_int = 8;
const OPTION_COMPILER_CACHE_DIR: c_int = 18;
const OPTION_RUNTIME_LIBRARY_DIR: c_int = 22;

/// `LiteRtEnvOption` holding a string `LiteRtAny`.
#[repr(C)]
struct EnvOption {
    tag: c_int,
    any_type: c_int,
    value: *const c_char,
}

/// `LiteRtLayout`: `rank : 7` and `has_strides : 1` share the first `u32`.
#[repr(C)]
#[derive(Clone, Copy)]
struct Layout {
    bits: u32,
    dimensions: [i32; MAX_RANK],
    strides: [u32; MAX_RANK],
}

/// `LiteRtRankedTensorType`.
#[repr(C)]
#[derive(Clone, Copy)]
struct RankedType {
    element_type: c_int,
    layout: Layout,
}

impl Layout {
    fn dims(&self) -> &[i32] {
        &self.dimensions[..((self.bits & 0x7f) as usize).min(MAX_RANK)]
    }

    fn new(dims: &[usize]) -> Self {
        let mut dimensions = [0; MAX_RANK];
        for (d, &n) in dimensions.iter_mut().zip(dims) {
            *d = n as i32;
        }
        Self {
            bits: dims.len() as u32,
            dimensions,
            strides: [0; MAX_RANK],
        }
    }
}

macro_rules! api {
    ($($name:ident = $sym:literal : fn($($arg:ty),*) $(-> $ret:ty)?;)*) => {
        /// The C functions used, resolved from the library.
        struct Api {
            $($name: unsafe extern "C" fn($($arg),*) $(-> $ret)?,)*
            _lib: Library,
        }

        impl Api {
            fn load(path: &Path) -> Result<Self> {
                // SAFETY: loading LiteRT runs no initialisers with preconditions.
                let lib = unsafe { Library::new(path) }.map_err(|e| err(format!("{}: {e}", path.display())))?;
                // SAFETY: each symbol has the C signature declared here (litert/c 2.3.2).
                unsafe {
                    Ok(Self {
                        $($name: *lib.get(concat!($sym, "\0").as_bytes()).map_err(|e| err(format!("{}: {e}", $sym)))?,)*
                        _lib: lib,
                    })
                }
            }
        }
    };
}

api! {
    status_string = "LiteRtGetStatusString": fn(Status) -> *const c_char;
    create_environment = "LiteRtCreateEnvironment": fn(c_int, *const EnvOption, *mut Handle) -> Status;
    destroy_environment = "LiteRtDestroyEnvironment": fn(Handle);
    create_model = "LiteRtCreateModelFromFile": fn(Handle, *const c_char, *mut Handle) -> Status;
    create_model_from_buffer = "LiteRtCreateModelFromBuffer": fn(Handle, *const c_void, usize, *mut Handle) -> Status;
    destroy_model = "LiteRtDestroyModel": fn(Handle);
    num_signatures = "LiteRtGetNumModelSignatures": fn(Handle, *mut usize) -> Status;
    signature = "LiteRtGetModelSignature": fn(Handle, usize, *mut Handle) -> Status;
    signature_key = "LiteRtGetSignatureKey": fn(Handle, *mut *const c_char) -> Status;
    num_inputs = "LiteRtGetNumSignatureInputs": fn(Handle, *mut usize) -> Status;
    num_outputs = "LiteRtGetNumSignatureOutputs": fn(Handle, *mut usize) -> Status;
    input_tensor = "LiteRtGetSignatureInputTensorByIndex": fn(Handle, usize, *mut Handle) -> Status;
    output_tensor = "LiteRtGetSignatureOutputTensorByIndex": fn(Handle, usize, *mut Handle) -> Status;
    ranked_type = "LiteRtGetRankedTensorType": fn(Handle, *mut RankedType) -> Status;
    create_options = "LiteRtCreateOptions": fn(*mut Handle) -> Status;
    destroy_options = "LiteRtDestroyOptions": fn(Handle);
    set_accelerators = "LiteRtSetOptionsHardwareAccelerators": fn(Handle, c_int) -> Status;
    create_opaque_options = "LiteRtCreateOpaqueOptions": fn(*const c_char, *mut c_void, Option<unsafe extern "C" fn(*mut c_void)>, *mut Handle) -> Status;
    add_opaque_options = "LiteRtAddOpaqueOptions": fn(Handle, Handle) -> Status;
    destroy_opaque_options = "LiteRtDestroyOpaqueOptions": fn(Handle);
    create_compiled = "LiteRtCreateCompiledModel": fn(Handle, Handle, Handle, *mut Handle) -> Status;
    destroy_compiled = "LiteRtDestroyCompiledModel": fn(Handle);
    fully_accelerated = "LiteRtCompiledModelIsFullyAccelerated": fn(Handle, *mut bool) -> Status;
    input_requirements = "LiteRtGetCompiledModelInputBufferRequirements": fn(Handle, usize, usize, *mut Handle) -> Status;
    output_requirements = "LiteRtGetCompiledModelOutputBufferRequirements": fn(Handle, usize, usize, *mut Handle) -> Status;
    create_buffer = "LiteRtCreateManagedTensorBufferFromRequirements": fn(Handle, *const RankedType, Handle, *mut Handle) -> Status;
    destroy_buffer = "LiteRtDestroyTensorBuffer": fn(Handle);
    buffer_size = "LiteRtGetTensorBufferSize": fn(Handle, *mut usize) -> Status;
    lock = "LiteRtLockTensorBuffer": fn(Handle, *mut *mut c_void, c_int) -> Status;
    unlock = "LiteRtUnlockTensorBuffer": fn(Handle) -> Status;
    run = "LiteRtRunCompiledModel": fn(Handle, usize, usize, *mut Handle, usize, *mut Handle) -> Status;
    resize_input = "LiteRtCompiledModelResizeInputTensorNonStrict": fn(Handle, usize, usize, *const c_int, usize) -> Status;
    output_layouts = "LiteRtGetCompiledModelOutputTensorLayouts": fn(Handle, usize, usize, *mut Layout, bool) -> Status;
}

/// Frees a payload made with `CString::into_raw`.
unsafe extern "C" fn free_c_string(p: *mut c_void) {
    // SAFETY: only ever given the pointer `cpu_options` leaked.
    drop(unsafe { CString::from_raw(p.cast()) });
}

fn err(e: impl std::fmt::Display) -> Error {
    Error::Backend(format!("litert: {e}"))
}

impl Api {
    fn check(&self, what: &str, s: Status) -> Result<()> {
        if s == OK {
            return Ok(());
        }
        // SAFETY: returns a static string for any status.
        let msg = unsafe { CStr::from_ptr((self.status_string)(s)) }.to_string_lossy();
        Err(err(format!("{what}: {msg} ({s})")))
    }
}

/// One signature: its tensor types (dimensions below 0 are dynamic) and
/// the buffers of the input shape it last ran on.
struct Signature {
    index: usize,
    key: String,
    input: RankedType,
    outputs: Vec<RankedType>,
    /// Input shape the buffers are for.
    shape: Option<Vec<usize>>,
    /// Input shape the compiled model holds (declared until resized).
    held: Vec<usize>,
    buffers: Vec<Handle>,
}

impl Signature {
    /// The input shape as declared, dynamic dimensions as 1 (LiteRT's own
    /// placeholder for them).
    fn declared(&self) -> Vec<usize> {
        self.input.layout.dims().iter().map(|&d| d.max(1) as usize).collect()
    }
}

#[derive(Debug, Clone)]
pub struct LiteRtOptions {
    /// `libLiteRt`; its directory is where LiteRT looks for accelerators.
    pub library: PathBuf,
    /// Skip the GPU.
    pub cpu_only: bool,
    /// Where LiteRT keeps compiled programs between loads.
    pub cache_dir: Option<PathBuf>,
    /// The model has one signature, converted with dynamic height and width
    /// (LiteRT may still declare them as 1), and takes inputs of any size by
    /// resizing it. Otherwise each input must match a signature's shape.
    pub resize: bool,
}

impl Default for LiteRtOptions {
    fn default() -> Self {
        Self {
            library: LIBRARY.into(),
            cpu_only: false,
            cache_dir: None,
            resize: false,
        }
    }
}

/// Where a model is read from.
#[derive(Clone)]
pub enum LiteRtModel {
    File(PathBuf),
    /// Bundled bytes, which LiteRT reads in place.
    Static(&'static [u8]),
}

/// A `.tflite` model compiled for one accelerator. Its handles stay on the
/// thread that made them ([`LiteRtBackend`]'s worker).
struct Compiled {
    api: Api,
    env: Handle,
    model: Handle,
    compiled: Handle,
    signatures: Vec<Signature>,
    provider: String,
    resize: bool,
}

/// `libLiteRt` for this platform, found by the dynamic loader.
pub const LIBRARY: &str = if cfg!(target_vendor = "apple") {
    "libLiteRt.dylib"
} else {
    "libLiteRt.so"
};

impl Compiled {
    /// Loads `model` on the GPU when it takes every op, else on the CPU (said
    /// in [`Backend::name`]).
    fn load(model: &LiteRtModel, opts: &LiteRtOptions) -> Result<Self> {
        let api = Api::load(&opts.library)?;
        let c = |p: &Path| CString::new(p.as_os_str().as_encoded_bytes()).map_err(err);
        let lib_dir = opts
            .library
            .parent()
            .filter(|d| !d.as_os_str().is_empty())
            .map(c)
            .transpose()?;
        let cache = opts.cache_dir.as_deref().map(c).transpose()?;
        let env_opts: Vec<EnvOption> = [
            (OPTION_RUNTIME_LIBRARY_DIR, &lib_dir),
            (OPTION_COMPILER_CACHE_DIR, &cache),
        ]
        .into_iter()
        .filter_map(|(tag, v)| {
            v.as_ref().map(|v| EnvOption {
                tag,
                any_type: ANY_STRING,
                value: v.as_ptr(),
            })
        })
        .collect();
        let mut env = std::ptr::null_mut();
        // SAFETY: the option strings outlive the call; `env` receives an owned handle.
        api.check("environment", unsafe {
            (api.create_environment)(env_opts.len() as c_int, env_opts.as_ptr(), &mut env)
        })?;
        let mut b = Self {
            api,
            env,
            model: std::ptr::null_mut(),
            compiled: std::ptr::null_mut(),
            signatures: Vec::new(),
            provider: String::new(),
            resize: opts.resize,
        };
        // SAFETY: `b.model` receives an owned handle; a static buffer outlives it.
        b.api.check("model", unsafe {
            match model {
                LiteRtModel::File(path) => {
                    let path = c(path)?;
                    (b.api.create_model)(b.env, path.as_ptr(), &mut b.model)
                }
                LiteRtModel::Static(bytes) => {
                    (b.api.create_model_from_buffer)(b.env, bytes.as_ptr().cast(), bytes.len(), &mut b.model)
                }
            }
        })?;
        b.provider = if opts.cpu_only {
            b.compile(CPU)?;
            "cpu".into()
        } else {
            match b.compile(GPU).and_then(|()| b.fully_accelerated()) {
                Ok(true) => "gpu".into(),
                Ok(false) => {
                    b.release_compiled();
                    b.compile(CPU)?;
                    "cpu (gpu left ops on the cpu)".into()
                }
                Err(e) => {
                    b.release_compiled();
                    b.compile(CPU)?;
                    format!("cpu (gpu unavailable: {e})")
                }
            }
        };
        b.read_signatures()?;
        if b.resize {
            if b.signatures.len() != 1 {
                return Err(err(format!("{} signatures, resizing needs one", b.signatures.len())));
            }
        } else {
            for i in 0..b.signatures.len() {
                let shape = b.signatures[i].declared();
                b.allocate(i, &shape)?;
            }
        }
        Ok(b)
    }

    fn compile(&mut self, accelerators: c_int) -> Result<()> {
        let a = &self.api;
        let mut opts = std::ptr::null_mut();
        // SAFETY: `opts` receives an owned handle, destroyed below.
        a.check("options", unsafe { (a.create_options)(&mut opts) })?;
        // SAFETY: valid handles; the options stay the caller's.
        let r = a
            .check("accelerators", unsafe { (a.set_accelerators)(opts, accelerators) })
            .and_then(|()| {
                // Without them XNNPACK keeps its default threads.
                let _ = self.cpu_options(opts);
                let mut compiled = std::ptr::null_mut();
                a.check("compile", unsafe {
                    (a.create_compiled)(self.env, self.model, opts, &mut compiled)
                })
                .map(|()| compiled)
            });
        // SAFETY: created above.
        unsafe { (a.destroy_options)(opts) };
        self.compiled = r?;
        Ok(())
    }

    /// XNNPACK on every core (`litert_cpu_options`: identifier `xnnpack`, a
    /// TOML payload); its default left the CPU slower than ONNX Runtime. All
    /// cores beat the big ones alone (Pixel 8a, v17: 9 threads 2.3 s, 5 threads
    /// 2.4 s, 4 threads 3.1 s).
    fn cpu_options(&self, opts: Handle) -> Result<()> {
        let threads = std::thread::available_parallelism().map_or(4, |n| n.get());
        let payload = CString::new(format!("num_threads = {threads}\n"))
            .map_err(err)?
            .into_raw();
        let mut opaque = std::ptr::null_mut();
        // SAFETY: the opaque options own `payload` (freed by `free_c_string`)
        // once created, and `opts` owns them once added.
        unsafe {
            let made =
                (self.api.create_opaque_options)(c"xnnpack".as_ptr(), payload.cast(), Some(free_c_string), &mut opaque);
            if made != OK {
                drop(CString::from_raw(payload));
            }
            self.api.check("cpu options", made)?;
            let added = (self.api.add_opaque_options)(opts, opaque);
            if added != OK {
                (self.api.destroy_opaque_options)(opaque);
            }
            self.api.check("cpu options", added)
        }
    }

    fn fully_accelerated(&self) -> Result<bool> {
        let mut full = false;
        // SAFETY: valid compiled model.
        self.api.check("placement", unsafe {
            (self.api.fully_accelerated)(self.compiled, &mut full)
        })?;
        Ok(full)
    }

    /// Every signature's key and tensor types.
    fn read_signatures(&mut self) -> Result<()> {
        let a = &self.api;
        let mut n = 0;
        // SAFETY: valid model handle throughout; out-parameters are locals and
        // the key is owned by the model.
        unsafe {
            a.check("signatures", (a.num_signatures)(self.model, &mut n))?;
            for index in 0..n {
                let (mut sig, mut key) = (std::ptr::null_mut(), std::ptr::null());
                a.check("signature", (a.signature)(self.model, index, &mut sig))?;
                a.check("signature key", (a.signature_key)(sig, &mut key))?;
                let (mut ni, mut no) = (0, 0);
                a.check("inputs", (a.num_inputs)(sig, &mut ni))?;
                a.check("outputs", (a.num_outputs)(sig, &mut no))?;
                if ni != 1 {
                    return Err(err(format!("signature {index}: {ni} inputs, expected 1")));
                }
                let ty =
                    |get: unsafe extern "C" fn(Handle, usize, *mut Handle) -> Status, k: usize| -> Result<RankedType> {
                        let mut t = std::ptr::null_mut();
                        let mut ty: RankedType = std::mem::zeroed();
                        a.check("tensor", get(sig, k, &mut t))?;
                        a.check("tensor type", (a.ranked_type)(t, &mut ty))?;
                        if ty.element_type != F32 {
                            return Err(err(format!(
                                "signature {index}: element type {} is not float32",
                                ty.element_type
                            )));
                        }
                        Ok(ty)
                    };
                self.signatures.push(Signature {
                    index,
                    key: CStr::from_ptr(key).to_string_lossy().into_owned(),
                    input: ty(a.input_tensor, 0)?,
                    outputs: (0..no).map(|k| ty(a.output_tensor, k)).collect::<Result<_>>()?,
                    shape: None,
                    held: Vec::new(),
                    buffers: Vec::new(),
                });
                let s = self.signatures.last_mut().expect("pushed");
                s.held = s.declared();
            }
        }
        Ok(())
    }

    /// Buffers of signature `i` for inputs of `shape`, as the compiled model
    /// requires them; the compiled model is resized to `shape` first unless
    /// it holds that shape.
    fn allocate(&mut self, i: usize, shape: &[usize]) -> Result<()> {
        let a = &self.api;
        let s = &mut self.signatures[i];
        // SAFETY: valid handles; each buffer is owned and destroyed once.
        unsafe {
            for b in s.buffers.drain(..) {
                (a.destroy_buffer)(b);
            }
            s.shape = None;
            let mut outputs = s.outputs.iter().map(|t| t.layout).collect::<Vec<_>>();
            if shape != s.held {
                // Unknown until both calls succeed: the next run resizes again.
                s.held.clear();
                let dims = shape.iter().map(|&n| n as c_int).collect::<Vec<_>>();
                a.check(
                    "resize",
                    (a.resize_input)(self.compiled, s.index, 0, dims.as_ptr(), dims.len()),
                )?;
                a.check(
                    "output layouts",
                    (a.output_layouts)(self.compiled, s.index, outputs.len(), outputs.as_mut_ptr(), true),
                )?;
                s.held = shape.to_vec();
            }
            let input = RankedType {
                element_type: F32,
                layout: Layout::new(shape),
            };
            let mut req = std::ptr::null_mut();
            let mut buf = std::ptr::null_mut();
            a.check(
                "input requirements",
                (a.input_requirements)(self.compiled, s.index, 0, &mut req),
            )?;
            a.check("buffer", (a.create_buffer)(self.env, &input, req, &mut buf))?;
            s.buffers.push(buf);
            for (k, layout) in outputs.into_iter().enumerate() {
                a.check(
                    "output requirements",
                    (a.output_requirements)(self.compiled, s.index, k, &mut req),
                )?;
                let ty = RankedType {
                    element_type: F32,
                    layout,
                };
                a.check("buffer", (a.create_buffer)(self.env, &ty, req, &mut buf))?;
                s.buffers.push(buf);
                s.outputs[k].layout = layout;
            }
            s.shape = Some(shape.to_vec());
        }
        Ok(())
    }

    /// Signature keys and their input dimensions (-1: dynamic).
    fn signatures(&self) -> Vec<(String, Vec<i32>)> {
        self.signatures
            .iter()
            .map(|s| (s.key.clone(), s.input.layout.dims().to_vec()))
            .collect()
    }

    fn release_compiled(&mut self) {
        if !self.compiled.is_null() {
            // SAFETY: owned, destroyed once.
            unsafe { (self.api.destroy_compiled)(self.compiled) };
            self.compiled = std::ptr::null_mut();
        }
    }

    /// Runs `f` on `buf`'s host view, which must hold `bytes`.
    fn locked<R>(&self, buf: Handle, mode: c_int, bytes: usize, f: impl FnOnce(*mut c_void) -> R) -> Result<R> {
        let mut size = 0;
        // SAFETY: valid buffer.
        self.api
            .check("size", unsafe { (self.api.buffer_size)(buf, &mut size) })?;
        if size < bytes {
            return Err(err(format!("buffer of {size} bytes, need {bytes}")));
        }
        let mut p = std::ptr::null_mut();
        // SAFETY: valid buffer; unlocked right after.
        self.api.check("lock", unsafe { (self.api.lock)(buf, &mut p, mode) })?;
        let r = f(p);
        self.api.check("unlock", unsafe { (self.api.unlock)(buf) })?;
        Ok(r)
    }

    fn name(&self) -> String {
        format!("litert/{}", self.provider)
    }

    fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
        let shape = input.shape().to_vec();
        let i = if self.resize {
            (self.signatures[0].declared().len() == shape.len()).then_some(0)
        } else {
            self.signatures.iter().position(|s| s.held == shape)
        }
        .ok_or_else(|| err(format!("no signature takes input {shape:?}")))?;
        if self.signatures[i].shape.as_deref() != Some(&shape) {
            self.allocate(i, &shape)?;
        }
        let s = &self.signatures[i];
        let x = input.as_standard_layout();
        let x = x.as_slice().expect("standard layout");
        self.locked(s.buffers[0], LOCK_WRITE, size_of_val(x), |p| {
            // SAFETY: the buffer holds the input tensor, `x.len()` floats.
            unsafe { std::ptr::copy_nonoverlapping(x.as_ptr(), p.cast::<f32>(), x.len()) }
        })?;
        let mut bufs = s.buffers.clone();
        let (ins, outs) = bufs.split_at_mut(1);
        // SAFETY: buffers of signature `s.index`, as allocated for this shape.
        self.api.check("run", unsafe {
            (self.api.run)(
                self.compiled,
                s.index,
                1,
                ins.as_mut_ptr(),
                outs.len(),
                outs.as_mut_ptr(),
            )
        })?;
        let outputs = s
            .outputs
            .iter()
            .zip(&s.buffers[1..])
            .map(|(t, &b)| {
                let dims = t.layout.dims().iter().map(|&d| d.max(0) as usize).collect::<Vec<_>>();
                let n = dims.iter().product::<usize>();
                let v = self.locked(b, LOCK_READ, n * size_of::<f32>(), |p| {
                    // SAFETY: the buffer holds `n` floats of this output.
                    unsafe { std::slice::from_raw_parts(p.cast::<f32>(), n) }.to_vec()
                })?;
                ArrayD::from_shape_vec(IxDyn(&dims), v).map_err(|e| Error::Shape(e.to_string()))
            })
            .collect::<Result<_>>()?;
        Ok(RawOutput { outputs })
    }
}

impl Drop for Compiled {
    fn drop(&mut self) {
        let a = &self.api;
        // SAFETY: owned handles, each destroyed once, buffers before the
        // compiled model, the model and the environment.
        unsafe {
            for &b in self.signatures.iter().flat_map(|s| &s.buffers) {
                (a.destroy_buffer)(b);
            }
            if !self.compiled.is_null() {
                (a.destroy_compiled)(self.compiled);
            }
            if !self.model.is_null() {
                (a.destroy_model)(self.model);
            }
            (a.destroy_environment)(self.env);
        }
    }
}

/// One run: the input and where its result goes.
type Job = (Array4<f32>, mpsc::SyncSender<Result<RawOutput>>);

/// A `.tflite` model on LiteRT, on a thread of its own: the GPU accelerator
/// keeps its context on the thread that compiled the model, and callers (the
/// app's FFI) arrive on any thread.
pub struct LiteRtBackend {
    jobs: Option<mpsc::Sender<Job>>,
    worker: Option<JoinHandle<()>>,
    name: String,
    signatures: Vec<(String, Vec<i32>)>,
}

impl LiteRtBackend {
    /// Loads the model file `model` (see [`LiteRtBackend::load_model`]).
    pub fn load(model: &Path, opts: &LiteRtOptions) -> Result<Self> {
        Self::load_model(LiteRtModel::File(model.to_path_buf()), opts)
    }

    /// Loads `model` on the GPU when it takes every op, else on the CPU (said
    /// in [`Backend::name`]).
    pub fn load_model(model: LiteRtModel, opts: &LiteRtOptions) -> Result<Self> {
        let opts = opts.clone();
        let (ready, loaded) = mpsc::sync_channel(1);
        let (jobs, queue) = mpsc::channel::<Job>();
        let worker = std::thread::Builder::new()
            .name("litert".into())
            .spawn(move || {
                let mut c = match Compiled::load(&model, &opts) {
                    Ok(c) => {
                        let _ = ready.send(Ok((c.name(), c.signatures())));
                        c
                    }
                    Err(e) => {
                        let _ = ready.send(Err(e));
                        return;
                    }
                };
                for (x, reply) in queue {
                    let _ = reply.send(c.run(x.view()));
                }
            })
            .map_err(err)?;
        let (name, signatures) = loaded.recv().map_err(err)??;
        Ok(Self {
            jobs: Some(jobs),
            worker: Some(worker),
            name,
            signatures,
        })
    }

    /// Signature keys and their input dimensions (-1: dynamic).
    pub fn signatures(&self) -> &[(String, Vec<i32>)] {
        &self.signatures
    }
}

impl Drop for LiteRtBackend {
    fn drop(&mut self) {
        // Closing the queue ends the worker, which releases the model.
        drop(self.jobs.take());
        if let Some(w) = self.worker.take() {
            let _ = w.join();
        }
    }
}

impl Backend for LiteRtBackend {
    fn name(&self) -> String {
        self.name.clone()
    }

    fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
        let (reply, result) = mpsc::sync_channel(1);
        self.jobs
            .as_ref()
            .expect("set until drop")
            .send((input.to_owned(), reply))
            .map_err(|_| err("worker stopped"))?;
        result.recv().map_err(|_| err("worker stopped"))?
    }
}

/// YuNet (opencv_zoo, MIT: `models/yunet/LICENSE`) as LiteRT runs it: the
/// ONNX export converted with onnx2tf (`-kat input`, so the input stays NCHW
/// with dynamic height and width; outputs in the ONNX order, within 1e-5 of
/// ONNX Runtime).
const YUNET: &[u8] = include_bytes!("../models/yunet/face_detection_yunet_2026may.tflite");

/// The bundled face detector, on the CPU of the LiteRT in `opts`: its input
/// follows each image's size, and a GPU would compile the graph again for
/// every size.
pub fn face_detector(opts: &LiteRtOptions) -> Result<FaceDetector> {
    let opts = LiteRtOptions {
        library: opts.library.clone(),
        cpu_only: true,
        cache_dir: None,
        resize: true,
    };
    Ok(FaceDetector::new(Box::new(LiteRtBackend::load_model(
        LiteRtModel::Static(YUNET),
        &opts,
    )?)))
}

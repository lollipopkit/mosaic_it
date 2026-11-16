//! LiteRT (CompiledModel API) backend for `.tflite` models with one
//! signature per input shape. Runs on the GPU accelerator when it takes the
//! whole graph, else on the CPU. `libLiteRt` is loaded at run time (the
//! Android app bundles it from the `com.google.ai.edge.litert` AARs), so
//! nothing links against it. Declarations follow LiteRT 2.3.2 `litert/c`.

use std::ffi::{CStr, CString, c_char, c_int, c_void};
use std::path::{Path, PathBuf};
use std::sync::mpsc;
use std::thread::JoinHandle;

use libloading::Library;
use ndarray::{Array4, ArrayD, ArrayView4, IxDyn};
use unseen_core::{Backend, Error, RawOutput, Result};

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

impl RankedType {
    fn dims(&self) -> Vec<usize> {
        let rank = (self.layout.bits & 0x7f) as usize;
        self.layout.dimensions[..rank.min(MAX_RANK)]
            .iter()
            .map(|&d| d.max(0) as usize)
            .collect()
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
    create_compiled = "LiteRtCreateCompiledModel": fn(Handle, Handle, Handle, *mut Handle) -> Status;
    destroy_compiled = "LiteRtDestroyCompiledModel": fn(Handle);
    fully_accelerated = "LiteRtCompiledModelIsFullyAccelerated": fn(Handle, *mut bool) -> Status;
    input_requirements = "LiteRtGetCompiledModelInputBufferRequirements": fn(Handle, usize, usize, *mut Handle) -> Status;
    output_requirements = "LiteRtGetCompiledModelOutputBufferRequirements": fn(Handle, usize, usize, *mut Handle) -> Status;
    create_buffer = "LiteRtCreateManagedTensorBufferFromRequirements": fn(Handle, *const RankedType, Handle, *mut Handle) -> Status;
    destroy_buffer = "LiteRtDestroyTensorBuffer": fn(Handle);
    lock = "LiteRtLockTensorBuffer": fn(Handle, *mut *mut c_void, c_int) -> Status;
    unlock = "LiteRtUnlockTensorBuffer": fn(Handle) -> Status;
    run = "LiteRtRunCompiledModel": fn(Handle, usize, usize, *mut Handle, usize, *mut Handle) -> Status;
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

/// One signature: its graph input shape and buffers, allocated once.
struct Signature {
    index: usize,
    /// `[1, 3, h, w]`.
    input_shape: Vec<usize>,
    inputs: Vec<Handle>,
    outputs: Vec<(Handle, Vec<usize>)>,
}

#[derive(Debug, Clone)]
pub struct LiteRtOptions {
    /// `libLiteRt`; its directory is where LiteRT looks for accelerators.
    pub library: PathBuf,
    /// Skip the GPU.
    pub cpu_only: bool,
    /// Where LiteRT keeps compiled programs between loads.
    pub cache_dir: Option<PathBuf>,
}

impl Default for LiteRtOptions {
    fn default() -> Self {
        Self {
            library: LIBRARY.into(),
            cpu_only: false,
            cache_dir: None,
        }
    }
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
    pub fn load(model: &Path, opts: &LiteRtOptions) -> Result<Self> {
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
        let cpu_only = opts.cpu_only;
        let mut b = Self {
            api,
            env,
            model: std::ptr::null_mut(),
            compiled: std::ptr::null_mut(),
            signatures: Vec::new(),
            provider: String::new(),
        };
        let path = CString::new(model.as_os_str().as_encoded_bytes()).map_err(err)?;
        // SAFETY: `path` is NUL-terminated; `b.model` receives an owned handle.
        b.api.check("model", unsafe {
            (b.api.create_model)(b.env, path.as_ptr(), &mut b.model)
        })?;
        b.provider = if cpu_only {
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
        b.allocate()?;
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
                a.check("compile", unsafe {
                    (a.create_compiled)(self.env, self.model, opts, &mut self.compiled)
                })
            });
        // SAFETY: created above.
        unsafe { (a.destroy_options)(opts) };
        r
    }

    fn fully_accelerated(&self) -> Result<bool> {
        let mut full = false;
        // SAFETY: valid compiled model.
        self.api.check("placement", unsafe {
            (self.api.fully_accelerated)(self.compiled, &mut full)
        })?;
        Ok(full)
    }

    /// Input and output buffers of every signature, as the compiled model
    /// requires them.
    fn allocate(&mut self) -> Result<()> {
        let a = &self.api;
        let mut n = 0;
        // SAFETY: valid model handle throughout; out-parameters are locals.
        unsafe {
            a.check("signatures", (a.num_signatures)(self.model, &mut n))?;
            for index in 0..n {
                let mut sig = std::ptr::null_mut();
                a.check("signature", (a.signature)(self.model, index, &mut sig))?;
                let (mut ni, mut no) = (0, 0);
                a.check("inputs", (a.num_inputs)(sig, &mut ni))?;
                a.check("outputs", (a.num_outputs)(sig, &mut no))?;
                if ni != 1 {
                    return Err(err(format!("signature {index}: {ni} inputs, expected 1")));
                }
                let mut s = Signature {
                    index,
                    input_shape: Vec::new(),
                    inputs: Vec::new(),
                    outputs: Vec::new(),
                };
                for (i, input) in (0..ni + no).map(|i| (i, i < ni)) {
                    let k = if input { i } else { i - ni };
                    let (mut t, mut req, mut buf) = (std::ptr::null_mut(), std::ptr::null_mut(), std::ptr::null_mut());
                    let mut ty: RankedType = std::mem::zeroed();
                    if input {
                        a.check("input", (a.input_tensor)(sig, k, &mut t))?;
                        a.check(
                            "input requirements",
                            (a.input_requirements)(self.compiled, index, k, &mut req),
                        )?;
                    } else {
                        a.check("output", (a.output_tensor)(sig, k, &mut t))?;
                        a.check(
                            "output requirements",
                            (a.output_requirements)(self.compiled, index, k, &mut req),
                        )?;
                    }
                    a.check("tensor type", (a.ranked_type)(t, &mut ty))?;
                    if ty.element_type != F32 {
                        return Err(err(format!(
                            "signature {index}: element type {} is not float32",
                            ty.element_type
                        )));
                    }
                    a.check("buffer", (a.create_buffer)(self.env, &ty, req, &mut buf))?;
                    if input {
                        s.input_shape = ty.dims();
                        s.inputs.push(buf);
                    } else {
                        s.outputs.push((buf, ty.dims()));
                    }
                }
                self.signatures.push(s);
            }
        }
        Ok(())
    }

    /// Signature keys and their input shapes.
    fn signatures(&self) -> Result<Vec<(String, Vec<usize>)>> {
        self.signatures
            .iter()
            .map(|s| {
                let (mut sig, mut key) = (std::ptr::null_mut(), std::ptr::null());
                // SAFETY: valid model; the key is owned by the model.
                unsafe {
                    self.api
                        .check("signature", (self.api.signature)(self.model, s.index, &mut sig))?;
                    self.api
                        .check("signature key", (self.api.signature_key)(sig, &mut key))?;
                    Ok((
                        CStr::from_ptr(key).to_string_lossy().into_owned(),
                        s.input_shape.clone(),
                    ))
                }
            })
            .collect()
    }

    fn release_compiled(&mut self) {
        if !self.compiled.is_null() {
            // SAFETY: owned, destroyed once.
            unsafe { (self.api.destroy_compiled)(self.compiled) };
            self.compiled = std::ptr::null_mut();
        }
    }

    /// Copies `data` into or out of `buf`'s host view.
    fn locked<R>(&self, buf: Handle, mode: c_int, f: impl FnOnce(*mut c_void) -> R) -> Result<R> {
        let mut p = std::ptr::null_mut();
        // SAFETY: valid buffer; unlocked right after.
        self.api.check("lock", unsafe { (self.api.lock)(buf, &mut p, mode) })?;
        let r = f(p);
        self.api.check("unlock", unsafe { (self.api.unlock)(buf) })?;
        Ok(r)
    }
}

impl Drop for Compiled {
    fn drop(&mut self) {
        let a = &self.api;
        // SAFETY: owned handles, each destroyed once, buffers before the
        // compiled model, the model and the environment.
        unsafe {
            for s in &self.signatures {
                for &b in s.inputs.iter().chain(s.outputs.iter().map(|(b, _)| b)) {
                    (a.destroy_buffer)(b);
                }
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

impl Compiled {
    fn name(&self) -> String {
        format!("litert/{}", self.provider)
    }

    fn run(&mut self, input: ArrayView4<'_, f32>) -> Result<RawOutput> {
        let shape = input.shape();
        let s = self
            .signatures
            .iter()
            .find(|s| s.input_shape == shape)
            .ok_or_else(|| err(format!("no signature takes input {shape:?}")))?;
        let x = input.as_standard_layout();
        let x = x.as_slice().expect("standard layout");
        self.locked(s.inputs[0], LOCK_WRITE, |p| {
            // SAFETY: the buffer holds the input tensor, `x.len()` floats.
            unsafe { std::ptr::copy_nonoverlapping(x.as_ptr(), p.cast::<f32>(), x.len()) }
        })?;
        let mut ins = s.inputs.clone();
        let mut outs: Vec<Handle> = s.outputs.iter().map(|(b, _)| *b).collect();
        // SAFETY: buffers of signature `s.index`, as allocated.
        self.api.check("run", unsafe {
            (self.api.run)(
                self.compiled,
                s.index,
                ins.len(),
                ins.as_mut_ptr(),
                outs.len(),
                outs.as_mut_ptr(),
            )
        })?;
        let outputs = s
            .outputs
            .iter()
            .map(|(b, dims)| {
                let n = dims.iter().product::<usize>();
                let v = self.locked(*b, LOCK_READ, |p| {
                    // SAFETY: the buffer holds `n` floats of this output.
                    unsafe { std::slice::from_raw_parts(p.cast::<f32>(), n) }.to_vec()
                })?;
                ArrayD::from_shape_vec(IxDyn(dims), v).map_err(|e| Error::Shape(e.to_string()))
            })
            .collect::<Result<_>>()?;
        Ok(RawOutput { outputs })
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
    signatures: Vec<(String, Vec<usize>)>,
}

impl LiteRtBackend {
    /// Loads `model` on the GPU when it takes every op, else on the CPU (said
    /// in [`Backend::name`]).
    pub fn load(model: &Path, opts: &LiteRtOptions) -> Result<Self> {
        let (model, opts) = (model.to_path_buf(), opts.clone());
        let (ready, loaded) = mpsc::sync_channel(1);
        let (jobs, queue) = mpsc::channel::<Job>();
        let worker = std::thread::Builder::new()
            .name("litert".into())
            .spawn(move || {
                let c = Compiled::load(&model, &opts).and_then(|c| Ok((c.name(), c.signatures()?, c)));
                let mut c = match c {
                    Ok((name, sigs, c)) => {
                        let _ = ready.send(Ok((name, sigs)));
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

    /// Signature keys and their input shapes.
    pub fn signatures(&self) -> &[(String, Vec<usize>)] {
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

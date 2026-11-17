//! `UNSEEN_LITERT_MODEL` (an exported `.tflite` with its sidecar) on the
//! LiteRT library `UNSEEN_LITERT`, on the CPU and the GPU: every sidecar
//! shape has a signature, and both agree with the ONNX export next to it
//! (`<model>.onnx` by stem, when present) on ORT's CPU.
#![cfg(all(feature = "litert", feature = "ort"))]

use std::path::{Path, PathBuf};

use ndarray::Array4;
use unseen_core::{Backend, ModelMeta};
use unseen_infer::{LiteRtBackend, LiteRtOptions};

fn inputs() -> Option<(PathBuf, PathBuf)> {
    let (Ok(model), Ok(lib)) = (std::env::var("UNSEEN_LITERT_MODEL"), std::env::var("UNSEEN_LITERT")) else {
        eprintln!("skip: set UNSEEN_LITERT_MODEL and UNSEEN_LITERT");
        return None;
    };
    Some((model.into(), lib.into()))
}

fn input(w: usize, h: usize) -> Array4<f32> {
    Array4::from_shape_fn((1, 3, h, w), |(_, c, y, x)| {
        ((x * 7 + y * 13 + c * 31) % 255) as f32 / 64.0 - 2.0
    })
}

fn max_diff(a: &[ndarray::ArrayD<f32>], b: &[ndarray::ArrayD<f32>]) -> f32 {
    assert_eq!(a.len(), b.len());
    a.iter()
        .zip(b)
        .map(|(x, y)| {
            assert_eq!(x.shape(), y.shape());
            x.iter().zip(y).map(|(p, q)| (p - q).abs()).fold(0.0, f32::max)
        })
        .fold(0.0, f32::max)
}

#[test]
fn signatures_run_and_match_ort() {
    let Some((model, lib)) = inputs() else { return };
    let meta = ModelMeta::load(&model).unwrap();
    let shapes: Vec<[u32; 2]> = if meta.shapes.is_empty() {
        meta.input_size.into_iter().collect()
    } else {
        meta.shapes.clone()
    };
    let onnx = model.with_extension("onnx");
    let mut ort = Path::new(&onnx).exists().then(|| {
        unseen_infer::OrtBackend::load_with(
            &onnx,
            unseen_infer::OrtOptions {
                cpu_only: true,
                ..Default::default()
            },
        )
        .unwrap()
    });
    for cpu in [true, false] {
        let opts = LiteRtOptions {
            library: lib.clone(),
            cpu_only: cpu,
            ..Default::default()
        };
        let mut b = LiteRtBackend::load(&model, &opts).unwrap();
        eprintln!("{} {:?}", b.name(), b.signatures());
        for &[w, h] in &shapes {
            let x = input(w as usize, h as usize);
            let got = b.run(x.view()).unwrap().outputs;
            assert_eq!(got.len(), 2 * meta.strides.len());
            if let Some(o) = ort.as_mut() {
                let want = o.run(x.view()).unwrap().outputs;
                let d = max_diff(&got, &want);
                eprintln!("{} {w}x{h}: max diff {d:.2e}", b.name());
                // GPU accelerators compute in float16.
                assert!(d < if cpu { 1e-3 } else { 5e-2 }, "{w}x{h}: {d}");
            }
        }
    }
}

/// The bundled YuNet as LiteRT runs it (dynamic height and width) against
/// the ONNX export on ORT's CPU, at the sizes of both face passes.
#[test]
fn yunet_matches_ort() {
    let Ok(lib) = std::env::var("UNSEEN_LITERT") else {
        eprintln!("skip: set UNSEEN_LITERT");
        return;
    };
    let dir = Path::new(env!("CARGO_MANIFEST_DIR")).join("models/yunet");
    let opts = LiteRtOptions {
        library: lib.into(),
        cpu_only: true,
        resize: true,
        ..Default::default()
    };
    let mut lite = LiteRtBackend::load(&dir.join("face_detection_yunet_2026may.tflite"), &opts).unwrap();
    let mut ort = unseen_infer::OrtBackend::load_with(
        &dir.join("face_detection_yunet_2026may.onnx"),
        unseen_infer::OrtOptions {
            cpu_only: true,
            ..Default::default()
        },
    )
    .unwrap();
    for (w, h) in [(288, 640), (800, 1760), (1440, 3072), (288, 640)] {
        let x = input(w, h) * 64.0 + 128.0;
        let d = max_diff(
            &lite.run(x.view()).unwrap().outputs,
            &ort.run(x.view()).unwrap().outputs,
        );
        eprintln!("yunet {w}x{h}: max diff {d:.2e}");
        assert!(d < 1e-3, "{w}x{h}: {d}");
    }
}

//! Links Apple's Clang runtime archive when building ONNX Runtime for Apple
//! targets. Prebuilt ONNX Runtime 1.31+ CoreML objects emit `@available(...)`
//! checks referencing `___isPlatformVersionAtLeast`, which lives in
//! `libclang_rt.{osx,ios,iossim}.a` and is not linked automatically by `rustc`.

use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    println!("cargo:rerun-if-changed=build.rs");

    if env::var_os("CARGO_FEATURE_ORT").is_none() {
        return;
    }
    if env::var("CARGO_CFG_TARGET_VENDOR").as_deref() != Ok("apple") {
        return;
    }

    println!("cargo:rerun-if-env-changed=DEVELOPER_DIR");
    println!("cargo:rerun-if-env-changed=SDKROOT");

    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap_or_default();
    let target_abi = env::var("CARGO_CFG_TARGET_ABI").unwrap_or_default();
    let rt = match (target_os.as_str(), target_abi.as_str()) {
        ("macos", _) | ("ios", "macabi") => "clang_rt.osx",
        ("ios", "sim") => "clang_rt.iossim",
        ("ios", "") => "clang_rt.ios",
        _ => return,
    };

    let Some(darwin_dir) = clang_darwin_lib_dir() else {
        println!("cargo:warning=could not locate Apple clang resource dir for {rt}");
        return;
    };
    if !darwin_dir.join(format!("lib{rt}.a")).is_file() {
        println!("cargo:warning=missing lib{rt}.a in {}", darwin_dir.display());
        return;
    }

    println!("cargo:rustc-link-search=native={}", darwin_dir.display());
    println!("cargo:rustc-link-lib=static:-bundle={rt}");
}

fn run_print_resource_dir(program: &str, args: &[&str]) -> Option<PathBuf> {
    let output = Command::new(program).args(args).output().ok()?;
    if !output.status.success() {
        return None;
    }
    let dir = String::from_utf8(output.stdout).ok()?;
    let dir = dir.trim();
    if dir.is_empty() {
        return None;
    }
    Some(PathBuf::from(dir).join("lib").join("darwin"))
}

fn clang_darwin_lib_dir() -> Option<PathBuf> {
    run_print_resource_dir("xcrun", &["clang", "--print-resource-dir"])
        .or_else(|| run_print_resource_dir("/usr/bin/clang", &["--print-resource-dir"]))
}

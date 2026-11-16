fn main() {
    // app/hook/build.dart makes ONNX Runtime link libc++_static on Android
    // (ORT_CXX_STDLIB). Since NDK r23 the static C++ runtime also needs
    // libc++abi, which ORT's build script does not add.
    if std::env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("android")
        && std::env::var("ORT_CXX_STDLIB").as_deref() == Ok("c++_static")
    {
        println!("cargo:rustc-link-lib=c++abi");
    }
    println!("cargo:rerun-if-env-changed=ORT_CXX_STDLIB");
}

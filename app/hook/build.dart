import 'package:code_assets/code_assets.dart';
import 'package:flutter_rust_bridge_hooks/flutter_rust_bridge_hooks.dart';

/// Builds crates/unseen-ffi and bundles it as a native asset.
void main(List<String> args) async {
  await build(args, (input, output) async {
    final android =
        input.config.buildCodeAssets &&
        input.config.code.targetOS == OS.android;
    // ONNX Runtime's prebuilt Android binaries are arm64 only; the APK ships
    // arm64-v8a only (android/app/build.gradle.kts).
    if (android && input.config.code.targetArchitecture != Architecture.arm64) {
      return;
    }
    await FlutterRustBridgeNativeAssetsBuilder(
      cratePath: '../crates/unseen-ffi',
      // ONNX Runtime links libc++_shared on Android by default, which the APK
      // would then have to ship. This library is the app's only user of the
      // NDK C++ runtime, so link it statically as the NDK recommends.
      extraCargoEnvironmentVariables: {
        if (android) 'ORT_CXX_STDLIB': 'c++_static',
      },
    ).run(input: input, output: output);
  });
}

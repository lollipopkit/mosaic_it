import 'package:code_assets/code_assets.dart';
import 'package:flutter_rust_bridge_hooks/flutter_rust_bridge_hooks.dart';

/// Builds crates/unseen-ffi and bundles it as a native asset.
void main(List<String> args) async {
  await build(args, (input, output) async {
    final android =
        input.config.buildCodeAssets &&
        input.config.code.targetOS == OS.android;
    // The APK ships arm64-v8a only (android/app/build.gradle.kts).
    if (android && input.config.code.targetArchitecture != Architecture.arm64) {
      return;
    }
    await FlutterRustBridgeNativeAssetsBuilder(
      cratePath: '../crates/unseen-ffi',
    ).run(input: input, output: output);
  });
}

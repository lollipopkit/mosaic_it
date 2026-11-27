import 'dart:io';

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

    // Prebuilt Windows ONNX Runtime from ort-sys links DirectML.dll dynamically
    // and copies it next to unseen_ffi.dll; bundle any sibling runtime DLLs so
    // the packaged app runs without a system-provided copy.
    if (input.config.buildCodeAssets &&
        input.config.code.targetOS == OS.windows &&
        input.config.code.linkModePreference != LinkModePreference.static) {
      final emitted = output.build().assets.code;
      final seenNames = <String>{};
      final searchDirs = <String>{};
      for (final asset in emitted) {
        final file = asset.file;
        if (file == null) continue;
        final path = File.fromUri(file).path;
        seenNames.add(file.pathSegments.last.toLowerCase());
        searchDirs.add(File(path).parent.path);
      }
      for (final dirPath in searchDirs) {
        final dir = Directory(dirPath);
        if (!dir.existsSync()) continue;
        final entries = dir.listSync()
          ..sort((a, b) => a.path.compareTo(b.path));
        for (final entry in entries) {
          if (entry is! File) continue;
          final lower = entry.uri.pathSegments.last.toLowerCase();
          final isOrtRuntime =
              lower == 'directml.dll' ||
              (lower.startsWith('onnxruntime') && lower.endsWith('.dll'));
          if (!isOrtRuntime || !seenNames.add(lower)) continue;
          output.assets.code.add(
            CodeAsset(
              package: input.packageName,
              name: 'native/$lower',
              linkMode: DynamicLoadingBundled(),
              file: entry.uri,
            ),
          );
        }
      }
    }
  });
}

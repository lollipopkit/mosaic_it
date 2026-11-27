# MosaicIt app

Flutter frontend (macOS, iOS, Android, Linux, Windows) over `crates/unseen-ffi` via flutter_rust_bridge 2.13.0.

```sh
flutter run -d macos
flutter run -d <ios-simulator-id>
flutter run -d <android-device>   # minSdk 29
```

No CocoaPods: plugins come in through Swift Package Manager (enabled in
`pubspec.yaml`), and the Rust library is built and bundled by the native-assets
hook in `hook/build.dart` (frb's `FlutterRustBridgeNativeAssetsBuilder`). The
toolchain and targets are pinned in `crates/unseen-ffi/rust-toolchain.toml`.
iOS simulators are arm64 only (ONNX Runtime has no x86_64 simulator build).
Android runs `.tflite` models on LiteRT (GPU, else CPU) and ships no ONNX
Runtime; the APK is arm64-v8a only.

On phones images come from the native zero-permission system picker
(`PHPickerViewController` on iOS, Photo Picker / `ACTION_OPEN_DOCUMENT` on Android;
non-PNG/JPEG/WebP images such as HEIC are transcoded on device to upright JPEG)
and exports go to the native clipboard, system share sheet (`share_plus`), or
write-only Photos/Gallery saves; desktops use native file dialogs (plus window
drag-and-drop on macOS). Video picking is currently disabled in the UI pending
native video model I/O.

The app runs completely offline with no network permissions (no Android
`INTERNET` permission in release builds and no macOS `network.client`
entitlement). Platform builds bundle the pinned detector release from
[models/manifest.toml](../models/manifest.toml) via `tool/bundle-model.sh`
(`unseen-det-tile.onnx` on Apple/Linux/Windows, `unseen-det.tflite` on Android).
A local model (`*.onnx` or `*.tflite` with its `.json` sidecar) can also be
imported by hand in Settings ([docs/model.md](../docs/model.md)). On narrow
screens the region list is in a drawer.

- Open several images at once; a strip at the bottom switches between them,
  "Find similar" searches all of them, and Export checks and writes each.
- Tap a box to toggle it; amber boxes are below the calibrated threshold and
  need review. In Draw mode, drag to add a box; right-click removes a drawn box.
- Export runs the self-check (re-detection on the output and pixel correlation
  inside each box) and refuses to write until the user resolves or overrides it.
- Videos (toolbar "Open a video"): the video is analysed (detection on
  keyframes, tracks across them), then a slider scrubs through keyframe
  previews and the track list (or a tap on a box) chooses what to redact.
  In Draw mode a box drawn on any frame becomes a manual track, followed
  across keyframes (also through scrolling) by template matching.
  Export writes H.264 MP4, without audio unless "Keep audio" is on (sound
  is copied as is, unchecked); the self-check runs on every
  keyframe and can jump to the frame it failed on.

After changing `crates/unseen-ffi/src/api.rs`:

```sh
flutter_rust_bridge_codegen generate
```

Tests: `flutter test` (widget and unit tests); `test/ffi_test.dart` runs end to end when
`UNSEEN_TEST_MODEL` and `UNSEEN_TEST_IMAGE` are set (see the file header).

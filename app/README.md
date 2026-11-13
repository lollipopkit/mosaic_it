# MosaicIt app

Flutter frontend (macOS, iOS, Android) over `crates/unseen-ffi` via flutter_rust_bridge 2.13.0.

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
On Android the hook links the NDK C++ runtime statically (`ORT_CXX_STDLIB`,
plus `c++abi` from `crates/unseen-ffi/build.rs`) so the APK ships no
`libc++_shared.so`; inference uses NNAPI, the only EP in ORT's prebuilt
Android binaries.

On phones images come from Photos (`image_picker`; iOS photos arrive as JPEG
since the decoder has no HEIC) and exports go to the share sheet
(`share_plus`); desktops use file dialogs.

The model is downloaded on first launch ([docs/release.md](../docs/release.md)).
A model can also be imported by hand: the `*.onnx` together with its
`*.onnx.json` sidecar ([docs/model.md](../docs/model.md)). On narrow screens the region list is in a drawer.

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
- Desktop only: review pseudo-labels (`coco.json`, images next to it). Amber boxes are teacher disagreements; selected
  boxes are kept. The class picker sets the tapped box and new boxes. "Verify &
  next" marks the image `verified`, saves the file (edited or drawn boxes get
  `source: "human"`) and jumps to the next image with open reviews.

After changing `crates/unseen-ffi/src/api.rs`:

```sh
flutter_rust_bridge_codegen generate
```

Tests: `flutter test` (widget and unit tests); `test/ffi_test.dart` runs end to end when
`UNSEEN_TEST_MODEL` and `UNSEEN_TEST_IMAGE` are set (see the file header).

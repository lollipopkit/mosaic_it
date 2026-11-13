# MosaicIt (码住)

On-device privacy redaction. MosaicIt detects names, addresses, ID numbers, phone
numbers, faces and other private information in images and videos — without
OCR — and lets you choose what to hide before export.

Images never leave the device. The app uses the network for one thing:
downloading the detector model and its signed list of releases
([docs/release.md](docs/release.md)).

| | |
|---|---|
| [app/](app/README.md) | Flutter app: macOS, iOS, Android |
| [crates/](crates) | Rust core, inference backends, FFI, `unseen` CLI |
| [models/](models/manifest.toml) | Classes and the list of released weights |
| [docs/design.md](docs/design.md) | Design |
| [docs/model.md](docs/model.md) | The detector weights: files, training data sources, limits |

The weights are public; the training code and the datasets are not.

## Build

```sh
git clone --recurse-submodules https://github.com/lollipopkit/mosaic_it
cargo build --release -p unseen-cli        # CLI: target/release/unseen
cd app && flutter run -d macos             # app
```

## License

[AGPL-3.0](LICENSE), code and weights. Contributions require signing the
[CLA](CLA.md) ([中文](CLA_zh.md)); see [CONTRIBUTING.md](CONTRIBUTING.md).

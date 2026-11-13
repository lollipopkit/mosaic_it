# Releasing a detector

Steps from an exported model (`unseen-det-tile.onnx`, `unseen-det.onnx` and
their `.json` sidecars) to a release the app installs. Training and export
are not part of this repository.

## 1. Bench (macOS)

```sh
cargo build --release -p unseen-cli --features coreml
target/release/unseen bench --model unseen-det-tile.onnx --runs 20 <image>
```

The tiled model must run as one CoreML partition with every node placed
(281/281 for the current architecture).

## 2. Calibrate

```sh
target/release/unseen calibrate --model unseen-det-tile.onnx --data <calibration set>
target/release/unseen calibrate --model unseen-det.onnx --data <calibration set>
```

`<calibration set>` is a directory with `coco.json` and its images. This
writes per-class thresholds into each `<model>.onnx.json` sidecar. Pass
`--verified` only for human-verified real data; without it no class is
presented as guaranteed.

## 3. Pin

```sh
target/release/unseen models hash unseen-det-tile.onnx --model-version X.Y.Z --variant tiled >> models/manifest.toml
target/release/unseen models hash unseen-det.onnx --model-version X.Y.Z --variant dynamic >> models/manifest.toml
target/release/unseen models verify unseen-det-tile.onnx unseen-det.onnx
```

Add a comment block above the entries (training data, certified classes) and
update [model.md](model.md).

## 4. Publish

The app ships without a model: it downloads the newest tiled release from
`https://pub.lolli.tech/models/unseen/` on first launch and, unless the user
turned that off, a newer one when it appears (used from the next launch).
It only installs what `manifest.signed` there lists (this repository's
`models/manifest.toml` under the publisher's Ed25519 signature, checked
against `unseen-core`'s `PUBLIC_KEY`).

Set the tiled entry's `url` to `https://pub.lolli.tech/models/unseen/X.Y.Z`,
commit, then:

```sh
op run --env-file models/publish.env -- models/publish.sh X.Y.Z <dir with unseen-det-tile.onnx and its .json>
```

It checks the files against the manifest, uploads them, signs the manifest
and uploads it last. Apps move to the highest version they can run:

- Raise `FORMAT` in `unseen-core` and give the entry that `format` when a
  release needs a newer app (classes without labels, new sidecar fields);
  older apps skip it.
- To withdraw a release, publish a higher version; apps never go back.
- A model the user imported by hand (anything but a listed tiled release) is
  left alone.

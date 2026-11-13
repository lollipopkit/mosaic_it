# unseen-det

The detector the app downloads. Releases are listed in
[models/manifest.toml](../models/manifest.toml) and served from
`https://pub.lolli.tech/models/unseen/<version>/`.

| | |
|---|---|
| Task | Boxes around private information in UI screenshots, without OCR |
| Input | RGB, width 720; the tiled export takes 1280×736 tiles ([design.md](design.md) §4) |
| Output | Per-stride class scores and raw boxes, decoded by `unseen-core::detect` |
| Format | ONNX (40 MB) with a sidecar `<file>.json`: classes and thresholds |
| Classes | [models/classes.json](../models/classes.json); `face` comes from YuNet, not from this model |
| Licence | AGPL-3.0, as this repository |

## Files

```
https://pub.lolli.tech/models/unseen/manifest.signed
https://pub.lolli.tech/models/unseen/0.4.0/unseen-det-tile.onnx
https://pub.lolli.tech/models/unseen/0.4.0/unseen-det-tile.onnx.json
```

`unseen models verify <file>` checks a download against the manifest
(BLAKE3 of the model and of its sidecar).

## Training

The training code and the datasets are not published. The weights are
trained from:

- synthetic screenshots rendered from invented values in 44 locales
  (identifiers that cannot be issued: unassigned ID regions, Luhn-failing
  card numbers, reserved email domains);
- real screenshots, labelled privately;
- [WebPII](https://huggingface.co/datasets/WebPII/WebPII) (Apache-2.0), with
  its CC-BY-NC product photos painted out.

The backbone starts from Apache-2.0 ImageNet weights (timm). No Ultralytics
code or weights are involved.

## Limits

- 0.4.0 certifies no class: its sidecar selects every class at score 0.45
  without a recall guarantee ([design.md](design.md) §6). Check the boxes
  before exporting; the app's export check re-runs the detector on the
  output.
- Trained on phone and desktop UI screenshots. Camera photos and scanned
  documents are outside its domain; the app says so when EXIF names a camera.
- `person_name` is the weakest class: without reading text, a name is told
  from its context and shape.

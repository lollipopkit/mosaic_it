import type { DocsBundle } from './types';

export const docsEn: DocsBundle = {
  lang: 'en',
  dir: 'ltr',
  pageTitle: 'Docs — MosaicIt',
  sidebarLabel: 'Documentation',
  paginationLabel: 'Documentation pagination',
  backHome: 'Home',
  copy: 'Copy',
  copied: 'Copied',
  prevLabel: 'Previous',
  nextLabel: 'Next',
  pages: [
    {
      slug: 'quick-start',
      title: 'Quick Start',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt detects and redacts private information in screenshots and photos completely offline. Model weights are bundled inside every release package—no sign-in, no network requests, and no photo-library read permission.',
        },
        { kind: 'h3', text: 'Download & Platform Notes' },
        {
          kind: 'table',
          headers: ['Platform', 'Package & Install'],
          rows: [
            [
              'Android (arm64-v8a)',
              'Install MosaicIt_vX.Y.Z_arm64.apk (signed release APK with bundled FP16 LiteRT model and zero android.permission.* entries).',
            ],
            [
              'macOS (Apple Silicon)',
              'Open MosaicIt_vX.Y.Z_NoSign_arm64.dmg and drag MosaicIt.app to Applications. For the unsigned build, allow it in System Settings → Privacy & Security on first launch.',
            ],
            [
              'iOS (arm64)',
              'Install from the App Store, or sign and sideload MosaicIt_vX.Y.Z_NoSign.ipa with your own Apple Developer certificate.',
            ],
            [
              'Linux (amd64)',
              'Use the AppImage (ubuntu-latest or legacy ubuntu-22.04), .deb, .rpm, or portable .tar.gz bundle.',
            ],
            [
              'Windows (amd64)',
              'Run the MosaicIt_vX.Y.Z_windows_amd64.exe installer or extract the portable .zip archive.',
            ],
          ],
        },
        { kind: 'h3', text: 'Verify Release Checksums' },
        {
          kind: 'p',
          text: 'Every GitHub Release ships with BLAKE3SUMS and SHA256SUMS. Verify downloads before installing:',
        },
        {
          kind: 'code',
          label: 'Shell',
          code: '# Verify a single downloaded asset with BLAKE3 or SHA-256\ngrep <filename> BLAKE3SUMS | b3sum -c -\nsha256sum -c --ignore-missing SHA256SUMS\n# Or verify the full release directory with b3sum\nb3sum -c BLAKE3SUMS',
        },
        { kind: 'h3', text: 'Basic Workflow' },
        {
          kind: 'ul',
          items: [
            'Launch MosaicIt to open the editor directly, or share/drag screenshots into the app.',
            'Pick one or more screenshots via the native system picker—detection completes automatically on device.',
            'Tap boxes to toggle redaction, hold the eye icon to peek at the original, or switch styles.',
            'Export to clipboard, system Share sheet, or write-only Photos/file save.',
          ],
        },
      ],
    },
    {
      slug: 'editor',
      title: 'Editor & Redaction',
      blocks: [
        {
          kind: 'p',
          text: 'Every detection can be reviewed and adjusted before pixels are overwritten. Original files are never modified in place.',
        },
        { kind: 'h3', text: 'Working With Boxes' },
        {
          kind: 'ul',
          items: [
            'Toggle selection: tap any detected box to include or exclude it from redaction.',
            'Peek original: press and hold the eye badge in the top bar to compare against the unredacted image.',
            'Manual draw: drag directly on the canvas to cover any custom area; long-press a box to open its menu and delete it (or use Undo).',
            'Multi-line grouping: choose the Merge tool in the bottom toolbar to combine wrapped lines (such as a two-line address) so they toggle together; long-press a grouped box to split it.',
            'Batch & Find Similar: open multiple screenshots at once using the bottom strip, then run Find Similar to locate matching visual strings across the whole batch without reading text.',
          ],
        },
        { kind: 'h3', text: 'Non-Reversible Redaction Styles' },
        {
          kind: 'table',
          headers: ['Style', 'How Pixels Are Written'],
          rows: [
            ['Solid', 'Fills the rectangle with a single flat color. Ignores interior pixels completely.'],
            ['Surround', 'Fills with the average color sampled only from a 4 px ring outside the box.'],
            ['Blocks', 'Generates a deterministic monochrome block mosaic without reading interior pixels.'],
            ['Tinted', 'Generates a color block mosaic seeded only from the 4 px exterior ring.'],
            ['Noise', 'Writes random pixel noise with zero reference to source pixels.'],
          ],
        },
        {
          kind: 'note',
          text: 'None of the five styles reads pixels inside the masked rectangle, preventing de-pixelation or de-blurring recovery attacks.',
        },
        { kind: 'h3', text: 'Export Self-Check' },
        {
          kind: 'p',
          text: 'Before writing or sharing the redacted image, MosaicIt re-runs the detector on the rendered output and checks pixel correlation inside masked regions to surface any remaining unmasked content. You can fix flagged areas or explicitly override.',
        },
      ],
    },
    {
      slug: 'models',
      title: 'Models & Hardware',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt runs a compact FP16 neural vision detector (unseen-det 0.6.0) directly on image pixels—without OCR and without dictionary or regular-expression keyword matching.',
        },
        { kind: 'h3', text: 'Hardware Acceleration & Power Efficiency' },
        {
          kind: 'table',
          headers: ['Platform', 'Runtime & Accelerator'],
          rows: [
            ['iOS & macOS', 'FP16 ONNX via ONNX Runtime + CoreML on Apple Neural Engine (ANE / NPU) for millisecond, battery-friendly inference.'],
            ['Android (arm64)', 'FP16 LiteRT (.tflite) on mobile GPU (OpenCL / OpenGL) with automatic XNNPACK CPU fallback.'],
            ['Linux & Windows', 'FP16 ONNX via ONNX Runtime on local CPU.'],
          ],
        },
        { kind: 'h3', text: 'Supported Classes (19 Total)' },
        {
          kind: 'p',
          text: 'unseen-det 0.6.0 covers 18 UI/document privacy classes, paired with built-in YuNet for face detection:',
        },
        {
          kind: 'code',
          label: 'Classes',
          code: 'person_name, address, phone, email, id_number, bank_card, plate,\naccount_id, avatar, qr, barcode, finance, organization, device_id,\nsecret, person, health, personal_info, face',
        },
        { kind: 'h3', text: 'Local Adaptive Preferences' },
        {
          kind: 'p',
          text: 'Your keep/uncheck actions adjust per-class pre-selection thresholds locally on device. Preferences stay on your device and can be reset anytime in Settings.',
        },
        { kind: 'h3', text: 'Importing a Custom Model' },
        {
          kind: 'p',
          text: 'In Settings, you can manually import a local .onnx (Apple/desktop) or .tflite (Android) model paired with its sidecar JSON named by appending .json to the full filename (for example, unseen-det-tile.onnx.json or unseen-det.tflite.json). Official models in models/manifest.toml are pinned by BLAKE3 hash.',
        },
      ],
    },
    {
      slug: 'cli',
      title: 'CLI Reference',
      blocks: [
        {
          kind: 'p',
          text: 'The standalone unseen CLI shares the exact same unseen-core Rust engine as the app for automated detection, batch redaction, benchmarking, and model integrity verification.',
        },
        { kind: 'h3', text: 'Install or Build' },
        {
          kind: 'p',
          text: 'Download a prebuilt unseen_vX.Y.Z_* archive for macOS, Linux, or Windows from GitHub Releases, or build from source:',
        },
        {
          kind: 'code',
          label: 'Build from source',
          code: 'git clone --recurse-submodules https://github.com/lollipopkit/mosaic_it\ncd mosaic_it\ncargo build --release -p unseen-cli\n# On macOS, enable CoreML / ANE acceleration:\ncargo build --release -p unseen-cli --features coreml',
        },
        { kind: 'h3', text: 'Detect Regions (JSON / JSONL)' },
        {
          kind: 'code',
          label: 'unseen detect',
          code: '# JSON output for one image (with YuNet face detection enabled)\nunseen detect --model unseen-det-tile.onnx --faces screenshot.png\n\n# JSONL stream across a folder of screenshots\nunseen detect --model unseen-det-tile.onnx --jsonl *.png',
        },
        { kind: 'h3', text: 'Redact Images' },
        {
          kind: 'code',
          label: 'unseen redact',
          code: '# Default solid black redaction with export self-check\nunseen redact --model unseen-det-tile.onnx --faces input.png output.png\n\n# Surround / Blocks / Tinted / Noise styles with custom padding\nunseen redact --model unseen-det-tile.onnx --style surround --pad 6 input.png output.png\nunseen redact --model unseen-det-tile.onnx --style solid --color 1A1418 input.png output.png',
        },
        { kind: 'h3', text: 'Verify Model Checksums & Benchmark' },
        {
          kind: 'code',
          label: 'Verify & Bench',
          code: 'unseen models verify unseen-det-tile.onnx unseen-det.tflite\nunseen bench --model unseen-det-tile.onnx --runs 20 screenshot.png',
        },
      ],
    },
    {
      slug: 'privacy',
      title: 'Privacy & FAQ',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt enforces its offline boundary at compile time, in OS permission manifests, and in automated CI checks.',
        },
        { kind: 'h3', text: 'Permission & Network Guarantees' },
        {
          kind: 'table',
          headers: ['Guarantee', 'Verification'],
          rows: [
            ['Zero app networking', 'No HTTP client, telemetry SDK, or crash reporter in the app; CI fails if any network dependency or socket API appears in app sources.'],
            ['Zero Android release permissions', 'Release manifests strip transitive permissions; CI and release builds verify zero android.permission.* entries via aapt2.'],
            ['Zero photo-library read access', 'iOS uses out-of-process PHPickerViewController (no NSPhotoLibraryUsageDescription) and write-only .addOnly saves; Android uses the system Photo Picker.'],
            ['macOS offline sandbox', 'Release.entitlements allows app-sandbox and user-selected file read/write only, with no com.apple.security.network.* entitlement.'],
            ['Optional web feedback', 'Opening mosaic.lollipopkit.com/feedback passes context via a URL #fragment that never enters HTTP GET logs and is cleared immediately via history.replaceState.'],
          ],
        },
        { kind: 'h3', text: 'Frequently Asked Questions' },
        {
          kind: 'ul',
          items: [
            'Does MosaicIt strip EXIF metadata on export? Yes. Exported images are freshly encoded pixel outputs without carrying over source EXIF metadata.',
            'Why does macOS warn on the unsigned DMG? GitHub Release DMGs are ad-hoc signed. Open System Settings → Privacy & Security and allow MosaicIt once, or build from source.',
            'Are any images uploaded for detection or feedback? Detection never uses the network. Feedback only opens a browser page when you explicitly tap Feedback and submit.',
            'What license applies? Source code and released model weights are published under AGPL-3.0.',
          ],
        },
      ],
    },
  ],
};

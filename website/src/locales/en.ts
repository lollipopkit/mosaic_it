import type { Copy } from './types';

export const en: Copy = {
  meta: {
    lang: 'en',
    dir: 'ltr',
    title: 'MosaicIt — On-device privacy redaction',
    description:
      'Detect and redact private information in screenshots and photos completely offline. No OCR, no network requests, and no photo-library read permissions.',
  },
  nav: {
    screenshots: 'Screenshots',
    features: 'Features',
    privacy: 'Privacy',
    download: 'Download',
    feedback: 'Feedback',
    github: 'GitHub',
    languageLabel: 'Language',
    cta: 'Download',
  },
  hero: {
    titlePrefix: 'Redact private info,',
    titleSuffix: 'completely offline.',
    subtitle:
      'MosaicIt detects names, phone numbers, addresses, financial figures, IDs, QR codes, and faces on device—without OCR, without network code, and without reading your photo library.',
    primaryAction: 'Download MosaicIt',
    feedbackAction: 'Web Feedback',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'Interactive MosaicIt redaction preview',
    peekLabel: 'Hold to peek original',
    resetLabel: 'Reset masks',
    receiptTitle: 'Transfer Receipt',
    recipientLabel: 'Recipient',
    recipientValue: 'Alex Chen',
    phoneLabel: 'Phone',
    phoneValue: '+1 (555) 014-8920',
    addressLabel: 'Address',
    addressValue: '42 Maple St, Apt 8B',
    amountLabel: 'Amount',
    amountValue: '$2,480.00',
    cardLabel: 'Account',
    cardValue: '6222 **** **** 4821',
    qrLabel: 'Receipt QR',
    styles: {
      solid: 'Solid',
      surround: 'Surround',
      blocks: 'Blocks',
      tinted: 'Tinted',
      noise: 'Noise',
    },
    classes: {
      person_name: 'Name',
      phone: 'Phone',
      address: 'Address',
      finance: 'Finance',
      bank_card: 'Bank card',
      qr: 'QR code',
    },
  },
  features: {
    title: 'Built for fast, verifiable redaction.',
    subtitle:
      'Open an image, inspect the detected regions, adjust if needed, and export in seconds.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'On-Device Detection Without OCR',
        description:
          'Bundled FP16 ONNX / LiteRT weights detect 18 PII classes across UI screenshots plus YuNet face detection—no text recognition or external model downloads.',
      },
      {
        tag: '5 Styles',
        title: 'Non-Reversible Pixel Overwrite',
        description:
          'Choose Solid, Surround, Blocks, Tinted, or Noise. None reads pixels inside the redacted box, preventing de-pixelation or de-blurring recovery.',
      },
      {
        tag: 'Self-Check',
        title: 'Re-Scan Before Export',
        description:
          'Before saving or sharing, MosaicIt can re-run the detector on the redacted output to surface any remaining unmasked regions.',
      },
      {
        tag: 'Batch & Adaptive',
        title: 'Batch Redaction & Local Learning',
        description:
          'Open multiple screenshots at once, run Find Similar across the batch, and let on-device preference learning adapt thresholds to your choices.',
      },
      {
        tag: 'Direct Editor',
        title: 'Hold-to-Peek, Copy & OS Share',
        description:
          'Launches directly into the editor. Hold the eye badge to compare against the original, copy directly to clipboard, or accept files via Share, Open With, and drag-and-drop.',
      },
      {
        tag: 'Rust Core + CLI',
        title: 'Scriptable unseen CLI',
        description:
          'Shared unseen-core engine powers both the Flutter app and a standalone CLI for batch redaction and BLAKE3 model verification.',
      },
    ],
    classesTitle: '19 supported classes',
    classesNote: '18 classes from bundled unseen-det 0.5.0 plus face detection via YuNet.',
  },
  privacy: {
    title: 'Zero network. Zero photo-library read access.',
    subtitle:
      'Every privacy claim is enforced at the build and OS-permission boundary rather than policy text.',
    factors: [
      {
        tag: 'Offline Binary',
        title: 'No Networking Code in the App',
        description:
          'The app ships with bundled model weights and contains no HTTP client, analytics SDK, crash reporter, or network entitlements. CI verifies zero network dependencies on every build.',
      },
      {
        tag: 'System Picker Only',
        title: 'No Photo-Library Read Permission',
        description:
          'iOS uses the out-of-process PHPickerViewController and write-only .addOnly saves. Android uses the system Photo Picker and strips transitive permissions from release manifests.',
      },
    ],
    tableColArea: 'Boundary',
    tableColDetail: 'Implementation',
    rows: [
      {
        area: 'Image processing',
        detail:
          'Detection, EXIF orientation handling, and pixel redaction execute locally in Rust (unseen-core) via FFI.',
      },
      {
        area: 'Redaction irreversibility',
        detail:
          'Solid, Blocks, and Noise ignore source pixels completely. Surround and Tinted sample only a 4 px ring outside the box.',
      },
      {
        area: 'Optional detection feedback',
        detail:
          'Submitting missed or false-positive cases opens mosaic.lollipopkit.com/feedback in your system browser via a URL #fragment that never hits HTTP GET logs and is stripped via history.replaceState.',
      },
      {
        area: 'Reproducible open source',
        detail:
          'App, Rust core, feedback worker, and released model weights are published under AGPL-3.0 with BLAKE3 checksums.',
      },
    ],
  },
  download: {
    title: 'Native across mobile and desktop.',
    subtitle: 'Prebuilt releases are published on GitHub, or build directly from source.',
    currentBadge: 'Current platform',
    releasesAction: 'GitHub Releases',
    sourceAction: 'Build from source',
    cliPrompt: '# Build the Rust CLI (unseen)',
    appPrompt: '# Run the Flutter app from source',
    copy: 'Copy',
    copied: 'Copied',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Zero release permissions' },
      linux: { name: 'Linux', meta: 'Desktop app (tar.gz) & unseen CLI' },
      windows: { name: 'Windows', meta: 'Desktop app (ZIP) & unseen CLI' },
    },
  },
  cta: {
    title: 'Open source under AGPL-3.0.',
    subtitle:
      'Audit the code, grab the latest release, or report missed detections on the web feedback page.',
    feedbackAction: 'Open Web Feedback',
    releasesAction: 'GitHub Releases',
    githubAction: 'View Source',
  },
  more: {
    title: 'More from lollipopkit.',
    subtitle: 'Other native apps built with the same engineering focus.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Server status monitoring, touch-ready SSH terminal, SFTP, Docker, systemd, and S.M.A.R.T. tools in one native workspace.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Mount SFTP, S3, WebDAV, and remote storage inside macOS Finder via Apple File Provider without kernel extensions.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Native client for OpenAI and compatible LLM APIs with local-first chat history, tool calling, and custom endpoints.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Features',
    privacy: 'Privacy',
    download: 'Download',
    feedback: 'Feedback',
    releases: 'Releases',
    license: 'AGPL-3.0',
  },
};

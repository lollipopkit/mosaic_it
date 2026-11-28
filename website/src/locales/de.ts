import type { Copy } from './types';

export const de: Copy = {
  meta: {
    lang: 'de',
    dir: 'ltr',
    title: 'MosaicIt — Lokale Datenschutz-Schwärzung auf dem Gerät',
    description:
      'Private Angaben in Screenshots und Fotos vollständig offline erkennen und unkenntlich machen. Ohne OCR, ohne Netzwerkanfragen und ohne Lesezugriff auf die Fotomediathek.',
  },
  nav: {
    screenshots: 'Screenshots',
    features: 'Funktionen',
    privacy: 'Datenschutz',
    download: 'Download',
    feedback: 'Feedback',
    github: 'GitHub',
    languageLabel: 'Sprache',
    cta: 'Download',
  },
  hero: {
    titlePrefix: 'Private Daten schwärzen,',
    titleSuffix: 'vollständig offline.',
    subtitle:
      'MosaicIt erkennt Namen, Telefonnummern, Adressen, Beträge, Ausweisnummern, QR-Codes und Gesichter direkt auf dem Gerät — ohne OCR, ohne Netzwerkcode und ohne Lesezugriff auf deine Fotomediathek.',
    primaryAction: 'MosaicIt herunterladen',
    feedbackAction: 'Web-Feedback',
    githubAction: 'GitHub',
  },
  features: {
    title: 'Für schnelles, nachvollziehbares Unkenntlichmachen.',
    subtitle:
      'Öffne ein Bild, prüfe die erkannten Bereiche, passe sie bei Bedarf an und exportiere in Sekunden.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'Lokale Erkennung ohne OCR',
        description:
          'Mitgelieferte FP16 ONNX / LiteRT-Gewichte erkennen 18 Klassen sensibler Daten in UI-Screenshots plus Gesichtserkennung via YuNet — ganz ohne Texterkennung oder externe Modell-Downloads.',
      },
      {
        tag: '5 Stile',
        title: 'Nicht umkehrbares Pixel-Überschreiben',
        description:
          'Wähle zwischen Volltonfarbe, Hintergrundfarbe, Graues Mosaik, Farbiges Mosaik oder Rauschen. Kein Stil liest Pixel innerhalb des geschwärzten Bereichs, sodass Verpixelung oder Unschärfe nicht rückgängig gemacht werden können.',
      },
      {
        tag: 'Selbstprüfung',
        title: 'Erneute Prüfung vor dem Export',
        description:
          'Vor dem Speichern oder Teilen kann MosaicIt den Detektor erneut über das geschwärzte Ergebnis laufen lassen, um noch sichtbare Bereiche aufzudecken.',
      },
      {
        tag: 'Stapel & Adaptiv',
        title: 'Stapelbearbeitung & lokales Lernen',
        description:
          'Öffne mehrere Screenshots gleichzeitig, suche ähnliche Bereiche im gesamten Stapel und passe Schwellenwerte lokal an deine Entscheidungen an.',
      },
      {
        tag: 'Direkt im Editor',
        title: 'Original-Vorschau, Kopieren & Teilen',
        description:
          'Startet direkt im Editor. Halte das Augensymbol für den Vergleich mit dem Original, kopiere direkt in die Zwischenablage oder übernimm Dateien per Teilen, „Öffnen mit“ und Drag-and-Drop.',
      },
      {
        tag: 'Rust-Kern + CLI',
        title: 'Skriptfähige unseen-CLI',
        description:
          'Die gemeinsame unseen-core-Engine treibt sowohl die Flutter-App als auch eine eigenständige CLI für Stapelverarbeitung und BLAKE3-Modellprüfung an.',
      },
    ],
    classesTitle: '19 unterstützte Klassen',
    classesNote: '18 Klassen aus dem integrierten unseen-det 0.5.0 plus Gesichtserkennung über YuNet.',
  },
  privacy: {
    title: 'Kein Netzwerk. Kein Lesezugriff auf Fotos.',
    subtitle:
      'Jedes Datenschutzversprechen wird auf Build- und Betriebssystemebene erzwungen, nicht bloß in einer Richtlinie behauptet.',
    factors: [
      {
        tag: 'Offline-Binary',
        title: 'Kein Netzwerkcode in der App',
        description:
          'Die App enthält die Modellgewichte direkt im Paket und verzichtet auf HTTP-Client, Analyse-SDK, Absturzberichte und Netzwerkberechtigungen. Die CI prüft bei jedem Build auf null Netzwerkabhängigkeiten.',
      },
      {
        tag: 'Nur Systemauswahl',
        title: 'Keine Leseberechtigung für die Fotomediathek',
        description:
          'iOS nutzt den prozessgetrennten PHPickerViewController und reines Schreiben per .addOnly. Android verwendet den System-Photo Picker und entfernt transitive Berechtigungen aus Release-Manifesten.',
      },
    ],
    tableColArea: 'Grenze',
    tableColDetail: 'Umsetzung',
    rows: [
      {
        area: 'Bildverarbeitung',
        detail:
          'Erkennung, EXIF-Ausrichtung und Pixel-Überschreibung laufen lokal in Rust (unseen-core) über FFI.',
      },
      {
        area: 'Unwiderruflichkeit',
        detail:
          'Volltonfarbe, Graues Mosaik und Rauschen ignorieren Quellpixel vollständig. Hintergrundfarbe und Farbiges Mosaik tasten nur einen 4 px breiten Ring außerhalb des Rahmens ab.',
      },
      {
        area: 'Optionales Erkennungs-Feedback',
        detail:
          'Beim Melden verpasster oder falscher Treffer öffnet sich mosaic.lollipopkit.com/feedback im Systembrowser über ein URL-#fragment, das nie in HTTP GET-Logs erscheint und per history.replaceState entfernt wird.',
      },
      {
        area: 'Nachvollziehbares Open Source',
        detail:
          'App, Rust-Kern, Feedback-Worker und veröffentlichte Modellgewichte stehen unter AGPL-3.0 mit BLAKE3-Prüfsummen bereit.',
      },
    ],
  },
  download: {
    title: 'Nativ für Mobilgeräte und Desktop.',
    subtitle: 'Vorkompilierte Releases findest du auf GitHub, oder baue direkt aus dem Quellcode.',
    currentBadge: 'Aktuelle Plattform',
    releasesAction: 'GitHub Releases',
    sourceAction: 'Aus Quellcode bauen',
    cliPrompt: '# Rust-CLI (unseen) bauen',
    appPrompt: '# Flutter-App aus dem Quellcode starten',
    copy: 'Kopieren',
    copied: 'Kopiert',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Keine Release-Berechtigungen' },
      linux: { name: 'Linux', meta: 'Desktop-App (tar.gz) & unseen CLI' },
      windows: { name: 'Windows', meta: 'Desktop-App (ZIP) & unseen CLI' },
    },
  },
  cta: {
    title: 'Open Source unter AGPL-3.0.',
    subtitle:
      'Prüfe den Quellcode, lade das neueste Release herunter oder melde übersehene Treffer auf der Web-Feedback-Seite.',
    feedbackAction: 'Web-Feedback öffnen',
    releasesAction: 'GitHub Releases',
    githubAction: 'Quellcode ansehen',
  },
  more: {
    title: 'Mehr von lollipopkit.',
    subtitle: 'Weitere native Apps mit demselben Fokus auf sauberes Engineering.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Serverstatus-Monitoring, touchfähiges SSH-Terminal, SFTP, Docker, systemd und S.M.A.R.T.-Werkzeuge in einer nativen Oberfläche.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Binde SFTP, S3, WebDAV und Remote-Speicher per Apple File Provider ohne Kernel-Erweiterungen direkt im macOS-Finder ein.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Nativer Client für OpenAI und kompatible LLM-APIs mit lokalem Chatverlauf, Tool-Aufrufen und eigenen Endpunkten.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Funktionen',
    privacy: 'Datenschutz',
    download: 'Download',
    feedback: 'Feedback',
    releases: 'Releases',
    license: 'AGPL-3.0',
  },
};

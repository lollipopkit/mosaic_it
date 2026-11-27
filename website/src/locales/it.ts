import type { Copy } from './types';

export const it: Copy = {
  meta: {
    lang: 'it',
    dir: 'ltr',
    title: 'MosaicIt — Oscuramento della privacy sul dispositivo',
    description:
      'Rileva e oscura i dati privati in screenshot e foto completamente offline. Nessun OCR, nessuna richiesta di rete e nessun permesso di lettura della libreria foto.',
  },
  nav: {
    features: 'Funzionalità',
    privacy: 'Privacy',
    download: 'Download',
    feedback: 'Feedback',
    github: 'GitHub',
    languageLabel: 'Lingua',
    cta: 'Download',
  },
  hero: {
    titlePrefix: 'Oscura i dati privati,',
    titleSuffix: 'completamente offline.',
    subtitle:
      'MosaicIt rileva nomi, numeri di telefono, indirizzi, importi, documenti, codici QR e volti direttamente sul dispositivo — senza OCR, senza codice di rete e senza leggere la tua libreria foto.',
    primaryAction: 'Scarica MosaicIt',
    feedbackAction: 'Feedback web',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'Anteprima interattiva dell’oscuramento con MosaicIt',
    peekLabel: 'Tieni premuto per vedere l’originale',
    resetLabel: 'Ripristina maschere',
    receiptTitle: 'Ricevuta di bonifico',
    recipientLabel: 'Beneficiario',
    recipientValue: 'Marco Conti',
    phoneLabel: 'Telefono',
    phoneValue: '+39 02 0000 8920',
    addressLabel: 'Indirizzo',
    addressValue: 'Via degli Aceri 42, Int. 8B',
    amountLabel: 'Importo',
    amountValue: '2.480,00 €',
    cardLabel: 'Conto',
    cardValue: '6222 **** **** 4821',
    qrLabel: 'QR ricevuta',
    styles: {
      solid: 'Tinta unita',
      surround: 'Colore di sfondo',
      blocks: 'Mosaico grigio',
      tinted: 'Mosaico a colori',
      noise: 'Rumore',
    },
    classes: {
      person_name: 'Nome',
      phone: 'Telefono',
      address: 'Indirizzo',
      finance: 'Importo',
      bank_card: 'Carta bancaria',
      qr: 'Codice QR',
    },
  },
  features: {
    title: 'Progettato per un oscuramento rapido e verificabile.',
    subtitle:
      'Apri un’immagine, controlla le aree rilevate, rifinisci se serve ed esporta in pochi secondi.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'Rilevamento locale senza OCR',
        description:
          'I pesi integrati FP16 ONNX / LiteRT rilevano 18 classi di dati sensibili negli screenshot dell’interfaccia più il rilevamento volti con YuNet — senza riconoscimento del testo né download di modelli esterni.',
      },
      {
        tag: '5 stili',
        title: 'Sovrascrittura irreversibile dei pixel',
        description:
          'Scegli Tinta unita, Colore di sfondo, Mosaico grigio, Mosaico a colori o Rumore. Nessuno stile legge i pixel all’interno del riquadro oscurato, impedendo il recupero da pixelatura o sfocatura.',
      },
      {
        tag: 'Autoverifica',
        title: 'Nuova scansione prima dell’esportazione',
        description:
          'Prima di salvare o condividere, MosaicIt può rieseguire il rilevatore sull’immagine oscurata per evidenziare eventuali aree rimaste scoperte.',
      },
      {
        tag: 'Batch e adattivo',
        title: 'Oscuramento in batch e apprendimento locale',
        description:
          'Apri più screenshot insieme, trova regioni simili nell’intero lotto e lascia che l’apprendimento locale adatti le soglie alle tue scelte.',
      },
      {
        tag: 'Editor immediato',
        title: 'Confronto rapido, copia e condivisione di sistema',
        description:
          'Si apre direttamente nell’editor. Tieni premuta l’icona dell’occhio per confrontare con l’originale, copia negli appunti o ricevi file tramite Condividi, Apri con e trascinamento.',
      },
      {
        tag: 'Core Rust + CLI',
        title: 'CLI unseen automatizzabile',
        description:
          'Il motore condiviso unseen-core alimenta sia l’app Flutter sia una CLI autonoma per l’oscuramento in batch e la verifica BLAKE3 dei modelli.',
      },
    ],
    classesTitle: '19 classi supportate',
    classesNote: '18 classi dal modello integrato unseen-det 0.5.0 più il rilevamento volti tramite YuNet.',
  },
  privacy: {
    title: 'Zero rete. Zero accesso in lettura alle foto.',
    subtitle:
      'Ogni garanzia di privacy è imposta a livello di build e permessi di sistema, non solo scritta in un’informativa.',
    factors: [
      {
        tag: 'Binario offline',
        title: 'Nessun codice di rete nell’app',
        description:
          'L’app include i pesi del modello nel pacchetto e non contiene client HTTP, SDK di analisi, segnalazione crash o permessi di rete. La CI verifica zero dipendenze di rete a ogni build.',
      },
      {
        tag: 'Solo selettore di sistema',
        title: 'Nessun permesso di lettura della libreria foto',
        description:
          'iOS usa PHPickerViewController fuori processo e salvataggi in sola scrittura .addOnly. Android usa il Photo Picker di sistema e rimuove i permessi transitivi dai manifest di rilascio.',
      },
    ],
    tableColArea: 'Confine',
    tableColDetail: 'Implementazione',
    rows: [
      {
        area: 'Elaborazione immagini',
        detail:
          'Rilevamento, gestione dell’orientamento EXIF e sovrascrittura dei pixel avvengono localmente in Rust (unseen-core) tramite FFI.',
      },
      {
        area: 'Irreversibilità dell’oscuramento',
        detail:
          'Tinta unita, Mosaico grigio e Rumore ignorano completamente i pixel originali. Colore di sfondo e Mosaico a colori campionano solo un anello di 4 px esterno al riquadro.',
      },
      {
        area: 'Feedback di rilevamento facoltativo',
        detail:
          'Segnalare mancate rilevazioni o falsi positivi apre mosaic.lollipopkit.com/feedback nel browser di sistema tramite un #fragment URL che non finisce mai nei log HTTP GET e viene rimosso con history.replaceState.',
      },
      {
        area: 'Open source riproducibile',
        detail:
          'App, core Rust, worker di feedback e pesi dei modelli rilasciati sono pubblicati sotto licenza AGPL-3.0 con checksum BLAKE3.',
      },
    ],
  },
  download: {
    title: 'Nativa su mobile e desktop.',
    subtitle: 'Le versioni precompilate sono disponibili su GitHub, oppure compila direttamente dai sorgenti.',
    currentBadge: 'Piattaforma attuale',
    releasesAction: 'Release su GitHub',
    sourceAction: 'Compila dai sorgenti',
    cliPrompt: '# Compila la CLI Rust (unseen)',
    appPrompt: '# Avvia l’app Flutter dai sorgenti',
    copy: 'Copia',
    copied: 'Copiato',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Zero permessi in release' },
      linux: { name: 'Linux', meta: 'App desktop (tar.gz) e unseen CLI' },
      windows: { name: 'Windows', meta: 'App desktop (ZIP) e unseen CLI' },
    },
  },
  cta: {
    title: 'Open source con licenza AGPL-3.0.',
    subtitle:
      'Verifica il codice, scarica l’ultima release o segnala le rilevazioni mancate sulla pagina web di feedback.',
    feedbackAction: 'Apri feedback web',
    releasesAction: 'Release su GitHub',
    githubAction: 'Vedi sorgenti',
  },
  more: {
    title: 'Altro da lollipopkit.',
    subtitle: 'Altre app native costruite con la stessa attenzione ingegneristica.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Monitoraggio server, terminale SSH touch, SFTP, Docker, systemd e strumenti S.M.A.R.T. in un unico spazio nativo.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Monta SFTP, S3, WebDAV e archivi remoti nel Finder di macOS tramite Apple File Provider, senza estensioni del kernel.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Client nativo per OpenAI e API LLM compatibili con cronologia locale, chiamate a strumenti ed endpoint personalizzati.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Funzionalità',
    privacy: 'Privacy',
    download: 'Download',
    feedback: 'Feedback',
    releases: 'Release',
    license: 'AGPL-3.0',
  },
};

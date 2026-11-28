import type { Copy } from './types';

export const nl: Copy = {
  meta: {
    lang: 'nl',
    dir: 'ltr',
    title: 'MosaicIt — Privégegevens lokaal onherkenbaar maken',
    description:
      'Detecteer en scherm privégegevens in screenshots en foto’s volledig offline af. Geen OCR, geen netwerkverzoeken en geen leesrechten voor je fotobibliotheek.',
  },
  nav: {
    screenshots: 'Screenshots',
    features: 'Functies',
    privacy: 'Privacy',
    download: 'Downloaden',
    feedback: 'Feedback',
    github: 'GitHub',
    languageLabel: 'Taal',
    cta: 'Downloaden',
  },
  hero: {
    titlePrefix: 'Scherm privégegevens af,',
    titleSuffix: 'volledig offline.',
    subtitle:
      'MosaicIt herkent namen, telefoonnummers, adressen, bedragen, identiteitsnummers, QR-codes en gezichten op je apparaat — zonder OCR, zonder netwerkcode en zonder toegang tot je fotobibliotheek.',
    primaryAction: 'Download MosaicIt',
    feedbackAction: 'Webfeedback',
    githubAction: 'GitHub',
  },
  features: {
    title: 'Gemaakt voor snel en controleerbaar anonimiseren.',
    subtitle:
      'Open een afbeelding, controleer de gedetecteerde gebieden, pas ze aan waar nodig en exporteer binnen enkele seconden.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'Lokale detectie zonder OCR',
        description:
          'Meegeleverde FP16 ONNX / LiteRT-gewichten herkennen 18 klassen persoonsgegevens in UI-screenshots plus gezichtsdetectie via YuNet — zonder tekstherkenning of externe modeldownloads.',
      },
      {
        tag: '5 stijlen',
        title: 'Onomkeerbare pixeloverschrijving',
        description:
          'Kies Effen kleur, Achtergrondkleur, Grijs mozaïek, Kleurenmozaïek of Ruis. Geen enkele stijl leest pixels binnen het afgeschermde vak, zodat terugrekenen van pixelatie of vervaging uitgesloten is.',
      },
      {
        tag: 'Zelfcontrole',
        title: 'Hercontrole vóór export',
        description:
          'Voor het opslaan of delen kan MosaicIt de detector opnieuw over het bewerkte resultaat draaien om gemiste gebieden direct zichtbaar te maken.',
      },
      {
        tag: 'Batch & adaptief',
        title: 'Batchverwerking & lokaal leren',
        description:
          'Open meerdere screenshots tegelijk, vind vergelijkbare gebieden in de hele reeks en laat lokale voorkeurslering drempelwaarden aanpassen aan jouw keuzes.',
      },
      {
        tag: 'Directe editor',
        title: 'Origineel bekijken, kopiëren & delen',
        description:
          'Start direct in de editor. Houd het oogpictogram ingedrukt om met het origineel te vergelijken, kopieer direct naar het klembord of open bestanden via Delen, Openen met en slepen.',
      },
      {
        tag: 'Rust-kern + CLI',
        title: 'Scriptbare unseen CLI',
        description:
          'De gedeelde unseen-core-engine drijft zowel de Flutter-app als een zelfstandige CLI aan voor batchverwerking en BLAKE3-modelverificatie.',
      },
    ],
    classesTitle: '19 ondersteunde klassen',
    classesNote: '18 klassen uit het gebundelde unseen-det 0.5.0 plus gezichtsdetectie via YuNet.',
  },
  privacy: {
    title: 'Geen netwerk. Geen leesrechten voor foto’s.',
    subtitle:
      'Elke privacybelofte wordt afgedwongen op build- en besturingssysteemniveau in plaats van alleen in een beleidstekst.',
    factors: [
      {
        tag: 'Offline binary',
        title: 'Geen netwerkcode in de app',
        description:
          'De app levert de modelgewichten mee en bevat geen HTTP-client, analyse-SDK, crashrapportage of netwerkmachtigingen. CI controleert bij elke build op nul netwerkafhankelijkheden.',
      },
      {
        tag: 'Alleen systeemkiezer',
        title: 'Geen leesrecht voor fotobibliotheek',
        description:
          'iOS gebruikt de externe PHPickerViewController en alleen-schrijven .addOnly voor opslaan. Android gebruikt de systeem-Photo Picker en verwijdert transitieve machtigingen uit release-manifesten.',
      },
    ],
    tableColArea: 'Grens',
    tableColDetail: 'Implementatie',
    rows: [
      {
        area: 'Beeldverwerking',
        detail:
          'Detectie, EXIF-oriëntatie en pixeloverschrijving draaien lokaal in Rust (unseen-core) via FFI.',
      },
      {
        area: 'Onomkeerbaarheid',
        detail:
          'Effen kleur, Grijs mozaïek en Ruis negeren bronpixels volledig. Achtergrondkleur en Kleurenmozaïek bemonsteren alleen een ring van 4 px buiten het vak.',
      },
      {
        area: 'Optionele detectiefeedback',
        detail:
          'Gemiste of onterechte detecties melden opent mosaic.lollipopkit.com/feedback in je systeembrowser via een URL-#fragment dat nooit in HTTP GET-logs terechtkomt en via history.replaceState wordt gewist.',
      },
      {
        area: 'Reproduceerbare open source',
        detail:
          'App, Rust-kern, feedback-worker en uitgebrachte modelgewichten worden gepubliceerd onder AGPL-3.0 met BLAKE3-controlesommen.',
      },
    ],
  },
  download: {
    title: 'Native op mobiel en desktop.',
    subtitle: 'Kant-en-klare releases staan op GitHub, of bouw direct vanuit de broncode.',
    currentBadge: 'Huidig platform',
    releasesAction: 'GitHub Releases',
    sourceAction: 'Bouwen uit broncode',
    cliPrompt: '# Bouw de Rust CLI (unseen)',
    appPrompt: '# Start de Flutter-app vanuit de broncode',
    copy: 'Kopiëren',
    copied: 'Gekopieerd',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Nul release-machtigingen' },
      linux: { name: 'Linux', meta: 'Desktop-app (tar.gz) & unseen CLI' },
      windows: { name: 'Windows', meta: 'Desktop-app (ZIP) & unseen CLI' },
    },
  },
  cta: {
    title: 'Open source onder AGPL-3.0.',
    subtitle:
      'Controleer de code, download de nieuwste versie of meld gemiste detecties op de webfeedbackpagina.',
    feedbackAction: 'Webfeedback openen',
    releasesAction: 'GitHub Releases',
    githubAction: 'Broncode bekijken',
  },
  more: {
    title: 'Meer van lollipopkit.',
    subtitle: 'Andere native apps gebouwd met dezelfde technische focus.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Serverstatusmonitoring, touch-vriendelijke SSH-terminal, SFTP, Docker, systemd en S.M.A.R.T.-tools in één native werkruimte.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Koppel SFTP, S3, WebDAV en externe opslag direct in macOS Finder via Apple File Provider, zonder kernelextensies.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Native client voor OpenAI en compatibele LLM-API’s met lokale chatgeschiedenis, tool-aanroepen en eigen endpoints.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Functies',
    privacy: 'Privacy',
    download: 'Downloaden',
    feedback: 'Feedback',
    releases: 'Releases',
    license: 'AGPL-3.0',
  },
};

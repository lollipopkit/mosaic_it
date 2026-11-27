// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Caricamento modello…';

  @override
  String get modelFileType => 'Modelli';

  @override
  String get useModel => 'Usa modello';

  @override
  String get imagesFileType => 'Immagini';

  @override
  String get detecting => 'Rilevamento…';

  @override
  String detectingProgress(int current, int total) {
    return 'Rilevamento $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Scegli prima un modello';

  @override
  String get findingSimilar => 'Ricerca di elementi simili…';

  @override
  String similarSelected(int found, int added) {
    return 'Selezionate $found regioni simili ($added nuove)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Selezionate $found regioni simili ($added nuove) in $images immagini';
  }

  @override
  String get saving => 'Salvataggio…';

  @override
  String get exportHere => 'Esporta qui';

  @override
  String exportStoppedAt(String name) {
    return 'Esportazione interrotta a $name';
  }

  @override
  String exportedTo(String path) {
    return 'Esportato in $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Esportato in $path (senza audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Esportate $count immagini',
      many: 'Esportate $count immagini',
      few: 'Esportate $count immagini',
      two: 'Esportate 2 immagini',
      one: 'Esportata 1 immagine',
      zero: 'Nessuna immagine esportata',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Verifica di $name…';
  }

  @override
  String get checkingAndExporting => 'Verifica ed esportazione…';

  @override
  String get cancel => 'Annulla';

  @override
  String get exportAnyway => 'Esporta comunque';

  @override
  String get regionsTooltip => 'Regioni';

  @override
  String get cameraPhoto =>
      'Questa è una foto della fotocamera; il rilevatore è fatto per gli screenshot, quindi le sue caselle qui sono inaffidabili.';

  @override
  String get modeDraw => 'Disegna';

  @override
  String get fillSolid => 'Tinta unita';

  @override
  String get fillBlocks => 'Mosaico grigio';

  @override
  String get fillNoise => 'Rumore';

  @override
  String get export => 'Esporta';

  @override
  String pickOneModel(String formats) {
    return 'Scegli esattamente un modello $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Scegli anche $name.json';
  }

  @override
  String get analysing => 'Analisi';

  @override
  String get followingRegion => 'Seguendo la regione';

  @override
  String get exporting => 'Esportazione';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count fotogrammi';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Censura $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Verifica di esportazione non riuscita alle $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count regioni con aspetto privato sono ancora visibili lì ($classes).',
      many:
          '$count regioni con aspetto privato sono ancora visibili lì ($classes).',
      few:
          '$count regioni con aspetto privato sono ancora visibili lì ($classes).',
      two: '2 regioni con aspetto privato sono ancora visibili lì ($classes).',
      one: '1 regione con aspetto privato è ancora visibile lì ($classes).',
      zero:
          'Nessuna regione con aspetto privato è ancora visibile lì ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Mostra fotogramma';

  @override
  String get drawMissedRegion =>
      'Disegna una regione che il rilevatore ha perso';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on di $total tracce censurate · $keyframes fotogrammi chiave';
  }

  @override
  String get keepAudio => 'Mantieni audio';

  @override
  String get keepAudioHint =>
      'Le voci e i suoni di notifica non vengono verificati';

  @override
  String get goToFirstAppearance => 'Vai alla prima apparizione';

  @override
  String get classPersonName => 'Nome';

  @override
  String get classAddress => 'Indirizzo';

  @override
  String get classPhone => 'Telefono';

  @override
  String get classEmail => 'Email';

  @override
  String get classIdNumber => 'Numero di documento';

  @override
  String get classBankCard => 'Carta di credito';

  @override
  String get classPlate => 'Targa';

  @override
  String get classAccountId => 'Account';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Volto';

  @override
  String get classQr => 'Codice QR';

  @override
  String get classBarcode => 'Codice a barre';

  @override
  String get classManual => 'Manuale';

  @override
  String savedModelFailed(String error) {
    return 'Impossibile caricare il modello salvato; seleziona di nuovo un modello. ($error)';
  }

  @override
  String get fillSurround => 'Colore di sfondo';

  @override
  String get fillTinted => 'Mosaico a colori';

  @override
  String get settings => 'Impostazioni';

  @override
  String get classFinance => 'Importo';

  @override
  String get delete => 'Elimina';

  @override
  String get undo => 'Annulla';

  @override
  String get redo => 'Ripristina';

  @override
  String get similar => 'Simili';

  @override
  String get thisImage => 'Questa immagine';

  @override
  String allImagesCount(int count) {
    return 'Tutte le $count immagini';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aree potrebbero essere ancora leggibili',
      many: '$count aree potrebbero essere ancora leggibili',
      few: '$count aree potrebbero essere ancora leggibili',
      two: '2 aree potrebbero essere ancora leggibili',
      one: '1 area potrebbe essere ancora leggibile',
      zero: 'Nessuna area potrebbe essere ancora leggibile',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Dopo l\'oscuramento, il controllo ha ancora rilevato queste aree nell\'output.';

  @override
  String get redactThemAndExport => 'Oscura e esporta';

  @override
  String get showThem => 'Mostra';

  @override
  String get pickClass => 'Scegli una classe';

  @override
  String get appearance => 'Aspetto';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Icona dell’app';

  @override
  String get threshold => 'Soglia';

  @override
  String get thresholdLow => 'Bassa';

  @override
  String get thresholdMedium => 'Media';

  @override
  String get thresholdHigh => 'Alta';

  @override
  String get redaction => 'Oscuramento';

  @override
  String get style => 'Stile';

  @override
  String get selectedByDefault => 'Selezionati per impostazione predefinita';

  @override
  String get dataPrivacy => 'Dati e privacy';

  @override
  String get model => 'Modello';

  @override
  String get importModel => 'Importa un altro modello';

  @override
  String get advanced => 'Avanzate';

  @override
  String get about => 'Informazioni';

  @override
  String get licenses => 'Licenze open source';

  @override
  String get merge => 'Unisci';

  @override
  String get split => 'Separa';

  @override
  String get mergeHint =>
      'Tocca un altro riquadro per renderlo parte dello stesso valore';

  @override
  String get classOrganization => 'Organizzazione';

  @override
  String get classDeviceId => 'ID dispositivo';

  @override
  String get classSecret => 'Credenziale';

  @override
  String get classPerson => 'Persona';

  @override
  String get classHealth => 'Salute';

  @override
  String get classPersonalInfo => 'Dati personali';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total selezionate';
  }

  @override
  String get fillStyle => 'Stile di riempimento';

  @override
  String get colour => 'Colore';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images immagini',
      one: '1 immagine',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions regioni',
      one: '1 regione',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Condividi';

  @override
  String get saveToPhotos => 'Salva in Foto';

  @override
  String get saveAs => 'Salva…';

  @override
  String get exportFormat => 'Formato';

  @override
  String get exportSize => 'Dimensioni';

  @override
  String get sizeOriginal => 'Originale';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count immagini salvate in Foto',
      one: '1 immagine salvata in Foto',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Tutte';

  @override
  String get selectNone => 'Nessuna';

  @override
  String get suggested => 'suggerita';

  @override
  String scoreValue(String score) {
    return 'Punteggio $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Dopo l’oscuramento, il controllo ha ancora rilevato queste aree nell’output dell’immagine $index.';
  }

  @override
  String get reasonNotSelected => 'non selezionata';

  @override
  String get reasonBoxTooSmall => 'riquadro troppo piccolo';

  @override
  String get reasonFillShowsThrough =>
      'il riempimento lascia intravedere il contenuto';

  @override
  String get openSource => 'Codice aperto';

  @override
  String get adaptivePreselectTitle => 'Preselezione adattiva locale';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classi regolate',
      one: '1 classe regolata',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Ripristina preferenze locali';

  @override
  String get adaptiveResetDone => 'Preferenze locali ripristinate';

  @override
  String get feedbackTitle => 'Segnala problema di rilevamento';

  @override
  String get feedbackShort => 'Segnalazioni';

  @override
  String get feedbackMenu => 'Segnala un problema';

  @override
  String get feedbackAction => 'Segnala';

  @override
  String get feedbackAttachScreenshot => 'Allega screenshot';

  @override
  String get feedbackModeMasked => 'Solo errori';

  @override
  String get feedbackModeFull => 'Immagine intera';

  @override
  String get feedbackModeText => 'Nessuna immagine';

  @override
  String get feedbackTagMissed => 'Non rilevato';

  @override
  String get feedbackTagFalsePositive => 'Falso positivo';

  @override
  String get feedbackTagBoxDrift => 'Riquadro spostato';

  @override
  String get feedbackTagWrongClass => 'Classe errata';

  @override
  String get feedbackTagOther => 'Altro';

  @override
  String get feedbackNoteHint => 'Nota facoltativa…';

  @override
  String feedbackCountMasked(int count) {
    return 'Oscurate $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Non rilevate $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Falsi positivi $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Deselezionate $count';
  }

  @override
  String get feedbackBoxMissed => 'Non rilevato';

  @override
  String get feedbackBoxMissedMasked => 'Non rilevato · oscurato';

  @override
  String get feedbackBoxFp => 'Falso positivo';

  @override
  String get feedbackBoxPreference => 'Mantieni visibile';

  @override
  String get introOfflineTitle => 'Nessun accesso alla rete';

  @override
  String get introOfflineBody =>
      'MosaicIt non contiene codice di rete e non richiede permessi di rete. Il modello è integrato nell’app e le immagini non lasciano mai il dispositivo.';

  @override
  String get introNoNetPermTitle => 'Zero permessi di rete';

  @override
  String get introBundledModelTitle => 'Modello integrato sul dispositivo';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · integrato';
  }

  @override
  String get resetBundledModel => 'Usa modello integrato';

  @override
  String get reviewIntro => 'Mostra di nuovo l’introduzione';

  @override
  String get feedbackOpenWeb => 'Apri modulo web';

  @override
  String get introNoNetPermBodyIos =>
      'Nessuna richiesta di rete · solo sul dispositivo';

  @override
  String get introNoNetPermBodyAndroid => 'Nessun permesso INTERNET dichiarato';

  @override
  String get introNoNetPermBodyDesktop =>
      'Nessun accesso di rete nella sandbox';

  @override
  String get customModel => 'Modello personalizzato';

  @override
  String modelClassCount(int count) {
    return '$count classi';
  }

  @override
  String get copyImage => 'Copia immagine';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get copyFailed => 'Impossibile copiare l’immagine';

  @override
  String get peekOriginal => 'Tieni premuto per vedere l’originale';

  @override
  String get selectMedia => 'Seleziona foto';

  @override
  String get saveFailed => 'Impossibile salvare in Foto';

  @override
  String get retry => 'Riprova';

  @override
  String get iosWirelessPromptTitle => 'Avviso dati wireless';

  @override
  String get iosWirelessPromptBody =>
      'L’apertura del selettore foto di sistema può attivare un avviso iOS per le miniature iCloud. MosaicIt non usa la rete: tocca «Non consentire».';

  @override
  String get continueAction => 'Continua';
}

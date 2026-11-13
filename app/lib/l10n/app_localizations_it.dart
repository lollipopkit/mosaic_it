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
  String get reviewButton => 'Rivedi';

  @override
  String get openingLabels => 'Apertura etichette…';

  @override
  String noImagesIn(String name) {
    return 'Nessuna immagine in $name';
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
  String get reviewPseudoLabels =>
      'Rivedi etichette pseudo (cartella con coco.json)';

  @override
  String get regionsTooltip => 'Regioni';

  @override
  String get notCalibrated =>
      'Il modello non è calibrato: la preselezione usa una soglia fissa.';

  @override
  String calibratedUnverified(String domain) {
    return 'Calibrato su dati non verificati ($domain): la garanzia di richiamo non si applica ancora.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Calibrato per immagini $domain. Altri tipi di immagini sono fuori dalla garanzia.';
  }

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
  String get verifyNext => 'Verifica e successivo';

  @override
  String get export => 'Esporta';

  @override
  String get pickOneModel => 'Scegli esattamente un modello .onnx';

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
  String noLabelsIn(String name) {
    return 'Nessun coco.json in $name';
  }

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
  String get collectTitle => 'Raccogli dati di addestramento';

  @override
  String get collectSubtitle =>
      'Conserva su questo dispositivo ogni immagine esportata, le aree rilevate e le tue scelte per addestrare modelli futuri. Non viene caricato nulla.';

  @override
  String collectStats(int count, String size) {
    return '$count immagini · $size';
  }

  @override
  String get collectDelete => 'Elimina dati raccolti';

  @override
  String get collectDeleteConfirm =>
      'Eliminare da questo dispositivo tutte le immagini e le scelte raccolte?';

  @override
  String get delete => 'Elimina';

  @override
  String collectFailed(String error) {
    return 'Impossibile salvare i dati di addestramento: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Etichette salvate per $count immagini';
  }

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
  String annotateOf(int index, int total) {
    return 'Annota $index / $total';
  }

  @override
  String get suggestions => 'Suggerimenti';

  @override
  String get skip => 'Salta';

  @override
  String get nothingPrivate => 'Nessuna informazione privata';

  @override
  String get next => 'Avanti';

  @override
  String get annotateHint =>
      'Tocca una riga di testo per riquadrarla, oppure trascina per disegnare';

  @override
  String get annotationData => 'Dati di annotazione';

  @override
  String get statLabeled => 'Etichettate';

  @override
  String get statEmpty => 'Nessuna informazione privata';

  @override
  String get statSkipped => 'Saltate';

  @override
  String get boxesPerClass => 'Riquadri per classe';

  @override
  String get imagesHeader => 'Immagini';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count riquadri',
      many: '$count riquadri',
      few: '$count riquadri',
      two: '2 riquadri',
      one: '1 riquadro',
      zero: '0 riquadri',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Esporta tutto';

  @override
  String get deleteAll => 'Elimina tutto';

  @override
  String get annotateDeleteConfirm =>
      'Eliminare tutte le annotazioni e le relative immagini da questo dispositivo?';

  @override
  String get noAnnotations =>
      'Nessuna annotazione. Seleziona le immagini e scegli Annota.';

  @override
  String get filterScreenshots => 'Screenshot';

  @override
  String get filterAll => 'Tutte';

  @override
  String get filterVideos => 'Video';

  @override
  String get albums => 'Album';

  @override
  String get limitedAccess =>
      'MosaicIt può visualizzare solo alcune delle tue foto';

  @override
  String get manage => 'Gestisci';

  @override
  String selectedImages(int count) {
    return '$count selezionate';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Oscura $count immagini',
      many: 'Oscura $count immagini',
      few: 'Oscura $count immagini',
      two: 'Oscura 2 immagini',
      one: 'Oscura 1 immagine',
      zero: 'Oscura 0 immagini',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annota';

  @override
  String get badgeRedacted => 'Oscurata';

  @override
  String get badgeAnnotated => 'Annotata';

  @override
  String get photosDenied =>
      'MosaicIt necessita dell\'accesso alle tue foto per mostrarle qui. Le foto non lasciano mai questo dispositivo.';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get openFiles => 'Apri file';

  @override
  String get noPhotos => 'Nessuna foto qui';

  @override
  String get loading => 'Caricamento…';

  @override
  String get appearance => 'Aspetto';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Icona dell’app';

  @override
  String get aspectRatioGrid => 'Griglia con proporzioni originali';

  @override
  String get modelDownloadFailed => 'Impossibile scaricare il modello';

  @override
  String get retry => 'Riprova';

  @override
  String get autoUpdateModel => 'Aggiorna il modello automaticamente';

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
  String get localOnly =>
      'Conservato solo su questo dispositivo, mai in iCloud o nei backup.';

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
  String selectedOf(int selected, int total) {
    return '$selected / $total selected';
  }

  @override
  String get fillStyle => 'Fill style';

  @override
  String get colour => 'Colour';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images images',
      one: '1 image',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions regions',
      one: '1 region',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Share';

  @override
  String get saveToPhotos => 'Save to Photos';

  @override
  String get saveAs => 'Save…';

  @override
  String get saveAndDeleteOriginals => 'Save and delete originals';

  @override
  String get originalsToRecentlyDeleted => 'Originals go to Recently Deleted';

  @override
  String get originalsToTrash => 'Originals go to the trash';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportSize => 'Size';

  @override
  String get sizeOriginal => 'Original';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $count images to Photos',
      one: 'Saved 1 image to Photos',
    );
    return '$_temp0';
  }

  @override
  String originalsNotDeleted(String error) {
    return 'The originals were kept: $error';
  }

  @override
  String get selectAll => 'All';

  @override
  String get selectNone => 'None';

  @override
  String get suggested => 'suggested';

  @override
  String scoreValue(String score) {
    return 'Score $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'After redaction, the check still found these areas in the output of image $index.';
  }

  @override
  String get reasonNotSelected => 'not selected';

  @override
  String get reasonBoxTooSmall => 'box too small';

  @override
  String get reasonFillShowsThrough => 'fill shows through';

  @override
  String get introTitle => 'Choose screenshots to redact';

  @override
  String get introBody =>
      'MosaicIt lists your screenshots here so you can pick the ones to redact. Detection runs on this device, and images never leave it.';

  @override
  String get allowPhotoAccess => 'Allow photo access';

  @override
  String get photosOffTitle => 'Photo access is off';

  @override
  String get openSource => 'Open source';

  @override
  String get downloadingDetector => 'Downloading the detector';

  @override
  String percent(int value) {
    return '$value%';
  }
}

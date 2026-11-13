// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Indlæser model…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Brug model';

  @override
  String get imagesFileType => 'Billeder';

  @override
  String get detecting => 'Søger…';

  @override
  String detectingProgress(int current, int total) {
    return 'Søger $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Vælg en model først';

  @override
  String get findingSimilar => 'Søger efter lignende…';

  @override
  String similarSelected(int found, int added) {
    return '$found lignende områder valgt ($added nye)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found lignende områder valgt ($added nye) på tværs af $images billeder';
  }

  @override
  String get reviewButton => 'Gennemse';

  @override
  String get openingLabels => 'Åbner etiketter…';

  @override
  String noImagesIn(String name) {
    return 'Ingen billeder i $name';
  }

  @override
  String get saving => 'Gemmer…';

  @override
  String get exportHere => 'Eksportér hertil';

  @override
  String exportStoppedAt(String name) {
    return 'Eksport stoppet ved $name';
  }

  @override
  String exportedTo(String path) {
    return 'Eksporteret til $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Eksporteret til $path (ingen lyd)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count billeder eksporteret',
      one: '1 billede eksporteret',
      zero: '0 billeder eksporteret',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Tjekker $name…';
  }

  @override
  String get checkingAndExporting => 'Tjekker og eksporterer…';

  @override
  String get cancel => 'Annullér';

  @override
  String get exportAnyway => 'Eksportér alligevel';

  @override
  String get reviewPseudoLabels =>
      'Gennemse pseudoetiketter (mappe med coco.json)';

  @override
  String get regionsTooltip => 'Områder';

  @override
  String get notCalibrated =>
      'Modellen er ikke kalibreret: forudvælgelse bruger en fast tærskel.';

  @override
  String calibratedUnverified(String domain) {
    return 'Kalibreret på uverificerede data ($domain): garantien for recall gælder endnu ikke.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Kalibreret til $domain-billeder. Andre typer billeder er uden for garantien.';
  }

  @override
  String get cameraPhoto =>
      'Dette er et kamerafoto; detektoren er lavet til skærmbilleder, så dens bokse her er upålidelige.';

  @override
  String get modeDraw => 'Tegn';

  @override
  String get fillSolid => 'Ensfarvet';

  @override
  String get fillBlocks => 'Grå mosaik';

  @override
  String get fillNoise => 'Støj';

  @override
  String get verifyNext => 'Verificér & næste';

  @override
  String get export => 'Eksportér';

  @override
  String get pickOneModel => 'Vælg præcis én .onnx-model';

  @override
  String pickSidecar(String name) {
    return 'Vælg også $name.json';
  }

  @override
  String get analysing => 'Analyserer';

  @override
  String get followingRegion => 'Følger området';

  @override
  String get exporting => 'Eksporterer';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count billeder';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Censurér det $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Eksporttjek fejlede ved $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count private udseende områder er stadig synlige der ($classes).',
      one: '1 privat udseende område er stadig synligt der ($classes).',
      zero: '0 private udseende områder er stadig synlige der ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Vis billede';

  @override
  String get drawMissedRegion => 'Tegn et område, detektoren overså';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on af $total spor censureret · $keyframes nøglebilleder';
  }

  @override
  String get keepAudio => 'Bevar lyd';

  @override
  String get keepAudioHint => 'Stemmer og notifikationslyde tjekkes ikke';

  @override
  String get goToFirstAppearance => 'Gå til første optræden';

  @override
  String get classPersonName => 'Navn';

  @override
  String get classAddress => 'Adresse';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'Personnummer';

  @override
  String get classBankCard => 'Bankkort';

  @override
  String get classPlate => 'Nummerplade';

  @override
  String get classAccountId => 'Konto';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Ansigt';

  @override
  String get classQr => 'QR-kode';

  @override
  String get classBarcode => 'Stregkode';

  @override
  String get classManual => 'Manuel';

  @override
  String noLabelsIn(String name) {
    return 'Ingen coco.json i $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Den gemte model kunne ikke indlæses; vælg en model igen. ($error)';
  }

  @override
  String get fillSurround => 'Baggrundsfarve';

  @override
  String get fillTinted => 'Farvemosaik';

  @override
  String get settings => 'Indstillinger';

  @override
  String get classFinance => 'Beløb';

  @override
  String get collectTitle => 'Indsaml træningsdata';

  @override
  String get collectSubtitle =>
      'Gem hvert eksporteret billede, de fundne områder og dine valg på denne enhed for at træne fremtidige modeller. Intet uploades.';

  @override
  String collectStats(int count, String size) {
    return '$count billeder · $size';
  }

  @override
  String get collectDelete => 'Slet indsamlede data';

  @override
  String get collectDeleteConfirm =>
      'Slet alle indsamlede billeder og valg fra denne enhed?';

  @override
  String get delete => 'Slet';

  @override
  String collectFailed(String error) {
    return 'Træningsdata kunne ikke gemmes: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Etiketter gemt for $count billeder';
  }

  @override
  String get undo => 'Fortryd';

  @override
  String get redo => 'Gentag';

  @override
  String get similar => 'Lignende';

  @override
  String get thisImage => 'Dette billede';

  @override
  String allImagesCount(int count) {
    return 'Alle $count billeder';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count områder kan stadig læses',
      one: '1 område kan stadig læses',
      zero: '0 områder kan stadig læses',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Efter censurering fandt kontrollen stadig disse områder i outputtet.';

  @override
  String get redactThemAndExport => 'Censurér dem og eksportér';

  @override
  String get showThem => 'Vis dem';

  @override
  String get pickClass => 'Vælg en klasse';

  @override
  String annotateOf(int index, int total) {
    return 'Annotér $index / $total';
  }

  @override
  String get suggestions => 'Forslag';

  @override
  String get skip => 'Spring over';

  @override
  String get nothingPrivate => 'Intet privat';

  @override
  String get next => 'Næste';

  @override
  String get annotateHint =>
      'Tryk på en tekstlinje for at boksé den, eller træk for at tegne';

  @override
  String get annotationData => 'Annoteringsdata';

  @override
  String get statLabeled => 'Mærket';

  @override
  String get statEmpty => 'Intet privat';

  @override
  String get statSkipped => 'Sprunget over';

  @override
  String get boxesPerClass => 'Bokse pr. klasse';

  @override
  String get imagesHeader => 'Billeder';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bokse',
      one: '1 boks',
      zero: '0 bokse',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Eksportér alle';

  @override
  String get deleteAll => 'Slet alle';

  @override
  String get annotateDeleteConfirm =>
      'Slet alle annotationer og deres billeder fra denne enhed?';

  @override
  String get noAnnotations =>
      'Ingen annotationer endnu. Vælg billeder og vælg Annotér.';

  @override
  String get filterScreenshots => 'Skærmbilleder';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterVideos => 'Videoer';

  @override
  String get albums => 'Albums';

  @override
  String get limitedAccess => 'MosaicIt kan kun se nogle af dine fotos';

  @override
  String get manage => 'Administrér';

  @override
  String selectedImages(int count) {
    return '$count valgt';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Censurér $count billeder',
      one: 'Censurér 1 billede',
      zero: 'Censurér 0 billeder',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annotér';

  @override
  String get badgeRedacted => 'Censureret';

  @override
  String get badgeAnnotated => 'Annoteret';

  @override
  String get photosDenied =>
      'MosaicIt har brug for adgang til dine fotos for at vise dem her. Fotos forlader aldrig denne enhed.';

  @override
  String get openSettings => 'Åbn Indstillinger';

  @override
  String get openFiles => 'Åbn filer';

  @override
  String get noPhotos => 'Ingen fotos her';

  @override
  String get loading => 'Indlæser…';

  @override
  String get appearance => 'Udseende';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Appsymbol';

  @override
  String get aspectRatioGrid => 'Gitter med billedformat';

  @override
  String get modelDownloadFailed => 'Modellen kunne ikke hentes';

  @override
  String get retry => 'Prøv igen';

  @override
  String get autoUpdateModel => 'Opdater modellen automatisk';

  @override
  String get threshold => 'Tærskel';

  @override
  String get thresholdLow => 'Lav';

  @override
  String get thresholdMedium => 'Middel';

  @override
  String get thresholdHigh => 'Høj';

  @override
  String get redaction => 'Censurering';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Valgt som standard';

  @override
  String get dataPrivacy => 'Data og privatliv';

  @override
  String get localOnly =>
      'Opbevares kun på denne enhed, aldrig i iCloud eller sikkerhedskopier.';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Importér en anden model';

  @override
  String get advanced => 'Avanceret';

  @override
  String get about => 'Om';

  @override
  String get licenses => 'Open source-licenser';

  @override
  String get merge => 'Flet';

  @override
  String get split => 'Opdel';

  @override
  String get mergeHint =>
      'Tryk på en anden boks for at gøre den en del af samme værdi';

  @override
  String get classOrganization => 'Organisation';

  @override
  String get classDeviceId => 'Enheds-id';

  @override
  String get classSecret => 'Hemmelighed';

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

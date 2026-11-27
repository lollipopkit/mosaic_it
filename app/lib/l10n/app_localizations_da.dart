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
  String get regionsTooltip => 'Områder';

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
  String get export => 'Eksportér';

  @override
  String pickOneModel(String formats) {
    return 'Vælg præcis én $formats-model';
  }

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
  String get delete => 'Slet';

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
  String get appearance => 'Udseende';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Appsymbol';

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
  String get classPerson => 'Person';

  @override
  String get classHealth => 'Helbred';

  @override
  String get classPersonalInfo => 'Personlige oplysninger';

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
  String get openSource => 'Open source';

  @override
  String get adaptivePreselectTitle => 'Local adaptive pre-selection';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes adjusted',
      one: '1 class adjusted',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Reset local preferences';

  @override
  String get adaptiveResetDone => 'Local preferences reset';

  @override
  String get feedbackTitle => 'Report detection issue';

  @override
  String get feedbackShort => 'Feedback';

  @override
  String get feedbackMenu => 'Report issue';

  @override
  String get feedbackAction => 'Report';

  @override
  String get feedbackAttachScreenshot => 'Attach screenshot';

  @override
  String get feedbackModeMasked => 'Errors only';

  @override
  String get feedbackModeFull => 'Full image';

  @override
  String get feedbackModeText => 'No image';

  @override
  String get feedbackTagMissed => 'Missed';

  @override
  String get feedbackTagFalsePositive => 'False positive';

  @override
  String get feedbackTagBoxDrift => 'Box drift';

  @override
  String get feedbackTagWrongClass => 'Wrong class';

  @override
  String get feedbackTagOther => 'Other';

  @override
  String get feedbackNoteHint => 'Optional note…';

  @override
  String feedbackCountMasked(int count) {
    return 'Masked $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Missed $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'False positive $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Unchecked $count';
  }

  @override
  String get feedbackBoxMissed => 'Missed';

  @override
  String get feedbackBoxMissedMasked => 'Missed · masked';

  @override
  String get feedbackBoxFp => 'False positive';

  @override
  String get feedbackBoxPreference => 'Keep visible';

  @override
  String get introOfflineTitle => 'No network access';

  @override
  String get introOfflineBody =>
      'MosaicIt contains no networking code and requests no network permission. The detector is bundled inside the app, and images and videos never leave your device.';

  @override
  String get introNoNetPermTitle => 'Zero network permissions';

  @override
  String get introBundledModelTitle => 'Bundled on-device model';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · on-device';
  }

  @override
  String get resetBundledModel => 'Use bundled model';

  @override
  String get reviewIntro => 'Show intro again';

  @override
  String get feedbackOpenWeb => 'Open web form';

  @override
  String get introNoNetPermBodyIos => 'No network requests · on-device only';

  @override
  String get introNoNetPermBodyAndroid => 'No INTERNET permission declared';

  @override
  String get introNoNetPermBodyDesktop => 'No network entitlement in sandbox';

  @override
  String get customModel => 'Custom model';

  @override
  String modelClassCount(int count) {
    return '$count classes';
  }

  @override
  String get copyImage => 'Copy image';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copyFailed => 'Could not copy image';

  @override
  String get peekOriginal => 'Hold to compare original';

  @override
  String get selectMedia => 'Select photos or video';

  @override
  String get saveFailed => 'Could not save to Photos';

  @override
  String get retry => 'Retry';

  @override
  String get iosWirelessPromptTitle => 'Wireless data prompt';

  @override
  String get iosWirelessPromptBody =>
      'Opening the system photo picker may trigger an iOS wireless data prompt for iCloud thumbnails. MosaicIt does not use the network — tap “Don’t Allow”.';

  @override
  String get continueAction => 'Continue';
}

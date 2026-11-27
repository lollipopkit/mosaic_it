// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Läser in modell…';

  @override
  String get modelFileType => 'Modeller';

  @override
  String get useModel => 'Använd modell';

  @override
  String get imagesFileType => 'Bilder';

  @override
  String get detecting => 'Detekterar…';

  @override
  String detectingProgress(int current, int total) {
    return 'Detekterar $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Välj en modell först';

  @override
  String get findingSimilar => 'Söker efter liknande…';

  @override
  String similarSelected(int found, int added) {
    return '$found liknande områden markerade ($added nya)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found liknande områden markerade ($added nya) i $images bilder';
  }

  @override
  String get saving => 'Sparar…';

  @override
  String get exportHere => 'Exportera hit';

  @override
  String exportStoppedAt(String name) {
    return 'Exporten stoppades vid $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exporterad till $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exporterad till $path (ingen ljudspår)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilder exporterade',
      many: 'Många bilder exporterade',
      few: 'Få bilder exporterade',
      two: '2 bilder exporterade',
      one: '1 bild exporterad',
      zero: '0 bilder exporterade',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Kontrollerar $name…';
  }

  @override
  String get checkingAndExporting => 'Kontrollerar och exporterar…';

  @override
  String get cancel => 'Avbryt';

  @override
  String get exportAnyway => 'Exportera ändå';

  @override
  String get regionsTooltip => 'Områden';

  @override
  String get cameraPhoto =>
      'Detta är ett kamerabild; detektorn är gjord för skärmdumpar, så rutor här är opålitliga.';

  @override
  String get modeDraw => 'Rita';

  @override
  String get fillSolid => 'Enfärgad';

  @override
  String get fillBlocks => 'Grå mosaik';

  @override
  String get fillNoise => 'Brus';

  @override
  String get export => 'Exportera';

  @override
  String pickOneModel(String formats) {
    return 'Välj exakt en $formats-modell';
  }

  @override
  String pickSidecar(String name) {
    return 'Välj också $name.json';
  }

  @override
  String get analysing => 'Analyserar';

  @override
  String get followingRegion => 'Följer området';

  @override
  String get exporting => 'Exporterar';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count bildrutor';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redigerar den $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Exportkontrollen misslyckades vid $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count privata områden är fortfarande synliga där ($classes).',
      many: 'Många privata områden är fortfarande synliga där ($classes).',
      few: 'Få privata områden är fortfarande synliga där ($classes).',
      two: '2 privata områden är fortfarande synliga där ($classes).',
      one: '1 privat område är fortfarande synligt där ($classes).',
      zero: 'Inga privata områden är synliga där.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Visa bildruta';

  @override
  String get drawMissedRegion => 'Rita ett område detektorn missade';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on av $total spår redigerade · $keyframes nyckelbilder';
  }

  @override
  String get keepAudio => 'Behåll ljud';

  @override
  String get keepAudioHint => 'Röster och notisljud kontrolleras inte';

  @override
  String get goToFirstAppearance => 'Gå till första framträdandet';

  @override
  String get classPersonName => 'Namn';

  @override
  String get classAddress => 'Adress';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-post';

  @override
  String get classIdNumber => 'Personnummer';

  @override
  String get classBankCard => 'Bankkort';

  @override
  String get classPlate => 'Registreringsnummer';

  @override
  String get classAccountId => 'Konto';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Ansikte';

  @override
  String get classQr => 'QR-kod';

  @override
  String get classBarcode => 'Streckkod';

  @override
  String get classManual => 'Manuell';

  @override
  String savedModelFailed(String error) {
    return 'Den sparade modellen kunde inte läsas in; välj en modell igen. ($error)';
  }

  @override
  String get fillSurround => 'Bakgrundsfärg';

  @override
  String get fillTinted => 'Färgmosaik';

  @override
  String get settings => 'Inställningar';

  @override
  String get classFinance => 'Belopp';

  @override
  String get delete => 'Radera';

  @override
  String get undo => 'Ångra';

  @override
  String get redo => 'Gör om';

  @override
  String get similar => 'Liknande';

  @override
  String get thisImage => 'Den här bilden';

  @override
  String allImagesCount(int count) {
    return 'Alla $count bilder';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count områden kan fortfarande vara läsbara',
      many: 'Många områden kan fortfarande vara läsbara',
      few: 'Få områden kan fortfarande vara läsbara',
      two: '2 områden kan fortfarande vara läsbara',
      one: '1 område kan fortfarande vara läsbar',
      zero: '0 områden kan fortfarande vara läsbara',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Efter redigering hittade kontrollen fortfarande dessa områden i utdata.';

  @override
  String get redactThemAndExport => 'Redigera dem och exportera';

  @override
  String get showThem => 'Visa dem';

  @override
  String get pickClass => 'Välj en klass';

  @override
  String get appearance => 'Utseende';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Appsymbol';

  @override
  String get threshold => 'Tröskel';

  @override
  String get thresholdLow => 'Låg';

  @override
  String get thresholdMedium => 'Medel';

  @override
  String get thresholdHigh => 'Hög';

  @override
  String get redaction => 'Redigering';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Valt som standard';

  @override
  String get dataPrivacy => 'Data och integritet';

  @override
  String get model => 'Modell';

  @override
  String get importModel => 'Importera en annan modell';

  @override
  String get advanced => 'Avancerat';

  @override
  String get about => 'Om';

  @override
  String get licenses => 'Öppen källkodslicenser';

  @override
  String get merge => 'Slå ihop';

  @override
  String get split => 'Dela';

  @override
  String get mergeHint =>
      'Tryck på en annan ruta för att göra den till en del av samma värde';

  @override
  String get classOrganization => 'Organisation';

  @override
  String get classDeviceId => 'Enhets-ID';

  @override
  String get classSecret => 'Hemlighet';

  @override
  String get classPerson => 'Person';

  @override
  String get classHealth => 'Hälsa';

  @override
  String get classPersonalInfo => 'Personuppgifter';

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
}

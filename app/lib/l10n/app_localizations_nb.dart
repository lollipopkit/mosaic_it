// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Laster modell…';

  @override
  String get modelFileType => 'Modeller';

  @override
  String get useModel => 'Bruk modell';

  @override
  String get imagesFileType => 'Bilder';

  @override
  String get detecting => 'Søker…';

  @override
  String detectingProgress(int current, int total) {
    return 'Søker $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Velg en modell først';

  @override
  String get findingSimilar => 'Søker etter lignende…';

  @override
  String similarSelected(int found, int added) {
    return '$found lignende områder valgt ($added nye)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found lignende områder valgt ($added nye) i $images bilder';
  }

  @override
  String get saving => 'Lagrer…';

  @override
  String get exportHere => 'Eksporter hit';

  @override
  String exportStoppedAt(String name) {
    return 'Eksportering stoppet ved $name';
  }

  @override
  String exportedTo(String path) {
    return 'Eksportert til $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Eksportert til $path (uten lyd)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eksportert $count bilder',
      many: 'Eksportert $count bilder',
      few: 'Eksportert $count bilder',
      two: 'Eksportert 2 bilder',
      one: 'Eksportert 1 bilde',
      zero: 'Eksportert 0 bilder',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Sjekker $name…';
  }

  @override
  String get checkingAndExporting => 'Sjekker og eksporterer…';

  @override
  String get cancel => 'Avbryt';

  @override
  String get exportAnyway => 'Eksporter likevel';

  @override
  String get regionsTooltip => 'Områder';

  @override
  String get cameraPhoto =>
      'Dette er et kamerafoto; detektoren er laget for skjermbilder, så boksene her er upålitelige.';

  @override
  String get modeDraw => 'Tegn';

  @override
  String get fillSolid => 'Ensfarget';

  @override
  String get fillBlocks => 'Grå mosaikk';

  @override
  String get fillNoise => 'Støy';

  @override
  String get export => 'Eksporter';

  @override
  String pickOneModel(String formats) {
    return 'Velg nøyaktig én $formats-modell';
  }

  @override
  String pickSidecar(String name) {
    return 'Velg også $name.json';
  }

  @override
  String get analysing => 'Analyserer';

  @override
  String get followingRegion => 'Følger området';

  @override
  String get exporting => 'Eksporterer';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count bilder';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redigerer den $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Eksportsjekk feilet ved $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count private-seende områder er fortsatt synlige der ($classes).',
      many: '$count private-seende områder er fortsatt synlige der ($classes).',
      few: '$count private-seende områder er fortsatt synlige der ($classes).',
      two: '2 private-seende områder er fortsatt synlige der ($classes).',
      one: '1 private-seende område er fortsatt synlig der ($classes).',
      zero: '0 private-seende områder er fortsatt synlige der ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Vis bilde';

  @override
  String get drawMissedRegion => 'Tegn et område detektoren gikk glipp av';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on av $total spor redigert · $keyframes nøkkelbilder';
  }

  @override
  String get keepAudio => 'Behold lyd';

  @override
  String get keepAudioHint => 'Røster og varselløyd sjekkes ikke';

  @override
  String get goToFirstAppearance => 'Gå til første opptreden';

  @override
  String get classPersonName => 'Navn';

  @override
  String get classAddress => 'Adresse';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-post';

  @override
  String get classIdNumber => 'ID-nummer';

  @override
  String get classBankCard => 'Bankkort';

  @override
  String get classPlate => 'Skilt';

  @override
  String get classAccountId => 'Konto';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Ansikt';

  @override
  String get classQr => 'QR-kode';

  @override
  String get classBarcode => 'Strekode';

  @override
  String get classManual => 'Manuell';

  @override
  String savedModelFailed(String error) {
    return 'Den lagrede modellen kunne ikke lastes. Velg en modell på nytt. ($error)';
  }

  @override
  String get fillSurround => 'Bakgrunnsfarge';

  @override
  String get fillTinted => 'Fargemosaikk';

  @override
  String get settings => 'Innstillinger';

  @override
  String get classFinance => 'Beløp';

  @override
  String get delete => 'Slett';

  @override
  String get undo => 'Angre';

  @override
  String get redo => 'Gjør om';

  @override
  String get similar => 'Lignende';

  @override
  String get thisImage => 'Dette bildet';

  @override
  String allImagesCount(int count) {
    return 'Alle $count bilder';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count områder kan fortsatt leses',
      many: '$count områder kan fortsatt leses',
      few: '$count områder kan fortsatt leses',
      two: '2 områder kan fortsatt leses',
      one: '1 område kan fortsatt leses',
      zero: '0 områder kan fortsatt leses',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Etter redigering fant sjekken fortsatt disse områdene i utdataene.';

  @override
  String get redactThemAndExport => 'Rediger dem og eksporter';

  @override
  String get showThem => 'Vis dem';

  @override
  String get pickClass => 'Velg en klasse';

  @override
  String get appearance => 'Utseende';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Appsymbol';

  @override
  String get threshold => 'Terskel';

  @override
  String get thresholdLow => 'Lav';

  @override
  String get thresholdMedium => 'Middels';

  @override
  String get thresholdHigh => 'Høy';

  @override
  String get redaction => 'Redigering';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Valgt som standard';

  @override
  String get dataPrivacy => 'Data og personvern';

  @override
  String get model => 'Modell';

  @override
  String get importModel => 'Importer en annen modell';

  @override
  String get advanced => 'Avansert';

  @override
  String get about => 'Om';

  @override
  String get licenses => 'Åpen kildekode-lisenser';

  @override
  String get merge => 'Slå sammen';

  @override
  String get split => 'Del opp';

  @override
  String get mergeHint =>
      'Trykk på en annen boks for å gjøre den til en del av samme verdi';

  @override
  String get classOrganization => 'Organisasjon';

  @override
  String get classDeviceId => 'Enhets-ID';

  @override
  String get classSecret => 'Hemmelighet';

  @override
  String get classPerson => 'Person';

  @override
  String get classHealth => 'Helse';

  @override
  String get classPersonalInfo => 'Personopplysninger';

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

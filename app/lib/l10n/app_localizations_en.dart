// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Loading model…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Use model';

  @override
  String get imagesFileType => 'Images';

  @override
  String get detecting => 'Detecting…';

  @override
  String detectingProgress(int current, int total) {
    return 'Detecting $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Choose a model first';

  @override
  String get findingSimilar => 'Finding similar…';

  @override
  String similarSelected(int found, int added) {
    return '$found similar regions selected ($added new)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found similar regions selected ($added new) across $images images';
  }

  @override
  String get saving => 'Saving…';

  @override
  String get exportHere => 'Export here';

  @override
  String exportStoppedAt(String name) {
    return 'Export stopped at $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exported to $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exported to $path (no audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Exported $count images',
      one: 'Exported 1 image',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Checking $name…';
  }

  @override
  String get checkingAndExporting => 'Checking and exporting…';

  @override
  String get cancel => 'Cancel';

  @override
  String get exportAnyway => 'Export anyway';

  @override
  String get regionsTooltip => 'Regions';

  @override
  String get cameraPhoto =>
      'This is a camera photo; the detector is made for screenshots, so its boxes here are unreliable.';

  @override
  String get modeDraw => 'Draw';

  @override
  String get fillSolid => 'Solid colour';

  @override
  String get fillBlocks => 'Grey mosaic';

  @override
  String get fillNoise => 'Noise';

  @override
  String get export => 'Export';

  @override
  String pickOneModel(String formats) {
    return 'Pick exactly one $formats model';
  }

  @override
  String pickSidecar(String name) {
    return 'Also pick $name.json';
  }

  @override
  String get analysing => 'Analysing';

  @override
  String get followingRegion => 'Following the region';

  @override
  String get exporting => 'Exporting';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count frames';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redacting it $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Export check failed at $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count private-looking regions are still visible there ($classes).',
      one: '1 private-looking region is still visible there ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Show frame';

  @override
  String get drawMissedRegion => 'Draw a region the detector missed';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on of $total tracks redacted · $keyframes keyframes';
  }

  @override
  String get keepAudio => 'Keep audio';

  @override
  String get keepAudioHint => 'Voices and notification sounds are not checked';

  @override
  String get goToFirstAppearance => 'Go to first appearance';

  @override
  String get classPersonName => 'Name';

  @override
  String get classAddress => 'Address';

  @override
  String get classPhone => 'Phone';

  @override
  String get classEmail => 'Email';

  @override
  String get classIdNumber => 'ID number';

  @override
  String get classBankCard => 'Bank card';

  @override
  String get classPlate => 'Plate';

  @override
  String get classAccountId => 'Account';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Face';

  @override
  String get classQr => 'QR code';

  @override
  String get classBarcode => 'Barcode';

  @override
  String get classManual => 'Manual';

  @override
  String savedModelFailed(String error) {
    return 'The saved model could not be loaded; choose a model again. ($error)';
  }

  @override
  String get fillSurround => 'Background colour';

  @override
  String get fillTinted => 'Colour mosaic';

  @override
  String get settings => 'Settings';

  @override
  String get classFinance => 'Finance';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get similar => 'Similar';

  @override
  String get thisImage => 'This image';

  @override
  String allImagesCount(int count) {
    return 'All $count images';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count areas may still be readable',
      one: '1 area may still be readable',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'After redaction, the check still found these areas in the output.';

  @override
  String get redactThemAndExport => 'Redact them and export';

  @override
  String get showThem => 'Show them';

  @override
  String get pickClass => 'Choose a class';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get appIcon => 'App icon';

  @override
  String get threshold => 'Threshold';

  @override
  String get thresholdLow => 'Low';

  @override
  String get thresholdMedium => 'Medium';

  @override
  String get thresholdHigh => 'High';

  @override
  String get redaction => 'Redaction';

  @override
  String get style => 'Style';

  @override
  String get selectedByDefault => 'Selected by default';

  @override
  String get dataPrivacy => 'Data and privacy';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Import another model';

  @override
  String get advanced => 'Advanced';

  @override
  String get about => 'About';

  @override
  String get licenses => 'Open-source licences';

  @override
  String get merge => 'Merge';

  @override
  String get split => 'Split';

  @override
  String get mergeHint => 'Tap another box to make it part of the same value';

  @override
  String get classOrganization => 'Organization';

  @override
  String get classDeviceId => 'Device ID';

  @override
  String get classSecret => 'Secret';

  @override
  String get classPerson => 'Person';

  @override
  String get classHealth => 'Health';

  @override
  String get classPersonalInfo => 'Personal info';

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

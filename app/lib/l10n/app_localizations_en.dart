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
  String get reviewButton => 'Review';

  @override
  String get openingLabels => 'Opening labels…';

  @override
  String noImagesIn(String name) {
    return 'No images in $name';
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
  String get reviewPseudoLabels =>
      'Review pseudo-labels (folder with coco.json)';

  @override
  String get regionsTooltip => 'Regions';

  @override
  String get notCalibrated =>
      'Model is not calibrated: pre-selection uses a fixed threshold.';

  @override
  String calibratedUnverified(String domain) {
    return 'Calibrated on unverified data ($domain): the recall guarantee does not apply yet.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Calibrated for $domain images. Other kinds of images are outside the guarantee.';
  }

  @override
  String get cameraPhoto =>
      'This is a camera photo; the detector is made for screenshots, so its boxes here are unreliable.';

  @override
  String get modeDraw => 'Draw';

  @override
  String get fillLabel => 'Fill';

  @override
  String get fillSolid => 'Solid colour';

  @override
  String get fillBlocks => 'Grey mosaic';

  @override
  String get fillNoise => 'Noise';

  @override
  String get verifyNext => 'Verify & next';

  @override
  String get export => 'Export';

  @override
  String get pickOneModel => 'Pick exactly one .onnx model';

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
  String noLabelsIn(String name) {
    return 'No coco.json in $name';
  }

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
  String get collectTitle => 'Collect training data';

  @override
  String get collectSubtitle =>
      'Keep each exported image, the detected boxes and your choices on this device to train future models. Nothing is uploaded.';

  @override
  String collectStats(int count, String size) {
    return '$count images · $size';
  }

  @override
  String get collectDelete => 'Delete collected data';

  @override
  String get collectDeleteConfirm =>
      'Delete all collected images and choices from this device?';

  @override
  String get delete => 'Delete';

  @override
  String collectFailed(String error) {
    return 'Could not save training data: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Saved labels for $count images';
  }

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
  String annotateOf(int index, int total) {
    return 'Annotate $index / $total';
  }

  @override
  String get suggestions => 'Suggestions';

  @override
  String get skip => 'Skip';

  @override
  String get nothingPrivate => 'Nothing private';

  @override
  String get next => 'Next';

  @override
  String get annotateHint => 'Tap a text line to box it, or drag to draw';

  @override
  String get annotationData => 'Annotation data';

  @override
  String get statLabeled => 'Labelled';

  @override
  String get statEmpty => 'Nothing private';

  @override
  String get statSkipped => 'Skipped';

  @override
  String get boxesPerClass => 'Boxes per class';

  @override
  String get imagesHeader => 'Images';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boxes',
      one: '1 box',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Export all';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get annotateDeleteConfirm =>
      'Delete all annotations and their images from this device?';

  @override
  String get noAnnotations =>
      'No annotations yet. Select images and choose Annotate.';

  @override
  String get filterScreenshots => 'Screenshots';

  @override
  String get filterAll => 'All';

  @override
  String get filterVideos => 'Videos';

  @override
  String get albums => 'Albums';

  @override
  String get limitedAccess => 'MosaicIt can see only some of your photos';

  @override
  String get manage => 'Manage';

  @override
  String selectedImages(int count) {
    return '$count selected';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redact $count images',
      one: 'Redact 1 image',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annotate';

  @override
  String get badgeRedacted => 'Redacted';

  @override
  String get badgeAnnotated => 'Annotated';

  @override
  String get photosDenied =>
      'MosaicIt needs access to your photos to show them here. Photos never leave this device.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get openFiles => 'Open files';

  @override
  String get noPhotos => 'No photos here';

  @override
  String get loading => 'Loading…';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get appIcon => 'App icon';

  @override
  String get aspectRatioGrid => 'Aspect ratio grid';

  @override
  String get modelDownloadFailed => 'The model could not be downloaded';

  @override
  String get retry => 'Retry';

  @override
  String get autoUpdateModel => 'Update the model automatically';

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
  String get localOnly =>
      'Kept on this device only, never in iCloud or backups.';

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
}

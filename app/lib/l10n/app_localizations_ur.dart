// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'ماڈل لوڈ ہو رہا ہے…';

  @override
  String get modelFileType => 'ماڈل';

  @override
  String get useModel => 'ماڈل استعمال کریں';

  @override
  String get imagesFileType => 'تصاویر';

  @override
  String get detecting => 'تشخیص ہو رہی ہے…';

  @override
  String detectingProgress(int current, int total) {
    return 'تشخیص $current/$total…';
  }

  @override
  String get chooseModelFirst => 'پہلے ماڈل منتخب کریں';

  @override
  String get findingSimilar => 'مشابہ تلاش ہو رہا ہے…';

  @override
  String similarSelected(int found, int added) {
    return '$found مشابہ علاقے منتخب کیے گئے ($added نئے)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found مشابہ علاقے $images تصاویر میں منتخب کیے گئے ($added نئے)';
  }

  @override
  String get saving => 'محفوظ ہو رہا ہے…';

  @override
  String get exportHere => 'یہاں ایکسپورٹ کریں';

  @override
  String exportStoppedAt(String name) {
    return 'ایکسپورٹ $name پر روک دی گئی';
  }

  @override
  String exportedTo(String path) {
    return '$path میں ایکسپورٹ کیا گیا';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path میں ایکسپورٹ کیا گیا (آواز کے بغیر)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تصاویر ایکسپورٹ کی گئیں',
      many: '$count تصاویر ایکسپورٹ کی گئیں',
      few: '$count تصاویر ایکسپورٹ کی گئیں',
      two: '2 تصاویر ایکسپورٹ کی گئیں',
      one: '1 تصویر ایکسپورٹ کی گئی',
      zero: 'کوئی تصویر ایکسپورٹ نہیں کی گئی',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name کی جانچ ہو رہی ہے…';
  }

  @override
  String get checkingAndExporting => 'جانچ اور ایکسپورٹ ہو رہا ہے…';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get exportAnyway => 'پھر بھی ایکسپورٹ کریں';

  @override
  String get regionsTooltip => 'علاقے';

  @override
  String get cameraPhoto =>
      'یہ کیمرے کی تصویر ہے؛ ڈیٹیکٹر اسکرین شاٹس کے لیے بنایا گیا ہے، اس لیے یہاں اس کے باکسز غیر قابل اعتماد ہیں۔';

  @override
  String get modeDraw => 'بنائیں';

  @override
  String get fillSolid => 'ٹھوس رنگ';

  @override
  String get fillBlocks => 'سرمئی موزیک';

  @override
  String get fillNoise => 'ناز';

  @override
  String get export => 'ایکسپورٹ';

  @override
  String pickOneModel(String formats) {
    return 'بالکل ایک $formats ماڈل منتخب کریں';
  }

  @override
  String pickSidecar(String name) {
    return '$name.json بھی منتخب کریں';
  }

  @override
  String get analysing => 'تجزیہ ہو رہا ہے';

  @override
  String get followingRegion => 'علاقے کی پیروی کر رہا ہے';

  @override
  String get exporting => 'ایکسپورٹ ہو رہا ہے';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count فریمز';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'اسے $start – $end پر ریڈیکٹ کر رہا ہے';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'ایکسپورٹ کی جانچ $time پر ناکام ہوئی';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نجی لگنے والے علاقے ابھی بھی نظر آ رہے ہیں ($classes)۔',
      many: '$count نجی لگنے والے علاقے ابھی بھی نظر آ رہے ہیں ($classes)۔',
      few: '$count نجی لگنے والے علاقے ابھی بھی نظر آ رہے ہیں ($classes)۔',
      two: 'وہاں 2 نجی لگنے والے علاقے ابھی بھی نظر آ رہے ہیں ($classes)۔',
      one: 'وہاں 1 نجی لگنے والا علاقہ ابھی بھی نظر آ رہا ہے ($classes)۔',
      zero: 'وہاں کوئی نجی لگنے والا علاقہ نظر نہیں آ رہا ($classes)۔',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'فریم دکھائیں';

  @override
  String get drawMissedRegion => 'ایسا علاقہ بنائیں جسے ڈیٹیکٹر نے چھوڑ دیا';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$total میں سے $on ٹریکس ریڈیکٹ کی گئیں · $keyframes کلیدی فریمز';
  }

  @override
  String get keepAudio => 'آواز برقرار رکھیں';

  @override
  String get keepAudioHint =>
      'آوازیں اور نوٹیفیکیشن کی آوازیں چیک نہیں کی جاتیں';

  @override
  String get goToFirstAppearance => 'پہلی ظاہری شکل پر جائیں';

  @override
  String get classPersonName => 'نام';

  @override
  String get classAddress => 'پتہ';

  @override
  String get classPhone => 'فون';

  @override
  String get classEmail => 'ای میل';

  @override
  String get classIdNumber => 'آئی ڈی نمبر';

  @override
  String get classBankCard => 'بینک کارڈ';

  @override
  String get classPlate => 'پلیٹ';

  @override
  String get classAccountId => 'اکاؤنٹ';

  @override
  String get classAvatar => 'اواٹار';

  @override
  String get classFace => 'چہرہ';

  @override
  String get classQr => 'QR کوڈ';

  @override
  String get classBarcode => 'بارکوڈ';

  @override
  String get classManual => 'مینیول';

  @override
  String savedModelFailed(String error) {
    return 'محفوظ شدہ ماڈل لوڈ نہیں ہو سکا؛ دوبارہ ماڈل منتخب کریں۔ ($error)';
  }

  @override
  String get fillSurround => 'پس منظر کا رنگ';

  @override
  String get fillTinted => 'رنگین موزیک';

  @override
  String get settings => 'ترتیبات';

  @override
  String get classFinance => 'رقم';

  @override
  String get delete => 'حذف کریں';

  @override
  String get undo => 'واپس لے';

  @override
  String get redo => 'دوبارہ کریں';

  @override
  String get similar => 'مشابہ';

  @override
  String get thisImage => 'یہ تصویر';

  @override
  String allImagesCount(int count) {
    return 'تمام $count تصاویر';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count علاقے پڑھے جا سکتے ہیں',
      many: '$count علاقے پڑھے جا سکتے ہیں',
      few: '$count علاقے پڑھے جا سکتے ہیں',
      two: '2 علاقے پڑھے جا سکتے ہیں',
      one: '1 علاقہ پڑھا جا سکتا ہے',
      zero: 'کوئی علاقہ پڑھا جا سکتا ہے',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'پوشیدگی کے بعد، جانچ نے آؤٹ پٹ میں ان علاقوں کو دوبارہ دریافت کیا۔';

  @override
  String get redactThemAndExport => 'انہیں پوشیدہ کریں اور برآمد کریں';

  @override
  String get showThem => 'انہیں دکھائیں';

  @override
  String get pickClass => 'کلاس منتخب کریں';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get theme => 'تھیم';

  @override
  String get appIcon => 'ایپ آئیکن';

  @override
  String get threshold => 'حد';

  @override
  String get thresholdLow => 'کم';

  @override
  String get thresholdMedium => 'درمیانی';

  @override
  String get thresholdHigh => 'زیادہ';

  @override
  String get redaction => 'پوشیدگی';

  @override
  String get style => 'اسٹائل';

  @override
  String get selectedByDefault => 'بطور ڈیفالٹ منتخب';

  @override
  String get dataPrivacy => 'ڈیٹا اور رازداری';

  @override
  String get model => 'ماڈل';

  @override
  String get importModel => 'کوئی اور ماڈل درآمد کریں';

  @override
  String get advanced => 'اعلیٰ درجے کے';

  @override
  String get about => 'تعارف';

  @override
  String get licenses => 'آپن سورس لائسنسز';

  @override
  String get merge => 'ملا دیں';

  @override
  String get split => 'الگ کریں';

  @override
  String get mergeHint =>
      'ایک ہی ویلیو کا حصہ بنانے کے لیے کسی اور باکس پر ٹیپ کریں';

  @override
  String get classOrganization => 'تنظیم';

  @override
  String get classDeviceId => 'ڈیوائس آئی ڈی';

  @override
  String get classSecret => 'خفیہ معلومات';

  @override
  String get classPerson => 'شخص';

  @override
  String get classHealth => 'صحت';

  @override
  String get classPersonalInfo => 'ذاتی معلومات';

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

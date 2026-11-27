// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'טוען מודל…';

  @override
  String get modelFileType => 'מודל';

  @override
  String get useModel => 'שימוש במודל';

  @override
  String get imagesFileType => 'תמונות';

  @override
  String get detecting => 'מזהה…';

  @override
  String detectingProgress(int current, int total) {
    return 'מזהה $current/$total…';
  }

  @override
  String get chooseModelFirst => 'יש לבחור מודל תחילה';

  @override
  String get findingSimilar => 'מחפש דומים…';

  @override
  String similarSelected(int found, int added) {
    return 'נבחרו $found אזורים דומים ($added חדשים)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'נבחרו $found אזורים דומים ($added חדשים) ב-$images תמונות';
  }

  @override
  String get saving => 'שומר…';

  @override
  String get exportHere => 'ייצוא לכאן';

  @override
  String exportStoppedAt(String name) {
    return 'הייצוא הופסק ב-$name';
  }

  @override
  String exportedTo(String path) {
    return 'יוצא ל-$path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'יוצא ל-$path (ללא שמע)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'יוצאו $count תמונות',
      many: 'יוצאו $count תמונות',
      few: 'יוצאו $count תמונות',
      two: 'יוצאו 2 תמונות',
      one: 'יוצאה תמונה 1',
      zero: 'יוצאו 0 תמונות',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'בדק $name…';
  }

  @override
  String get checkingAndExporting => 'בודק ויוצא…';

  @override
  String get cancel => 'ביטול';

  @override
  String get exportAnyway => 'ייצוא בכל זאת';

  @override
  String get regionsTooltip => 'אזורים';

  @override
  String get cameraPhoto =>
      'זוהי תמונת מצלמה; המזהה מיועד לצילומי מסך, ולכן התיבות כאן אינן אמינות.';

  @override
  String get modeDraw => 'ציור';

  @override
  String get fillSolid => 'צבע אחיד';

  @override
  String get fillBlocks => 'פסיפס אפור';

  @override
  String get fillNoise => 'רעש';

  @override
  String get export => 'ייצוא';

  @override
  String pickOneModel(String formats) {
    return 'יש לבחור בדיוק מודל $formats אחד';
  }

  @override
  String pickSidecar(String name) {
    return 'יש לבחור גם את $name.json';
  }

  @override
  String get analysing => 'מנתח';

  @override
  String get followingRegion => 'מעקב אחר האזור';

  @override
  String get exporting => 'יוצא';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count פריימים';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'מחוסה אותו $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'בדיקת ייצוא נכשלה ב-$time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count אזורים פרטיים עדיין נראים שם ($classes)',
      many: '$count אזורים פרטיים עדיין נראים שם ($classes)',
      few: '$count אזורים פרטיים עדיין נראים שם ($classes)',
      two: 'שני אזורים פרטיים עדיין נראים שם ($classes)',
      one: 'אזור פרטי אחד עדיין נראה שם ($classes)',
      zero: 'אין אזורים פרטיים נראים שם',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'הצגת פריים';

  @override
  String get drawMissedRegion => 'ציור אזור שהמזהה פספס';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on מתוך $total מסלולים מחוסים · $keyframes פריימים מפתח';
  }

  @override
  String get keepAudio => 'שמירת שמע';

  @override
  String get keepAudioHint => 'קולות וצללי התראות אינם נבדקים';

  @override
  String get goToFirstAppearance => 'מעבר להופעה הראשונה';

  @override
  String get classPersonName => 'שם';

  @override
  String get classAddress => 'כתובת';

  @override
  String get classPhone => 'טלפון';

  @override
  String get classEmail => 'אימייל';

  @override
  String get classIdNumber => 'מספר זהות';

  @override
  String get classBankCard => 'כרטיס אשראי';

  @override
  String get classPlate => 'לוחית רישוי';

  @override
  String get classAccountId => 'חשבון';

  @override
  String get classAvatar => 'אווטאר';

  @override
  String get classFace => 'פנים';

  @override
  String get classQr => 'קוד QR';

  @override
  String get classBarcode => 'קוד ברקוד';

  @override
  String get classManual => 'ידני';

  @override
  String savedModelFailed(String error) {
    return 'לא ניתן לטעון את המודל שנוצר; בחר מודל שוב. ($error)';
  }

  @override
  String get fillSurround => 'צבע הרקע';

  @override
  String get fillTinted => 'פסיפס צבעוני';

  @override
  String get settings => 'הגדרות';

  @override
  String get classFinance => 'סכום';

  @override
  String get delete => 'מחיקה';

  @override
  String get undo => 'ביטול';

  @override
  String get redo => 'ביצוע מחדש';

  @override
  String get similar => 'דומה';

  @override
  String get thisImage => 'תמונה זו';

  @override
  String allImagesCount(int count) {
    return 'כל $count התמונות';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count אזורות עשויות להיות קריאות',
      many: '$count אזורות עשויות להיות קריאות',
      few: '$count אזורות עשויות להיות קריאות',
      two: '2 אזורות עשויות להיות קריאות',
      one: 'אזורת אחת עשויה להיות קריאה',
      zero: '0 אזורות עשויות להיות קריאות',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'לאחר הסתרה, הבדיקה עדיין מצאה אזורות אלו בתוצאה.';

  @override
  String get redactThemAndExport => 'הסתר אותן וייצא';

  @override
  String get showThem => 'הצג אותן';

  @override
  String get pickClass => 'בחר סוג';

  @override
  String get appearance => 'מראה';

  @override
  String get theme => 'ערכת נושא';

  @override
  String get appIcon => 'צלמית היישום';

  @override
  String get threshold => 'סף';

  @override
  String get thresholdLow => 'נמוך';

  @override
  String get thresholdMedium => 'בינוני';

  @override
  String get thresholdHigh => 'גבוה';

  @override
  String get redaction => 'הסתרה';

  @override
  String get style => 'סגנון';

  @override
  String get selectedByDefault => 'נבחר כברירת מחדל';

  @override
  String get dataPrivacy => 'נתונים ופרטיות';

  @override
  String get model => 'מודל';

  @override
  String get importModel => 'ייבא מודל אחר';

  @override
  String get advanced => 'מתקדם';

  @override
  String get about => 'אודות';

  @override
  String get licenses => 'רישיונות קוד פתוח';

  @override
  String get merge => 'מיזוג';

  @override
  String get split => 'פיצול';

  @override
  String get mergeHint => 'הקש על תיבה אחרת כדי להפוך אותה לחלק מאותו ערך';

  @override
  String get classOrganization => 'ארגון';

  @override
  String get classDeviceId => 'מזהה מכשיר';

  @override
  String get classSecret => 'פרטי גישה';

  @override
  String get classPerson => 'אדם';

  @override
  String get classHealth => 'בריאות';

  @override
  String get classPersonalInfo => 'פרטים אישיים';

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

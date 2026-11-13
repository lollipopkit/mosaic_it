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
  String get reviewButton => 'סקירה';

  @override
  String get openingLabels => 'פותח תוויות…';

  @override
  String noImagesIn(String name) {
    return 'אין תמונות ב-$name';
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
  String get reviewPseudoLabels => 'בדיקת תוויות מדומות (תיקייה עם coco.json)';

  @override
  String get regionsTooltip => 'אזורים';

  @override
  String get notCalibrated =>
      'המודל אינו מאולף: הבחירה המוקדמת משתמשת בסף קבוע.';

  @override
  String calibratedUnverified(String domain) {
    return 'מאולף על נתונים לא מאומתים ($domain): אחריות האיתנות אינה חלה עדיין.';
  }

  @override
  String calibratedFor(String domain) {
    return 'מאולף לתמונות $domain. סוגי תמונות אחרים אינם כלולים באחריות.';
  }

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
  String get verifyNext => 'אימות והבא';

  @override
  String get export => 'ייצוא';

  @override
  String get pickOneModel => 'יש לבחור בדיוק מודל .onnx אחד';

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
  String noLabelsIn(String name) {
    return 'אין coco.json ב-$name';
  }

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
  String get collectTitle => 'איסוף נתוני אימון';

  @override
  String get collectSubtitle =>
      'שמירה במכשיר זה של כל תמונה מיוצאת, האזורים שזוהו והבחירות שלך לאימון מודלים עתידיים. שום דבר לא מועלה.';

  @override
  String collectStats(int count, String size) {
    return 'תמונות: $count · $size';
  }

  @override
  String get collectDelete => 'מחיקת הנתונים שנאספו';

  @override
  String get collectDeleteConfirm =>
      'למחוק מהמכשיר את כל התמונות והבחירות שנאספו?';

  @override
  String get delete => 'מחיקה';

  @override
  String collectFailed(String error) {
    return 'לא ניתן לשמור את נתוני האימון: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'התיוגים נשמרו עבור $count תמונות';
  }

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
  String annotateOf(int index, int total) {
    return 'סימון $index / $total';
  }

  @override
  String get suggestions => 'הצעות';

  @override
  String get skip => 'דלג';

  @override
  String get nothingPrivate => 'אין פרטים אישיים';

  @override
  String get next => 'הבא';

  @override
  String get annotateHint =>
      'הקש על שורת טקסט כדי לסמן אותה, או גרור כדי לצייר';

  @override
  String get annotationData => 'נתוני סימון';

  @override
  String get statLabeled => 'סומנו';

  @override
  String get statEmpty => 'אין פרטים אישיים';

  @override
  String get statSkipped => 'דולגו';

  @override
  String get boxesPerClass => 'תיבות לפי סוג';

  @override
  String get imagesHeader => 'תמונות';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count תיבות',
      many: '$count תיבות',
      few: '$count תיבות',
      two: '2 תיבות',
      one: 'תיבה אחת',
      zero: '0 תיבות',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'ייצא הכל';

  @override
  String get deleteAll => 'מחק הכל';

  @override
  String get annotateDeleteConfirm =>
      'למחוק את כל הסימונים ואת התמונות שלהם מהמכשיר הזה?';

  @override
  String get noAnnotations => 'אין סימונים עדיין. בחר תמונות ובחר סימון.';

  @override
  String get filterScreenshots => 'צילומי מסך';

  @override
  String get filterAll => 'הכל';

  @override
  String get filterVideos => 'סרטונים';

  @override
  String get albums => 'אלבומים';

  @override
  String get limitedAccess => 'MosaicIt יכולה לראות רק חלק מהתמונות שלך';

  @override
  String get manage => 'ניהול';

  @override
  String selectedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count נבחרו',
      many: '$count נבחרו',
      few: '$count נבחרו',
      two: '2 נבחרו',
      one: '1 נבחרה',
      zero: '0 נבחרו',
    );
    return '$_temp0';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'הסתר $count תמונות',
      many: 'הסתר $count תמונות',
      few: 'הסתר $count תמונות',
      two: 'הסתר 2 תמונות',
      one: 'הסתר תמונה אחת',
      zero: 'הסתר 0 תמונות',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'סימון';

  @override
  String get badgeRedacted => 'נסתר';

  @override
  String get badgeAnnotated => 'סומן';

  @override
  String get photosDenied =>
      'MosaicIt זקוקה לגישה לתמונות שלך כדי להציג אותן כאן. התמונות לעולם אינן עוזבות את המכשיר הזה.';

  @override
  String get openSettings => 'פתח הגדרות';

  @override
  String get openFiles => 'פתח קבצים';

  @override
  String get noPhotos => 'אין תמונות כאן';

  @override
  String get loading => 'טוען…';

  @override
  String get appearance => 'מראה';

  @override
  String get theme => 'ערכת נושא';

  @override
  String get appIcon => 'צלמית היישום';

  @override
  String get aspectRatioGrid => 'רשת ביחס גובה־רוחב';

  @override
  String get modelDownloadFailed => 'לא ניתן היה להוריד את המודל';

  @override
  String get retry => 'נסה שוב';

  @override
  String get autoUpdateModel => 'עדכון המודל אוטומטית';

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
  String get localOnly =>
      'נשמר במכשיר הזה בלבד, לעולם לא ב-iCloud או בגיבויים.';

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

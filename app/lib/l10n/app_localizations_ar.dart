// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'جارٍ تحميل النموذج…';

  @override
  String get modelFileType => 'النماذج';

  @override
  String get useModel => 'استخدام النموذج';

  @override
  String get imagesFileType => 'الصور';

  @override
  String get detecting => 'جارٍ الكشف…';

  @override
  String detectingProgress(int current, int total) {
    return 'جارٍ الكشف $current/$total…';
  }

  @override
  String get chooseModelFirst => 'اختر نموذجًا أولاً';

  @override
  String get findingSimilar => 'جارٍ البحث عن مشابه…';

  @override
  String similarSelected(int found, int added) {
    return 'تم تحديد $found مناطق مشابهة ($added جديدة)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'تم تحديد $found مناطق مشابهة ($added جديدة) عبر $images صور';
  }

  @override
  String get reviewButton => 'مراجعة';

  @override
  String get openingLabels => 'جارٍ فتح التسميات…';

  @override
  String noImagesIn(String name) {
    return 'لا توجد صور في $name';
  }

  @override
  String get saving => 'جارٍ الحفظ…';

  @override
  String get exportHere => 'تصدير هنا';

  @override
  String exportStoppedAt(String name) {
    return 'توقف التصدير عند $name';
  }

  @override
  String exportedTo(String path) {
    return 'تم التصدير إلى $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'تم التصدير إلى $path (بدون صوت)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تصدير $count صورة',
      many: 'تم تصدير $count صورة',
      few: 'تم تصدير $count صور',
      two: 'تم تصدير صورتين',
      one: 'تم تصدير صورة واحدة',
      zero: 'تم تصدير 0 صور',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'جارٍ فحص $name…';
  }

  @override
  String get checkingAndExporting => 'جارٍ الفحص والتصدير…';

  @override
  String get cancel => 'إلغاء';

  @override
  String get exportAnyway => 'تصدير على أي حال';

  @override
  String get reviewPseudoLabels =>
      'مراجعة التسميات الوهمية (مجلد يحتوي على coco.json)';

  @override
  String get regionsTooltip => 'المناطق';

  @override
  String get notCalibrated =>
      'النموذج غير مُعاير: يستخدم التحديد المسبق عتبة ثابتة.';

  @override
  String calibratedUnverified(String domain) {
    return 'معاير على بيانات غير مُتحقق منها ($domain): ضمان الاسترجاع لا ينطبق بعد.';
  }

  @override
  String calibratedFor(String domain) {
    return 'معاير لصور $domain. أنواع الصور الأخرى خارج نطاق الضمان.';
  }

  @override
  String get cameraPhoto =>
      'هذه صورة كاميرا؛ الكاشف مصمم لالتقاطات الشاشة، لذا فإن صناديقه هنا غير موثوقة.';

  @override
  String get modeDraw => 'رسم';

  @override
  String get fillSolid => 'لون خالص';

  @override
  String get fillBlocks => 'فسيفساء رمادية';

  @override
  String get fillNoise => 'ضجيج';

  @override
  String get verifyNext => 'تحقق والتالي';

  @override
  String get export => 'تصدير';

  @override
  String get pickOneModel => 'اختر نموذج .onnx واحدًا بالضبط';

  @override
  String pickSidecar(String name) {
    return 'اختر أيضًا $name.json';
  }

  @override
  String get analysing => 'جارٍ التحليل';

  @override
  String get followingRegion => 'متابعة المنطقة';

  @override
  String get exporting => 'جارٍ التصدير';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count إطارات';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'جارٍ الحجب $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'فشل فحص التصدير عند $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منطقة خاصة ما زالت مرئية هناك ($classes).',
      many: '$count منطقة خاصة ما زالت مرئية هناك ($classes).',
      few: '$count مناطق خاصة ما زالت مرئية هناك ($classes).',
      two: 'منطقتان خاصتان ما زالتا مرئيتين هناك ($classes).',
      one: 'منطقة خاصة واحدة ما زالت مرئية هناك ($classes).',
      zero: 'لا توجد مناطق خاصة مرئية هناك.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'إظهار الإطار';

  @override
  String get drawMissedRegion => 'ارسم منطقة فات عليها الكاشف';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on من $total مسارات محجوبة · $keyframes إطارات رئيسية';
  }

  @override
  String get keepAudio => 'إبقاء الصوت';

  @override
  String get keepAudioHint => 'الأصوات وأصوات الإشعارات لا يتم فحصها';

  @override
  String get goToFirstAppearance => 'الانتقال إلى أول ظهور';

  @override
  String get classPersonName => 'الاسم';

  @override
  String get classAddress => 'العنوان';

  @override
  String get classPhone => 'الهاتف';

  @override
  String get classEmail => 'البريد الإلكتروني';

  @override
  String get classIdNumber => 'رقم الهوية';

  @override
  String get classBankCard => 'بطاقة بنكية';

  @override
  String get classPlate => 'لوحة سيارة';

  @override
  String get classAccountId => 'الحساب';

  @override
  String get classAvatar => 'الصورة الرمزية';

  @override
  String get classFace => 'الوجه';

  @override
  String get classQr => 'رمز QR';

  @override
  String get classBarcode => 'الباركود';

  @override
  String get classManual => 'يدوي';

  @override
  String noLabelsIn(String name) {
    return 'لا يوجد coco.json في $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'تعذر تحميل النموذج المحفوظ؛ اختر نموذجًا مرة أخرى. ($error)';
  }

  @override
  String get fillSurround => 'لون الخلفية';

  @override
  String get fillTinted => 'فسيفساء ملونة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get classFinance => 'المبلغ';

  @override
  String get collectTitle => 'جمع بيانات التدريب';

  @override
  String get collectSubtitle =>
      'الاحتفاظ على هذا الجهاز بكل صورة مُصدَّرة والمناطق المكتشفة واختياراتك لتدريب النماذج المستقبلية. لا يتم رفع أي شيء.';

  @override
  String collectStats(int count, String size) {
    return 'الصور: $count · $size';
  }

  @override
  String get collectDelete => 'حذف البيانات المجمّعة';

  @override
  String get collectDeleteConfirm =>
      'هل تريد حذف جميع الصور والاختيارات المجمّعة من هذا الجهاز؟';

  @override
  String get delete => 'حذف';

  @override
  String collectFailed(String error) {
    return 'تعذّر حفظ بيانات التدريب: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'تم حفظ تسميات $count صور';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get similar => 'مشابه';

  @override
  String get thisImage => 'هذه الصورة';

  @override
  String allImagesCount(int count) {
    return 'جميع الصور ($count)';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قد تكون $count منطقة قابلة للقراءة',
      many: 'قد تكون $count منطقة قابلة للقراءة',
      few: 'قد تكون $count مناطق قابلة للقراءة',
      two: 'قد تكون منطقتان قابلتان للقراءة',
      one: 'قد تكون منطقة واحدة قابلة للقراءة',
      zero: 'قد تكون 0 مناطق قابلة للقراءة',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'بعد الإخفاء، لا يزال الفحص يجد هذه المناطق في المخرجات.';

  @override
  String get redactThemAndExport => 'إخفاؤها والتصدير';

  @override
  String get showThem => 'عرضها';

  @override
  String get pickClass => 'اختر فئة';

  @override
  String annotateOf(int index, int total) {
    return 'تعليم $index / $total';
  }

  @override
  String get suggestions => 'اقتراحات';

  @override
  String get skip => 'تخطي';

  @override
  String get nothingPrivate => 'لا يوجد شيء خاص';

  @override
  String get next => 'التالي';

  @override
  String get annotateHint => 'انقر على سطر نص لتأطيره، أو اسحب لرسم مربع';

  @override
  String get annotationData => 'بيانات التعليم';

  @override
  String get statLabeled => 'مُعلَّمة';

  @override
  String get statEmpty => 'لا يوجد شيء خاص';

  @override
  String get statSkipped => 'تم تخطيها';

  @override
  String get boxesPerClass => 'المربعات حسب الفئة';

  @override
  String get imagesHeader => 'الصور';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مربع',
      many: '$count مربع',
      few: '$count مربعات',
      two: 'مربعان',
      one: 'مربع واحد',
      zero: '0 مربعات',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'تصدير الكل';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get annotateDeleteConfirm =>
      'هل تريد حذف جميع التعليمات وصورها من هذا الجهاز؟';

  @override
  String get noAnnotations => 'لا توجد تعليمات بعد. حدد الصور واختر تعليم.';

  @override
  String get filterScreenshots => 'لقطات الشاشة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterVideos => 'الفيديوهات';

  @override
  String get albums => 'الألبومات';

  @override
  String get limitedAccess => 'MosaicIt يمكنه رؤية بعض صورك فقط';

  @override
  String get manage => 'إدارة';

  @override
  String selectedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديد $count صورة',
      many: 'تم تحديد $count صورة',
      few: 'تم تحديد $count صور',
      two: 'تم تحديد صورتين',
      one: 'تم تحديد صورة واحدة',
      zero: 'تم تحديد 0 صور',
    );
    return '$_temp0';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إخفاء $count صورة',
      many: 'إخفاء $count صورة',
      few: 'إخفاء $count صور',
      two: 'إخفاء صورتين',
      one: 'إخفاء صورة واحدة',
      zero: 'إخفاء 0 صور',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'وسم';

  @override
  String get badgeRedacted => 'مُخفاة';

  @override
  String get badgeAnnotated => 'مُعلَّمة';

  @override
  String get photosDenied =>
      'يحتاج MosaicIt إلى الوصول إلى صورك لعرضها هنا. لا تغادر الصور هذا الجهاز أبداً.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get openFiles => 'فتح الملفات';

  @override
  String get noPhotos => 'لا توجد صور هنا';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get appIcon => 'أيقونة التطبيق';

  @override
  String get aspectRatioGrid => 'شبكة بنسبة الأبعاد الأصلية';

  @override
  String get modelDownloadFailed => 'تعذّر تنزيل النموذج';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get autoUpdateModel => 'تحديث النموذج تلقائيًا';

  @override
  String get threshold => 'العتبة';

  @override
  String get thresholdLow => 'منخفضة';

  @override
  String get thresholdMedium => 'متوسطة';

  @override
  String get thresholdHigh => 'مرتفعة';

  @override
  String get redaction => 'الإخفاء';

  @override
  String get style => 'النمط';

  @override
  String get selectedByDefault => 'محدد افتراضيًا';

  @override
  String get dataPrivacy => 'البيانات والخصوصية';

  @override
  String get localOnly =>
      'تُحفظ على هذا الجهاز فقط، ولا تُخزَّن في iCloud أو النسخ الاحتياطية أبداً.';

  @override
  String get model => 'النموذج';

  @override
  String get importModel => 'استيراد نموذج آخر';

  @override
  String get advanced => 'متقدم';

  @override
  String get about => 'حول';

  @override
  String get licenses => 'تراخيص المصادر المفتوحة';

  @override
  String get merge => 'دمج';

  @override
  String get split => 'تقسيم';

  @override
  String get mergeHint => 'انقر على مربع آخر لجعله جزءاً من نفس القيمة';

  @override
  String get classOrganization => 'منظمة';

  @override
  String get classDeviceId => 'معرّف الجهاز';

  @override
  String get classSecret => 'بيانات سرية';

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

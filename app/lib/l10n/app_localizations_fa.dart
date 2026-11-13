// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'در حال بارگذاری مدل…';

  @override
  String get modelFileType => 'مدل';

  @override
  String get useModel => 'استفاده از مدل';

  @override
  String get imagesFileType => 'تصاویر';

  @override
  String get detecting => 'در حال شناسایی…';

  @override
  String detectingProgress(int current, int total) {
    return 'در حال شناسایی $current/$total…';
  }

  @override
  String get chooseModelFirst => 'ابتدا یک مدل انتخاب کنید';

  @override
  String get findingSimilar => 'در حال یافتن موارد مشابه…';

  @override
  String similarSelected(int found, int added) {
    return '$found ناحیه مشابه انتخاب شد ($added جدید)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found ناحیه مشابه انتخاب شد ($added جدید) در $images تصویر';
  }

  @override
  String get reviewButton => 'بازبینی';

  @override
  String get openingLabels => 'در حال باز کردن برچسب‌ها…';

  @override
  String noImagesIn(String name) {
    return 'تصویری در $name وجود ندارد';
  }

  @override
  String get saving => 'در حال ذخیره‌سازی…';

  @override
  String get exportHere => 'خروجی گرفتن در اینجا';

  @override
  String exportStoppedAt(String name) {
    return 'خروجی گرفتن در $name متوقف شد';
  }

  @override
  String exportedTo(String path) {
    return 'خروجی گرفته شد در $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'خروجی گرفته شد در $path (بدون صدا)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تصویر خروجی گرفته شد',
      many: '$count تصویر خروجی گرفته شد',
      few: '$count تصویر خروجی گرفته شد',
      two: '۲ تصویر خروجی گرفته شد',
      one: '۱ تصویر خروجی گرفته شد',
      zero: 'تصویری خروجی گرفته نشد',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'در حال بررسی $name…';
  }

  @override
  String get checkingAndExporting => 'در حال بررسی و خروجی گرفتن…';

  @override
  String get cancel => 'لغو';

  @override
  String get exportAnyway => 'با این حال خروجی بگیر';

  @override
  String get reviewPseudoLabels => 'بررسی برچسب‌های شبهه (پوشه حاوی coco.json)';

  @override
  String get regionsTooltip => 'ناحیه‌ها';

  @override
  String get notCalibrated =>
      'مدل کالیبره نشده است: پیش‌انتخاب از یک آستانه ثابت استفاده می‌کند.';

  @override
  String calibratedUnverified(String domain) {
    return 'بر روی داده‌های تأییدنشده کالیبره شده ($domain): تضمین بازیابی هنوز اعمال نمی‌شود.';
  }

  @override
  String calibratedFor(String domain) {
    return 'برای تصاویر $domain کالیبره شده است. انواع دیگر تصاویر خارج از محدوده تضمین هستند.';
  }

  @override
  String get cameraPhoto =>
      'این یک عکس دوربین است؛ تشخیص‌دهنده برای اسکرین‌شات‌ها ساخته شده است، بنابراین جعبه‌های آن در اینجا قابل اعتماد نیستند.';

  @override
  String get modeDraw => 'ترسیم';

  @override
  String get fillLabel => 'پر کردن';

  @override
  String get fillSolid => 'رنگ یکدست';

  @override
  String get fillBlocks => 'موزاییک خاکستری';

  @override
  String get fillNoise => 'نویز';

  @override
  String get verifyNext => 'تأیید و بعدی';

  @override
  String get export => 'خروجی گرفتن';

  @override
  String get pickOneModel => 'دقیقاً یک مدل .onnx انتخاب کنید';

  @override
  String pickSidecar(String name) {
    return 'همچنین $name.json را انتخاب کنید';
  }

  @override
  String get analysing => 'در حال تحلیل';

  @override
  String get followingRegion => 'دنبال کردن ناحیه';

  @override
  String get exporting => 'در حال خروجی گرفتن';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count فریم';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'در حال ویرایش آن $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'بررسی خروجی در $time ناموفق بود';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ناحیه با ظاهر خصوصی هنوز در آنجا دیده می‌شود ($classes).',
      many: '$count ناحیه با ظاهر خصوصی هنوز در آنجا دیده می‌شود ($classes).',
      few: '$count ناحیه با ظاهر خصوصی هنوز در آنجا دیده می‌شود ($classes).',
      two: '۲ ناحیه با ظاهر خصوصی هنوز در آنجا دیده می‌شود ($classes).',
      one: '۱ ناحیه با ظاهر خصوصی هنوز در آنجا دیده می‌شود ($classes).',
      zero: 'هیچ ناحیه‌ای با ظاهر خصوصی در آنجا دیده نمی‌شود ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'نمایش فریم';

  @override
  String get drawMissedRegion =>
      'ناحیه‌ای را که تشخیص‌دهنده از آن غافل شده ترسیم کنید';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on از $total ردیابی ویرایش شده · $keyframes فریم کلیدی';
  }

  @override
  String get keepAudio => 'نگه داشتن صدا';

  @override
  String get keepAudioHint => 'صداها و صداهای اعلان بررسی نمی‌شوند';

  @override
  String get goToFirstAppearance => 'رفتن به اولین ظهور';

  @override
  String get classPersonName => 'نام';

  @override
  String get classAddress => 'آدرس';

  @override
  String get classPhone => 'تلفن';

  @override
  String get classEmail => 'ایمیل';

  @override
  String get classIdNumber => 'شماره شناسایی';

  @override
  String get classBankCard => 'کارت بانکی';

  @override
  String get classPlate => 'پلاک';

  @override
  String get classAccountId => 'حساب';

  @override
  String get classAvatar => 'آواتار';

  @override
  String get classFace => 'چهره';

  @override
  String get classQr => 'کد QR';

  @override
  String get classBarcode => 'بارکد';

  @override
  String get classManual => 'دستی';

  @override
  String noLabelsIn(String name) {
    return 'coco.json در $name یافت نشد';
  }

  @override
  String savedModelFailed(String error) {
    return 'مدل ذخیره‌شده بارگذاری نشد؛ دوباره یک مدل انتخاب کنید. ($error)';
  }

  @override
  String get fillSurround => 'رنگ پس‌زمینه';

  @override
  String get fillTinted => 'موزاییک رنگی';

  @override
  String get settings => 'تنظیمات';

  @override
  String get classFinance => 'مبلغ';

  @override
  String get collectTitle => 'جمع‌آوری داده‌های آموزشی';

  @override
  String get collectSubtitle =>
      'هر تصویر خروجی‌گرفته، ناحیه‌های شناسایی‌شده و انتخاب‌های شما برای آموزش مدل‌های آینده روی این دستگاه نگه داشته می‌شود. چیزی بارگذاری نمی‌شود.';

  @override
  String collectStats(int count, String size) {
    return 'تصاویر: $count · $size';
  }

  @override
  String get collectDelete => 'حذف داده‌های جمع‌آوری‌شده';

  @override
  String get collectDeleteConfirm =>
      'همه تصاویر و انتخاب‌های جمع‌آوری‌شده از این دستگاه حذف شوند؟';

  @override
  String get delete => 'حذف';

  @override
  String collectFailed(String error) {
    return 'ذخیره داده‌های آموزشی ممکن نشد: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'برچسب‌های $count تصویر ذخیره شد';
  }

  @override
  String get undo => 'واگرد';

  @override
  String get redo => 'ازنو انجام';

  @override
  String get similar => 'مشابه';

  @override
  String get thisImage => 'این تصویر';

  @override
  String allImagesCount(int count) {
    return 'هر $count تصویر';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ناحیه ممکن است هنوز قابل خواندن باشند',
      many: '$count ناحیه ممکن است هنوز قابل خواندن باشند',
      few: '$count ناحیه ممکن است هنوز قابل خواندن باشند',
      two: '۲ ناحیه ممکن است هنوز قابل خواندن باشند',
      one: '۱ ناحیه ممکن است هنوز قابل خواندن باشد',
      zero: 'هیچ ناحیه‌ای قابل خواندن نیست',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'پس از پنهان‌سازی، بررسی هنوز این نواحی را در خروجی یافت.';

  @override
  String get redactThemAndExport => 'پنهان‌سازی و خروجی گرفتن';

  @override
  String get showThem => 'نمایش آن‌ها';

  @override
  String get pickClass => 'انتخاب یک کلاس';

  @override
  String annotateOf(int index, int total) {
    return 'برچسب‌گذاری $index / $total';
  }

  @override
  String get suggestions => 'پیشنهادها';

  @override
  String get skip => 'رد کردن';

  @override
  String get nothingPrivate => 'هیچ اطلاعات خصوصی';

  @override
  String get next => 'بعدی';

  @override
  String get annotateHint =>
      'برای جعبه‌بندی روی یک خط متن ضربه بزنید یا بکشید تا رسم کنید';

  @override
  String get annotationData => 'داده‌های برچسب‌گذاری';

  @override
  String get statLabeled => 'برچسب‌گذاری‌شده';

  @override
  String get statEmpty => 'هیچ اطلاعات خصوصی';

  @override
  String get statSkipped => 'ردشده';

  @override
  String get boxesPerClass => 'جعبه‌ها بر اساس کلاس';

  @override
  String get imagesHeader => 'تصاویر';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جعبه',
      many: '$count جعبه',
      few: '$count جعبه',
      two: '۲ جعبه',
      one: '۱ جعبه',
      zero: '۰ جعبه',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'خروجی گرفتن از همه';

  @override
  String get deleteAll => 'حذف همه';

  @override
  String get annotateDeleteConfirm =>
      'آیا همه برچسب‌ها و تصاویر آن‌ها از این دستگاه حذف شوند؟';

  @override
  String get noAnnotations =>
      'هنوز برچسب‌گذاری‌ای انجام نشده است. تصاویر را انتخاب کنید و گزینه برچسب‌گذاری را بزنید.';

  @override
  String get filterScreenshots => 'اسکرین‌شات‌ها';

  @override
  String get filterAll => 'همه';

  @override
  String get filterVideos => 'ویدیوها';

  @override
  String get albums => 'آلبوم‌ها';

  @override
  String get limitedAccess => 'MosaicIt فقط به برخی از عکس‌های شما دسترسی دارد';

  @override
  String get manage => 'مدیریت';

  @override
  String selectedImages(int count) {
    return '$count انتخاب‌شده';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'پنهان‌سازی $count تصویر',
      many: 'پنهان‌سازی $count تصویر',
      few: 'پنهان‌سازی $count تصویر',
      two: 'پنهان‌سازی ۲ تصویر',
      one: 'پنهان‌سازی ۱ تصویر',
      zero: 'پنهان‌سازی ۰ تصویر',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'برچسب‌گذاری';

  @override
  String get badgeRedacted => 'پنهان‌سازی‌شده';

  @override
  String get badgeAnnotated => 'برچسب‌گذاری‌شده';

  @override
  String get photosDenied =>
      'MosaicIt برای نمایش عکس‌ها در اینجا به دسترسی به آن‌ها نیاز دارد. عکس‌ها هرگز از این دستگاه خارج نمی‌شوند.';

  @override
  String get openSettings => 'باز کردن تنظیمات';

  @override
  String get openFiles => 'باز کردن فایل‌ها';

  @override
  String get noPhotos => 'عکسی در اینجا نیست';

  @override
  String get loading => 'در حال بارگذاری…';

  @override
  String get appearance => 'ظاهر';

  @override
  String get theme => 'پوسته';

  @override
  String get appIcon => 'آیکون برنامه';

  @override
  String get aspectRatioGrid => 'شبکه با نسبت ابعاد اصلی';

  @override
  String get modelDownloadFailed => 'مدل بارگیری نشد';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String get autoUpdateModel => 'به‌روزرسانی خودکار مدل';

  @override
  String get threshold => 'آستانه';

  @override
  String get thresholdLow => 'کم';

  @override
  String get thresholdMedium => 'متوسط';

  @override
  String get thresholdHigh => 'زیاد';

  @override
  String get redaction => 'پنهان‌سازی';

  @override
  String get style => 'سبک';

  @override
  String get selectedByDefault => 'انتخاب‌شده به‌طور پیش‌فرض';

  @override
  String get dataPrivacy => 'داده و حریم خصوصی';

  @override
  String get localOnly =>
      'فقط روی این دستگاه نگهداری می‌شود، هرگز در iCloud یا پشتیبان‌گیری.';

  @override
  String get model => 'مدل';

  @override
  String get importModel => 'وارد کردن مدل دیگر';

  @override
  String get advanced => 'پیشرفته';

  @override
  String get about => 'درباره';

  @override
  String get licenses => 'مجوزهای متن‌باز';

  @override
  String get merge => 'ادغام';

  @override
  String get split => 'تفکیک';

  @override
  String get mergeHint =>
      'برای تبدیل به بخشی از همان مقدار، روی جعبه دیگر ضربه بزنید';

  @override
  String get classOrganization => 'سازمان';

  @override
  String get classDeviceId => 'شناسه دستگاه';

  @override
  String get classSecret => 'اطلاعات محرمانه';
}

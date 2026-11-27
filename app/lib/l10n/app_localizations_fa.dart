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
  String get regionsTooltip => 'ناحیه‌ها';

  @override
  String get cameraPhoto =>
      'این یک عکس دوربین است؛ تشخیص‌دهنده برای اسکرین‌شات‌ها ساخته شده است، بنابراین جعبه‌های آن در اینجا قابل اعتماد نیستند.';

  @override
  String get modeDraw => 'ترسیم';

  @override
  String get fillSolid => 'رنگ یکدست';

  @override
  String get fillBlocks => 'موزاییک خاکستری';

  @override
  String get fillNoise => 'نویز';

  @override
  String get export => 'خروجی گرفتن';

  @override
  String pickOneModel(String formats) {
    return 'دقیقاً یک مدل $formats انتخاب کنید';
  }

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
  String get delete => 'حذف';

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
  String get appearance => 'ظاهر';

  @override
  String get theme => 'پوسته';

  @override
  String get appIcon => 'آیکون برنامه';

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

  @override
  String get classPerson => 'شخص';

  @override
  String get classHealth => 'سلامت';

  @override
  String get classPersonalInfo => 'اطلاعات شخصی';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total انتخاب‌شده';
  }

  @override
  String get fillStyle => 'سبک پرکردن';

  @override
  String get colour => 'رنگ';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images تصویر',
      one: '۱ تصویر',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions ناحیه',
      one: '۱ ناحیه',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String get saveToPhotos => 'ذخیره در عکس‌ها';

  @override
  String get saveAs => 'ذخیره…';

  @override
  String get exportFormat => 'قالب';

  @override
  String get exportSize => 'اندازه';

  @override
  String get sizeOriginal => 'اصلی';

  @override
  String sizePixels(int px) {
    return '$px پیکسل';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تصویر در عکس‌ها ذخیره شد',
      one: '۱ تصویر در عکس‌ها ذخیره شد',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'همه';

  @override
  String get selectNone => 'هیچ‌کدام';

  @override
  String get suggested => 'پیشنهادی';

  @override
  String scoreValue(String score) {
    return 'امتیاز $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'پس از پنهان‌سازی، بررسی هنوز این نواحی را در خروجی تصویر $index یافت.';
  }

  @override
  String get reasonNotSelected => 'انتخاب نشده';

  @override
  String get reasonBoxTooSmall => 'جعبه بیش از حد کوچک است';

  @override
  String get reasonFillShowsThrough => 'محتوا از زیر پوشش دیده می‌شود';

  @override
  String get openSource => 'متن‌باز';

  @override
  String get adaptivePreselectTitle => 'پیش‌انتخاب تطبیقی محلی';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلاس تنظیم شد',
      one: '۱ کلاس تنظیم شد',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'بازنشانی ترجیحات محلی';

  @override
  String get adaptiveResetDone => 'ترجیحات محلی بازنشانی شد';

  @override
  String get feedbackTitle => 'گزارش مشکل تشخیص';

  @override
  String get feedbackShort => 'بازخورد';

  @override
  String get feedbackMenu => 'گزارش مشکل';

  @override
  String get feedbackAction => 'گزارش';

  @override
  String get feedbackAttachScreenshot => 'پیوست کردن اسکرین‌شات';

  @override
  String get feedbackModeMasked => 'فقط خطاها';

  @override
  String get feedbackModeFull => 'تصویر کامل';

  @override
  String get feedbackModeText => 'بدون تصویر';

  @override
  String get feedbackTagMissed => 'جاافتاده';

  @override
  String get feedbackTagFalsePositive => 'تشخیص اشتباه';

  @override
  String get feedbackTagBoxDrift => 'جابه‌جایی جعبه';

  @override
  String get feedbackTagWrongClass => 'کلاس نادرست';

  @override
  String get feedbackTagOther => 'سایر';

  @override
  String get feedbackNoteHint => 'یادداشت اختیاری…';

  @override
  String feedbackCountMasked(int count) {
    return 'پنهان‌شده $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'جاافتاده $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'تشخیص اشتباه $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'لغو انتخاب $count';
  }

  @override
  String get feedbackBoxMissed => 'جاافتاده';

  @override
  String get feedbackBoxMissedMasked => 'جاافتاده · پنهان‌شده';

  @override
  String get feedbackBoxFp => 'تشخیص اشتباه';

  @override
  String get feedbackBoxPreference => 'نمایان بماند';

  @override
  String get introOfflineTitle => 'بدون دسترسی به شبکه';

  @override
  String get introOfflineBody =>
      'MosaicIt هیچ کد شبکه‌ای ندارد و هیچ مجوز شبکه‌ای درخواست نمی‌کند. تشخیص‌دهنده در داخل برنامه تعبیه شده است و تصاویر هرگز دستگاه شما را ترک نمی‌کنند.';

  @override
  String get introNoNetPermTitle => 'صفر مجوز شبکه';

  @override
  String get introBundledModelTitle => 'مدل داخلی روی دستگاه';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · روی دستگاه';
  }

  @override
  String get resetBundledModel => 'استفاده از مدل داخلی';

  @override
  String get reviewIntro => 'نمایش دوباره معرفی';

  @override
  String get feedbackOpenWeb => 'باز کردن فرم وب';

  @override
  String get introNoNetPermBodyIos => 'بدون درخواست شبکه · فقط روی دستگاه';

  @override
  String get introNoNetPermBodyAndroid => 'هیچ مجوز INTERNET اعلام نشده است';

  @override
  String get introNoNetPermBodyDesktop => 'بدون مجوز شبکه در محیط ایزوله';

  @override
  String get customModel => 'مدل سفارشی';

  @override
  String modelClassCount(int count) {
    return '$count کلاس';
  }

  @override
  String get copyImage => 'کپی کردن تصویر';

  @override
  String get copiedToClipboard => 'در حافظه موقت کپی شد';

  @override
  String get copyFailed => 'کپی کردن تصویر ناموفق بود';

  @override
  String get peekOriginal => 'برای مقایسه با نسخه اصلی نگه دارید';

  @override
  String get selectMedia => 'انتخاب عکس‌ها';

  @override
  String get saveFailed => 'ذخیره در عکس‌ها ناموفق بود';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get iosWirelessPromptTitle => 'پیام داده بی‌سیم';

  @override
  String get iosWirelessPromptBody =>
      'باز کردن انتخابگر عکس سیستم ممکن است پیام داده بی‌سیم iOS را برای بندانگشتی‌های iCloud نمایش دهد. MosaicIt از شبکه استفاده نمی‌کند — روی «اجازه نده» ضربه بزنید.';

  @override
  String get continueAction => 'ادامه';
}

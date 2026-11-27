// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Model yükleniyor…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Modeli kullan';

  @override
  String get imagesFileType => 'Görseller';

  @override
  String get detecting => 'Algılanıyor…';

  @override
  String detectingProgress(int current, int total) {
    return '$current/$total algılanıyor…';
  }

  @override
  String get chooseModelFirst => 'Önce bir model seçin';

  @override
  String get findingSimilar => 'Benzerler aranıyor…';

  @override
  String similarSelected(int found, int added) {
    return '$found benzer bölge seçildi ($added yeni)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$images görselde $found benzer bölge seçildi ($added yeni)';
  }

  @override
  String get saving => 'Kaydediliyor…';

  @override
  String get exportHere => 'Buraya dışa aktar';

  @override
  String exportStoppedAt(String name) {
    return 'Dışa aktarma $name öğesinde durduruldu';
  }

  @override
  String exportedTo(String path) {
    return '$path konumuna dışa aktarıldı';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path konumuna dışa aktarıldı (ses yok)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count görsel dışa aktarıldı',
      many: 'çok görsel dışa aktarıldı',
      few: 'birkaç görsel dışa aktarıldı',
      two: '2 görsel dışa aktarıldı',
      one: '1 görsel dışa aktarıldı',
      zero: '0 görsel dışa aktarıldı',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name kontrol ediliyor…';
  }

  @override
  String get checkingAndExporting => 'Kontrol ediliyor ve dışa aktarılıyor…';

  @override
  String get cancel => 'İptal';

  @override
  String get exportAnyway => 'Yine de dışa aktar';

  @override
  String get regionsTooltip => 'Bölgeler';

  @override
  String get cameraPhoto =>
      'Bu bir kamera fotoğrafıdır; algılayıcı ekran görüntüleri için yapıldığından buradaki kutuları güvenilir değildir.';

  @override
  String get modeDraw => 'Çiz';

  @override
  String get fillSolid => 'Düz renk';

  @override
  String get fillBlocks => 'Gri mozaik';

  @override
  String get fillNoise => 'Gürültü';

  @override
  String get export => 'Dışa aktar';

  @override
  String pickOneModel(String formats) {
    return 'Tam olarak bir $formats modeli seçin';
  }

  @override
  String pickSidecar(String name) {
    return '$name.json dosyasını da seçin';
  }

  @override
  String get analysing => 'Analiz ediliyor';

  @override
  String get followingRegion => 'Bölge takip ediliyor';

  @override
  String get exporting => 'Dışa aktarılıyor';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count kare';
  }

  @override
  String redactingSpan(String start, String end) {
    return '$start – $end arası sansürleniyor';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Dışa aktarma kontrolü $time zamanında başarısız oldu';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Orada $count özel görünümlü bölge hâlâ görünür ($classes).',
      many: 'Orada çok özel görünümlü bölge hâlâ görünür ($classes).',
      few: 'Orada birkaç özel görünümlü bölge hâlâ görünür ($classes).',
      two: 'Orada 2 özel görünümlü bölge hâlâ görünür ($classes).',
      one: 'Orada 1 özel görünümlü bölge hâlâ görünür ($classes).',
      zero: 'Orada görünür özel bölge yok.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Kareyi göster';

  @override
  String get drawMissedRegion => 'Algılayıcının kaçırdığı bir bölge çizin';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$total izden $on tanesi sansürlendi · $keyframes anahtar kare';
  }

  @override
  String get keepAudio => 'Sesi koru';

  @override
  String get keepAudioHint => 'Sesler ve bildirim sesleri kontrol edilmez';

  @override
  String get goToFirstAppearance => 'İlk görünüme git';

  @override
  String get classPersonName => 'Ad';

  @override
  String get classAddress => 'Adres';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-posta';

  @override
  String get classIdNumber => 'Kimlik numarası';

  @override
  String get classBankCard => 'Banka kartı';

  @override
  String get classPlate => 'Plaka';

  @override
  String get classAccountId => 'Hesap';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Yüz';

  @override
  String get classQr => 'QR kodu';

  @override
  String get classBarcode => 'Barkod';

  @override
  String get classManual => 'Manuel';

  @override
  String savedModelFailed(String error) {
    return 'Kaydedilen model yüklenemedi; lütfen bir model seçin. ($error)';
  }

  @override
  String get fillSurround => 'Arka plan rengi';

  @override
  String get fillTinted => 'Renkli mozaik';

  @override
  String get settings => 'Ayarlar';

  @override
  String get classFinance => 'Tutar';

  @override
  String get delete => 'Sil';

  @override
  String get undo => 'Geri Al';

  @override
  String get redo => 'Yinele';

  @override
  String get similar => 'Benzer';

  @override
  String get thisImage => 'Bu görsel';

  @override
  String allImagesCount(int count) {
    return 'Tüm $count görsel';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alan hâlâ okunabilir olabilir',
      many: '$count alan hâlâ okunabilir olabilir',
      few: '$count alan hâlâ okunabilir olabilir',
      two: '2 alan hâlâ okunabilir olabilir',
      one: '1 alan hâlâ okunabilir olabilir',
      zero: '0 alan hâlâ okunabilir olabilir',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Gizlemeden sonra, denetim çıktıdaki bu alanları yine de buldu.';

  @override
  String get redactThemAndExport => 'Gizle ve dışa aktar';

  @override
  String get showThem => 'Göster';

  @override
  String get pickClass => 'Bir sınıf seç';

  @override
  String get appearance => 'Görünüm';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Uygulama simgesi';

  @override
  String get threshold => 'Eşik';

  @override
  String get thresholdLow => 'Düşük';

  @override
  String get thresholdMedium => 'Orta';

  @override
  String get thresholdHigh => 'Yüksek';

  @override
  String get redaction => 'Gizleme';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Varsayılan olarak seçili';

  @override
  String get dataPrivacy => 'Veri ve gizlilik';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Başka bir model içe aktar';

  @override
  String get advanced => 'Gelişmiş';

  @override
  String get about => 'Hakkında';

  @override
  String get licenses => 'Açık kaynak lisansları';

  @override
  String get merge => 'Birleştir';

  @override
  String get split => 'Ayır';

  @override
  String get mergeHint =>
      'Aynı değerin bir parçası yapmak için başka bir kutuya dokunun';

  @override
  String get classOrganization => 'Kuruluş';

  @override
  String get classDeviceId => 'Cihaz kimliği';

  @override
  String get classSecret => 'Gizli bilgi';

  @override
  String get classPerson => 'Kişi';

  @override
  String get classHealth => 'Sağlık';

  @override
  String get classPersonalInfo => 'Kişisel bilgiler';

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

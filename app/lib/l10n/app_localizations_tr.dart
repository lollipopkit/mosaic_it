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
      one: '1 görsel dışa aktarıldı',
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
      one: 'Orada 1 özel görünümlü bölge hâlâ görünür ($classes).',
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
      one: '1 alan hâlâ okunabilir olabilir',
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
    return '$selected / $total seçili';
  }

  @override
  String get fillStyle => 'Dolgu stili';

  @override
  String get colour => 'Renk';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images görsel',
      one: '1 görsel',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions bölge',
      one: '1 bölge',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Paylaş';

  @override
  String get saveToPhotos => 'Fotoğraflar’a kaydet';

  @override
  String get saveAs => 'Kaydet…';

  @override
  String get exportFormat => 'Biçim';

  @override
  String get exportSize => 'Boyut';

  @override
  String get sizeOriginal => 'Orijinal';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count görsel Fotoğraflar’a kaydedildi',
      one: '1 görsel Fotoğraflar’a kaydedildi',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Tümü';

  @override
  String get selectNone => 'Hiçbiri';

  @override
  String get suggested => 'önerilen';

  @override
  String scoreValue(String score) {
    return 'Puan $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Gizlemeden sonra, denetim $index. görselin çıktısında bu alanları hâlâ buldu.';
  }

  @override
  String get reasonNotSelected => 'seçilmedi';

  @override
  String get reasonBoxTooSmall => 'kutu çok küçük';

  @override
  String get reasonFillShowsThrough => 'dolgu altından görünüyor';

  @override
  String get openSource => 'Açık kaynak';

  @override
  String get adaptivePreselectTitle => 'Yerel uyarlanabilir ön seçim';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sınıf ayarlandı',
      one: '1 sınıf ayarlandı',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Yerel tercihleri sıfırla';

  @override
  String get adaptiveResetDone => 'Yerel tercihler sıfırlandı';

  @override
  String get feedbackTitle => 'Algılama sorunu bildir';

  @override
  String get feedbackShort => 'Geri bildirim';

  @override
  String get feedbackMenu => 'Sorun bildir';

  @override
  String get feedbackAction => 'Bildir';

  @override
  String get feedbackAttachScreenshot => 'Ekran görüntüsü ekle';

  @override
  String get feedbackModeMasked => 'Yalnızca hatalar';

  @override
  String get feedbackModeFull => 'Tam görsel';

  @override
  String get feedbackModeText => 'Görsel yok';

  @override
  String get feedbackTagMissed => 'Kaçırıldı';

  @override
  String get feedbackTagFalsePositive => 'Yanlış pozitif';

  @override
  String get feedbackTagBoxDrift => 'Kutu kayması';

  @override
  String get feedbackTagWrongClass => 'Yanlış sınıf';

  @override
  String get feedbackTagOther => 'Diğer';

  @override
  String get feedbackNoteHint => 'İsteğe bağlı not…';

  @override
  String feedbackCountMasked(int count) {
    return 'Gizlenen $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Kaçırılan $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Yanlış pozitif $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'İşareti kaldırılan $count';
  }

  @override
  String get feedbackBoxMissed => 'Kaçırıldı';

  @override
  String get feedbackBoxMissedMasked => 'Kaçırıldı · gizlendi';

  @override
  String get feedbackBoxFp => 'Yanlış pozitif';

  @override
  String get feedbackBoxPreference => 'Görünür bırak';

  @override
  String get introOfflineTitle => 'Ağ erişimi yok';

  @override
  String get introOfflineBody =>
      'MosaicIt hiçbir ağ kodu içermez ve ağ izni istemez. Algılayıcı uygulamanın içine gömülüdür; görseller cihazınızdan asla çıkmaz.';

  @override
  String get introNoNetPermTitle => 'Sıfır ağ izni';

  @override
  String get introBundledModelTitle => 'Cihaz içi yerleşik model';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · cihaz içi';
  }

  @override
  String get resetBundledModel => 'Yerleşik modeli kullan';

  @override
  String get reviewIntro => 'Tanıtımı tekrar göster';

  @override
  String get feedbackOpenWeb => 'Web formunu aç';

  @override
  String get introNoNetPermBodyIos => 'Ağ isteği yok · yalnızca cihaz içinde';

  @override
  String get introNoNetPermBodyAndroid => 'INTERNET izni tanımlı değil';

  @override
  String get introNoNetPermBodyDesktop => 'Korumalı alanda ağ yetkisi yok';

  @override
  String get customModel => 'Özel model';

  @override
  String modelClassCount(int count) {
    return '$count sınıf';
  }

  @override
  String get copyImage => 'Görseli kopyala';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get copyFailed => 'Görsel kopyalanamadı';

  @override
  String get peekOriginal => 'Orijinalle karşılaştırmak için basılı tutun';

  @override
  String get selectMedia => 'Fotoğraf seç';

  @override
  String get saveFailed => 'Fotoğraflar’a kaydedilemedi';

  @override
  String get retry => 'Yeniden dene';

  @override
  String get iosWirelessPromptTitle => 'Kablosuz veri istemi';

  @override
  String get iosWirelessPromptBody =>
      'Sistem fotoğraf seçicisini açmak, iCloud küçük resimleri için bir iOS kablosuz veri istemini tetikleyebilir. MosaicIt ağ kullanmaz — “İzin Verme”ye dokunun.';

  @override
  String get continueAction => 'Devam et';
}

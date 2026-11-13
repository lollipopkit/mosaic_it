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
  String get reviewButton => 'İncele';

  @override
  String get openingLabels => 'Etiketler açılıyor…';

  @override
  String noImagesIn(String name) {
    return '$name içinde görsel yok';
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
  String get reviewPseudoLabels =>
      'Sahte etiketleri gözden geçir (coco.json içeren klasör)';

  @override
  String get regionsTooltip => 'Bölgeler';

  @override
  String get notCalibrated =>
      'Model kalibre edilmemiş: ön seçim sabit bir eşik değeri kullanır.';

  @override
  String calibratedUnverified(String domain) {
    return 'Doğrulanmamış verilerde kalibre edildi ($domain): hatırlatma garantisi henüz geçerli değil.';
  }

  @override
  String calibratedFor(String domain) {
    return '$domain görselleri için kalibre edildi. Diğer türdeki görseller garanti kapsamı dışındadır.';
  }

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
  String get verifyNext => 'Doğrula ve sonraki';

  @override
  String get export => 'Dışa aktar';

  @override
  String get pickOneModel => 'Tam olarak bir .onnx modeli seçin';

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
  String noLabelsIn(String name) {
    return '$name içinde coco.json yok';
  }

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
  String get collectTitle => 'Eğitim verisi topla';

  @override
  String get collectSubtitle =>
      'Dışa aktarılan her görseli, algılanan alanları ve seçimlerinizi gelecekteki modelleri eğitmek için bu cihazda saklayın. Hiçbir şey yüklenmez.';

  @override
  String collectStats(int count, String size) {
    return '$count görsel · $size';
  }

  @override
  String get collectDelete => 'Toplanan verileri sil';

  @override
  String get collectDeleteConfirm =>
      'Toplanan tüm görseller ve seçimler bu cihazdan silinsin mi?';

  @override
  String get delete => 'Sil';

  @override
  String collectFailed(String error) {
    return 'Eğitim verisi kaydedilemedi: $error';
  }

  @override
  String labelsSaved(int count) {
    return '$count görselin etiketleri kaydedildi';
  }

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
  String annotateOf(int index, int total) {
    return '$index / $total etiketle';
  }

  @override
  String get suggestions => 'Öneriler';

  @override
  String get skip => 'Atla';

  @override
  String get nothingPrivate => 'Özel bilgi yok';

  @override
  String get next => 'İleri';

  @override
  String get annotateHint =>
      'Bir metin satırına dokunarak kutu ekleyin veya çizmek için sürükleyin';

  @override
  String get annotationData => 'Etiketleme verileri';

  @override
  String get statLabeled => 'Etiketlendi';

  @override
  String get statEmpty => 'Özel bilgi yok';

  @override
  String get statSkipped => 'Atlandı';

  @override
  String get boxesPerClass => 'Sınıfa göre kutular';

  @override
  String get imagesHeader => 'Görseller';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kutu',
      many: '$count kutu',
      few: '$count kutu',
      two: '2 kutu',
      one: '1 kutu',
      zero: '0 kutu',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Tümünü dışa aktar';

  @override
  String get deleteAll => 'Tümünü sil';

  @override
  String get annotateDeleteConfirm =>
      'Tüm etiketlemeler ve görselleri bu cihazdan silinsin mi?';

  @override
  String get noAnnotations =>
      'Henüz etiketleme yok. Görselleri seçin ve Etiketle\'yi seçin.';

  @override
  String get filterScreenshots => 'Ekran görüntüleri';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterVideos => 'Videolar';

  @override
  String get albums => 'Albümler';

  @override
  String get limitedAccess =>
      'MosaicIt yalnızca fotoğraflarınızın bir kısmını görebilir';

  @override
  String get manage => 'Yönet';

  @override
  String selectedImages(int count) {
    return '$count seçildi';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count görseli sansürlensin',
      many: '$count görseli sansürlensin',
      few: '$count görseli sansürlensin',
      two: '2 görseli sansürlensin',
      one: '1 görseli sansürlensin',
      zero: '0 görseli sansürlensin',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Etiketle';

  @override
  String get badgeRedacted => 'Gizlendi';

  @override
  String get badgeAnnotated => 'Etiketlendi';

  @override
  String get photosDenied =>
      'MosaicIt, fotoğrafları burada göstermek için fotoğraflarınıza erişime ihtiyaç duyar. Fotoğraflar asla bu cihazdan ayrılmaz.';

  @override
  String get openSettings => 'Ayarları Aç';

  @override
  String get openFiles => 'Dosyaları aç';

  @override
  String get noPhotos => 'Burada fotoğraf yok';

  @override
  String get loading => 'Yükleniyor…';

  @override
  String get appearance => 'Görünüm';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Uygulama simgesi';

  @override
  String get aspectRatioGrid => 'En boy oranlı ızgara';

  @override
  String get modelDownloadFailed => 'Model indirilemedi';

  @override
  String get retry => 'Yeniden dene';

  @override
  String get autoUpdateModel => 'Modeli otomatik güncelle';

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
  String get localOnly =>
      'Yalnızca bu cihazda tutulur, asla iCloud veya yedeklerde tutulmaz.';

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

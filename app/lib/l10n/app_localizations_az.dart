// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Model yüklənir…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Modeli istifadə et';

  @override
  String get imagesFileType => 'Şəkillər';

  @override
  String get detecting => 'Aşkarlanır…';

  @override
  String detectingProgress(int current, int total) {
    return 'Aşkarlanır $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Əvvəlcə bir model seçin';

  @override
  String get findingSimilar => 'Oxşarlar axtarılır…';

  @override
  String similarSelected(int found, int added) {
    return '$found oxşar sahə seçildi ($added yeni)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$images şəkildə $found oxşar sahə seçildi ($added yeni)';
  }

  @override
  String get saving => 'Saxlanılır…';

  @override
  String get exportHere => 'Bura ixrac et';

  @override
  String exportStoppedAt(String name) {
    return 'İxrac $name faylında dayandırıldı';
  }

  @override
  String exportedTo(String path) {
    return '$path ünvanına ixrac edildi';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path ünvanına ixrac edildi (səssiz)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şəkil ixrac edildi',
      one: '1 şəkil ixrac edildi',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name yoxlanılır…';
  }

  @override
  String get checkingAndExporting => 'Yoxlanılır və ixrac edilir…';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get exportAnyway => 'Yenə də ixrac et';

  @override
  String get regionsTooltip => 'Sahələr';

  @override
  String get cameraPhoto =>
      'Bu, kamera fotosudur; aşkarlayıcı ekran görüntüləri üçün hazırlanıb, ona görə buradakı çərçivələr etibarsızdır.';

  @override
  String get modeDraw => 'Çək';

  @override
  String get fillSolid => 'Bütöv rəng';

  @override
  String get fillBlocks => 'Boz mozaika';

  @override
  String get fillNoise => 'Küy';

  @override
  String get export => 'İxrac et';

  @override
  String pickOneModel(String formats) {
    return 'Dəqiq bir $formats modeli seçin';
  }

  @override
  String pickSidecar(String name) {
    return '$name.json faylını da seçin';
  }

  @override
  String get analysing => 'Təhlil edilir';

  @override
  String get followingRegion => 'Sahə izlənilir';

  @override
  String get exporting => 'İxrac edilir';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count kadr';
  }

  @override
  String redactingSpan(String start, String end) {
    return '$start – $end aralığı gizlədilir';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'İxrac yoxlaması $time anında uğursuz oldu';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Orada $count məxfi görünüşlü sahə hələ də görünür ($classes).',
      one: 'Orada 1 məxfi görünüşlü sahə hələ də görünür ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Kadrı göstər';

  @override
  String get drawMissedRegion => 'Aşkarlayıcının qaçırdığı sahəni çəkin';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$total izləmədən $on ədədi gizlədildi · $keyframes açar kadr';
  }

  @override
  String get keepAudio => 'Səsi saxla';

  @override
  String get keepAudioHint => 'Səslər və bildiriş səsləri yoxlanılmır';

  @override
  String get goToFirstAppearance => 'İlk görünüşə keç';

  @override
  String get classPersonName => 'Ad';

  @override
  String get classAddress => 'Ünvan';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-poçt';

  @override
  String get classIdNumber => 'Şəxsiyyət nömrəsi';

  @override
  String get classBankCard => 'Bank kartı';

  @override
  String get classPlate => 'Dövlət nömrəsi';

  @override
  String get classAccountId => 'Hesab';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Üz';

  @override
  String get classQr => 'QR kod';

  @override
  String get classBarcode => 'Ştrix-kod';

  @override
  String get classManual => 'Əl ilə';

  @override
  String savedModelFailed(String error) {
    return 'Saxlanılmış model yüklənə bilmədi; yenidən model seçin. ($error)';
  }

  @override
  String get fillSurround => 'Arxa plan rəngi';

  @override
  String get fillTinted => 'Rəngli mozaika';

  @override
  String get settings => 'Ayarlar';

  @override
  String get classFinance => 'Maliyyə';

  @override
  String get delete => 'Sil';

  @override
  String get undo => 'Geri al';

  @override
  String get redo => 'Təkrarla';

  @override
  String get similar => 'Oxşar';

  @override
  String get thisImage => 'Bu şəkil';

  @override
  String allImagesCount(int count) {
    return 'Bütün $count şəkil';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sahə hələ də oxuna bilər',
      one: '1 sahə hələ də oxuna bilər',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Gizlətmədən sonra yoxlama çıxışda bu sahələri hələ də aşkar etdi.';

  @override
  String get redactThemAndExport => 'Gizlət və ixrac et';

  @override
  String get showThem => 'Göstər';

  @override
  String get pickClass => 'Sinif seçin';

  @override
  String get appearance => 'Görünüş';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Tətbiq nişanı';

  @override
  String get threshold => 'Hədd';

  @override
  String get thresholdLow => 'Aşağı';

  @override
  String get thresholdMedium => 'Orta';

  @override
  String get thresholdHigh => 'Yüksək';

  @override
  String get redaction => 'Gizlətmə';

  @override
  String get style => 'Üslub';

  @override
  String get selectedByDefault => 'Defolt olaraq seçili';

  @override
  String get dataPrivacy => 'Məlumat və məxfilik';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Başqa model idxal et';

  @override
  String get advanced => 'Ətraflı';

  @override
  String get about => 'Haqqında';

  @override
  String get licenses => 'Açıq mənbə lisenziyaları';

  @override
  String get merge => 'Birləşdir';

  @override
  String get split => 'Ayır';

  @override
  String get mergeHint =>
      'Eyni dəyərin hissəsi etmək üçün başqa çərçivəyə toxunun';

  @override
  String get classOrganization => 'Təşkilat';

  @override
  String get classDeviceId => 'Cihaz ID-si';

  @override
  String get classSecret => 'Məxfi məlumat';

  @override
  String get classPerson => 'Şəxs';

  @override
  String get classHealth => 'Sağlamlıq';

  @override
  String get classPersonalInfo => 'Şəxsi məlumat';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total seçilib';
  }

  @override
  String get fillStyle => 'Doldurma üslubu';

  @override
  String get colour => 'Rəng';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images şəkil',
      one: '1 şəkil',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions sahə',
      one: '1 sahə',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Paylaş';

  @override
  String get saveToPhotos => 'Fotolarda saxla';

  @override
  String get saveAs => 'Saxla…';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportSize => 'Ölçü';

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
      other: '$count şəkil Fotolarda saxlanıldı',
      one: '1 şəkil Fotolarda saxlanıldı',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Hamısı';

  @override
  String get selectNone => 'Heç biri';

  @override
  String get suggested => 'təklif olunan';

  @override
  String scoreValue(String score) {
    return 'Bal $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Gizlətmədən sonra yoxlama $index. şəklin çıxışında bu sahələri hələ də aşkar etdi.';
  }

  @override
  String get reasonNotSelected => 'seçilməyib';

  @override
  String get reasonBoxTooSmall => 'çərçivə çox kiçikdir';

  @override
  String get reasonFillShowsThrough => 'doldurma altından görünür';

  @override
  String get openSource => 'Açıq mənbə';

  @override
  String get adaptivePreselectTitle => 'Yerli uyğunlaşan ön seçim';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sinif tənzimləndi',
      one: '1 sinif tənzimləndi',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Yerli seçimləri sıfırla';

  @override
  String get adaptiveResetDone => 'Yerli seçimlər sıfırlandı';

  @override
  String get feedbackTitle => 'Aşkarlama problemini bildir';

  @override
  String get feedbackShort => 'Rəy';

  @override
  String get feedbackMenu => 'Problem bildir';

  @override
  String get feedbackAction => 'Bildir';

  @override
  String get feedbackAttachScreenshot => 'Ekran görüntüsü əlavə et';

  @override
  String get feedbackModeMasked => 'Yalnız xətalar';

  @override
  String get feedbackModeFull => 'Tam şəkil';

  @override
  String get feedbackModeText => 'Şəkilsiz';

  @override
  String get feedbackTagMissed => 'Qaçırılıb';

  @override
  String get feedbackTagFalsePositive => 'Yanlış aşkarlama';

  @override
  String get feedbackTagBoxDrift => 'Çərçivə sürüşməsi';

  @override
  String get feedbackTagWrongClass => 'Səhv sinif';

  @override
  String get feedbackTagOther => 'Digər';

  @override
  String get feedbackNoteHint => 'İstəyə bağlı qeyd…';

  @override
  String feedbackCountMasked(int count) {
    return 'Gizlədilib $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Qaçırılıb $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Yanlış aşkarlama $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Seçimi silinib $count';
  }

  @override
  String get feedbackBoxMissed => 'Qaçırılıb';

  @override
  String get feedbackBoxMissedMasked => 'Qaçırılıb · gizlədilib';

  @override
  String get feedbackBoxFp => 'Yanlış aşkarlama';

  @override
  String get feedbackBoxPreference => 'Görünən saxla';

  @override
  String get introOfflineTitle => 'Şəbəkə girişi yoxdur';

  @override
  String get introOfflineBody =>
      'MosaicIt heç bir şəbəkə kodu ehtiva etmir və şəbəkə icazəsi istəmir. Aşkarlayıcı tətbiqin daxilinə quraşdırılıb, şəkillər heç vaxt cihazınızı tərk etmir.';

  @override
  String get introNoNetPermTitle => 'Sıfır şəbəkə icazəsi';

  @override
  String get introBundledModelTitle => 'Cihazdaxili daxili model';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · cihazda';
  }

  @override
  String get resetBundledModel => 'Daxili modeli istifadə et';

  @override
  String get reviewIntro => 'Tanıtımı yenidən göstər';

  @override
  String get feedbackOpenWeb => 'Veb-formanı aç';

  @override
  String get introNoNetPermBodyIos => 'Şəbəkə sorğusu yoxdur · yalnız cihazda';

  @override
  String get introNoNetPermBodyAndroid => 'INTERNET icazəsi elan edilməyib';

  @override
  String get introNoNetPermBodyDesktop =>
      'Təcrid mühitində şəbəkə hüququ yoxdur';

  @override
  String get customModel => 'Fərdi model';

  @override
  String modelClassCount(int count) {
    return '$count sinif';
  }

  @override
  String get copyImage => 'Şəkli kopyala';

  @override
  String get copiedToClipboard => 'Mübadilə buferinə kopyalandı';

  @override
  String get copyFailed => 'Şəkil kopyalana bilmədi';

  @override
  String get peekOriginal => 'Orijinal ilə müqayisə üçün basıb saxlayın';

  @override
  String get selectMedia => 'Fotoları seç';

  @override
  String get saveFailed => 'Fotolarda saxlanıla bilmədi';

  @override
  String get retry => 'Yenidən cəhd et';

  @override
  String get iosWirelessPromptTitle => 'Simsiz məlumat sorğusu';

  @override
  String get iosWirelessPromptBody =>
      'Sistem foto seçicisini açmaq iCloud kiçik şəkilləri üçün iOS simsiz məlumat sorğusunu göstərə bilər. MosaicIt şəbəkədən istifadə etmir — “İcazə vermə” seçiminə toxunun.';

  @override
  String get continueAction => 'Davam et';
}

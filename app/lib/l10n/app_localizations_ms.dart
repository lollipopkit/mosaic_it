// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Memuatkan model…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Guna model';

  @override
  String get imagesFileType => 'Imej';

  @override
  String get detecting => 'Mengesan…';

  @override
  String detectingProgress(int current, int total) {
    return 'Mengesan $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Pilih model dahulu';

  @override
  String get findingSimilar => 'Mencari yang serupa…';

  @override
  String similarSelected(int found, int added) {
    return '$found kawasan serupa dipilih ($added baharu)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found kawasan serupa dipilih ($added baharu) merentasi $images imej';
  }

  @override
  String get saving => 'Menyimpan…';

  @override
  String get exportHere => 'Eksport di sini';

  @override
  String exportStoppedAt(String name) {
    return 'Eksport berhenti pada $name';
  }

  @override
  String exportedTo(String path) {
    return 'Dieksport ke $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Dieksport ke $path (tiada audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imej dieksport',
      one: '1 imej dieksport',
      zero: 'Tiada imej dieksport',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Memeriksa $name…';
  }

  @override
  String get checkingAndExporting => 'Memeriksa dan mengeksport…';

  @override
  String get cancel => 'Batal';

  @override
  String get exportAnyway => 'Eksport juga';

  @override
  String get regionsTooltip => 'Kawasan';

  @override
  String get cameraPhoto =>
      'Ini adalah foto kamera; pengesan ini direka untuk tangkapan skrin, jadi kotak di sini tidak boleh dipercayai.';

  @override
  String get modeDraw => 'Lukis';

  @override
  String get fillSolid => 'Warna pepejal';

  @override
  String get fillBlocks => 'Mozek kelabu';

  @override
  String get fillNoise => 'Hingar';

  @override
  String get export => 'Eksport';

  @override
  String pickOneModel(String formats) {
    return 'Pilih tepat satu model $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Pilih juga $name.json';
  }

  @override
  String get analysing => 'Menganalisis';

  @override
  String get followingRegion => 'Mengikut kawasan';

  @override
  String get exporting => 'Mengeksport';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count bingkai';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Menyunting $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Pemeriksaan eksport gagal pada $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count kawasan yang kelihatan peribadi masih kelihatan di sana ($classes).',
      one:
          '1 kawasan yang kelihatan peribadi masih kelihatan di sana ($classes).',
      zero:
          'Tiada kawasan yang kelihatan peribadi masih kelihatan di sana ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Tunjuk bingkai';

  @override
  String get drawMissedRegion => 'Lukis kawasan yang terlepas oleh pengesan';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on daripada $total jejak disunting · $keyframes bingkai kunci';
  }

  @override
  String get keepAudio => 'Kekal audio';

  @override
  String get keepAudioHint => 'Suara dan bunyi notifikasi tidak diperiksa';

  @override
  String get goToFirstAppearance => 'Pergi ke penampilan pertama';

  @override
  String get classPersonName => 'Nama';

  @override
  String get classAddress => 'Alamat';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-mel';

  @override
  String get classIdNumber => 'Nombor ID';

  @override
  String get classBankCard => 'Kad bank';

  @override
  String get classPlate => 'Plat';

  @override
  String get classAccountId => 'Akaun';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Wajah';

  @override
  String get classQr => 'Kod QR';

  @override
  String get classBarcode => 'Kod bar';

  @override
  String get classManual => 'Manual';

  @override
  String savedModelFailed(String error) {
    return 'Model yang disimpan tidak dapat dimuatkan; pilih model sekali lagi. ($error)';
  }

  @override
  String get fillSurround => 'Warna latar';

  @override
  String get fillTinted => 'Mozek berwarna';

  @override
  String get settings => 'Tetapan';

  @override
  String get classFinance => 'Jumlah';

  @override
  String get delete => 'Padam';

  @override
  String get undo => 'Batal';

  @override
  String get redo => 'Ulang';

  @override
  String get similar => 'Serupa';

  @override
  String get thisImage => 'Imej ini';

  @override
  String allImagesCount(int count) {
    return 'Semua $count imej';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kawasan mungkin masih boleh dibaca',
      many: 'Banyak kawasan mungkin masih boleh dibaca',
      few: 'Beberapa kawasan mungkin masih boleh dibaca',
      two: '2 kawasan mungkin masih boleh dibaca',
      one: '1 kawasan mungkin masih boleh dibaca',
      zero: 'Tiada kawasan boleh dibaca',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Selepas penyorotan, semakan masih menemui kawasan-kawasan ini dalam output.';

  @override
  String get redactThemAndExport => 'Sorot dan eksport';

  @override
  String get showThem => 'Tunjuk';

  @override
  String get pickClass => 'Pilih kelas';

  @override
  String get appearance => 'Penampilan';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ikon app';

  @override
  String get threshold => 'Ambang';

  @override
  String get thresholdLow => 'Rendah';

  @override
  String get thresholdMedium => 'Sederhana';

  @override
  String get thresholdHigh => 'Tinggi';

  @override
  String get redaction => 'Penyorotan';

  @override
  String get style => 'Gaya';

  @override
  String get selectedByDefault => 'Dipilih secara lalai';

  @override
  String get dataPrivacy => 'Data dan privasi';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Import model lain';

  @override
  String get advanced => 'Lanjutan';

  @override
  String get about => 'Mengenai';

  @override
  String get licenses => 'Lesen sumber terbuka';

  @override
  String get merge => 'Gabung';

  @override
  String get split => 'Pecahkan';

  @override
  String get mergeHint =>
      'Ketik kotak lain untuk menjadikannya sebahagian daripada nilai yang sama';

  @override
  String get classOrganization => 'Organisasi';

  @override
  String get classDeviceId => 'ID peranti';

  @override
  String get classSecret => 'Kelayakan';

  @override
  String get classPerson => 'Orang';

  @override
  String get classHealth => 'Kesihatan';

  @override
  String get classPersonalInfo => 'Maklumat peribadi';

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
  String get selectMedia => 'Select photos';

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

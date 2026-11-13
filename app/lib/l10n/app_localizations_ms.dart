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
  String get reviewButton => 'Semak';

  @override
  String get openingLabels => 'Membuka label…';

  @override
  String noImagesIn(String name) {
    return 'Tiada imej dalam $name';
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
  String get reviewPseudoLabels =>
      'Semak label pseudo (folder dengan coco.json)';

  @override
  String get regionsTooltip => 'Kawasan';

  @override
  String get notCalibrated =>
      'Model tidak dikalibrasi: prapilihan menggunakan ambang tetap.';

  @override
  String calibratedUnverified(String domain) {
    return 'Dikalibrasi pada data tidak disahkan ($domain): jaminan recall belum terpakai.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Dikalibrasi untuk imej $domain. Jenis imej lain di luar jaminan.';
  }

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
  String get verifyNext => 'Sahkan & seterusnya';

  @override
  String get export => 'Eksport';

  @override
  String get pickOneModel => 'Pilih tepat satu model .onnx';

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
  String noLabelsIn(String name) {
    return 'Tiada coco.json dalam $name';
  }

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
  String get collectTitle => 'Kumpul data latihan';

  @override
  String get collectSubtitle =>
      'Simpan setiap imej yang dieksport, kawasan yang dikesan dan pilihan anda pada peranti ini untuk melatih model akan datang. Tiada apa-apa dimuat naik.';

  @override
  String collectStats(int count, String size) {
    return '$count imej · $size';
  }

  @override
  String get collectDelete => 'Padam data yang dikumpul';

  @override
  String get collectDeleteConfirm =>
      'Padam semua imej dan pilihan yang dikumpul daripada peranti ini?';

  @override
  String get delete => 'Padam';

  @override
  String collectFailed(String error) {
    return 'Tidak dapat menyimpan data latihan: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Label disimpan untuk $count imej';
  }

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
  String annotateOf(int index, int total) {
    return 'Annotasi $index / $total';
  }

  @override
  String get suggestions => 'Cadangan';

  @override
  String get skip => 'Langkau';

  @override
  String get nothingPrivate => 'Tiada maklumat peribadi';

  @override
  String get next => 'Seterusnya';

  @override
  String get annotateHint =>
      'Ketik baris teks untuk mengkotak, atau seret untuk melukis';

  @override
  String get annotationData => 'Data anotasi';

  @override
  String get statLabeled => 'Dilabel';

  @override
  String get statEmpty => 'Tiada maklumat peribadi';

  @override
  String get statSkipped => 'Dilangkau';

  @override
  String get boxesPerClass => 'Kotak mengikut kelas';

  @override
  String get imagesHeader => 'Imej';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kotak',
      many: 'Banyak kotak',
      few: 'Beberapa kotak',
      two: '2 kotak',
      one: '1 kotak',
      zero: '0 kotak',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Eksport semua';

  @override
  String get deleteAll => 'Padam semua';

  @override
  String get annotateDeleteConfirm =>
      'Padam semua anotasi dan imejnya daripada peranti ini?';

  @override
  String get noAnnotations =>
      'Belum ada anotasi. Pilih imej dan pilih Annotasi.';

  @override
  String get filterScreenshots => 'Tangkapan skrin';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterVideos => 'Video';

  @override
  String get albums => 'Album';

  @override
  String get limitedAccess =>
      'MosaicIt hanya boleh melihat sebahagian daripada foto anda';

  @override
  String get manage => 'Urus';

  @override
  String selectedImages(int count) {
    return '$count dipilih';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sorot $count imej',
      many: 'Sorot banyak imej',
      few: 'Sorot beberapa imej',
      two: 'Sorot 2 imej',
      one: 'Sorot 1 imej',
      zero: 'Sorot 0 imej',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annotasi';

  @override
  String get badgeRedacted => 'Disorot';

  @override
  String get badgeAnnotated => 'Dianotasi';

  @override
  String get photosDenied =>
      'MosaicIt memerlukan akses ke foto anda untuk memaparkannya di sini. Foto tidak pernah keluar daripada peranti ini.';

  @override
  String get openSettings => 'Buka Tetapan';

  @override
  String get openFiles => 'Buka fail';

  @override
  String get noPhotos => 'Tiada foto di sini';

  @override
  String get loading => 'Memuatkan…';

  @override
  String get appearance => 'Penampilan';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ikon app';

  @override
  String get aspectRatioGrid => 'Grid nisbah aspek';

  @override
  String get modelDownloadFailed => 'Model tidak dapat dimuat turun';

  @override
  String get retry => 'Cuba lagi';

  @override
  String get autoUpdateModel => 'Kemas kini model secara automatik';

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
  String get localOnly =>
      'Disimpan pada peranti ini sahaja, tidak pernah dalam iCloud atau sandaran.';

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

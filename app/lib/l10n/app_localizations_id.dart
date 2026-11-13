// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Memuat model…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Gunakan model';

  @override
  String get imagesFileType => 'Gambar';

  @override
  String get detecting => 'Mendeteksi…';

  @override
  String detectingProgress(int current, int total) {
    return 'Mendeteksi $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Pilih model terlebih dahulu';

  @override
  String get findingSimilar => 'Mencari yang serupa…';

  @override
  String similarSelected(int found, int added) {
    return '$found wilayah serupa dipilih ($added baru)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found wilayah serupa dipilih ($added baru) di $images gambar';
  }

  @override
  String get reviewButton => 'Tinjau';

  @override
  String get openingLabels => 'Membuka label…';

  @override
  String noImagesIn(String name) {
    return 'Tidak ada gambar di $name';
  }

  @override
  String get saving => 'Menyimpan…';

  @override
  String get exportHere => 'Ekspor di sini';

  @override
  String exportStoppedAt(String name) {
    return 'Ekspor berhenti di $name';
  }

  @override
  String exportedTo(String path) {
    return 'Diekspor ke $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Diekspor ke $path (tanpa audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gambar diekspor',
      one: '1 gambar diekspor',
      zero: '0 gambar diekspor',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Memeriksa $name…';
  }

  @override
  String get checkingAndExporting => 'Memeriksa dan mengekspor…';

  @override
  String get cancel => 'Batal';

  @override
  String get exportAnyway => 'Ekspor saja';

  @override
  String get reviewPseudoLabels =>
      'Tinjau label semu (folder dengan coco.json)';

  @override
  String get regionsTooltip => 'Wilayah';

  @override
  String get notCalibrated =>
      'Model tidak dikalibrasi: praseleksi menggunakan ambang batas tetap.';

  @override
  String calibratedUnverified(String domain) {
    return 'Dikalibrasi pada data yang belum diverifikasi ($domain): jaminan recall belum berlaku.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Dikalibrasi untuk gambar $domain. Jenis gambar lainnya di luar jaminan.';
  }

  @override
  String get cameraPhoto =>
      'Ini adalah foto kamera; detektor dibuat untuk tangkapan layar, sehingga kotak di sini tidak dapat diandalkan.';

  @override
  String get modeDraw => 'Gambar';

  @override
  String get fillLabel => 'Isi';

  @override
  String get fillSolid => 'Warna solid';

  @override
  String get fillBlocks => 'Mozaik abu-abu';

  @override
  String get fillNoise => 'Derau';

  @override
  String get verifyNext => 'Verifikasi & berikutnya';

  @override
  String get export => 'Ekspor';

  @override
  String get pickOneModel => 'Pilih tepat satu model .onnx';

  @override
  String pickSidecar(String name) {
    return 'Juga pilih $name.json';
  }

  @override
  String get analysing => 'Menganalisis';

  @override
  String get followingRegion => 'Mengikuti wilayah';

  @override
  String get exporting => 'Mengekspor';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count bingkai';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Mensori $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Pemeriksaan ekspor gagal pada $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count wilayah yang terlihat privat masih terlihat di sana ($classes).',
      one: '1 wilayah yang terlihat privat masih terlihat di sana ($classes).',
      zero: 'Tidak ada wilayah yang terlihat privat di sana.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Tampilkan bingkai';

  @override
  String get drawMissedRegion => 'Gambar wilayah yang terlewat oleh detektor';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on dari $total lacakan disensor · $keyframes bingkai kunci';
  }

  @override
  String get keepAudio => 'Simpan audio';

  @override
  String get keepAudioHint => 'Suara dan bunyi notifikasi tidak diperiksa';

  @override
  String get goToFirstAppearance => 'Pergi ke kemunculan pertama';

  @override
  String get classPersonName => 'Nama';

  @override
  String get classAddress => 'Alamat';

  @override
  String get classPhone => 'Telepon';

  @override
  String get classEmail => 'Email';

  @override
  String get classIdNumber => 'Nomor ID';

  @override
  String get classBankCard => 'Kartu bank';

  @override
  String get classPlate => 'Plat nomor';

  @override
  String get classAccountId => 'Akun';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Wajah';

  @override
  String get classQr => 'Kode QR';

  @override
  String get classBarcode => 'Kode batang';

  @override
  String get classManual => 'Manual';

  @override
  String noLabelsIn(String name) {
    return 'Tidak ada coco.json di $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Model yang disimpan tidak dapat dimuat; pilih model lagi. ($error)';
  }

  @override
  String get fillSurround => 'Warna latar';

  @override
  String get fillTinted => 'Mozaik warna';

  @override
  String get settings => 'Pengaturan';

  @override
  String get classFinance => 'Jumlah';

  @override
  String get collectTitle => 'Kumpulkan data pelatihan';

  @override
  String get collectSubtitle =>
      'Simpan setiap gambar yang diekspor, area yang terdeteksi, dan pilihan Anda di perangkat ini untuk melatih model di masa depan. Tidak ada yang diunggah.';

  @override
  String collectStats(int count, String size) {
    return '$count gambar · $size';
  }

  @override
  String get collectDelete => 'Hapus data yang dikumpulkan';

  @override
  String get collectDeleteConfirm =>
      'Hapus semua gambar dan pilihan yang dikumpulkan dari perangkat ini?';

  @override
  String get delete => 'Hapus';

  @override
  String collectFailed(String error) {
    return 'Tidak dapat menyimpan data pelatihan: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Label disimpan untuk $count gambar';
  }

  @override
  String get undo => 'Urungkan';

  @override
  String get redo => 'Ulangi';

  @override
  String get similar => 'Serupa';

  @override
  String get thisImage => 'Gambar ini';

  @override
  String allImagesCount(int count) {
    return 'Semua $count gambar';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count area masih mungkin terbaca',
      many: 'Banyak area masih mungkin terbaca',
      few: 'Beberapa area masih mungkin terbaca',
      two: '2 area masih mungkin terbaca',
      one: '1 area masih mungkin terbaca',
      zero: '0 area masih terbaca',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Setelah penyensoran, pemeriksaan masih menemukan area-area ini di hasil akhir.';

  @override
  String get redactThemAndExport => 'Sensor dan ekspor';

  @override
  String get showThem => 'Tampilkan';

  @override
  String get pickClass => 'Pilih kelas';

  @override
  String annotateOf(int index, int total) {
    return 'Anotasi $index / $total';
  }

  @override
  String get suggestions => 'Saran';

  @override
  String get skip => 'Lewati';

  @override
  String get nothingPrivate => 'Tidak ada data pribadi';

  @override
  String get next => 'Berikutnya';

  @override
  String get annotateHint =>
      'Ketuk baris teks untuk mengkotaknya, atau geser untuk menggambar';

  @override
  String get annotationData => 'Data anotasi';

  @override
  String get statLabeled => 'Diberi label';

  @override
  String get statEmpty => 'Tidak ada data pribadi';

  @override
  String get statSkipped => 'Dilewati';

  @override
  String get boxesPerClass => 'Kotak per kelas';

  @override
  String get imagesHeader => 'Gambar';

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
  String get exportAll => 'Ekspor semua';

  @override
  String get deleteAll => 'Hapus semua';

  @override
  String get annotateDeleteConfirm =>
      'Hapus semua anotasi dan gambarnya dari perangkat ini?';

  @override
  String get noAnnotations =>
      'Belum ada anotasi. Pilih gambar dan pilih Anotasi.';

  @override
  String get filterScreenshots => 'Tangkapan layar';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterVideos => 'Video';

  @override
  String get albums => 'Album';

  @override
  String get limitedAccess => 'MosaicIt hanya dapat melihat sebagian foto Anda';

  @override
  String get manage => 'Kelola';

  @override
  String selectedImages(int count) {
    return '$count dipilih';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sensor $count gambar',
      many: 'Sensor banyak gambar',
      few: 'Sensor beberapa gambar',
      two: 'Sensor 2 gambar',
      one: 'Sensor 1 gambar',
      zero: 'Sensor 0 gambar',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Anotasi';

  @override
  String get badgeRedacted => 'Disensor';

  @override
  String get badgeAnnotated => 'Dianotasi';

  @override
  String get photosDenied =>
      'MosaicIt memerlukan akses ke foto Anda untuk menampilkannya di sini. Foto tidak pernah meninggalkan perangkat ini.';

  @override
  String get openSettings => 'Buka Pengaturan';

  @override
  String get openFiles => 'Buka file';

  @override
  String get noPhotos => 'Tidak ada foto di sini';

  @override
  String get loading => 'Memuat…';

  @override
  String get appearance => 'Tampilan';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ikon app';

  @override
  String get aspectRatioGrid => 'Kisi rasio aspek';

  @override
  String get modelDownloadFailed => 'Model tidak dapat diunduh';

  @override
  String get retry => 'Coba lagi';

  @override
  String get autoUpdateModel => 'Perbarui model secara otomatis';

  @override
  String get threshold => 'Ambang';

  @override
  String get thresholdLow => 'Rendah';

  @override
  String get thresholdMedium => 'Sedang';

  @override
  String get thresholdHigh => 'Tinggi';

  @override
  String get redaction => 'Penyensoran';

  @override
  String get style => 'Gaya';

  @override
  String get selectedByDefault => 'Dipilih secara default';

  @override
  String get dataPrivacy => 'Data dan privasi';

  @override
  String get localOnly =>
      'Hanya disimpan di perangkat ini, tidak pernah di iCloud atau cadangan.';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Impor model lain';

  @override
  String get advanced => 'Lanjutan';

  @override
  String get about => 'Tentang';

  @override
  String get licenses => 'Lisensi sumber terbuka';

  @override
  String get merge => 'Gabungkan';

  @override
  String get split => 'Pisahkan';

  @override
  String get mergeHint =>
      'Ketuk kotak lain untuk menjadikannya bagian dari nilai yang sama';

  @override
  String get classOrganization => 'Organisasi';

  @override
  String get classDeviceId => 'ID perangkat';

  @override
  String get classSecret => 'Kredensial';
}

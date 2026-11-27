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
  String get regionsTooltip => 'Wilayah';

  @override
  String get cameraPhoto =>
      'Ini adalah foto kamera; detektor dibuat untuk tangkapan layar, sehingga kotak di sini tidak dapat diandalkan.';

  @override
  String get modeDraw => 'Gambar';

  @override
  String get fillSolid => 'Warna solid';

  @override
  String get fillBlocks => 'Mozaik abu-abu';

  @override
  String get fillNoise => 'Derau';

  @override
  String get export => 'Ekspor';

  @override
  String pickOneModel(String formats) {
    return 'Pilih tepat satu model $formats';
  }

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
    return 'Menyensor $start – $end';
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
  String get delete => 'Hapus';

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
      one: '1 area masih mungkin terbaca',
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
  String get appearance => 'Tampilan';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ikon app';

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

  @override
  String get classPerson => 'Orang';

  @override
  String get classHealth => 'Kesehatan';

  @override
  String get classPersonalInfo => 'Info pribadi';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total dipilih';
  }

  @override
  String get fillStyle => 'Gaya isian';

  @override
  String get colour => 'Warna';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images gambar',
      one: '1 gambar',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions wilayah',
      one: '1 wilayah',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Bagikan';

  @override
  String get saveToPhotos => 'Simpan ke Foto';

  @override
  String get saveAs => 'Simpan…';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportSize => 'Ukuran';

  @override
  String get sizeOriginal => 'Asli';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gambar disimpan ke Foto',
      one: '1 gambar disimpan ke Foto',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Semua';

  @override
  String get selectNone => 'Tidak ada';

  @override
  String get suggested => 'disarankan';

  @override
  String scoreValue(String score) {
    return 'Skor $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Setelah penyensoran, pemeriksaan masih menemukan area-area ini di hasil akhir gambar $index.';
  }

  @override
  String get reasonNotSelected => 'tidak dipilih';

  @override
  String get reasonBoxTooSmall => 'kotak terlalu kecil';

  @override
  String get reasonFillShowsThrough => 'isian tembus pandang';

  @override
  String get openSource => 'Sumber terbuka';

  @override
  String get adaptivePreselectTitle => 'Prapemilihan adaptif lokal';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kelas disesuaikan',
      one: '1 kelas disesuaikan',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Atur ulang preferensi lokal';

  @override
  String get adaptiveResetDone => 'Preferensi lokal diatur ulang';

  @override
  String get feedbackTitle => 'Laporkan masalah deteksi';

  @override
  String get feedbackShort => 'Masukan';

  @override
  String get feedbackMenu => 'Laporkan masalah';

  @override
  String get feedbackAction => 'Laporkan';

  @override
  String get feedbackAttachScreenshot => 'Lampirkan tangkapan layar';

  @override
  String get feedbackModeMasked => 'Hanya kesalahan';

  @override
  String get feedbackModeFull => 'Gambar penuh';

  @override
  String get feedbackModeText => 'Tanpa gambar';

  @override
  String get feedbackTagMissed => 'Terlewat';

  @override
  String get feedbackTagFalsePositive => 'Positif palsu';

  @override
  String get feedbackTagBoxDrift => 'Kotak bergeser';

  @override
  String get feedbackTagWrongClass => 'Kelas salah';

  @override
  String get feedbackTagOther => 'Lainnya';

  @override
  String get feedbackNoteHint => 'Catatan opsional…';

  @override
  String feedbackCountMasked(int count) {
    return 'Disensor $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Terlewat $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Positif palsu $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Tidak dicentang $count';
  }

  @override
  String get feedbackBoxMissed => 'Terlewat';

  @override
  String get feedbackBoxMissedMasked => 'Terlewat · disensor';

  @override
  String get feedbackBoxFp => 'Positif palsu';

  @override
  String get feedbackBoxPreference => 'Biarkan terlihat';

  @override
  String get introOfflineTitle => 'Tanpa akses jaringan';

  @override
  String get introOfflineBody =>
      'MosaicIt tidak memiliki kode jaringan dan tidak meminta izin jaringan. Detektor terpasang di dalam aplikasi, sehingga gambar tidak pernah meninggalkan perangkat Anda.';

  @override
  String get introNoNetPermTitle => 'Tanpa izin jaringan';

  @override
  String get introBundledModelTitle => 'Model bawaan di perangkat';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · di perangkat';
  }

  @override
  String get resetBundledModel => 'Gunakan model bawaan';

  @override
  String get reviewIntro => 'Tampilkan pengenalan lagi';

  @override
  String get feedbackOpenWeb => 'Buka formulir web';

  @override
  String get introNoNetPermBodyIos =>
      'Tanpa permintaan jaringan · hanya di perangkat';

  @override
  String get introNoNetPermBodyAndroid =>
      'Tidak ada izin INTERNET yang dideklarasikan';

  @override
  String get introNoNetPermBodyDesktop =>
      'Tidak ada hak akses jaringan di sandbox';

  @override
  String get customModel => 'Model kustom';

  @override
  String modelClassCount(int count) {
    return '$count kelas';
  }

  @override
  String get copyImage => 'Salin gambar';

  @override
  String get copiedToClipboard => 'Disalin ke papan klip';

  @override
  String get copyFailed => 'Tidak dapat menyalin gambar';

  @override
  String get peekOriginal => 'Tahan untuk membandingkan dengan asli';

  @override
  String get selectMedia => 'Pilih foto';

  @override
  String get saveFailed => 'Tidak dapat menyimpan ke Foto';

  @override
  String get retry => 'Coba lagi';

  @override
  String get iosWirelessPromptTitle => 'Permintaan data nirkabel';

  @override
  String get iosWirelessPromptBody =>
      'Membuka pemilih foto sistem dapat memunculkan permintaan data nirkabel iOS untuk gambar mini iCloud. MosaicIt tidak menggunakan jaringan — ketuk “Jangan Izinkan”.';

  @override
  String get continueAction => 'Lanjutkan';
}

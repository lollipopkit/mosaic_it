import type { Copy } from './types';

export const id: Copy = {
  meta: {
    lang: 'id',
    dir: 'ltr',
    title: 'MosaicIt — Penyensoran privasi langsung di perangkat',
    description:
      'Deteksi dan sensor informasi pribadi pada tangkapan layar dan foto sepenuhnya secara luring. Tanpa OCR, tanpa permintaan jaringan, dan tanpa izin baca galeri foto.',
  },
  nav: {
    screenshots: 'Tangkapan layar',
    features: 'Fitur',
    privacy: 'Privasi',
    download: 'Unduh',
    feedback: 'Umpan Balik',
    github: 'GitHub',
    languageLabel: 'Bahasa',
    cta: 'Unduh',
  },
  hero: {
    titlePrefix: 'Sensor info pribadi,',
    titleSuffix: 'sepenuhnya luring.',
    subtitle:
      'MosaicIt mendeteksi nama, nomor telepon, alamat, angka keuangan, nomor identitas, kode QR, dan wajah langsung di perangkat—tanpa OCR, tanpa kode jaringan, dan tanpa membaca galeri foto Anda.',
    primaryAction: 'Unduh MosaicIt',
    feedbackAction: 'Umpan Balik Web',
    githubAction: 'GitHub',
  },
  features: {
    title: 'Dirancang untuk penyensoran yang cepat dan dapat diverifikasi.',
    subtitle:
      'Buka gambar, periksa area yang terdeteksi, sesuaikan bila perlu, lalu ekspor dalam hitungan detik.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'Deteksi di Perangkat Tanpa OCR',
        description:
          'Bobot FP16 ONNX / LiteRT yang dibundel mendeteksi 18 kelas data pribadi pada tangkapan layar antarmuka ditambah deteksi wajah YuNet—tanpa pengenalan teks atau unduhan model eksternal.',
      },
      {
        tag: '5 Gaya',
        title: 'Penimpaan Piksel Permanen',
        description:
          'Pilih Polos, Serasi Latar, Blok, Blok Warna, atau Derau. Tidak ada satu pun yang membaca piksel di dalam kotak sensor, sehingga mencegah pemulihan depikselasi atau penghilangan buram.',
      },
      {
        tag: 'Cek Mandiri',
        title: 'Pindai Ulang Sebelum Ekspor',
        description:
          'Sebelum menyimpan atau membagikan, MosaicIt dapat menjalankan ulang detektor pada hasil yang telah disensor untuk menandai area sensitif yang masih terbuka.',
      },
      {
        tag: 'Massal & Adaptif',
        title: 'Penyensoran Massal & Pembelajaran Lokal',
        description:
          'Buka beberapa tangkapan layar sekaligus, jalankan Temukan Serupa di seluruh rangkaian, dan biarkan pembelajaran preferensi di perangkat menyesuaikan ambang batas dengan pilihan Anda.',
      },
      {
        tag: 'Editor Langsung',
        title: 'Tahan untuk Intip, Salin & Berbagi Sistem',
        description:
          'Terbuka langsung ke editor. Tahan ikon mata untuk membandingkan dengan gambar asli, salin langsung ke papan klip, atau terima berkas lewat Bagikan, Buka Dengan, dan seret-lepas.',
      },
      {
        tag: 'Inti Rust + CLI',
        title: 'unseen CLI yang Siap Diskripkan',
        description:
          'Mesin bersama unseen-core menggerakkan aplikasi Flutter sekaligus CLI mandiri untuk penyensoran massal dan verifikasi model BLAKE3.',
      },
    ],
    classesTitle: '19 kelas yang didukung',
    classesNote: '18 kelas dari model bawaan unseen-det 0.5.0 ditambah deteksi wajah melalui YuNet.',
  },
  privacy: {
    title: 'Nol jaringan. Nol akses baca galeri foto.',
    subtitle:
      'Setiap klaim privasi ditegakkan di tingkat kompilasi dan batas izin sistem operasi, bukan sekadar teks kebijakan.',
    factors: [
      {
        tag: 'Biner Luring',
        title: 'Tidak Ada Kode Jaringan di Aplikasi',
        description:
          'Aplikasi hadir dengan bobot model bawaan dan tidak menyertakan klien HTTP, SDK analitik, pelapor kerusakan, maupun hak jaringan. CI memverifikasi nol dependensi jaringan di setiap kompilasi.',
      },
      {
        tag: 'Hanya Pemilih Sistem',
        title: 'Tanpa Izin Baca Galeri Foto',
        description:
          'iOS menggunakan PHPickerViewController di luar proses dan penyimpanan khusus tulis .addOnly. Android memakai Photo Picker sistem dan menghapus izin transitif dari manifes rilis.',
      },
    ],
    tableColArea: 'Batasan',
    tableColDetail: 'Implementasi',
    rows: [
      {
        area: 'Pemrosesan gambar',
        detail:
          'Deteksi, penanganan orientasi EXIF, dan penimpaan piksel berjalan secara lokal di Rust (unseen-core) melalui FFI.',
      },
      {
        area: 'Ketidakbalikan sensor',
        detail:
          'Polos, Blok, dan Derau sepenuhnya mengabaikan piksel sumber. Serasi Latar dan Blok Warna hanya mengambil sampel cincin 4 px di luar kotak.',
      },
      {
        area: 'Umpan balik deteksi opsional',
        detail:
          'Mengirim kasus terlewat atau deteksi keliru akan membuka mosaic.lollipopkit.com/feedback di peramban sistem melalui URL #fragment yang tidak pernah masuk ke log HTTP GET dan langsung dihapus lewat history.replaceState.',
      },
      {
        area: 'Sumber terbuka yang dapat direproduksi',
        detail:
          'Aplikasi, inti Rust, layanan umpan balik, dan bobot model yang dirilis diterbitkan di bawah AGPL-3.0 lengkap dengan checksum BLAKE3.',
      },
    ],
  },
  download: {
    title: 'Natif di perangkat seluler dan desktop.',
    subtitle: 'Rilis siap pakai tersedia di GitHub, atau bangun langsung dari kode sumber.',
    currentBadge: 'Platform saat ini',
    releasesAction: 'Rilis GitHub',
    sourceAction: 'Bangun dari sumber',
    cliPrompt: '# Bangun Rust CLI (unseen)',
    appPrompt: '# Jalankan aplikasi Flutter dari kode sumber',
    copy: 'Salin',
    copied: 'Disalin',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Nol izin pada rilis' },
      linux: { name: 'Linux', meta: 'Aplikasi desktop (tar.gz) & unseen CLI' },
      windows: { name: 'Windows', meta: 'Aplikasi desktop (ZIP) & unseen CLI' },
    },
  },
  cta: {
    title: 'Sumber terbuka di bawah AGPL-3.0.',
    subtitle:
      'Audit kodenya, unduh rilis terbaru, atau laporkan deteksi yang terlewat di halaman umpan balik web.',
    feedbackAction: 'Buka Umpan Balik Web',
    releasesAction: 'Rilis GitHub',
    githubAction: 'Lihat Sumber',
  },
  more: {
    title: 'Lainnya dari lollipopkit.',
    subtitle: 'Aplikasi natif lain yang dibangun dengan fokus rekayasa yang sama.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Pemantauan status server, terminal SSH ramah sentuh, SFTP, Docker, systemd, dan alat S.M.A.R.T. dalam satu ruang kerja natif.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Kaitkan SFTP, S3, WebDAV, dan penyimpanan jarak jauh langsung di macOS Finder melalui Apple File Provider tanpa ekstensi kernel.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Klien natif untuk OpenAI dan API LLM yang kompatibel dengan riwayat obrolan lokal-utama, pemanggilan alat, dan titik akhir kustom.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Fitur',
    privacy: 'Privasi',
    download: 'Unduh',
    feedback: 'Umpan Balik',
    releases: 'Rilis',
    license: 'AGPL-3.0',
  },
};

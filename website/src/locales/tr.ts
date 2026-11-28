import type { Copy } from './types';

export const tr: Copy = {
  meta: {
    lang: 'tr',
    dir: 'ltr',
    title: 'MosaicIt — Cihaz üzerinde gizlilik sansürleme',
    description:
      'Ekran görüntülerindeki ve fotoğraflardaki kişisel bilgileri tamamen çevrimdışı olarak tespit edip gizleyin. OCR yok, ağ isteği yok ve fotoğraf arşivi okuma izni yok.',
  },
  nav: {
    screenshots: 'Ekran görüntüleri',
    features: 'Özellikler',
    privacy: 'Gizlilik',
    download: 'İndir',
    feedback: 'Geri Bildirim',
    github: 'GitHub',
    languageLabel: 'Dil',
    cta: 'İndir',
  },
  hero: {
    titlePrefix: 'Kişisel bilgileri gizleyin,',
    titleSuffix: 'tamamen çevrimdışı.',
    subtitle:
      'MosaicIt; adları, telefon numaralarını, adresleri, finansal tutarları, kimlik bilgilerini, QR kodlarını ve yüzleri doğrudan cihazda algılar — OCR olmadan, ağ kodu olmadan ve fotoğraf arşivinizi okumadan.',
    primaryAction: "MosaicIt'i İndir",
    feedbackAction: 'Web Geri Bildirimi',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'Etkileşimli MosaicIt sansürleme önizlemesi',
    peekLabel: 'Orijinali görmek için basılı tutun',
    resetLabel: 'Maskeleri sıfırla',
    receiptTitle: 'Transfer Dekontu',
    recipientLabel: 'Alıcı',
    recipientValue: 'Kerem Yılmaz',
    phoneLabel: 'Telefon',
    phoneValue: '+90 (555) 014 89 20',
    addressLabel: 'Adres',
    addressValue: 'Çınar Sok. No: 42, D: 8',
    amountLabel: 'Tutar',
    amountValue: '₺24.800,00',
    cardLabel: 'Hesap',
    cardValue: '4543 **** **** 4821',
    qrLabel: 'Dekont QR',
    styles: {
      solid: 'Düz Renk',
      surround: 'Çevre Uyumlu',
      blocks: 'Bloklar',
      tinted: 'Renkli Bloklar',
      noise: 'Kumlama',
    },
    classes: {
      person_name: 'Ad Soyad',
      phone: 'Telefon',
      address: 'Adres',
      finance: 'Tutar',
      bank_card: 'Banka Kartı',
      qr: 'QR Kod',
    },
  },
  features: {
    title: 'Hızlı ve doğrulanabilir gizlilik sansürü için tasarlandı.',
    subtitle:
      'Bir görsel açın, tespit edilen alanları inceleyin, gerekirse düzenleyin ve saniyeler içinde dışa aktarın.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'OCR Olmadan Cihaz Üzerinde Algılama',
        description:
          'Uygulamaya gömülü FP16 ONNX / LiteRT ağırlıkları, arayüz ekran görüntülerinde 18 kişisel veri sınıfını ve YuNet ile yüzleri algılar — metin tanıma veya harici model indirme gerektirmez.',
      },
      {
        tag: '5 Stil',
        title: 'Geri Döndürülemez Piksel Üzerine Yazma',
        description:
          'Düz Renk, Çevre Uyumlu, Bloklar, Renkli Bloklar veya Kumlama arasından seçin. Hiçbiri gizlenen kutu içindeki pikselleri okumaz; pikselleştirme veya bulanıklık çözme ile geri kurtarmayı engeller.',
      },
      {
        tag: 'Oto-Kontrol',
        title: 'Dışa Aktarmadan Önce Yeniden Tarama',
        description:
          'Kaydetmeden veya paylaşmadan önce MosaicIt, sansürlenmiş çıktı üzerinde dedektörü yeniden çalıştırarak açıkta kalmış bölgeleri gösterebilir.',
      },
      {
        tag: 'Toplu ve Uyarlanabilir',
        title: 'Toplu Sansürleme ve Yerel Öğrenme',
        description:
          'Birden fazla ekran görüntüsünü aynı anda açın, tüm sette benzer alanları bulun ve cihaz içi tercih öğrenmesinin eşikleri seçimlerinize göre uyarlamasına izin verin.',
      },
      {
        tag: 'Doğrudan Düzenleyici',
        title: 'Basılı Tutup Bakma, Kopyalama ve Sistem Paylaşımı',
        description:
          'Doğrudan düzenleyici ekranında açılır. Orijinalle karşılaştırmak için göz simgesine basılı tutun, doğrudan panoya kopyalayın ya da Paylaş, Birlikte Aç ve sürükle-bırak ile dosya aktarın.',
      },
      {
        tag: 'Rust Çekirdek + CLI',
        title: 'Betiklenebilir unseen CLI',
        description:
          'Ortak unseen-core motoru hem Flutter uygulamasını hem de toplu sansürleme ve BLAKE3 model doğrulaması için bağımsız komut satırı aracını çalıştırır.',
      },
    ],
    classesTitle: 'Desteklenen 19 sınıf',
    classesNote: 'Gömülü unseen-det 0.5.0 modelinden 18 sınıf ve YuNet ile yüz algılama.',
  },
  privacy: {
    title: 'Sıfır ağ. Sıfır fotoğraf arşivi okuma erişimi.',
    subtitle:
      'Her gizlilik iddiası yalnızca gizlilik politikası metniyle değil, derleme ve işletim sistemi izin sınırlarıyla zorunlu kılınır.',
    factors: [
      {
        tag: 'Çevrimdışı Paket',
        title: 'Uygulamada Ağ Kodu Yoktur',
        description:
          'Uygulama gömülü model ağırlıklarıyla gelir; HTTP istemcisi, analitik SDK, çökme raporlayıcı veya ağ yetkisi içermez. CI her derlemede sıfır ağ bağımlılığını doğrular.',
      },
      {
        tag: 'Yalnızca Sistem Seçici',
        title: 'Fotoğraf Arşivi Okuma İzni Yok',
        description:
          'iOS işlem dışı PHPickerViewController ve yalnızca yazmaya izin veren .addOnly kaydını kullanır. Android sistem Photo Picker kullanır ve yayın manifestolarından geçişli izinleri temizler.',
      },
    ],
    tableColArea: 'Sınır',
    tableColDetail: 'Uygulama',
    rows: [
      {
        area: 'Görüntü işleme',
        detail:
          'Algılama, EXIF yönlendirme düzeltmesi ve piksel sansürleme işlemleri yerel olarak Rust (unseen-core) içinde FFI üzerinden çalışır.',
      },
      {
        area: 'Sansürün geri döndürülemezliği',
        detail:
          'Düz Renk, Bloklar ve Kumlama kaynak pikselleri tamamen yok sayar. Çevre Uyumlu ve Renkli Bloklar yalnızca kutunun dışındaki 4 px halka alanından örnek alır.',
      },
      {
        area: 'İsteğe bağlı algılama geri bildirimi',
        detail:
          'Kaçırılan veya hatalı algılamaları bildirmek, sistem tarayıcınızda mosaic.lollipopkit.com/feedback sayfasını HTTP GET günlüklerine düşmeyen ve history.replaceState ile temizlenen bir URL #fragment ile açar.',
      },
      {
        area: 'Tekrarlanabilir açık kaynak',
        detail:
          'Uygulama, Rust çekirdeği, geri bildirim servisi ve yayımlanan model ağırlıkları BLAKE3 sağlama toplamlarıyla AGPL-3.0 altında paylaşılır.',
      },
    ],
  },
  download: {
    title: 'Mobil ve masaüstünde yerel deneyim.',
    subtitle: 'Hazır sürümler GitHub üzerinde yayımlanır veya doğrudan kaynak koddan derleyebilirsiniz.',
    currentBadge: 'Mevcut platform',
    releasesAction: 'GitHub Sürümleri',
    sourceAction: 'Kaynaktan derle',
    cliPrompt: '# Rust CLI aracını derle (unseen)',
    appPrompt: '# Flutter uygulamasını kaynak koddan çalıştır',
    copy: 'Kopyala',
    copied: 'Kopyalandı',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Sürümde sıfır izin' },
      linux: { name: 'Linux', meta: 'Masaüstü uygulaması (tar.gz) ve unseen CLI' },
      windows: { name: 'Windows', meta: 'Masaüstü uygulaması (ZIP) ve unseen CLI' },
    },
  },
  cta: {
    title: 'AGPL-3.0 altında açık kaynak.',
    subtitle:
      'Kodu denetleyin, en son sürümü indirin veya kaçırılan algılamaları web geri bildirim sayfasından bildirin.',
    feedbackAction: 'Web Geri Bildirimini Aç',
    releasesAction: 'GitHub Sürümleri',
    githubAction: 'Kaynak Kodu Gör',
  },
  more: {
    title: "lollipopkit'ten daha fazlası.",
    subtitle: 'Aynı mühendislik odağıyla geliştirilmiş diğer yerel uygulamalar.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Sunucu durumu izleme, dokunmatik uyumlu SSH terminali, SFTP, Docker, systemd ve S.M.A.R.T. araçları tek bir yerel çalışma alanında.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Çekirdek eklentisi olmadan Apple File Provider aracılığıyla SFTP, S3, WebDAV ve uzak depolamaları macOS Finder içinde bağlayın.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Yerel öncelikli sohbet geçmişi, araç çağırma ve özel uç noktalarla OpenAI ve uyumlu LLM API istemcisi.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Özellikler',
    privacy: 'Gizlilik',
    download: 'İndir',
    feedback: 'Geri Bildirim',
    releases: 'Sürümler',
    license: 'AGPL-3.0',
  },
};

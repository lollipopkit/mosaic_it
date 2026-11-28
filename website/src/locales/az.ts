import type { Copy } from './types';

export const az: Copy = {
  meta: {
    lang: 'az',
    dir: 'ltr',
    title: 'MosaicIt — Cihazda məxfilik gizlətmə',
    description:
      'Ekran görüntülərində və fotolarda şəxsi məlumatları tamamilə oflayn aşkar edin və gizlədin. OCR yoxdur, şəbəkə sorğusu yoxdur və foto qalereyasını oxuma icazəsi yoxdur.',
  },
  nav: {
    screenshots: 'Ekran görüntüləri',
    features: 'İmkanlar',
    privacy: 'Məxfilik',
    download: 'Yüklə',
    feedback: 'Rəy',
    github: 'GitHub',
    languageLabel: 'Dil',
    cta: 'Yüklə',
  },
  hero: {
    titlePrefix: 'Şəxsi məlumatları gizlədin,',
    titleSuffix: 'tamamilə oflayn.',
    subtitle:
      'MosaicIt adları, telefon nömrələrini, ünvanları, maliyyə məbləğlərini, şəxsiyyət məlumatlarını, QR kodları və üzləri birbaşa cihazda tanıyır — OCR olmadan, şəbəkə kodu olmadan və foto qalereyanızı oxumadan.',
    primaryAction: 'MosaicIt yüklə',
    feedbackAction: 'Veb Rəy',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'MosaicIt interaktiv gizlətmə önizləməsi',
    peekLabel: 'Orijinalı görmək üçün basıb saxlayın',
    resetLabel: 'Maskaları sıfırla',
    receiptTitle: 'Köçürmə Qəbzi',
    recipientLabel: 'Alan',
    recipientValue: 'Elvin Məmmədov',
    phoneLabel: 'Telefon',
    phoneValue: '+994 50 555 01 42',
    addressLabel: 'Ünvan',
    addressValue: 'Çinar küç. 42, mən. 8',
    amountLabel: 'Məbləğ',
    amountValue: '2.480,00 ₼',
    cardLabel: 'Hesab',
    cardValue: '4169 **** **** 4821',
    qrLabel: 'Qəbz QR',
    styles: {
      solid: 'Tək rəng',
      surround: 'Fona uyğun',
      blocks: 'Bloklar',
      tinted: 'Rəngli bloklar',
      noise: 'Küy',
    },
    classes: {
      person_name: 'Ad və soyad',
      phone: 'Telefon',
      address: 'Ünvan',
      finance: 'Məbləğ',
      bank_card: 'Bank kartı',
      qr: 'QR kod',
    },
  },
  features: {
    title: 'Sürətli və yoxlanıla bilən gizlətmə üçün yaradılıb.',
    subtitle:
      'Şəkli açın, aşkar edilmiş sahələri yoxlayın, lazım gələrsə düzəliş edin və saniyələr içində ixrac edin.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'OCR Olmadan Cihazda Aşkarlama',
        description:
          'Daxili FP16 ONNX / LiteRT çəkiləri interfeys ekran görüntülərində 18 şəxsi məlumat sinfini və YuNet ilə üzləri aşkar edir — mətn tanıma və ya kənar model yükləməsi olmadan.',
      },
      {
        tag: '5 üslub',
        title: 'Geri Qaytarılmaz Piksel Yeniləməsi',
        description:
          'Tək rəng, Fona uyğun, Bloklar, Rəngli bloklar və ya Küy seçin. Heç biri gizlədilmiş çərçivənin daxilindəki pikselləri oxumur və pikselləşdirmənin və ya bulanıqlığın geri bərpasının qarşısını alır.',
      },
      {
        tag: 'Özünü-Yoxlama',
        title: 'İxracdan Əvvəl Təkrar Skan',
        description:
          'Yadda saxlamazdan və ya paylaşmazdan əvvəl MosaicIt gizlədilmiş nəticə üzərində detektoru yenidən işə salaraq açıq qalan sahələri göstərə bilər.',
      },
      {
        tag: 'Toplu və Uyğunlaşan',
        title: 'Toplu Gizlətmə və Yerli Öyrənmə',
        description:
          'Eyni anda bir neçə ekran görüntüsünü açın, bütün dəstdə oxşar sahələri tapın və cihazdaxili seçim öyrənməsinin hədləri vərdişlərinizə uyğunlaşdırmasına imkan verin.',
      },
      {
        tag: 'Birbaşa Redaktor',
        title: 'Basıb Baxma, Kopyalama və Sistem Paylaşımı',
        description:
          'Birbaşa redaktorda açılır. Orijinalla müqayisə etmək üçün göz nişanını basıb saxlayın, birbaşa buferə kopyalayın və ya Paylaş, Birlikdə Aç və sürükləyib-buraxma ilə fayl qəbul edin.',
      },
      {
        tag: 'Rust Nüvəsi + CLI',
        title: 'Skriptlənən unseen CLI',
        description:
          'Ümumi unseen-core mühərriki həm Flutter tətbiqini, həm də toplu gizlətmə və BLAKE3 model yoxlaması üçün müstəqil CLI alətini işlədir.',
      },
    ],
    classesTitle: '19 dəstəklənən sinif',
    classesNote: 'Daxili unseen-det 0.5.0 modelindən 18 sinif və YuNet ilə üz aşkarlama.',
  },
  privacy: {
    title: 'Sıfır şəbəkə. Sıfır foto qalereya oxuma girişi.',
    subtitle:
      'Hər bir məxfilik iddiası siyasət mətni ilə deyil, qurma və əməliyyat sistemi icazə sərhədləri ilə təmin olunur.',
    factors: [
      {
        tag: 'Oflayn Paket',
        title: 'Tətbiqdə Şəbəkə Kodu Yoxdur',
        description:
          'Tətbiq daxili model çəkiləri ilə gəlir və HTTP müştərisi, analitika SDK, xəta hesabatçısı və ya şəbəkə hüququ ehtiva etmir. CI hər quruluşda sıfır şəbəkə asılılığını yoxlayır.',
      },
      {
        tag: 'Yalnız Sistem Seçici',
        title: 'Foto Qalereyasını Oxuma İcazəsi Yoxdur',
        description:
          'iOS prosesdənkənar PHPickerViewController və yalnız yazmaq üçün .addOnly yadda saxlamasından istifadə edir. Android sistem Photo Picker tətbiq edir və buraxılış manifestlərindən keçid icazələrini silir.',
      },
    ],
    tableColArea: 'Sərhəd',
    tableColDetail: 'İcra',
    rows: [
      {
        area: 'Şəkil emalı',
        detail:
          'Aşkarlama, EXIF istiqamətinin tənzimlənməsi və piksel gizlətməsi lokal olaraq Rust (unseen-core) daxilində FFI vasitəsilə icra olunur.',
      },
      {
        area: 'Gizlətmənin geri qaytarılmazlığı',
        detail:
          'Tək rəng, Bloklar və Küy mənbə piksellərini tamamilə nəzərə almır. Fona uyğun və Rəngli bloklar yalnız çərçivənin xaricindəki 4 px halqadan nümunə götürür.',
      },
      {
        area: 'İstəyə bağlı aşkarlama rəyi',
        detail:
          'Buraxılmış və ya yanlış aşkarlamaları göndərmək sistem brauzerində mosaic.lollipopkit.com/feedback səhifəsini HTTP GET jurnallarına düşməyən və history.replaceState ilə silinən URL #fragment vasitəsilə açır.',
      },
      {
        area: 'Təkrarlana bilən açıq mənbə',
        detail:
          'Tətbiq, Rust nüvəsi, rəy xidməti və dərc olunmuş model çəkiləri BLAKE3 yoxlama cəmləri ilə AGPL-3.0 altında yayımlanır.',
      },
    ],
  },
  download: {
    title: 'Mobil və masaüstündə yerli tətbiq.',
    subtitle: 'Hazır buraxılışlar GitHub üzərində dərc olunub və ya birbaşa mənbə koddan qura bilərsiniz.',
    currentBadge: 'Cari platforma',
    releasesAction: 'GitHub Buraxılışları',
    sourceAction: 'Mənbədən qur',
    cliPrompt: '# Rust CLI alətini qur (unseen)',
    appPrompt: '# Flutter tətbiqini mənbə koddan işə sal',
    copy: 'Kopyala',
    copied: 'Kopyalandı',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Buraxılışda sıfır icazə' },
      linux: { name: 'Linux', meta: 'Masaüstü tətbiqi (tar.gz) və unseen CLI' },
      windows: { name: 'Windows', meta: 'Masaüstü tətbiqi (ZIP) və unseen CLI' },
    },
  },
  cta: {
    title: 'AGPL-3.0 altında açıq mənbə.',
    subtitle:
      'Kodu yoxlayın, ən son buraxılışı yükləyin və ya buraxılmış aşkarlamaları veb rəy səhifəsində bildirin.',
    feedbackAction: 'Veb Rəy Səhifəsini Aç',
    releasesAction: 'GitHub Buraxılışları',
    githubAction: 'Mənbə Koda Bax',
  },
  more: {
    title: 'lollipopkit-dən daha çox.',
    subtitle: 'Eyni mühəndislik yanaşması ilə yaradılmış digər yerli tətbiqlər.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Server vəziyyətinin izlənməsi, toxunuşa uyğun SSH terminalı, SFTP, Docker, systemd və S.M.A.R.T. alətləri bir yerli iş sahəsində.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Nüvə genişlənmələri olmadan Apple File Provider vasitəsilə SFTP, S3, WebDAV və uzaq yaddaşları macOS Finder daxilində qoşun.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Yerli-öncəlikli söhbət tarixçəsi, alət çağırışı və fərdi son nöqtələrlə OpenAI və uyğun LLM API müştərisi.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'İmkanlar',
    privacy: 'Məxfilik',
    download: 'Yüklə',
    feedback: 'Rəy',
    releases: 'Buraxılışlar',
    license: 'AGPL-3.0',
  },
};

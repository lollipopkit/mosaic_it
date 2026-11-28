import type { Copy } from './types';

export const fa: Copy = {
  meta: {
    lang: 'fa',
    dir: 'rtl',
    title: 'MosaicIt — پوشاندن اطلاعات خصوصی روی دستگاه',
    description:
      'اطلاعات محرمانه موجود در اسکرین‌شات‌ها و عکس‌ها را به‌صورت کاملاً آفلاین شناسایی و پنهان کنید. بدون OCR، بدون درخواست شبکه و بدون دسترسی خواندن به گالری عکس.',
  },
  nav: {
    screenshots: 'تصاویر صفحه',
    features: 'ویژگی‌ها',
    privacy: 'حریم خصوصی',
    download: 'دانلود',
    feedback: 'بازخورد',
    github: 'GitHub',
    languageLabel: 'زبان',
    cta: 'دانلود',
  },
  hero: {
    titlePrefix: 'اطلاعات خصوصی را بپوشانید،',
    titleSuffix: 'کاملاً آفلاین.',
    subtitle:
      'MosaicIt نام‌ها، شماره‌های تلفن، نشانی‌ها، مبالغ مالی، شناسه‌ها، کدهای QR و چهره‌ها را مستقیماً روی دستگاه تشخیص می‌دهد؛ بدون OCR، بدون کد شبکه و بدون خواندن گالری عکس شما.',
    primaryAction: 'دانلود MosaicIt',
    feedbackAction: 'بازخورد وب',
    githubAction: 'GitHub',
  },
  features: {
    title: 'طراحی‌شده برای پوشاندن سریع و قابل‌راستی‌آزمایی.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'تشخیص روی دستگاه بدون OCR',
        description:
          'وزن‌های داخلی FP16 ONNX / LiteRT ۱۸ دسته داده شخصی را در اسکرین‌شات‌های رابط کاربری همراه با تشخیص چهره YuNet شناسایی می‌کنند؛ بدون بازشناسی متن یا دانلود مدل خارجی.',
      },
      {
        tag: '۵ سبک',
        title: 'بازنویسی برگشت‌ناپذیر پیکسل‌ها',
        description:
          'از میان تک‌رنگ، همرنگ اطراف، بلوک‌ها، بلوک رنگی یا نویز انتخاب کنید. هیچ‌کدام پیکسل‌های داخل کادر پوشانده‌شده را نمی‌خوانند تا بازیابی از طریق رفع پیکسلی یا رفع تاری ممکن نباشد.',
      },
      {
        tag: 'خودآزمایی',
        title: 'اسکن دوباره پیش از خروجی',
        description:
          'پیش از ذخیره یا اشتراک‌گذاری، MosaicIt می‌تواند تشخیص‌گر را دوباره روی خروجی پوشانده‌شده اجرا کند تا نواحی جاافتاده را نمایش دهد.',
      },
      {
        tag: 'گروهی و تطبیقی',
        title: 'پردازش گروهی و یادگیری محلی',
        description:
          'چند اسکرین‌شات را هم‌زمان باز کنید، جست‌وجوی موارد مشابه را روی کل مجموعه اجرا کنید و بگذارید یادگیری محلی ترجیحات، آستانه‌ها را با انتخاب‌های شما تطبیق دهد.',
      },
      {
        tag: 'ورود مستقیم به ویرایشگر',
        title: 'نگه‌داشتن برای دیدن اصل، کپی و اشتراک سیستم',
        description:
          'مستقیماً وارد ویرایشگر می‌شود. برای مقایسه با اصل نشان چشم را نگه دارید، مستقیماً در کلیپ‌بورد کپی کنید یا فایل‌ها را از طریق اشتراک‌گذاری، باز کردن با و کشیدن و رها کردن وارد کنید.',
      },
      {
        tag: 'هسته Rust + CLI',
        title: 'ابزار خط فرمان unseen قابل اسکریپت‌نویسی',
        description:
          'موتور مشترک unseen-core هم برنامه Flutter و هم ابزار مستقل خط فرمان را برای پردازش گروهی و بررسی یکپارچگی مدل با BLAKE3 قدرت می‌بخشد.',
      },
    ],
    classesTitle: '۱۹ دسته پشتیبانی‌شده',
  },
  privacy: {
    title: 'صفر شبکه. صفر دسترسی خواندن به گالری عکس.',
    factors: [
      {
        tag: 'باینری آفلاین',
        title: 'نبود هیچ کد شبکه‌ای در برنامه',
        description:
          'برنامه با وزن‌های مدل داخلی عرضه می‌شود و هیچ کلاینت HTTP، کیت تحلیل، گزارشگر خطا یا مجوز شبکه‌ای ندارد. CI در هر بار ساخت نبود وابستگی شبکه را بررسی می‌کند.',
      },
      {
        tag: 'فقط انتخاب‌گر سیستم',
        title: 'بدون مجوز خواندن گالری عکس',
        description:
          'iOS از PHPickerViewController برون‌فرآیندی و ذخیره فقط‌نوشتنی .addOnly استفاده می‌کند. Android از Photo Picker سیستم بهره می‌برد و مجوزهای انتقالی را از مانیفست انتشار حذف می‌کند.',
      },
    ],
    tableColArea: 'مرز',
    tableColDetail: 'پیاده‌سازی',
    rows: [
      {
        area: 'پردازش تصویر',
        detail:
          'تشخیص نواحی، اصلاح جهت EXIF و بازنویسی پیکسل‌ها به‌صورت محلی در Rust (unseen-core) از طریق FFI اجرا می‌شود.',
      },
      {
        area: 'برگشت‌ناپذیری پوشش',
        detail:
          'سبک‌های تک‌رنگ، بلوک‌ها و نویز پیکسل‌های اصلی را کاملاً نادیده می‌گیرند. همرنگ اطراف و بلوک رنگی فقط از یک حلقه ۴ پیکسلی بیرون کادر نمونه‌برداری می‌کنند.',
      },
      {
        area: 'بازخورد اختیاری تشخیص',
        detail:
          'ارسال موارد جاافتاده یا خطای تشخیص، نشانی mosaic.lollipopkit.com/feedback را در مرورگر سیستم با URL #fragment باز می‌کند که هرگز در لاگ‌های HTTP GET ثبت نمی‌شود و با history.replaceState پاک می‌شود.',
      },
      {
        area: 'متن‌باز و قابل بازتولید',
        detail:
          'برنامه، هسته Rust، سرویس بازخورد و وزن‌های منتشرشده مدل تحت مجوز AGPL-3.0 همراه با جمع کنترلی BLAKE3 منتشر شده‌اند.',
      },
    ],
  },
  download: {
    title: 'بومی برای موبایل و دسکتاپ.',
    currentBadge: 'پلتفرم فعلی',
    releasesAction: 'انتشارهای GitHub',
    sourceAction: 'ساخت از کد منبع',
    cliPrompt: '# ساخت ابزار خط فرمان Rust (unseen)',
    appPrompt: '# اجرای برنامه Flutter از کد منبع',
    copy: 'کپی',
    copied: 'کپی شد',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · بدون مجوز در نسخه انتشار' },
      linux: { name: 'Linux', meta: 'برنامه دسکتاپ (tar.gz) و unseen CLI' },
      windows: { name: 'Windows', meta: 'برنامه دسکتاپ (ZIP) و unseen CLI' },
    },
  },
  cta: {
    title: 'متن‌باز تحت مجوز AGPL-3.0.',
    feedbackAction: 'باز کردن بازخورد وب',
    releasesAction: 'انتشارهای GitHub',
    githubAction: 'مشاهده کد منبع',
  },
  more: {
    title: 'پروژه‌های دیگر از lollipopkit.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'پایش وضعیت سرور، ترمینال لمسی SSH، SFTP، Docker، systemd و ابزارهای S.M.A.R.T. در یک محیط کار بومی.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'فضاهای SFTP، S3، WebDAV و ذخیره‌سازی‌های راه دور را بدون افزونه کرنل و با Apple File Provider درون Finder مک متصل کنید.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'کلاینت بومی برای OpenAI و APIهای سازگار LLM با تاریخچه گفت‌وگوی محلی‌محور، فراخوانی ابزار و نقطه‌پایان‌های سفارشی.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'ویژگی‌ها',
    privacy: 'حریم خصوصی',
    download: 'دانلود',
    feedback: 'بازخورد',
    releases: 'انتشارها',
    license: 'AGPL-3.0',
  },
};

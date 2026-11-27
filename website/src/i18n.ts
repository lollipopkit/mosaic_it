export type Locale = 'en' | 'zh-CN' | 'zh-TW' | 'ja';

export const LOCALES: { code: Locale; label: string }[] = [
  { code: 'en', label: 'English' },
  { code: 'zh-CN', label: '简体中文' },
  { code: 'zh-TW', label: '繁體中文' },
  { code: 'ja', label: '日本語' },
];

export type StyleKey = 'solid' | 'surround' | 'blocks' | 'tinted' | 'noise';

export interface Copy {
  meta: {
    lang: string;
    title: string;
    description: string;
  };
  nav: {
    features: string;
    privacy: string;
    download: string;
    feedback: string;
    github: string;
    languageLabel: string;
    cta: string;
  };
  hero: {
    titlePrefix: string;
    titleSuffix: string;
    subtitle: string;
    primaryAction: string;
    feedbackAction: string;
    githubAction: string;
  };
  demo: {
    ariaLabel: string;
    peekLabel: string;
    resetLabel: string;
    receiptTitle: string;
    recipientLabel: string;
    recipientValue: string;
    phoneLabel: string;
    phoneValue: string;
    addressLabel: string;
    addressValue: string;
    amountLabel: string;
    amountValue: string;
    cardLabel: string;
    cardValue: string;
    qrLabel: string;
    styles: Record<StyleKey, string>;
    classes: {
      person_name: string;
      phone: string;
      address: string;
      finance: string;
      bank_card: string;
      qr: string;
    };
  };
  features: {
    title: string;
    subtitle: string;
    cards: Array<{ tag: string; title: string; description: string }>;
    classesTitle: string;
    classesNote: string;
  };
  privacy: {
    title: string;
    subtitle: string;
    factors: Array<{ tag: string; title: string; description: string }>;
    tableColArea: string;
    tableColDetail: string;
    rows: Array<{ area: string; detail: string }>;
  };
  download: {
    title: string;
    subtitle: string;
    currentBadge: string;
    releasesAction: string;
    sourceAction: string;
    cliPrompt: string;
    appPrompt: string;
    copy: string;
    copied: string;
    platforms: {
      ios: { name: string; meta: string };
      macos: { name: string; meta: string };
      android: { name: string; meta: string };
      linux: { name: string; meta: string };
      windows: { name: string; meta: string };
    };
  };
  cta: {
    title: string;
    subtitle: string;
    feedbackAction: string;
    releasesAction: string;
    githubAction: string;
  };
  more: {
    title: string;
    subtitle: string;
    apps: Array<{
      title: string;
      tag: string;
      description: string;
      action: string;
      href: string;
    }>;
  };
  footer: {
    features: string;
    privacy: string;
    download: string;
    feedback: string;
    releases: string;
    license: string;
  };
}

export const DETECTED_CLASSES = [
  'person_name',
  'address',
  'phone',
  'email',
  'id_number',
  'bank_card',
  'plate',
  'account_id',
  'avatar',
  'qr',
  'barcode',
  'finance',
  'organization',
  'device_id',
  'secret',
  'person',
  'health',
  'personal_info',
  'face',
] as const;

const en: Copy = {
  meta: {
    lang: 'en',
    title: 'MosaicIt — On-device privacy redaction',
    description:
      'Detect and redact private information in screenshots and photos completely offline. No OCR, no network requests, and no photo-library read permissions.',
  },
  nav: {
    features: 'Features',
    privacy: 'Privacy',
    download: 'Download',
    feedback: 'Feedback',
    github: 'GitHub',
    languageLabel: 'Language',
    cta: 'Download',
  },
  hero: {
    titlePrefix: 'Redact private info,',
    titleSuffix: 'completely offline.',
    subtitle:
      'MosaicIt detects names, phone numbers, addresses, financial figures, IDs, QR codes, and faces on device—without OCR, without network code, and without reading your photo library.',
    primaryAction: 'Download MosaicIt',
    feedbackAction: 'Web Feedback',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'Interactive MosaicIt redaction preview',
    peekLabel: 'Hold to peek original',
    resetLabel: 'Reset masks',
    receiptTitle: 'Transfer Receipt',
    recipientLabel: 'Recipient',
    recipientValue: 'Alex Chen',
    phoneLabel: 'Phone',
    phoneValue: '+1 (555) 014-8920',
    addressLabel: 'Address',
    addressValue: '42 Maple St, Apt 8B',
    amountLabel: 'Amount',
    amountValue: '$2,480.00',
    cardLabel: 'Account',
    cardValue: '6222 **** **** 4821',
    qrLabel: 'Receipt QR',
    styles: {
      solid: 'Solid',
      surround: 'Surround',
      blocks: 'Blocks',
      tinted: 'Tinted',
      noise: 'Noise',
    },
    classes: {
      person_name: 'person_name',
      phone: 'phone',
      address: 'address',
      finance: 'finance',
      bank_card: 'bank_card',
      qr: 'qr',
    },
  },
  features: {
    title: 'Built for fast, verifiable redaction.',
    subtitle:
      'Open an image or video, inspect the detected regions, adjust if needed, and export in seconds.',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'On-Device Detection Without OCR',
        description:
          'Bundled FP16 ONNX / LiteRT weights detect 18 PII classes across UI screenshots plus YuNet face detection—no text recognition or external model downloads.',
      },
      {
        tag: '5 Styles',
        title: 'Non-Reversible Pixel Overwrite',
        description:
          'Choose Solid, Surround, Blocks, Tinted, or Noise. None reads pixels inside the redacted box, preventing de-pixelation or de-blurring recovery.',
      },
      {
        tag: 'Self-Check',
        title: 'Re-Scan Before Export',
        description:
          'Before saving or sharing, MosaicIt can re-run the detector on the redacted output to surface any remaining unmasked regions.',
      },
      {
        tag: 'Batch & Adaptive',
        title: 'Batch Redaction & Local Learning',
        description:
          'Open multiple screenshots at once, run Find Similar across the batch, and let on-device preference learning adapt thresholds to your choices.',
      },
      {
        tag: 'Direct Editor',
        title: 'Hold-to-Peek, Copy & OS Share',
        description:
          'Launches directly into the editor. Hold the eye badge to compare against the original, copy directly to clipboard, or accept files via Share, Open With, and drag-and-drop.',
      },
      {
        tag: 'Rust Core + CLI',
        title: 'Scriptable unseen CLI',
        description:
          'Shared unseen-core engine powers both the Flutter app and a standalone CLI for batch redaction and BLAKE3 model verification.',
      },
    ],
    classesTitle: '19 supported classes',
    classesNote: '18 classes from bundled unseen-det 0.5.0 plus face detection via YuNet.',
  },
  privacy: {
    title: 'Zero network. Zero photo-library read access.',
    subtitle:
      'Every privacy claim is enforced at the build and OS-permission boundary rather than policy text.',
    factors: [
      {
        tag: 'Offline Binary',
        title: 'No Networking Code in the App',
        description:
          'The app ships with bundled model weights and contains no HTTP client, analytics SDK, crash reporter, or network entitlements. CI verifies zero network dependencies on every build.',
      },
      {
        tag: 'System Picker Only',
        title: 'No Photo-Library Read Permission',
        description:
          'iOS uses the out-of-process PHPickerViewController and write-only .addOnly saves. Android uses the system Photo Picker and strips transitive permissions from release manifests.',
      },
    ],
    tableColArea: 'Boundary',
    tableColDetail: 'Implementation',
    rows: [
      {
        area: 'Image processing',
        detail:
          'Detection, EXIF orientation handling, and pixel redaction execute locally in Rust (unseen-core) via FFI.',
      },
      {
        area: 'Redaction irreversibility',
        detail:
          'Solid, Blocks, and Noise ignore source pixels completely. Surround and Tinted sample only a 4 px ring outside the box.',
      },
      {
        area: 'Optional detection feedback',
        detail:
          'Submitting missed or false-positive cases opens mosaic.lollipopkit.com/feedback in your system browser via a URL #fragment that never hits HTTP GET logs and is stripped via history.replaceState.',
      },
      {
        area: 'Reproducible open source',
        detail:
          'App, Rust core, feedback worker, and released model weights are published under AGPL-3.0 with BLAKE3 checksums.',
      },
    ],
  },
  download: {
    title: 'Native across mobile and desktop.',
    subtitle: 'Prebuilt releases are published on GitHub, or build directly from source.',
    currentBadge: 'Current platform',
    releasesAction: 'GitHub Releases',
    sourceAction: 'Build from source',
    cliPrompt: '# Build the Rust CLI (unseen)',
    appPrompt: '# Run the Flutter app from source',
    copy: 'Copy',
    copied: 'Copied',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Zero release permissions' },
      linux: { name: 'Linux', meta: 'Desktop app (tar.gz) & unseen CLI' },
      windows: { name: 'Windows', meta: 'Desktop app (ZIP) & unseen CLI' },
    },
  },
  cta: {
    title: 'Open source under AGPL-3.0.',
    subtitle:
      'Audit the code, grab the latest release, or report missed detections on the web feedback page.',
    feedbackAction: 'Open Web Feedback',
    releasesAction: 'GitHub Releases',
    githubAction: 'View Source',
  },
  more: {
    title: 'More from lollipopkit.',
    subtitle: 'Other native apps built with the same engineering focus.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Server status monitoring, touch-ready SSH terminal, SFTP, Docker, systemd, and S.M.A.R.T. tools in one native workspace.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Mount SFTP, S3, WebDAV, and remote storage inside macOS Finder via Apple File Provider without kernel extensions.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Native client for OpenAI and compatible LLM APIs with local-first chat history, tool calling, and custom endpoints.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Features',
    privacy: 'Privacy',
    download: 'Download',
    feedback: 'Feedback',
    releases: 'Releases',
    license: 'AGPL-3.0',
  },
};

const zhCN: Copy = {
  meta: {
    lang: 'zh-CN',
    title: 'MosaicIt（码住）— 本地离线隐私打码工具',
    description:
      '全程离线检测并遮挡截图与照片中的隐私信息。无需 OCR、不包含任何网络请求代码、不申请相册读取权限。',
  },
  nav: {
    features: '功能',
    privacy: '隐私',
    download: '下载',
    feedback: '检测反馈',
    github: 'GitHub',
    languageLabel: '语言',
    cta: '立即下载',
  },
  hero: {
    titlePrefix: '自动打码隐私信息，',
    titleSuffix: '全程离线不上传。',
    subtitle:
      'MosaicIt 在本地直接识别截图与照片中的姓名、手机号、地址、金额、证件号、二维码与人脸——无需 OCR、不包含联网代码，也不申请读取相册权限。',
    primaryAction: '下载 MosaicIt',
    feedbackAction: '提交检测反馈',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'MosaicIt 交互式打码预览',
    peekLabel: '按住对比原图',
    resetLabel: '重置遮挡',
    receiptTitle: '转账回执',
    recipientLabel: '收款人',
    recipientValue: '林明',
    phoneLabel: '手机号',
    phoneValue: '138 **** 8920',
    addressLabel: '联系地址',
    addressValue: '枫林路 42 号 802 室',
    amountLabel: '转账金额',
    amountValue: '¥ 12,840.00',
    cardLabel: '收款账户',
    cardValue: '6222 **** **** 4821',
    qrLabel: '回执二维码',
    styles: {
      solid: '纯色',
      surround: '环境融合',
      blocks: '灰度马赛克',
      tinted: '彩色马赛克',
      noise: '噪点',
    },
    classes: {
      person_name: '姓名',
      phone: '手机号',
      address: '地址',
      finance: '金额',
      bank_card: '银行卡',
      qr: '二维码',
    },
  },
  features: {
    title: '快速、可验证的本地打码工作流。',
    subtitle: '打开图片或视频后自动标出隐私区域，按需增删遮挡框，一键复制或导出。',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: '免 OCR 本地检测',
        description:
          '内置 FP16 ONNX / LiteRT 权重，直接定位 18 类截图隐私信息并结合 YuNet 检测人脸，无需识别文字内容，也无需联网下载模型。',
      },
      {
        tag: '5 种遮挡样式',
        title: '不可逆像素覆写',
        description:
          '提供纯色、环境融合、灰度马赛克、彩色马赛克与噪点五种样式。所有样式均不读取遮挡区域内部原像素，防止反马赛克或去模糊还原。',
      },
      {
        tag: '导出自检',
        title: '导出前二次复检',
        description:
          '保存或分享前自动对已打码图像重新运行检测器，提示可能遗漏的敏感区域。',
      },
      {
        tag: '批量与自适应',
        title: '批量打码与本地偏好学习',
        description:
          '一次导入多张截图并支持跨图查找相似区域，同时在本地根据你的勾选习惯自动微调各类别阈值。',
      },
      {
        tag: '直达编辑器',
        title: '按住透视、原生复制与系统分享',
        description:
          '启动即进入编辑界面；按住眼睛徽标可对比原图，一键写入系统剪贴板，支持系统分享面板、打开方式与拖拽导入。',
      },
      {
        tag: 'Rust 核心 + CLI',
        title: '可脚本化的 unseen CLI',
        description:
          '与移动端共用 unseen-core 引擎，提供独立命令行工具用于批量打码与 BLAKE3 模型校验。',
      },
    ],
    classesTitle: '支持 19 类敏感目标',
    classesNote: '包含内置 unseen-det 0.5.0 的 18 个类别，以及基于 YuNet 的人脸检测（face）。',
  },
  privacy: {
    title: '零网络代码，零相册读取权限。',
    subtitle: '隐私边界由构建产物与系统权限清单直接约束，支持公开审计。',
    factors: [
      {
        tag: '离线构建',
        title: '应用内不含任何联网代码',
        description:
          '模型权重直接随安装包内置，移除 HTTP 客户端、统计 SDK 与崩溃上报，CI 每次构建均自动校验零网络依赖。',
      },
      {
        tag: '系统选图器',
        title: '不申请相册读取权限',
        description:
          'iOS 仅调用系统进程外 PHPickerViewController，保存时仅申请 .addOnly 写入权限；Android 调用系统照片选择器并在 Release 清单中剔除传递权限。',
      },
    ],
    tableColArea: '检查项',
    tableColDetail: '实现方式',
    rows: [
      {
        area: '图像处理',
        detail: '检测、EXIF 方向校正与像素覆写全部在本地 Rust（unseen-core）经 FFI 执行。',
      },
      {
        area: '打码不可逆性',
        detail: '纯色、灰度马赛克与噪点完全不读取原图；环境融合与彩色马赛克仅采样框外 4 px 环带颜色。',
      },
      {
        area: '可选网页检测反馈',
        detail:
          '主动反馈漏检或误检时，应用通过 URL #fragment 在系统浏览器中打开 mosaic.lollipopkit.com/feedback；fragment 不进入 HTTP GET 日志，页面加载后立即通过 history.replaceState 清除。',
      },
      {
        area: '开源可复现',
        detail: '客户端、Rust 核心、反馈 Worker 与发布模型权重均以 AGPL-3.0 协议开源，并提供 BLAKE3 校验和。',
      },
    ],
  },
  download: {
    title: '覆盖移动与桌面端。',
    subtitle: '在 GitHub Releases 获取预编译版本，或直接从源码构建。',
    currentBadge: '当前平台',
    releasesAction: 'GitHub Releases',
    sourceAction: '从源码构建',
    cliPrompt: '# 构建 Rust 命令行工具（unseen）',
    appPrompt: '# 从源码运行 Flutter 应用',
    copy: '复制',
    copied: '已复制',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Release 零权限清单' },
      linux: { name: 'Linux', meta: '桌面应用（tar.gz）与 unseen CLI' },
      windows: { name: 'Windows', meta: '桌面应用（ZIP）与 unseen CLI' },
    },
  },
  cta: {
    title: '基于 AGPL-3.0 协议免费开源。',
    subtitle: '查阅完整源码、下载最新版本，或在网页反馈页提交漏检与误检样例以改进检测模型。',
    feedbackAction: '打开检测反馈页',
    releasesAction: 'GitHub Releases',
    githubAction: '查看源码',
  },
  more: {
    title: 'lollipopkit 的更多作品。',
    subtitle: '同样强调原生性能与克制设计的其他开源工具。',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description: '集实时状态图表、触控 SSH 终端、SFTP、Docker、systemd 与 S.M.A.R.T. 于一体的原生服务器运维工具。',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description: '基于 macOS 原生 File Provider，无需内核扩展即可在访达中挂载 SFTP、S3 与 WebDAV 远程存储。',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description: '原生 OpenAI 及兼容大模型 API 客户端，支持本地优先对话存储、工具调用与自定义接口。',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: '功能',
    privacy: '隐私',
    download: '下载',
    feedback: '检测反馈',
    releases: '版本发布',
    license: 'AGPL-3.0',
  },
};

const zhTW: Copy = {
  ...zhCN,
  meta: {
    lang: 'zh-TW',
    title: 'MosaicIt（碼住）— 本機離線隱私打碼工具',
    description:
      '全程離線偵測並遮蔽截圖與照片中的隱私資訊。無需 OCR、不含網路請求程式碼，也不申請相簿讀取權限。',
  },
  nav: {
    features: '功能',
    privacy: '隱私',
    download: '下載',
    feedback: '偵測回饋',
    github: 'GitHub',
    languageLabel: '語言',
    cta: '立即下載',
  },
  hero: {
    titlePrefix: '自動打碼隱私資訊，',
    titleSuffix: '全程離線不上傳。',
    subtitle:
      'MosaicIt 在本機直接偵測截圖與照片中的姓名、電話、地址、金額、證件號碼、QR 碼與人臉——無需 OCR、不含連網程式碼，也不申請讀取相簿權限。',
    primaryAction: '下載 MosaicIt',
    feedbackAction: '提交偵測回饋',
    githubAction: 'GitHub',
  },
  demo: {
    ...zhCN.demo,
    ariaLabel: 'MosaicIt 互動式打碼預覽',
    peekLabel: '按住對比原圖',
    resetLabel: '重設遮蔽',
    receiptTitle: '轉帳收據',
    recipientLabel: '收款人',
    recipientValue: '林明',
    phoneLabel: '手機號碼',
    phoneValue: '0912 *** 892',
    addressLabel: '聯絡地址',
    addressValue: '楓林路 42 號 8 樓',
    amountLabel: '轉帳金額',
    amountValue: 'NT$ 12,840',
    cardLabel: '收款帳戶',
    cardValue: '6222 **** **** 4821',
    qrLabel: '收據 QR 碼',
    styles: {
      solid: '純色',
      surround: '環境融合',
      blocks: '灰階馬賽克',
      tinted: '彩色馬賽克',
      noise: '雜訊',
    },
    classes: {
      person_name: '姓名',
      phone: '手機',
      address: '地址',
      finance: '金額',
      bank_card: '銀行卡',
      qr: 'QR 碼',
    },
  },
  features: {
    title: '快速、可驗證的本機打碼流程。',
    subtitle: '開啟圖片或影片後自動標出隱私區域，依需求增減遮蔽框，一鍵複製或匯出。',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: '免 OCR 本機偵測',
        description:
          '內建 FP16 ONNX / LiteRT 權重，直接定位 18 類截圖隱私資訊並結合 YuNet 偵測人臉，無需辨識文字，也無需連網下載模型。',
      },
      {
        tag: '5 種遮蔽樣式',
        title: '不可逆像素覆寫',
        description:
          '提供純色、環境融合、灰階馬賽克、彩色馬賽克與雜訊五種樣式。皆不讀取遮蔽區域內部原像素，避免反馬賽克或去模糊還原。',
      },
      {
        tag: '匯出自檢',
        title: '匯出前二次複檢',
        description: '儲存或分享前自動對已打碼影像重新執行偵測器，提示可能遺漏的敏感區域。',
      },
      {
        tag: '批次與自適應',
        title: '批次打碼與本機偏好學習',
        description: '一次匯入多張截圖並支援跨圖尋找相似區域，同時在本機依你的勾選習慣自動微調各類別門檻。',
      },
      {
        tag: '直達編輯器',
        title: '按住透視、原生複製與系統分享',
        description:
          '啟動即進入編輯介面；按住眼睛徽標可對比原圖，一鍵寫入系統剪貼簿，支援系統分享、開啟方式與拖曳匯入。',
      },
      {
        tag: 'Rust 核心 + CLI',
        title: '可腳本化的 unseen CLI',
        description: '與行動端共用 unseen-core 引擎，提供獨立命令列工具進行批次打碼與 BLAKE3 模型驗證。',
      },
    ],
    classesTitle: '支援 19 類敏感目標',
    classesNote: '包含內建 unseen-det 0.5.0 的 18 個類別，以及基於 YuNet 的人臉偵測（face）。',
  },
  privacy: {
    title: '零網路程式碼，零相簿讀取權限。',
    subtitle: '隱私邊界由建置產物與系統權限清單直接約束，支援公開稽核。',
    factors: [
      {
        tag: '離線建置',
        title: '應用程式不含任何連網程式碼',
        description:
          '模型權重直接隨安裝包內建，移除 HTTP 用戶端、統計 SDK 與當機回報，CI 每次建置均自動檢查零網路相依。',
      },
      {
        tag: '系統選圖器',
        title: '不申請相簿讀取權限',
        description:
          'iOS 僅呼叫系統行程外 PHPickerViewController，儲存時僅申請 .addOnly 寫入權限；Android 呼叫系統相片選擇器並在 Release 清單中移除傳遞權限。',
      },
    ],
    tableColArea: '檢查項',
    tableColDetail: '實作方式',
    rows: [
      {
        area: '影像處理',
        detail: '偵測、EXIF 方向校正與像素覆寫全部在本機 Rust（unseen-core）經 FFI 執行。',
      },
      {
        area: '打碼不可逆性',
        detail: '純色、灰階馬賽克與雜訊完全不讀取原圖；環境融合與彩色馬賽克僅取樣框外 4 px 環帶顏色。',
      },
      {
        area: '選用網頁偵測回饋',
        detail:
          '主動回報漏檢或誤檢時，應用程式透過 URL #fragment 在系統瀏覽器開啟 mosaic.lollipopkit.com/feedback；fragment 不會進入 HTTP GET 記錄，載入後立即以 history.replaceState 清除。',
      },
      {
        area: '開源可重現',
        detail: '用戶端、Rust 核心、回饋 Worker 與發布模型權重均以 AGPL-3.0 授權開源，並提供 BLAKE3 校驗和。',
      },
    ],
  },
  download: {
    ...zhCN.download,
    title: '支援行動與桌面平台。',
    subtitle: '於 GitHub Releases 下載預編譯版本，或直接由原始碼建置。',
    currentBadge: '目前平台',
    sourceAction: '由原始碼建置',
    cliPrompt: '# 建置 Rust 命令列工具（unseen）',
    appPrompt: '# 由原始碼執行 Flutter 應用程式',
    copy: '複製',
    copied: '已複製',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Release 零權限清單' },
      linux: { name: 'Linux', meta: '桌面應用程式（tar.gz）與 unseen CLI' },
      windows: { name: 'Windows', meta: '桌面應用程式（ZIP）與 unseen CLI' },
    },
  },
  cta: {
    title: '以 AGPL-3.0 授權免費開源。',
    subtitle: '檢視完整原始碼、下載最新版本，或在網頁回饋頁提交漏檢與誤檢樣本以改進偵測模型。',
    feedbackAction: '開啟偵測回饋頁',
    releasesAction: 'GitHub Releases',
    githubAction: '檢視原始碼',
  },
  more: {
    title: 'lollipopkit 的更多專案。',
    subtitle: '同樣專注於原生體驗與簡潔設計的其他開源工具。',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description: '整合即時狀態圖表、觸控 SSH 終端、SFTP、Docker、systemd 與 S.M.A.R.T. 的原生伺服器管理工具。',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description: '透過 macOS 原生 File Provider，無需核心延伸功能即可在 Finder 中掛載 SFTP、S3 與 WebDAV。',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description: '原生 OpenAI 及相容模型 API 用戶端，支援本機優先對話儲存、工具呼叫與自訂端點。',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: '功能',
    privacy: '隱私',
    download: '下載',
    feedback: '偵測回饋',
    releases: '版本發布',
    license: 'AGPL-3.0',
  },
};

const ja: Copy = {
  meta: {
    lang: 'ja',
    title: 'MosaicIt — 完全オフラインのプライバシー自動マスキング',
    description:
      'スクリーンショットや写真内の個人情報をオンデバイスで検出して遮蔽。OCR 不要、ネットワーク通信なし、写真ライブラリ読み取り権限なし。',
  },
  nav: {
    features: '機能',
    privacy: 'プライバシー',
    download: 'ダウンロード',
    feedback: 'フィードバック',
    github: 'GitHub',
    languageLabel: '言語',
    cta: 'ダウンロード',
  },
  hero: {
    titlePrefix: '個人情報を自動マスク、',
    titleSuffix: '完全オフラインで。',
    subtitle:
      'MosaicIt は氏名・電話番号・住所・金額・ID・QR コード・顔を端末内で直接検出します。OCR もネットワーク通信も写真ライブラリの読み取り権限も不要です。',
    primaryAction: 'MosaicIt をダウンロード',
    feedbackAction: 'Web フィードバック',
    githubAction: 'GitHub',
  },
  demo: {
    ariaLabel: 'MosaicIt インタラクティブ遮蔽プレビュー',
    peekLabel: '長押しで元画像を確認',
    resetLabel: 'マスクをリセット',
    receiptTitle: '振込明細',
    recipientLabel: '受取人',
    recipientValue: '山田 太郎',
    phoneLabel: '電話番号',
    phoneValue: '090-0148-8920',
    addressLabel: '住所',
    addressValue: '東京都港区楓町 4-2-8',
    amountLabel: '振込金額',
    amountValue: '¥ 128,400',
    cardLabel: '口座番号',
    cardValue: '6222 **** **** 4821',
    qrLabel: '明細 QR',
    styles: {
      solid: '単色',
      surround: '周囲色',
      blocks: 'ブロック',
      tinted: 'カラーモザイク',
      noise: 'ノイズ',
    },
    classes: {
      person_name: 'person_name',
      phone: 'phone',
      address: 'address',
      finance: 'finance',
      bank_card: 'bank_card',
      qr: 'qr',
    },
  },
  features: {
    title: '高速で検証可能なローカル遮蔽。',
    subtitle: '画像や動画を開いて検出領域を確認・調整し、そのままコピーまたは書き出せます。',
    cards: [
      {
        tag: 'unseen-det 0.5.0',
        title: 'OCR 不要のオンデバイス検出',
        description:
          '同梱された FP16 ONNX / LiteRT モデルで 18 クラスの PII と YuNet による顔領域を端末内で検出。テキスト認識や外部ダウンロードは行いません。',
      },
      {
        tag: '5 スタイル',
        title: '復元不可能なピクセル上書き',
        description:
          '単色・周囲色・ブロック・カラーモザイク・ノイズの 5 種類を用意。遮蔽枠内の元ピクセルを一切参照しないため逆モザイク復元を防ぎます。',
      },
      {
        tag: '書き出し前チェック',
        title: '保存前の再スキャン',
        description: '保存・共有前に遮蔽済み画像へ再度検出器を実行し、マスク漏れを確認できます。',
      },
      {
        tag: '一括処理・適応学習',
        title: '複数画像の一括遮蔽とローカル学習',
        description: '複数枚のスクリーンショットをまとめて開き、類似領域の一括検索や選択履歴に応じたローカルしきい値調整を行います。',
      },
      {
        tag: '直接エディタ起動',
        title: '長押し確認・コピー・OS 共有',
        description:
          '起動直後にエディタを表示。目のバッジ長押しで元画像と比較でき、クリップボードコピー、共有メニュー、ドラッグ&ドロップに対応します。',
      },
      {
        tag: 'Rust コア + CLI',
        title: 'unseen CLI',
        description: 'アプリと共通の unseen-core エンジンを用いた CLI で、バッチ遮蔽や BLAKE3 モデル検証を実行できます。',
      },
    ],
    classesTitle: '19 クラスの検出対象',
    classesNote: '同梱の unseen-det 0.5.0（18 クラス）と YuNet による顔検出（face）。',
  },
  privacy: {
    title: '通信コードゼロ。写真読み取り権限ゼロ。',
    subtitle: 'プライバシー保証を規約ではなくビルド構成と OS 権限レベルで強制しています。',
    factors: [
      {
        tag: 'オフライン構成',
        title: 'アプリ内にネットワーク通信コードなし',
        description:
          'モデル重みをアプリ内に同梱し、HTTP クライアント・計測 SDK・クラッシュ送信を含みません。CI で毎回ゼロネットワーク依存を検証します。',
      },
      {
        tag: 'システムピッカー',
        title: '写真ライブラリの読み取り権限不要',
        description:
          'iOS は別プロセスの PHPickerViewController と .addOnly 書き込み保存のみ使用。Android はシステムフォトピッカーを使い、リリース時に不要権限を削除します。',
      },
    ],
    tableColArea: '対象',
    tableColDetail: '実装内容',
    rows: [
      {
        area: '画像処理',
        detail: '検出・EXIF 回転補正・ピクセル上書きはすべてローカルの Rust（unseen-core）経由で実行。',
      },
      {
        area: '遮蔽の不可逆性',
        detail: '単色・ブロック・ノイズは元画像を参照せず、周囲色・カラーモザイクは枠外 4 px のリングのみサンプリングします。',
      },
      {
        area: '任意の検出フィードバック',
        detail:
          '誤検出・検出漏れを報告する場合、アプリは URL #fragment 経由でシステムブラウザの mosaic.lollipopkit.com/feedback を開きます。fragment は HTTP GET ログに残らず history.replaceState で即時消去されます。',
      },
      {
        area: 'オープンソース',
        detail: 'アプリ・Rust コア・フィードバック Worker・モデル重みを AGPL-3.0 で公開し、BLAKE3 チェックサムを添付しています。',
      },
    ],
  },
  download: {
    title: 'モバイルとデスクトップに対応。',
    subtitle: 'GitHub Releases からビルド済みパッケージを入手するか、ソースからビルドできます。',
    currentBadge: '現在のプラットフォーム',
    releasesAction: 'GitHub Releases',
    sourceAction: 'ソースからビルド',
    cliPrompt: '# Rust CLI（unseen）をビルド',
    appPrompt: '# ソースから Flutter アプリを実行',
    copy: 'コピー',
    copied: 'コピー済み',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · PHPicker · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · リリース権限ゼロ' },
      linux: { name: 'Linux', meta: 'デスクトップアプリ（tar.gz）・unseen CLI' },
      windows: { name: 'Windows', meta: 'デスクトップアプリ（ZIP）・unseen CLI' },
    },
  },
  cta: {
    title: 'AGPL-3.0 オープンソース。',
    subtitle: 'ソースコードの監査、最新版の入手、または Web フィードバックページからの検出報告が可能です。',
    feedbackAction: 'Web フィードバックを開く',
    releasesAction: 'GitHub Releases',
    githubAction: 'ソースを見る',
  },
  more: {
    title: 'lollipopkit の他のプロジェクト。',
    subtitle: '同じ設計方針で作られたネイティブアプリ。',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description: 'リアルタイム監視・タッチ対応 SSH・SFTP・Docker・systemd・S.M.A.R.T. をまとめたサーバー管理アプリ。',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description: 'Apple File Provider を使い、カーネル拡張なしで SFTP / S3 / WebDAV を Finder にマウント。',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description: 'OpenAI 互換 API 向けの高速ネイティブクライアント。ローカル優先履歴・ツール呼び出し対応。',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: '機能',
    privacy: 'プライバシー',
    download: 'ダウンロード',
    feedback: 'フィードバック',
    releases: 'リリース',
    license: 'AGPL-3.0',
  },
};

export const TRANSLATIONS: Record<Locale, Copy> = {
  en,
  'zh-CN': zhCN,
  'zh-TW': zhTW,
  ja,
};

const STORAGE_KEY = 'mosaic-locale';

function matchLocale(raw: string | null | undefined): Locale | null {
  if (!raw) return null;
  const norm = raw.trim().toLowerCase();
  if (norm === 'en' || norm.startsWith('en-')) return 'en';
  if (
    norm === 'zh-tw' ||
    norm === 'zh-hk' ||
    norm === 'zh-mo' ||
    norm === 'zh-hant' ||
    norm.startsWith('zh-hant-') ||
    norm.includes('-hant')
  ) {
    return 'zh-TW';
  }
  if (norm === 'zh' || norm === 'zh-cn' || norm === 'zh-sg' || norm.startsWith('zh-')) return 'zh-CN';
  if (norm === 'ja' || norm.startsWith('ja-')) return 'ja';
  return null;
}

export function detectInitialLocale(): Locale {
  if (typeof window === 'undefined') return 'en';
  const params = new URLSearchParams(window.location.search);
  const fromQuery = matchLocale(params.get('lang'));
  if (fromQuery) return fromQuery;
  try {
    const fromStorage = matchLocale(window.localStorage.getItem(STORAGE_KEY));
    if (fromStorage) return fromStorage;
  } catch {
    // Ignore storage access restrictions.
  }
  for (const lang of navigator.languages ?? [navigator.language]) {
    const matched = matchLocale(lang);
    if (matched) return matched;
  }
  return 'en';
}

export function persistLocale(locale: Locale): void {
  if (typeof window === 'undefined') return;
  try {
    window.localStorage.setItem(STORAGE_KEY, locale);
  } catch {
    // Ignore storage access restrictions.
  }
}

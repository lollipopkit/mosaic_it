import type { Copy } from './types';

export const zhTW: Copy = {
  meta: {
    lang: 'zh-TW',
    dir: 'ltr',
    title: 'MosaicIt（碼住）— 本機離線隱私打碼工具',
    description:
      '全程離線偵測並遮蔽截圖與照片中的隱私資訊。無需 OCR、不含網路請求程式碼，也不申請相簿讀取權限。',
  },
  nav: {
    screenshots: '截圖',
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
  features: {
    title: '快速、可驗證的本機打碼流程。',
    subtitle: '開啟圖片後自動標出隱私區域，依需求增減遮蔽框，一鍵複製或匯出。',
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
    title: '支援行動與桌面平台。',
    subtitle: '於 GitHub Releases 下載預編譯版本，或直接由原始碼建置。',
    currentBadge: '目前平台',
    releasesAction: 'GitHub Releases',
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

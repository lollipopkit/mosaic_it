import type { DocsBundle } from './types';

export const docsZhTW: DocsBundle = {
  lang: 'zh-TW',
  dir: 'ltr',
  pageTitle: '文件 — MosaicIt（碼住）',
  sidebarLabel: '使用文件',
  paginationLabel: '文件翻頁',
  backHome: '返回首頁',
  copy: '複製',
  copied: '已複製',
  prevLabel: '上一篇',
  nextLabel: '下一篇',
  pages: [
    {
      slug: 'quick-start',
      title: '快速開始',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt（碼住）在本機離線偵測並遮蔽截圖與照片中的隱私資訊。每個安裝包皆已內建偵測模型，無需帳號登入、不含連網程式碼，也不申請相簿讀取權限。',
        },
        { kind: 'h3', text: '各平台下載與安裝' },
        {
          kind: 'table',
          headers: ['平台', '安裝包與說明'],
          rows: [
            [
              'Android（arm64-v8a）',
              '下載並安裝 MosaicIt_vX.Y.Z_arm64.apk（正式簽署安裝包，內建 FP16 LiteRT 模型，零 android.permission.* 權限）。',
            ],
            [
              'macOS（Apple Silicon）',
              '開啟 MosaicIt_vX.Y.Z_NoSign_arm64.dmg 並拖入「應用程式」。未簽署版本首次開啟請至「系統設定 → 隱私權與安全性」允許執行。',
            ],
            [
              'iOS（arm64）',
              '由 App Store 安裝，或使用個人 Apple 開發者憑證自行簽署安裝 MosaicIt_vX.Y.Z_NoSign.ipa。',
            ],
            [
              'Linux（amd64）',
              '提供 AppImage（ubuntu-latest / 相容版 ubuntu-22.04）、.deb、.rpm 與可攜版 .tar.gz。',
            ],
            [
              'Windows（amd64）',
              '執行 MosaicIt_vX.Y.Z_windows_amd64.exe 安裝程式，或解壓可攜版 .zip 直接使用。',
            ],
          ],
        },
        { kind: 'h3', text: '驗證發布檔案雜湊值' },
        {
          kind: 'p',
          text: '每個 GitHub Release 均附帶 BLAKE3SUMS 與 SHA256SUMS，安裝前可進行校驗：',
        },
        {
          kind: 'code',
          label: 'Shell',
          code: '# 驗證單一已下載檔案（BLAKE3 或 SHA-256）\ngrep <filename> BLAKE3SUMS | b3sum -c -\nsha256sum -c --ignore-missing SHA256SUMS\n# 若已下載全部發布檔案，可直接執行\nb3sum -c BLAKE3SUMS',
        },
        { kind: 'h3', text: '基本流程' },
        {
          kind: 'ul',
          items: [
            '啟動應用程式直接進入編輯器，亦可從系統分享面板或桌面拖曳圖片匯入。',
            '透過系統原生選圖器挑選一張或多張截圖，本機自動完成隱私區域偵測。',
            '點擊偵測框切換遮蔽狀態，按住頂部眼睛圖示對比原圖，或切換打碼樣式。',
            '一鍵複製到剪貼簿、呼叫系統分享面板，或僅使用寫入權限儲存至相簿／檔案。',
          ],
        },
      ],
    },
    {
      slug: 'editor',
      title: '編輯器與打碼樣式',
      blocks: [
        {
          kind: 'p',
          text: '所有自動偵測結果皆可在匯出前逐項核對與調整，不會覆寫你的原始圖片檔案。',
        },
        { kind: 'h3', text: '區域編輯操作' },
        {
          kind: 'ul',
          items: [
            '切換遮蔽：點擊任意偵測框即可啟用或取消該區域打碼。',
            '按住透視：長按頂欄眼睛圖示暫時隱藏遮蔽層，核對原圖細節。',
            '手動繪製：在畫布上直接拖曳即可手繪補框；長按該框開啟選單刪除（或復原）。',
            '多行分組：使用底部工具列的「合併（Merge）」工具將換行內容（如兩行地址）合併為一組連動切換；長按已分組框可拆分（Split）。',
            '批次處理與尋找相似：透過底部縮圖列一次處理多張截圖，點擊「尋找相似」可在不辨識文字的情況下跨圖定位重複敏感區域。',
          ],
        },
        { kind: 'h3', text: '5 種不可逆打碼樣式' },
        {
          kind: 'table',
          headers: ['樣式', '像素覆寫方式'],
          rows: [
            ['純色（Solid）', '以單一純色完全填滿選區，完全不讀取框內原始像素。'],
            ['環境融合（Surround）', '僅取樣遮蔽框外側 4 px 環帶平均色填滿，自然融入背景。'],
            ['灰階馬賽克（Blocks）', '產生確定性灰階色塊，完全不讀取框內原圖像素。'],
            ['彩色馬賽克（Tinted）', '僅依據框外 4 px 環帶色彩產生色塊馬賽克。'],
            ['雜訊（Noise）', '寫入隨機像素雜訊，與原圖內容完全無關。'],
          ],
        },
        {
          kind: 'note',
          text: '五種樣式皆不讀取遮蔽框內部的原始像素，避免反馬賽克或去模糊還原風險。',
        },
        { kind: 'h3', text: '匯出前自檢' },
        {
          kind: 'p',
          text: '儲存或分享前，應用程式會對已打碼影像重新執行偵測器並檢查框內像素相關性，提示可能遺漏的敏感區域；可返回補框或手動確認匯出。',
        },
      ],
    },
    {
      slug: 'models',
      title: '模型與硬體加速',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt 內建輕量 FP16 視覺神經網路偵測器（unseen-det 0.6.0），直接從影像像素定位敏感區域，無需 OCR，也不依賴傳統詞庫或正規表示式比對。',
        },
        { kind: 'h3', text: '端側硬體加速與省電表現' },
        {
          kind: 'table',
          headers: ['平台', '推論後端與硬體加速器'],
          rows: [
            ['iOS / macOS', 'FP16 ONNX 經 ONNX Runtime + CoreML 執行於 Apple 神經網路引擎（ANE / NPU），毫秒級回應且省電。'],
            ['Android（arm64）', 'FP16 LiteRT（.tflite）執行於行動端 GPU（OpenCL / OpenGL），不支援時自動回退 XNNPACK CPU。'],
            ['Linux / Windows', 'FP16 ONNX 經 ONNX Runtime 於本機 CPU 執行。'],
          ],
        },
        { kind: 'h3', text: '支援偵測的 19 類目標' },
        {
          kind: 'p',
          text: 'unseen-det 0.6.0 涵蓋 18 類截圖與文件隱私目標，並內建 YuNet 進行人臉偵測：',
        },
        {
          kind: 'code',
          label: '類別清單',
          code: 'person_name, address, phone, email, id_number, bank_card, plate,\naccount_id, avatar, qr, barcode, finance, organization, device_id,\nsecret, person, health, personal_info, face',
        },
        { kind: 'h3', text: '本機自適應門檻偏好' },
        {
          kind: 'p',
          text: '每次保留或取消勾選的操作都會在本機微調對應類別的預選門檻。所有偏好僅存放於本機，隨時可在設定中重設。',
        },
        { kind: 'h3', text: '匯入自訂模型' },
        {
          kind: 'p',
          text: '可在設定中手動匯入本機 .onnx（Apple / 桌面端）或 .tflite（Android）權重與對應的 .onnx.json / .tflite.json sidecar 檔案（在完整模型檔名後加上 .json，例如 unseen-det-tile.onnx.json）。官方發布清單（models/manifest.toml）透過 BLAKE3 鎖定權重校驗和。',
        },
      ],
    },
    {
      slug: 'cli',
      title: 'CLI 命令列指南',
      blocks: [
        {
          kind: 'p',
          text: '獨立命令列工具 unseen 與用戶端共用 unseen-core 引擎，適合腳本化偵測、批次打碼、效能測試與模型校驗。',
        },
        { kind: 'h3', text: '安裝或從原始碼建置' },
        {
          kind: 'p',
          text: '可直接從 GitHub Releases 下載適用於 macOS、Linux 或 Windows 的預編譯 unseen_vX.Y.Z_* 封存檔，或從原始碼建置：',
        },
        {
          kind: 'code',
          label: '從原始碼建置',
          code: 'git clone --recurse-submodules https://github.com/lollipopkit/mosaic_it\ncd mosaic_it\ncargo build --release -p unseen-cli\n# macOS 啟用 CoreML / ANE 硬體加速：\ncargo build --release -p unseen-cli --features coreml',
        },
        { kind: 'h3', text: '偵測並輸出 JSON / JSONL' },
        {
          kind: 'code',
          label: 'unseen detect',
          code: '# 單圖 JSON 輸出（啟用內建 YuNet 人臉偵測）\nunseen detect --model unseen-det-tile.onnx --faces screenshot.png\n\n# 批次截圖串流 JSONL 輸出\nunseen detect --model unseen-det-tile.onnx --jsonl *.png',
        },
        { kind: 'h3', text: '批次打碼匯出' },
        {
          kind: 'code',
          label: 'unseen redact',
          code: '# 預設純黑遮蔽並執行匯出自檢\nunseen redact --model unseen-det-tile.onnx --faces input.png output.png\n\n# 指定打碼樣式（solid / surround / blocks / tinted / noise）與外擴邊距\nunseen redact --model unseen-det-tile.onnx --style surround --pad 6 input.png output.png\nunseen redact --model unseen-det-tile.onnx --style solid --color 1A1418 input.png output.png',
        },
        { kind: 'h3', text: '驗證模型雜湊與測速' },
        {
          kind: 'code',
          label: 'Verify & Bench',
          code: 'unseen models verify unseen-det-tile.onnx unseen-det.tflite\nunseen bench --model unseen-det-tile.onnx --runs 20 screenshot.png',
        },
      ],
    },
    {
      slug: 'privacy',
      title: '隱私邊界與常見問題',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt 的離線與零權限保證透過編譯期相依檢查、系統權限清單與 CI 自動化檢查共同落實。',
        },
        { kind: 'h3', text: '隱私與權限校驗清單' },
        {
          kind: 'table',
          headers: ['保證項', '落實與校驗方式'],
          rows: [
            ['應用程式零網路程式碼', '不含 HTTP 用戶端、統計 SDK 與當機回報；CI 每次建置均掃描相依與原始碼，發現連網 API 即失敗。'],
            ['Android 零權限發布', 'Release 清單移除傳遞權限；CI 與發布流程透過 aapt2 強制驗證最終 APK 不含任何 android.permission.*。'],
            ['零相簿讀取權限', 'iOS 僅呼叫系統行程外 PHPickerViewController（無 NSPhotoLibraryUsageDescription），儲存僅申請 .addOnly 寫入權限；Android 僅用系統相片選擇器。'],
            ['macOS 無網路沙盒', 'Release.entitlements 僅啟用 app-sandbox 與使用者選取檔案讀寫，不含 com.apple.security.network.*。'],
            ['選用網頁回饋', '主動回報時經 URL #fragment 在系統瀏覽器開啟 mosaic.lollipopkit.com/feedback；fragment 不進入 HTTP GET 記錄，載入後立即以 history.replaceState 清除。'],
          ],
        },
        { kind: 'h3', text: '常見問題' },
        {
          kind: 'ul',
          items: [
            '匯出圖片會清除 EXIF 中繼資料嗎？會。匯出結果為重新編碼的像素影像，不保留原圖 EXIF 資訊。',
            'macOS 提示未簽署應用如何開啟？GitHub Release 中的 DMG 為 ad-hoc 簽署，首次於「系統設定 → 隱私權與安全性」允許即可，亦可自行從原始碼建置。',
            '偵測過程中會上傳圖片嗎？不會，應用程式內不含任何連網能力；僅當你主動點擊回饋並於瀏覽器送出時才由瀏覽器發起請求。',
            '開源授權為何？應用程式原始碼、Rust 引擎與發布的模型權重皆採 AGPL-3.0 授權。',
          ],
        },
      ],
    },
  ],
};

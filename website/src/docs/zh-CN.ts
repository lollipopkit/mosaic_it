import type { DocsBundle } from './types';

export const docsZhCN: DocsBundle = {
  lang: 'zh-CN',
  dir: 'ltr',
  pageTitle: '文档 — MosaicIt（码住）',
  sidebarLabel: '使用文档',
  paginationLabel: '文档翻页',
  backHome: '返回首页',
  copy: '复制',
  copied: '已复制',
  prevLabel: '上一篇',
  nextLabel: '下一篇',
  pages: [
    {
      slug: 'quick-start',
      title: '快速开始',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt（码住）在设备本地离线检测并遮挡截图与照片中的隐私信息。每个安装包均已内置检测模型，无需账号登录、不含联网代码，也不申请相册读取权限。',
        },
        { kind: 'h3', text: '各平台下载与安装' },
        {
          kind: 'table',
          headers: ['平台', '安装包与说明'],
          rows: [
            [
              'Android（arm64-v8a）',
              '下载并安装 MosaicIt_vX.Y.Z_arm64.apk（正式签名包，内置 FP16 LiteRT 模型，零 android.permission.* 权限）。',
            ],
            [
              'macOS（Apple Silicon）',
              '打开 MosaicIt_vX.Y.Z_NoSign_arm64.dmg 并拖入“应用程序”。未签名版本首次打开请在“系统设置 → 隐私与安全性”中允许运行。',
            ],
            [
              'iOS（arm64）',
              '通过 App Store 安装，或使用个人 Apple 开发者证书自签安装 MosaicIt_vX.Y.Z_NoSign.ipa。',
            ],
            [
              'Linux（amd64）',
              '提供 AppImage（ubuntu-latest / 兼容版 ubuntu-22.04）、.deb、.rpm 与便携版 .tar.gz。',
            ],
            [
              'Windows（amd64）',
              '运行 MosaicIt_vX.Y.Z_windows_amd64.exe 安装程序，或解压便携版 .zip 直接运行。',
            ],
          ],
        },
        { kind: 'h3', text: '校验发布产物哈希' },
        {
          kind: 'p',
          text: '每个 GitHub Release 均附带 BLAKE3SUMS 与 SHA256SUMS，安装前可按需校验：',
        },
        {
          kind: 'code',
          label: 'Shell',
          code: '# 校验单个已下载产物（BLAKE3 或 SHA-256）\ngrep <filename> BLAKE3SUMS | b3sum -c -\nsha256sum -c --ignore-missing SHA256SUMS\n# 若已下载全部发布资产，可直接执行\nb3sum -c BLAKE3SUMS',
        },
        { kind: 'h3', text: '基本流程' },
        {
          kind: 'ul',
          items: [
            '启动应用直接进入编辑器，也可从系统分享面板或桌面拖拽图片导入。',
            '通过系统原生选图器挑选一张或多张截图，本地自动完成隐私区域检测。',
            '点击检测框切换遮挡状态，按住顶栏眼睛图标对比原图，或切换打码样式。',
            '一键复制到剪贴板、调用系统分享面板，或仅使用写入权限保存到相册/文件。',
          ],
        },
      ],
    },
    {
      slug: 'editor',
      title: '编辑器与打码样式',
      blocks: [
        {
          kind: 'p',
          text: '所有自动检测结果均可在导出前逐项核对与调整，不会覆盖或修改你的原始图片文件。',
        },
        { kind: 'h3', text: '区域编辑操作' },
        {
          kind: 'ul',
          items: [
            '切换遮挡：点击任意检测框即可开启或取消该区域打码。',
            '按住透视：长按顶栏眼睛图标临时隐藏遮挡层，核对原图细节。',
            '手动绘制：在画布上直接拖拽即可手绘补框；长按对应框打开菜单删除（或撤销）。',
            '多行成组：使用底部工具栏的“合并（Merge）”工具将跨行内容（如两行地址）合并为一组联动开关；长按已分组框可拆分（Split）。',
            '批量处理与查找相似：通过底部缩略图栏一次处理多张截图，点击“查找相似”可在不识字的情况下跨图定位重复出现的敏感区域。',
          ],
        },
        { kind: 'h3', text: '5 种不可逆打码样式' },
        {
          kind: 'table',
          headers: ['样式', '像素覆写方式'],
          rows: [
            ['纯色（Solid）', '用单一纯色完全填充选区，完全不读取框内原始像素。'],
            ['环境融合（Surround）', '仅采样遮挡框外侧 4 px 环带平均色进行填充，自然融入背景。'],
            ['灰度马赛克（Blocks）', '生成确定性灰度色块，完全不读取框内原图像素。'],
            ['彩色马赛克（Tinted）', '仅基于框外 4 px 环带色彩生成色块马赛克。'],
            ['噪点（Noise）', '写入随机像素噪点，与原图内容完全无关。'],
          ],
        },
        {
          kind: 'note',
          text: '五种样式均不读取遮挡框内部的原始像素，避免反马赛克或去模糊还原风险。',
        },
        { kind: 'h3', text: '导出前自检' },
        {
          kind: 'p',
          text: '保存或分享前，应用会对已打码图像重新运行检测器并核查框内像素相关性，提示可能残留或漏遮的敏感区域；你可以返回补框，或手动确认继续导出。',
        },
      ],
    },
    {
      slug: 'models',
      title: '模型与硬件加速',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt 内置轻量 FP16 视觉神经网络检测器（unseen-det 0.6.0），直接基于图像像素定位敏感区域，无需 OCR，也不依赖传统词库或正则表达式匹配。',
        },
        { kind: 'h3', text: '端侧硬件加速与省电表现' },
        {
          kind: 'table',
          headers: ['平台', '推理后端与硬件加速器'],
          rows: [
            ['iOS / macOS', 'FP16 ONNX 经 ONNX Runtime + CoreML 运行在 Apple 神经网络引擎（ANE / NPU），毫秒级响应且低功耗省电。'],
            ['Android（arm64）', 'FP16 LiteRT（.tflite）运行在移动端 GPU（OpenCL / OpenGL），不支持时自动回退至 XNNPACK CPU。'],
            ['Linux / Windows', 'FP16 ONNX 经 ONNX Runtime 在本地 CPU 运行。'],
          ],
        },
        { kind: 'h3', text: '支持检测的 19 类目标' },
        {
          kind: 'p',
          text: 'unseen-det 0.6.0 覆盖 18 类截图与文档隐私目标，并内置 YuNet 用于人脸检测：',
        },
        {
          kind: 'code',
          label: '类别清单',
          code: 'person_name, address, phone, email, id_number, bank_card, plate,\naccount_id, avatar, qr, barcode, finance, organization, device_id,\nsecret, person, health, personal_info, face',
        },
        { kind: 'h3', text: '本地自适应阈值偏好' },
        {
          kind: 'p',
          text: '你每次保留或取消勾选的操作都会在本地微调对应类别的预选阈值。所有偏好仅存于本机，可随时在设置中重置。',
        },
        { kind: 'h3', text: '导入自定义模型' },
        {
          kind: 'p',
          text: '可在设置中手动导入本地 .onnx（Apple / 桌面端）或 .tflite（Android）权重及对应的 .onnx.json / .tflite.json sidecar 文件（在完整模型文件名后追加 .json，例如 unseen-det-tile.onnx.json）。官方发布清单（models/manifest.toml）通过 BLAKE3 锁定全部权重校验和。',
        },
      ],
    },
    {
      slug: 'cli',
      title: 'CLI 命令行指南',
      blocks: [
        {
          kind: 'p',
          text: '独立命令行工具 unseen 与客户端共用 unseen-core 引擎，适合脚本化检测、批量打码、性能基准测试与模型校验。',
        },
        { kind: 'h3', text: '安装或从源码构建' },
        {
          kind: 'p',
          text: '可直接从 GitHub Releases 下载适用于 macOS、Linux 或 Windows 的预编译 unseen_vX.Y.Z_* 压缩包，或从源码构建：',
        },
        {
          kind: 'code',
          label: '从源码构建',
          code: 'git clone --recurse-submodules https://github.com/lollipopkit/mosaic_it\ncd mosaic_it\ncargo build --release -p unseen-cli\n# macOS 启用 CoreML / ANE 硬件加速：\ncargo build --release -p unseen-cli --features coreml',
        },
        { kind: 'h3', text: '检测并输出 JSON / JSONL' },
        {
          kind: 'code',
          label: 'unseen detect',
          code: '# 单图 JSON 输出（开启内置 YuNet 人脸检测）\nunseen detect --model unseen-det-tile.onnx --faces screenshot.png\n\n# 批量截图流式 JSONL 输出\nunseen detect --model unseen-det-tile.onnx --jsonl *.png',
        },
        { kind: 'h3', text: '批量打码导出' },
        {
          kind: 'code',
          label: 'unseen redact',
          code: '# 默认纯黑遮挡并执行导出自检\nunseen redact --model unseen-det-tile.onnx --faces input.png output.png\n\n# 指定打码样式（solid / surround / blocks / tinted / noise）与外扩边距\nunseen redact --model unseen-det-tile.onnx --style surround --pad 6 input.png output.png\nunseen redact --model unseen-det-tile.onnx --style solid --color 1A1418 input.png output.png',
        },
        { kind: 'h3', text: '校验模型哈希与测速' },
        {
          kind: 'code',
          label: 'Verify & Bench',
          code: 'unseen models verify unseen-det-tile.onnx unseen-det.tflite\nunseen bench --model unseen-det-tile.onnx --runs 20 screenshot.png',
        },
      ],
    },
    {
      slug: 'privacy',
      title: '隐私边界与常见问题',
      blocks: [
        {
          kind: 'p',
          text: 'MosaicIt 的离线与零权限承诺通过编译期依赖检查、系统权限清单以及 CI 自动化校验共同保障。',
        },
        { kind: 'h3', text: '隐私与权限校验清单' },
        {
          kind: 'table',
          headers: ['保障项', '落地与校验方式'],
          rows: [
            ['应用零网络代码', '不含 HTTP 客户端、统计 SDK 与崩溃上报；CI 每次构建均扫描应用依赖与源码，发现联网 API 直接失败。'],
            ['Android 零权限发布', 'Release 清单剔除传递权限；CI 与发布流水线通过 aapt2 强制校验最终 APK 不含任何 android.permission.*。'],
            ['零相册读取权限', 'iOS 仅调用系统进程外 PHPickerViewController（无 NSPhotoLibraryUsageDescription），保存仅申请 .addOnly 写入权限；Android 仅用系统照片选择器。'],
            ['macOS 无网络沙盒', 'Release.entitlements 仅启用 app-sandbox 与用户选定文件读写，不含 com.apple.security.network.* 权限。'],
            ['可选网页反馈', '主动反馈时经 URL #fragment 在系统浏览器打开 mosaic.lollipopkit.com/feedback；fragment 不进入 HTTP GET 日志，页面加载后立即经 history.replaceState 清除。'],
          ],
        },
        { kind: 'h3', text: '常见问题' },
        {
          kind: 'ul',
          items: [
            '导出图片会清除 EXIF 元数据吗？会。导出结果为重新编码的像素图像，不继承原图 EXIF 元数据。',
            'macOS 提示未签名应用如何打开？GitHub Release 中的 DMG 为 ad-hoc 签名，首次在“系统设置 → 隐私与安全性”点击允许即可，也可自行从源码构建。',
            '检测或使用过程中会上传图片吗？不会，应用内没有任何联网能力；仅当你主动点击反馈并在浏览器提交时才由浏览器发起请求。',
            '开源协议是什么？应用源码、Rust 引擎与发布的模型权重均遵循 AGPL-3.0 协议。',
          ],
        },
      ],
    },
  ],
};

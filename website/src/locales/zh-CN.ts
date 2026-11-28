import type { Copy } from './types';

export const zhCN: Copy = {
  meta: {
    lang: 'zh-CN',
    dir: 'ltr',
    title: 'MosaicIt（码住）— 本地离线隐私打码工具',
    description:
      '全程离线检测并遮挡截图与照片中的隐私信息。无需 OCR、不包含任何网络请求代码、不申请相册读取权限。',
  },
  nav: {
    screenshots: '截图',
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
  features: {
    title: '快速、可验证的本地打码工作流。',
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
  },
  privacy: {
    title: '零网络代码，零相册读取权限。',
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
    currentBadge: '当前平台',
    releasesAction: 'GitHub Releases',
    sourceAction: '从源码构建',
    cliPrompt: '# 构建 Rust 命令行工具（unseen）',
    appPrompt: '# 从源码运行 Flutter 应用',
    copy: '复制',
    copied: '已复制',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Release 零权限清单' },
      linux: { name: 'Linux', meta: '桌面应用（tar.gz）与 unseen CLI' },
      windows: { name: 'Windows', meta: '桌面应用（ZIP）与 unseen CLI' },
    },
  },
  cta: {
    title: '基于 AGPL-3.0 协议免费开源。',
    feedbackAction: '打开检测反馈页',
    releasesAction: 'GitHub Releases',
    githubAction: '查看源码',
  },
  more: {
    title: 'lollipopkit 的更多作品。',
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

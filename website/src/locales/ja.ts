import type { Copy } from './types';

export const ja: Copy = {
  meta: {
    lang: 'ja',
    dir: 'ltr',
    title: 'MosaicIt — 完全オフラインのプライバシー自動マスキング',
    description:
      'スクリーンショットや写真内の個人情報をオンデバイスで検出して遮蔽。OCR 不要、ネットワーク通信なし、写真ライブラリ読み取り権限なし。',
  },
  nav: {
    screenshots: 'スクリーンショット',
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
      person_name: '氏名',
      phone: '電話番号',
      address: '住所',
      finance: '金額',
      bank_card: '銀行口座',
      qr: 'QR コード',
    },
  },
  features: {
    title: '高速で検証可能なローカル遮蔽。',
    subtitle: '画像を開いて検出領域を確認・調整し、そのままコピーまたは書き出せます。',
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

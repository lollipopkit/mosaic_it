// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '码住';

  @override
  String get loadingModel => '正在加载模型…';

  @override
  String get modelFileType => '模型';

  @override
  String get useModel => '使用模型';

  @override
  String get imagesFileType => '图片';

  @override
  String get detecting => '正在检测…';

  @override
  String detectingProgress(int current, int total) {
    return '正在检测 $current/$total…';
  }

  @override
  String get chooseModelFirst => '请先选择模型';

  @override
  String get findingSimilar => '正在查找相似项…';

  @override
  String similarSelected(int found, int added) {
    return '已选择 $found 个相似区域（新增 $added 个）';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '已在 $images 张图片中选择 $found 个相似区域（新增 $added 个）';
  }

  @override
  String get saving => '正在保存…';

  @override
  String get exportHere => '导出到此位置';

  @override
  String exportStoppedAt(String name) {
    return '导出在 $name 处停止';
  }

  @override
  String exportedTo(String path) {
    return '已导出到 $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return '已导出到 $path（无音频）';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已导出 $count 张图片',
      one: '已导出 1 张图片',
      zero: '已导出 0 张图片',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '正在检查 $name…';
  }

  @override
  String get checkingAndExporting => '正在检查并导出…';

  @override
  String get cancel => '取消';

  @override
  String get exportAnyway => '仍然导出';

  @override
  String get regionsTooltip => '区域';

  @override
  String get cameraPhoto => '这是一张相机照片；检测器专为截图设计，因此此处的框选不可靠。';

  @override
  String get modeDraw => '绘制';

  @override
  String get fillSolid => '纯色';

  @override
  String get fillBlocks => '灰色马赛克';

  @override
  String get fillNoise => '噪点';

  @override
  String get export => '导出';

  @override
  String pickOneModel(String formats) {
    return '请恰好选择一个 $formats 模型';
  }

  @override
  String pickSidecar(String name) {
    return '同时选择 $name.json';
  }

  @override
  String get analysing => '正在分析';

  @override
  String get followingRegion => '正在跟踪区域';

  @override
  String get exporting => '正在导出';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count 帧';
  }

  @override
  String redactingSpan(String start, String end) {
    return '正在涂改 $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return '导出检查在 $time 失败';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '那里仍有 $count 个疑似隐私区域可见 ($classes)。',
      one: '那里仍有 1 个疑似隐私区域可见 ($classes)。',
      zero: '那里没有可见的疑似隐私区域。',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => '显示帧';

  @override
  String get drawMissedRegion => '绘制检测器遗漏的区域';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '已涂改 $on/$total 条轨迹 · $keyframes 个关键帧';
  }

  @override
  String get keepAudio => '保留音频';

  @override
  String get keepAudioHint => '不会检查语音和通知声音';

  @override
  String get goToFirstAppearance => '跳转到首次出现';

  @override
  String get classPersonName => '姓名';

  @override
  String get classAddress => '地址';

  @override
  String get classPhone => '电话';

  @override
  String get classEmail => '电子邮件';

  @override
  String get classIdNumber => '身份证号';

  @override
  String get classBankCard => '银行卡';

  @override
  String get classPlate => '车牌';

  @override
  String get classAccountId => '账户';

  @override
  String get classAvatar => '头像';

  @override
  String get classFace => '人脸';

  @override
  String get classQr => '二维码';

  @override
  String get classBarcode => '条形码';

  @override
  String get classManual => '手动';

  @override
  String savedModelFailed(String error) {
    return '无法加载已保存的模型，请重新选择模型。（$error）';
  }

  @override
  String get fillSurround => '背景色';

  @override
  String get fillTinted => '彩色马赛克';

  @override
  String get settings => '设置';

  @override
  String get classFinance => '金额';

  @override
  String get delete => '删除';

  @override
  String get undo => '撤销';

  @override
  String get redo => '重做';

  @override
  String get similar => '相似';

  @override
  String get thisImage => '本图';

  @override
  String allImagesCount(int count) {
    return '全部 $count 张';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还有 $count 处可能看得清',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody => '打码后的检查在导出的图片里又找到了这些区域。';

  @override
  String get redactThemAndExport => '一并打码并导出';

  @override
  String get showThem => '查看这些区域';

  @override
  String get pickClass => '选择类别';

  @override
  String get appearance => '外观';

  @override
  String get theme => '主题';

  @override
  String get appIcon => '应用图标';

  @override
  String get threshold => '阈值';

  @override
  String get thresholdLow => '低';

  @override
  String get thresholdMedium => '中';

  @override
  String get thresholdHigh => '高';

  @override
  String get redaction => '打码';

  @override
  String get style => '样式';

  @override
  String get selectedByDefault => '默认选中';

  @override
  String get dataPrivacy => '数据与隐私';

  @override
  String get model => '模型';

  @override
  String get importModel => '导入其他模型';

  @override
  String get advanced => '高级';

  @override
  String get about => '关于';

  @override
  String get licenses => '开源许可';

  @override
  String get merge => '合并';

  @override
  String get split => '拆分';

  @override
  String get mergeHint => '点另一个框，与选中的框合并为同一个值';

  @override
  String get classOrganization => '组织名称';

  @override
  String get classDeviceId => '设备标识';

  @override
  String get classSecret => '密码与密钥';

  @override
  String get classPerson => '人物';

  @override
  String get classHealth => '健康';

  @override
  String get classPersonalInfo => '个人信息';

  @override
  String selectedOf(int selected, int total) {
    return '已选 $selected / $total';
  }

  @override
  String get fillStyle => '填充样式';

  @override
  String get colour => '颜色';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images 张图片',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions 个区域',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => '分享';

  @override
  String get saveToPhotos => '保存到相册';

  @override
  String get saveAs => '另存为…';

  @override
  String get exportFormat => '格式';

  @override
  String get exportSize => '尺寸';

  @override
  String get sizeOriginal => '原尺寸';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已保存 $count 张图片到相册',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => '全选';

  @override
  String get selectNone => '全不选';

  @override
  String get suggested => '建议';

  @override
  String scoreValue(String score) {
    return '置信度 $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return '打码后的检查在导出的第 $index 张图片里又找到了这些区域。';
  }

  @override
  String get reasonNotSelected => '未选中';

  @override
  String get reasonBoxTooSmall => '框太小';

  @override
  String get reasonFillShowsThrough => '填充未完全遮挡';

  @override
  String get openSource => '开源';

  @override
  String get adaptivePreselectTitle => '本机自适应预选';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已调整 $count 个类别',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => '重置偏好';

  @override
  String get adaptiveResetDone => '已重置本机偏好';

  @override
  String get feedbackTitle => '反馈识别问题';

  @override
  String get feedbackShort => '反馈';

  @override
  String get feedbackMenu => '反馈问题';

  @override
  String get feedbackAction => '反馈错例';

  @override
  String get feedbackAttachScreenshot => '选择截图';

  @override
  String get feedbackModeMasked => '仅错例区域';

  @override
  String get feedbackModeFull => '完整原图';

  @override
  String get feedbackModeText => '不含图片';

  @override
  String get feedbackTagMissed => '漏检';

  @override
  String get feedbackTagFalsePositive => '误检';

  @override
  String get feedbackTagBoxDrift => '框不准';

  @override
  String get feedbackTagWrongClass => '分类错';

  @override
  String get feedbackTagOther => '其他';

  @override
  String get feedbackNoteHint => '补充说明（可选）…';

  @override
  String feedbackCountMasked(int count) {
    return '已遮盖 $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return '漏检 $count';
  }

  @override
  String feedbackCountFp(int count) {
    return '误检 $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return '不想遮 $count';
  }

  @override
  String get feedbackBoxMissed => '漏检';

  @override
  String get feedbackBoxMissedMasked => '漏检·遮盖';

  @override
  String get feedbackBoxFp => '误检';

  @override
  String get feedbackBoxPreference => '不想遮';

  @override
  String get introOfflineTitle => '无联网功能';

  @override
  String get introOfflineBody =>
      'MosaicIt 不包含任何网络请求代码，也未申请系统网络权限。检测模型已内置于安装包中，所有识别与打码均在本机完成。';

  @override
  String get introNoNetPermTitle => '零网络权限';

  @override
  String get introBundledModelTitle => '检测模型已内置';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · 本机内置';
  }

  @override
  String get resetBundledModel => '恢复内置模型';

  @override
  String get reviewIntro => '重新查看介绍';

  @override
  String get feedbackOpenWeb => '前往网页提交';

  @override
  String get introNoNetPermBodyIos => '不发起任何网络请求 · 仅本机运行';

  @override
  String get introNoNetPermBodyAndroid => '未申请 INTERNET 网络权限';

  @override
  String get introNoNetPermBodyDesktop => '沙盒未申请网络访问权限';

  @override
  String get customModel => '自定义模型';

  @override
  String modelClassCount(int count) {
    return '$count 个类别';
  }

  @override
  String get copyImage => '复制图片';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get copyFailed => '复制图片失败';

  @override
  String get peekOriginal => '按住查看原图';

  @override
  String get selectMedia => '选择图片';

  @override
  String get saveFailed => '保存到相册失败';

  @override
  String get retry => '重试';

  @override
  String get iosWirelessPromptTitle => '无线数据弹窗提示';

  @override
  String get iosWirelessPromptBody =>
      '打开系统相册时，iOS 可能会因预览 iCloud 缩略图弹出「允许使用无线数据」提示。码住本身不联网，弹窗出现时直接选「不允许」即可。';

  @override
  String get continueAction => '继续';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '碼住';

  @override
  String get loadingModel => '載入模型中…';

  @override
  String get modelFileType => '模型';

  @override
  String get useModel => '使用模型';

  @override
  String get imagesFileType => '圖片';

  @override
  String get detecting => '偵測中…';

  @override
  String detectingProgress(int current, int total) {
    return '偵測中 $current/$total…';
  }

  @override
  String get chooseModelFirst => '請先選擇模型';

  @override
  String get findingSimilar => '尋找相似項目中…';

  @override
  String similarSelected(int found, int added) {
    return '已選取 $found 個相似區域（新增 $added 個）';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '已選取 $found 個相似區域（新增 $added 個），涵蓋 $images 張圖片';
  }

  @override
  String get saving => '儲存中…';

  @override
  String get exportHere => '匯出至此';

  @override
  String exportStoppedAt(String name) {
    return '匯出已停止於 $name';
  }

  @override
  String exportedTo(String path) {
    return '已匯出至 $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return '已匯出至 $path（無音訊）';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已匯出 $count 張圖片',
      one: '已匯出 1 張圖片',
      zero: '已匯出 0 張圖片',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '檢查 $name 中…';
  }

  @override
  String get checkingAndExporting => '檢查並匯出中…';

  @override
  String get cancel => '取消';

  @override
  String get exportAnyway => '仍要匯出';

  @override
  String get regionsTooltip => '區域';

  @override
  String get cameraPhoto => '這是相機照片；偵測器是為截圖設計的，因此此處的框選結果不可靠。';

  @override
  String get modeDraw => '繪製';

  @override
  String get fillSolid => '純色';

  @override
  String get fillBlocks => '灰色馬賽克';

  @override
  String get fillNoise => '雜訊';

  @override
  String get export => '匯出';

  @override
  String pickOneModel(String formats) {
    return '請精確選擇一個 $formats 模型';
  }

  @override
  String pickSidecar(String name) {
    return '同時選擇 $name.json';
  }

  @override
  String get analysing => '分析中';

  @override
  String get followingRegion => '追蹤區域';

  @override
  String get exporting => '匯出中';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count 幀';
  }

  @override
  String redactingSpan(String start, String end) {
    return '正在遮蔽 $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return '匯出檢查失敗於 $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '該處仍有 $count 個看似私人的區域 ($classes)。',
      one: '該處仍有 1 個看似私人的區域 ($classes)。',
      zero: '該處沒有看似私人的區域。',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => '顯示幀';

  @override
  String get drawMissedRegion => '繪製偵測器遺漏的區域';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '已遮蔽 $on / $total 條軌跡 · $keyframes 個關鍵幀';
  }

  @override
  String get keepAudio => '保留音訊';

  @override
  String get keepAudioHint => '不會檢查人聲和通知音效';

  @override
  String get goToFirstAppearance => '前往首次出現';

  @override
  String get classPersonName => '姓名';

  @override
  String get classAddress => '地址';

  @override
  String get classPhone => '電話';

  @override
  String get classEmail => '電子郵件';

  @override
  String get classIdNumber => '身分證字號';

  @override
  String get classBankCard => '銀行卡';

  @override
  String get classPlate => '車牌';

  @override
  String get classAccountId => '帳號';

  @override
  String get classAvatar => '頭像';

  @override
  String get classFace => '人臉';

  @override
  String get classQr => 'QR 碼';

  @override
  String get classBarcode => '條碼';

  @override
  String get classManual => '手動';

  @override
  String savedModelFailed(String error) {
    return '無法載入已儲存的模型；請重新選擇模型。（$error）';
  }

  @override
  String get fillSurround => '背景色';

  @override
  String get fillTinted => '彩色馬賽克';

  @override
  String get settings => '設定';

  @override
  String get classFinance => '金額';

  @override
  String get delete => '刪除';

  @override
  String get undo => '復原';

  @override
  String get redo => '重做';

  @override
  String get similar => '相似';

  @override
  String get thisImage => '此影像';

  @override
  String allImagesCount(int count) {
    return '全部 $count 張影像';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 處可能仍可讀取',
      one: '1 處可能仍可讀取',
      zero: '0 處可能仍可讀取',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody => '遮蔽後，檢查仍在輸出結果中發現這些區域。';

  @override
  String get redactThemAndExport => '遮蔽並匯出';

  @override
  String get showThem => '顯示它們';

  @override
  String get pickClass => '選擇類別';

  @override
  String get appearance => '外觀';

  @override
  String get theme => '主題';

  @override
  String get appIcon => 'App 圖像';

  @override
  String get threshold => '閾值';

  @override
  String get thresholdLow => '低';

  @override
  String get thresholdMedium => '中';

  @override
  String get thresholdHigh => '高';

  @override
  String get redaction => '遮蔽';

  @override
  String get style => '樣式';

  @override
  String get selectedByDefault => '預設選取';

  @override
  String get dataPrivacy => '資料與隱私';

  @override
  String get model => '模型';

  @override
  String get importModel => '匯入其他模型';

  @override
  String get advanced => '進階';

  @override
  String get about => '關於';

  @override
  String get licenses => '開放原始碼授權條款';

  @override
  String get merge => '合併';

  @override
  String get split => '拆分';

  @override
  String get mergeHint => '輕點另一個選取框，使其成為同一數值的一部分';

  @override
  String get classOrganization => '組織名稱';

  @override
  String get classDeviceId => '裝置識別碼';

  @override
  String get classSecret => '密碼與金鑰';

  @override
  String get classPerson => '人物';

  @override
  String get classHealth => '健康';

  @override
  String get classPersonalInfo => '個人資訊';

  @override
  String selectedOf(int selected, int total) {
    return '已選 $selected / $total';
  }

  @override
  String get fillStyle => '填滿樣式';

  @override
  String get colour => '顏色';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images 張圖片',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions 個區域',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => '分享';

  @override
  String get saveToPhotos => '儲存到相簿';

  @override
  String get saveAs => '另存新檔…';

  @override
  String get exportFormat => '格式';

  @override
  String get exportSize => '尺寸';

  @override
  String get sizeOriginal => '原始尺寸';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已儲存 $count 張圖片到相簿',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => '全選';

  @override
  String get selectNone => '全不選';

  @override
  String get suggested => '建議';

  @override
  String scoreValue(String score) {
    return '信心度 $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return '遮蔽後，檢查仍在第 $index 張圖片的輸出結果中發現這些區域。';
  }

  @override
  String get reasonNotSelected => '未選取';

  @override
  String get reasonBoxTooSmall => '選取框太小';

  @override
  String get reasonFillShowsThrough => '填滿未完全遮蔽';

  @override
  String get openSource => '開放原始碼';

  @override
  String get adaptivePreselectTitle => '本機自適應預選';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已調整 $count 個類別',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => '重設偏好';

  @override
  String get adaptiveResetDone => '已重設本機偏好';

  @override
  String get feedbackTitle => '回報辨識問題';

  @override
  String get feedbackShort => '回饋';

  @override
  String get feedbackMenu => '回報問題';

  @override
  String get feedbackAction => '回報錯例';

  @override
  String get feedbackAttachScreenshot => '選擇截圖';

  @override
  String get feedbackModeMasked => '僅錯例區域';

  @override
  String get feedbackModeFull => '完整原圖';

  @override
  String get feedbackModeText => '不含圖片';

  @override
  String get feedbackTagMissed => '漏檢';

  @override
  String get feedbackTagFalsePositive => '誤檢';

  @override
  String get feedbackTagBoxDrift => '框不準';

  @override
  String get feedbackTagWrongClass => '分類錯';

  @override
  String get feedbackTagOther => '其他';

  @override
  String get feedbackNoteHint => '補充說明（選填）…';

  @override
  String feedbackCountMasked(int count) {
    return '已遮蔽 $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return '漏檢 $count';
  }

  @override
  String feedbackCountFp(int count) {
    return '誤檢 $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return '不想遮 $count';
  }

  @override
  String get feedbackBoxMissed => '漏檢';

  @override
  String get feedbackBoxMissedMasked => '漏檢·遮蔽';

  @override
  String get feedbackBoxFp => '誤檢';

  @override
  String get feedbackBoxPreference => '不想遮';

  @override
  String get introOfflineTitle => '無聯網功能';

  @override
  String get introOfflineBody =>
      'MosaicIt 不包含任何網路請求程式碼，也未申請系統網路權限。偵測模型已內建於安裝包中，所有辨識與打碼皆於本機完成。';

  @override
  String get introNoNetPermTitle => '零網路權限';

  @override
  String get introBundledModelTitle => '偵測模型已內建';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · 本機內建';
  }

  @override
  String get resetBundledModel => '恢復內建模型';

  @override
  String get reviewIntro => '重新檢視介紹';

  @override
  String get feedbackOpenWeb => '前往網頁提交';

  @override
  String get introNoNetPermBodyIos => '不發起任何網路請求 · 僅本機執行';

  @override
  String get introNoNetPermBodyAndroid => '未申請 INTERNET 網路權限';

  @override
  String get introNoNetPermBodyDesktop => '沙盒未申請網路存取權限';

  @override
  String get customModel => '自訂模型';

  @override
  String modelClassCount(int count) {
    return '$count 個類別';
  }

  @override
  String get copyImage => '複製圖片';

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get copyFailed => '複製圖片失敗';

  @override
  String get peekOriginal => '按住檢視原圖';

  @override
  String get selectMedia => '選擇圖片';

  @override
  String get saveFailed => '儲存到相簿失敗';

  @override
  String get retry => '重試';

  @override
  String get iosWirelessPromptTitle => '無線資料彈窗提示';

  @override
  String get iosWirelessPromptBody =>
      '開啟系統相簿時，iOS 可能會因預覽 iCloud 縮圖彈出「允許使用無線資料」提示。碼住本身不連網，彈窗出現時直接選「不允許」即可。';

  @override
  String get continueAction => '繼續';
}

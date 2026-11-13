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
  String get reviewButton => '审核';

  @override
  String get openingLabels => '正在打开标签…';

  @override
  String noImagesIn(String name) {
    return '$name 中没有图片';
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
  String get reviewPseudoLabels => '查看伪标签（包含 coco.json 的文件夹）';

  @override
  String get regionsTooltip => '区域';

  @override
  String get notCalibrated => '模型未校准：预选使用固定阈值。';

  @override
  String calibratedUnverified(String domain) {
    return '在未经验证的数据 ($domain) 上校准：召回率保证尚未生效。';
  }

  @override
  String calibratedFor(String domain) {
    return '已针对 $domain 图片进行校准。其他类型的图片不在保证范围内。';
  }

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
  String get verifyNext => '验证并下一项';

  @override
  String get export => '导出';

  @override
  String get pickOneModel => '请恰好选择一个 .onnx 模型';

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
  String noLabelsIn(String name) {
    return '$name 中没有 coco.json';
  }

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
  String get collectTitle => '收集训练数据';

  @override
  String get collectSubtitle => '在本机保存每张导出的图片、检测到的区块以及你的选择,用于训练以后的模型。不会上传任何内容。';

  @override
  String collectStats(int count, String size) {
    return '$count 张图片 · $size';
  }

  @override
  String get collectDelete => '删除已收集的数据';

  @override
  String get collectDeleteConfirm => '从本机删除所有已收集的图片和选择?';

  @override
  String get delete => '删除';

  @override
  String collectFailed(String error) {
    return '无法保存训练数据:$error';
  }

  @override
  String labelsSaved(int count) {
    return '已保存 $count 张图片的标注';
  }

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
  String annotateOf(int index, int total) {
    return '标注 $index / $total';
  }

  @override
  String get suggestions => '建议';

  @override
  String get skip => '跳过';

  @override
  String get nothingPrivate => '本张没有隐私';

  @override
  String get next => '下一张';

  @override
  String get annotateHint => '点文字行建框,或拖动画框';

  @override
  String get annotationData => '标注数据';

  @override
  String get statLabeled => '已标注';

  @override
  String get statEmpty => '无隐私';

  @override
  String get statSkipped => '跳过';

  @override
  String get boxesPerClass => '各类别框数';

  @override
  String get imagesHeader => '图片';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个框',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => '导出全部';

  @override
  String get deleteAll => '全部删除';

  @override
  String get annotateDeleteConfirm => '从本机删除所有标注及其图片?';

  @override
  String get noAnnotations => '还没有标注。选中图片后点“标注”。';

  @override
  String get filterScreenshots => '截图';

  @override
  String get filterAll => '全部';

  @override
  String get filterVideos => '视频';

  @override
  String get albums => '相册';

  @override
  String get limitedAccess => '只允许访问部分照片';

  @override
  String get manage => '管理';

  @override
  String selectedImages(int count) {
    return '已选 $count 张';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '打码 $count 张',
    );
    return '$_temp0';
  }

  @override
  String get annotate => '标注';

  @override
  String get badgeRedacted => '已打码';

  @override
  String get badgeAnnotated => '已标注';

  @override
  String get photosDenied => '码住 需要访问照片才能在这里显示。照片不会离开这台设备。';

  @override
  String get openSettings => '打开设置';

  @override
  String get openFiles => '打开文件';

  @override
  String get noPhotos => '这里没有照片';

  @override
  String get loading => '正在加载…';

  @override
  String get appearance => '外观';

  @override
  String get theme => '主题';

  @override
  String get appIcon => '应用图标';

  @override
  String get aspectRatioGrid => '按原始比例显示';

  @override
  String get modelDownloadFailed => '模型下载失败';

  @override
  String get retry => '重试';

  @override
  String get autoUpdateModel => '自动更新模型';

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
  String get localOnly => '只存在本机,不进 iCloud 和备份。';

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
  String get mergeHint => '点另一个框,与选中的框合并为同一个值';

  @override
  String get classOrganization => '组织名称';

  @override
  String get classDeviceId => '设备标识';

  @override
  String get classSecret => '密码与密钥';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total selected';
  }

  @override
  String get fillStyle => 'Fill style';

  @override
  String get colour => 'Colour';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images images',
      one: '1 image',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions regions',
      one: '1 region',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Share';

  @override
  String get saveToPhotos => 'Save to Photos';

  @override
  String get saveAs => 'Save…';

  @override
  String get saveAndDeleteOriginals => 'Save and delete originals';

  @override
  String get originalsToRecentlyDeleted => 'Originals go to Recently Deleted';

  @override
  String get originalsToTrash => 'Originals go to the trash';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportSize => 'Size';

  @override
  String get sizeOriginal => 'Original';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $count images to Photos',
      one: 'Saved 1 image to Photos',
    );
    return '$_temp0';
  }

  @override
  String originalsNotDeleted(String error) {
    return 'The originals were kept: $error';
  }

  @override
  String get selectAll => 'All';

  @override
  String get selectNone => 'None';

  @override
  String get suggested => 'suggested';

  @override
  String scoreValue(String score) {
    return 'Score $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'After redaction, the check still found these areas in the output of image $index.';
  }

  @override
  String get reasonNotSelected => 'not selected';

  @override
  String get reasonBoxTooSmall => 'box too small';

  @override
  String get reasonFillShowsThrough => 'fill shows through';

  @override
  String get introTitle => 'Choose screenshots to redact';

  @override
  String get introBody =>
      'MosaicIt lists your screenshots here so you can pick the ones to redact. Detection runs on this device, and images never leave it.';

  @override
  String get allowPhotoAccess => 'Allow photo access';

  @override
  String get photosOffTitle => 'Photo access is off';

  @override
  String get openSource => 'Open source';

  @override
  String get downloadingDetector => 'Downloading the detector';

  @override
  String percent(int value) {
    return '$value%';
  }
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
  String get reviewButton => '檢視';

  @override
  String get openingLabels => '開啟標籤中…';

  @override
  String noImagesIn(String name) {
    return '$name 中沒有圖片';
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
  String get reviewPseudoLabels => '檢視偽標籤（包含 coco.json 的資料夾）';

  @override
  String get regionsTooltip => '區域';

  @override
  String get notCalibrated => '模型未校準：預選使用固定閾值。';

  @override
  String calibratedUnverified(String domain) {
    return '已針對未驗證資料 ($domain) 進行校準：召回率保證尚未生效。';
  }

  @override
  String calibratedFor(String domain) {
    return '已針對 $domain 圖片進行校準。其他類型的圖片不在保證範圍內。';
  }

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
  String get verifyNext => '驗證並下一項';

  @override
  String get export => '匯出';

  @override
  String get pickOneModel => '請精確選擇一個 .onnx 模型';

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
  String noLabelsIn(String name) {
    return '$name 中沒有 coco.json';
  }

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
  String get collectTitle => '收集訓練資料';

  @override
  String get collectSubtitle => '在本機保存每張匯出的圖片、偵測到的區塊以及你的選擇,用於訓練日後的模型。不會上傳任何內容。';

  @override
  String collectStats(int count, String size) {
    return '$count 張圖片 · $size';
  }

  @override
  String get collectDelete => '刪除已收集的資料';

  @override
  String get collectDeleteConfirm => '要從本機刪除所有已收集的圖片和選擇嗎?';

  @override
  String get delete => '刪除';

  @override
  String collectFailed(String error) {
    return '無法保存訓練資料:$error';
  }

  @override
  String labelsSaved(int count) {
    return '已儲存 $count 張圖片的標註';
  }

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
  String annotateOf(int index, int total) {
    return '標註 $index / $total';
  }

  @override
  String get suggestions => '建議';

  @override
  String get skip => '略過';

  @override
  String get nothingPrivate => '無隱私資訊';

  @override
  String get next => '下一張';

  @override
  String get annotateHint => '輕點文字行以框選，或拖曳以繪製';

  @override
  String get annotationData => '標註資料';

  @override
  String get statLabeled => '已標註';

  @override
  String get statEmpty => '無隱私資訊';

  @override
  String get statSkipped => '已略過';

  @override
  String get boxesPerClass => '各類別選取框數';

  @override
  String get imagesHeader => '影像';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個選取框',
      one: '1 個選取框',
      zero: '0 個選取框',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => '全部匯出';

  @override
  String get deleteAll => '全部刪除';

  @override
  String get annotateDeleteConfirm => '要從此裝置刪除所有標註及其影像嗎？';

  @override
  String get noAnnotations => '尚無標註。請選取影像並選擇「標註」。';

  @override
  String get filterScreenshots => '螢幕截圖';

  @override
  String get filterAll => '全部';

  @override
  String get filterVideos => '影片';

  @override
  String get albums => '相簿';

  @override
  String get limitedAccess => '碼住 只能看到部分照片';

  @override
  String get manage => '管理';

  @override
  String selectedImages(int count) {
    return '已選取 $count 張';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '遮蔽 $count 張影像',
      one: '遮蔽 1 張影像',
      zero: '遮蔽 0 張影像',
    );
    return '$_temp0';
  }

  @override
  String get annotate => '標註';

  @override
  String get badgeRedacted => '已遮蔽';

  @override
  String get badgeAnnotated => '已標註';

  @override
  String get photosDenied => '碼住 需要存取您的照片才能在此顯示。照片絕不會離開此裝置。';

  @override
  String get openSettings => '開啟設定';

  @override
  String get openFiles => '開啟檔案';

  @override
  String get noPhotos => '此處沒有照片';

  @override
  String get loading => '載入中…';

  @override
  String get appearance => '外觀';

  @override
  String get theme => '主題';

  @override
  String get appIcon => 'App 圖像';

  @override
  String get aspectRatioGrid => '以原始比例顯示';

  @override
  String get modelDownloadFailed => '模型下載失敗';

  @override
  String get retry => '重試';

  @override
  String get autoUpdateModel => '自動更新模型';

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
  String get localOnly => '僅保留在此裝置上，絕不會儲存在 iCloud 或備份中。';

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
}

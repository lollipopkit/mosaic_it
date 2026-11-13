// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'モデルを読み込み中…';

  @override
  String get modelFileType => 'モデル';

  @override
  String get useModel => 'モデルを使用';

  @override
  String get imagesFileType => '画像';

  @override
  String get detecting => '検出中…';

  @override
  String detectingProgress(int current, int total) {
    return '$current/$total 検出中…';
  }

  @override
  String get chooseModelFirst => '先にモデルを選択してください';

  @override
  String get findingSimilar => '類似を検索中…';

  @override
  String similarSelected(int found, int added) {
    return '$found 件の類似領域を選択しました（新規 $added 件）';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$images 枚の画像にまたがり、$found 件の類似領域を選択しました（新規 $added 件）';
  }

  @override
  String get reviewButton => '確認';

  @override
  String get openingLabels => 'ラベルを開いています…';

  @override
  String noImagesIn(String name) {
    return '$name に画像がありません';
  }

  @override
  String get saving => '保存中…';

  @override
  String get exportHere => 'ここにエクスポート';

  @override
  String exportStoppedAt(String name) {
    return '$name でエクスポートが停止しました';
  }

  @override
  String exportedTo(String path) {
    return '$path にエクスポートしました';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path にエクスポートしました（音声なし）';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '画像を $count 枚エクスポートしました',
      one: '画像を 1 枚エクスポートしました',
      zero: '画像をエクスポートしませんでした',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name を確認中…';
  }

  @override
  String get checkingAndExporting => '確認してエクスポート中…';

  @override
  String get cancel => 'キャンセル';

  @override
  String get exportAnyway => 'それでもエクスポート';

  @override
  String get reviewPseudoLabels => '疑似ラベルを確認（coco.jsonを含むフォルダ）';

  @override
  String get regionsTooltip => '領域';

  @override
  String get notCalibrated => 'モデルはキャリブレーションされていません: 事前選択には固定しきい値が使用されます。';

  @override
  String calibratedUnverified(String domain) {
    return '未検証データ ($domain) でキャリブレーションされました: 再現率の保証はまだ適用されません。';
  }

  @override
  String calibratedFor(String domain) {
    return '$domain 画像用にキャリブレーションされました。他の種類の画像は保証の対象外です。';
  }

  @override
  String get cameraPhoto =>
      'これはカメラ写真です。検出器はスクリーンショット用に作られているため、ここでのボックスは信頼できません。';

  @override
  String get modeDraw => '描画';

  @override
  String get fillLabel => '塗りつぶし';

  @override
  String get fillSolid => '単色';

  @override
  String get fillBlocks => 'グレーのモザイク';

  @override
  String get fillNoise => 'ノイズ';

  @override
  String get verifyNext => '検証して次へ';

  @override
  String get export => 'エクスポート';

  @override
  String get pickOneModel => '.onnx モデルをちょうど 1 つ選択してください';

  @override
  String pickSidecar(String name) {
    return '$name.json も選択してください';
  }

  @override
  String get analysing => '解析中';

  @override
  String get followingRegion => '領域を追跡中';

  @override
  String get exporting => 'エクスポート中';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count フレーム';
  }

  @override
  String redactingSpan(String start, String end) {
    return '$start – $end を編集しています';
  }

  @override
  String exportCheckFailedAt(String time) {
    return '$time でエクスポート確認に失敗しました';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'そこに個人情報が含まれている可能性のある領域が $count 件まだ表示されています ($classes)。',
      one: 'そこに個人情報が含まれている可能性のある領域が 1 件まだ表示されています ($classes)。',
      zero: 'そこに個人情報が含まれている可能性のある領域はありません。',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'フレームを表示';

  @override
  String get drawMissedRegion => '検出器が見逃した領域を描画する';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$total トラック中 $on トラックを編集済み · $keyframes キーフレーム';
  }

  @override
  String get keepAudio => '音声を保持';

  @override
  String get keepAudioHint => '音声や通知音はチェックされません';

  @override
  String get goToFirstAppearance => '初出に移動';

  @override
  String get classPersonName => '氏名';

  @override
  String get classAddress => '住所';

  @override
  String get classPhone => '電話番号';

  @override
  String get classEmail => 'メールアドレス';

  @override
  String get classIdNumber => 'ID番号';

  @override
  String get classBankCard => '銀行カード';

  @override
  String get classPlate => 'ナンバープレート';

  @override
  String get classAccountId => 'アカウント';

  @override
  String get classAvatar => 'アバター';

  @override
  String get classFace => '顔';

  @override
  String get classQr => 'QRコード';

  @override
  String get classBarcode => 'バーコード';

  @override
  String get classManual => '手動';

  @override
  String noLabelsIn(String name) {
    return '$nameにcoco.jsonがありません';
  }

  @override
  String savedModelFailed(String error) {
    return '保存されたモデルを読み込めませんでした。再度モデルを選択してください。（$error）';
  }

  @override
  String get fillSurround => '背景色';

  @override
  String get fillTinted => 'カラーモザイク';

  @override
  String get settings => '設定';

  @override
  String get classFinance => '金額';

  @override
  String get collectTitle => '学習データを収集';

  @override
  String get collectSubtitle =>
      '書き出した画像、検出された領域、あなたの選択をこの端末に保存し、今後のモデルの学習に使います。何もアップロードされません。';

  @override
  String collectStats(int count, String size) {
    return '$count 枚の画像 · $size';
  }

  @override
  String get collectDelete => '収集したデータを削除';

  @override
  String get collectDeleteConfirm => '収集した画像と選択をすべてこの端末から削除しますか?';

  @override
  String get delete => '削除';

  @override
  String collectFailed(String error) {
    return '学習データを保存できませんでした: $error';
  }

  @override
  String labelsSaved(int count) {
    return '$count 枚の画像のラベルを保存しました';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get redo => 'やり直す';

  @override
  String get similar => '類似';

  @override
  String get thisImage => 'この画像';

  @override
  String allImagesCount(int count) {
    return 'すべての$count画像';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の領域がまだ読める可能性があります',
      one: '1件の領域がまだ読める可能性があります',
      zero: '0件の領域がまだ読める可能性があります',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody => '編集後、チェックで出力内にこれらの領域がまだ検出されました。';

  @override
  String get redactThemAndExport => 'これらも編集してエクスポート';

  @override
  String get showThem => '表示する';

  @override
  String get pickClass => 'クラスを選択';

  @override
  String annotateOf(int index, int total) {
    return 'アノテーション $index / $total';
  }

  @override
  String get suggestions => '提案';

  @override
  String get skip => 'スキップ';

  @override
  String get nothingPrivate => '個人情報はなし';

  @override
  String get next => '次へ';

  @override
  String get annotateHint => 'テキスト行をタップしてボックスを作成するか、ドラッグして描画';

  @override
  String get annotationData => 'アノテーションデータ';

  @override
  String get statLabeled => 'ラベル済み';

  @override
  String get statEmpty => '個人情報はなし';

  @override
  String get statSkipped => 'スキップ済み';

  @override
  String get boxesPerClass => 'クラス別のボックス数';

  @override
  String get imagesHeader => '画像';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のボックス',
      one: '1個のボックス',
      zero: '0個のボックス',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'すべてエクスポート';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String get annotateDeleteConfirm => 'このデバイスからすべてのアノテーションとその画像を削除しますか？';

  @override
  String get noAnnotations => 'まだアノテーションがありません。画像を選択して「アノテーション」を選択してください。';

  @override
  String get filterScreenshots => 'スクリーンショット';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterVideos => '動画';

  @override
  String get albums => 'アルバム';

  @override
  String get limitedAccess => 'MosaicItは一部の写真のみを表示できます';

  @override
  String get manage => '管理';

  @override
  String selectedImages(int count) {
    return '$count件選択中';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の画像をマスク',
      one: '1件の画像をマスク',
      zero: '0件の画像をマスク',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'アノテーション';

  @override
  String get badgeRedacted => '編集済み';

  @override
  String get badgeAnnotated => 'アノテーション済み';

  @override
  String get photosDenied =>
      'MosaicItはここに写真を表示するために写真へのアクセスが必要です。写真は決してこのデバイスから送信されません。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get openFiles => 'ファイルを開く';

  @override
  String get noPhotos => 'ここに写真はありません';

  @override
  String get loading => '読み込み中…';

  @override
  String get appearance => '外観';

  @override
  String get theme => 'テーマ';

  @override
  String get appIcon => 'アプリアイコン';

  @override
  String get aspectRatioGrid => 'アスペクト比グリッド';

  @override
  String get modelDownloadFailed => 'モデルをダウンロードできませんでした';

  @override
  String get retry => '再試行';

  @override
  String get autoUpdateModel => 'モデルを自動更新';

  @override
  String get threshold => 'しきい値';

  @override
  String get thresholdLow => '低';

  @override
  String get thresholdMedium => '中';

  @override
  String get thresholdHigh => '高';

  @override
  String get redaction => '編集';

  @override
  String get style => 'スタイル';

  @override
  String get selectedByDefault => 'デフォルトで選択';

  @override
  String get dataPrivacy => 'データとプライバシー';

  @override
  String get localOnly => 'このデバイスにのみ保存され、iCloudやバックアップには保存されません。';

  @override
  String get model => 'モデル';

  @override
  String get importModel => '別のモデルをインポート';

  @override
  String get advanced => '詳細';

  @override
  String get about => '情報';

  @override
  String get licenses => 'オープンソースライセンス';

  @override
  String get merge => '結合';

  @override
  String get split => '分割';

  @override
  String get mergeHint => '同じ値の一部にするには、別のボックスをタップしてください';

  @override
  String get classOrganization => '団体名';

  @override
  String get classDeviceId => 'デバイスID';

  @override
  String get classSecret => '認証情報';
}

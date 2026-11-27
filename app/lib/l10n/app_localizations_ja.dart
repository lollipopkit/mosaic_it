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
  String get regionsTooltip => '領域';

  @override
  String get cameraPhoto =>
      'これはカメラ写真です。検出器はスクリーンショット用に作られているため、ここでのボックスは信頼できません。';

  @override
  String get modeDraw => '描画';

  @override
  String get fillSolid => '単色';

  @override
  String get fillBlocks => 'グレーのモザイク';

  @override
  String get fillNoise => 'ノイズ';

  @override
  String get export => 'エクスポート';

  @override
  String pickOneModel(String formats) {
    return '$formats モデルをちょうど 1 つ選択してください';
  }

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
  String get delete => '削除';

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
    return '全 $count 枚の画像';
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
  String get appearance => '外観';

  @override
  String get theme => 'テーマ';

  @override
  String get appIcon => 'アプリアイコン';

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

  @override
  String get classPerson => '人物';

  @override
  String get classHealth => '健康';

  @override
  String get classPersonalInfo => '個人情報';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total 選択中';
  }

  @override
  String get fillStyle => '塗りつぶしスタイル';

  @override
  String get colour => '色';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images 枚の画像',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions 件の領域',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => '共有';

  @override
  String get saveToPhotos => '写真に保存';

  @override
  String get saveAs => '保存…';

  @override
  String get exportFormat => '形式';

  @override
  String get exportSize => 'サイズ';

  @override
  String get sizeOriginal => 'オリジナル';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 枚の画像を写真に保存しました',
      one: '1 枚の画像を写真に保存しました',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'すべて';

  @override
  String get selectNone => 'なし';

  @override
  String get suggested => '候補';

  @override
  String scoreValue(String score) {
    return 'スコア $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return '処理後のチェックで、画像 $index の出力内にこれらの領域がまだ検出されました。';
  }

  @override
  String get reasonNotSelected => '未選択';

  @override
  String get reasonBoxTooSmall => 'ボックスが小さすぎます';

  @override
  String get reasonFillShowsThrough => '塗りつぶしが透けています';

  @override
  String get openSource => 'オープンソース';

  @override
  String get adaptivePreselectTitle => '端末内での適応的な自動選択';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count クラスを調整済み',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'ローカル設定をリセット';

  @override
  String get adaptiveResetDone => 'ローカル設定をリセットしました';

  @override
  String get feedbackTitle => '検出の問題を報告';

  @override
  String get feedbackShort => 'フィードバック';

  @override
  String get feedbackMenu => '問題を報告';

  @override
  String get feedbackAction => '報告';

  @override
  String get feedbackAttachScreenshot => 'スクリーンショットを添付';

  @override
  String get feedbackModeMasked => '誤検出箇所のみ';

  @override
  String get feedbackModeFull => '画像全体';

  @override
  String get feedbackModeText => '画像なし';

  @override
  String get feedbackTagMissed => '見逃し';

  @override
  String get feedbackTagFalsePositive => '誤検出';

  @override
  String get feedbackTagBoxDrift => '枠のずれ';

  @override
  String get feedbackTagWrongClass => 'クラス違い';

  @override
  String get feedbackTagOther => 'その他';

  @override
  String get feedbackNoteHint => 'メモ（任意）…';

  @override
  String feedbackCountMasked(int count) {
    return 'マスク済み $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return '見逃し $count';
  }

  @override
  String feedbackCountFp(int count) {
    return '誤検出 $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return '未選択 $count';
  }

  @override
  String get feedbackBoxMissed => '見逃し';

  @override
  String get feedbackBoxMissedMasked => '見逃し · マスク済み';

  @override
  String get feedbackBoxFp => '誤検出';

  @override
  String get feedbackBoxPreference => '表示のまま';

  @override
  String get introOfflineTitle => 'ネットワーク機能なし';

  @override
  String get introOfflineBody =>
      'MosaicIt には通信コードがなく、ネットワーク権限も要求しません。検出モデルはアプリに内蔵されており、画像は端末外に送信されません。';

  @override
  String get introNoNetPermTitle => 'ネットワーク権限ゼロ';

  @override
  String get introBundledModelTitle => '内蔵オンデバイスモデル';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · 端末内蔵';
  }

  @override
  String get resetBundledModel => '内蔵モデルに戻す';

  @override
  String get reviewIntro => 'イントロをもう一度見る';

  @override
  String get feedbackOpenWeb => 'ブラウザで送信';

  @override
  String get introNoNetPermBodyIos => '通信なし・端末内のみで処理';

  @override
  String get introNoNetPermBodyAndroid => 'INTERNET 権限を未宣言';

  @override
  String get introNoNetPermBodyDesktop => 'サンドボックスに通信権限なし';

  @override
  String get customModel => 'カスタムモデル';

  @override
  String modelClassCount(int count) {
    return '$count クラス';
  }

  @override
  String get copyImage => '画像をコピー';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get copyFailed => '画像をコピーできませんでした';

  @override
  String get peekOriginal => '長押しで元の画像を表示';

  @override
  String get selectMedia => '写真を選択';

  @override
  String get saveFailed => '写真に保存できませんでした';

  @override
  String get retry => '再試行';

  @override
  String get iosWirelessPromptTitle => 'ワイヤレスデータの確認について';

  @override
  String get iosWirelessPromptBody =>
      'システムの写真ピッカーを開くと、iCloud サムネイルの表示により iOS のワイヤレスデータ確認が表示されることがあります。MosaicIt は通信を行わないため「許可しない」を選択してください。';

  @override
  String get continueAction => '続ける';
}

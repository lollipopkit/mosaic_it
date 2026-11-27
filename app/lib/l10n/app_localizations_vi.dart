// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Đang tải mô hình…';

  @override
  String get modelFileType => 'Mô hình';

  @override
  String get useModel => 'Sử dụng mô hình';

  @override
  String get imagesFileType => 'Hình ảnh';

  @override
  String get detecting => 'Đang phát hiện…';

  @override
  String detectingProgress(int current, int total) {
    return 'Đang phát hiện $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Hãy chọn một mô hình trước';

  @override
  String get findingSimilar => 'Đang tìm kiếm tương tự…';

  @override
  String similarSelected(int found, int added) {
    return 'Đã chọn $found vùng tương tự ($added mới)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Đã chọn $found vùng tương tự ($added mới) trong $images hình ảnh';
  }

  @override
  String get saving => 'Đang lưu…';

  @override
  String get exportHere => 'Xuất tại đây';

  @override
  String exportStoppedAt(String name) {
    return 'Xuất bị dừng tại $name';
  }

  @override
  String exportedTo(String path) {
    return 'Đã xuất đến $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Đã xuất đến $path (không có âm thanh)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã xuất $count hình ảnh',
      one: 'Đã xuất 1 hình ảnh',
      zero: 'Đã xuất 0 hình ảnh',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Đang kiểm tra $name…';
  }

  @override
  String get checkingAndExporting => 'Đang kiểm tra và xuất…';

  @override
  String get cancel => 'Hủy';

  @override
  String get exportAnyway => 'Vẫn xuất';

  @override
  String get regionsTooltip => 'Các vùng';

  @override
  String get cameraPhoto =>
      'Đây là ảnh chụp bằng máy ảnh; bộ phát hiện được thiết kế cho ảnh chụp màn hình, nên các khung ở đây không đáng tin cậy.';

  @override
  String get modeDraw => 'Vẽ';

  @override
  String get fillSolid => 'Màu đơn sắc';

  @override
  String get fillBlocks => 'Khảm xám';

  @override
  String get fillNoise => 'Nhiễu';

  @override
  String get export => 'Xuất';

  @override
  String pickOneModel(String formats) {
    return 'Chọn đúng một mô hình $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Cũng chọn $name.json';
  }

  @override
  String get analysing => 'Đang phân tích';

  @override
  String get followingRegion => 'Đang theo dõi vùng';

  @override
  String get exporting => 'Đang xuất';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count khung hình';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Đang che $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Kiểm tra xuất thất bại tại $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vùng có vẻ riêng tư vẫn hiển thị ở đó ($classes).',
      one: '1 vùng có vẻ riêng tư vẫn hiển thị ở đó ($classes).',
      zero: '0 vùng có vẻ riêng tư vẫn hiển thị ở đó ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Hiển thị khung hình';

  @override
  String get drawMissedRegion => 'Vẽ một vùng mà bộ phát hiện đã bỏ sót';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on trong số $total đường theo dõi đã được che · $keyframes khung hình chính';
  }

  @override
  String get keepAudio => 'Giữ âm thanh';

  @override
  String get keepAudioHint =>
      'Giọng nói và âm thanh thông báo không được kiểm tra';

  @override
  String get goToFirstAppearance => 'Đi đến lần xuất hiện đầu tiên';

  @override
  String get classPersonName => 'Tên';

  @override
  String get classAddress => 'Địa chỉ';

  @override
  String get classPhone => 'Điện thoại';

  @override
  String get classEmail => 'Email';

  @override
  String get classIdNumber => 'Số định danh';

  @override
  String get classBankCard => 'Thẻ ngân hàng';

  @override
  String get classPlate => 'Biển số';

  @override
  String get classAccountId => 'Tài khoản';

  @override
  String get classAvatar => 'Ảnh đại diện';

  @override
  String get classFace => 'Khuôn mặt';

  @override
  String get classQr => 'Mã QR';

  @override
  String get classBarcode => 'Mã vạch';

  @override
  String get classManual => 'Thủ công';

  @override
  String savedModelFailed(String error) {
    return 'Không thể tải mô hình đã lưu; hãy chọn mô hình khác. ($error)';
  }

  @override
  String get fillSurround => 'Màu nền';

  @override
  String get fillTinted => 'Khảm màu';

  @override
  String get settings => 'Cài đặt';

  @override
  String get classFinance => 'Số tiền';

  @override
  String get delete => 'Xóa';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get redo => 'Làm lại';

  @override
  String get similar => 'Tương tự';

  @override
  String get thisImage => 'Ảnh này';

  @override
  String allImagesCount(int count) {
    return 'Tất cả $count ảnh';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vùng có thể vẫn đọc được',
      many: 'nhiều vùng có thể vẫn đọc được',
      few: 'vài vùng có thể vẫn đọc được',
      two: '2 vùng có thể vẫn đọc được',
      one: '1 vùng có thể vẫn đọc được',
      zero: '0 vùng có thể vẫn đọc được',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Sau khi che, kiểm tra vẫn tìm thấy các vùng này trong kết quả xuất.';

  @override
  String get redactThemAndExport => 'Che chúng và xuất';

  @override
  String get showThem => 'Hiển thị chúng';

  @override
  String get pickClass => 'Chọn một lớp';

  @override
  String get appearance => 'Giao diện';

  @override
  String get theme => 'Giao diện';

  @override
  String get appIcon => 'Biểu tượng ứng dụng';

  @override
  String get threshold => 'Ngưỡng';

  @override
  String get thresholdLow => 'Thấp';

  @override
  String get thresholdMedium => 'Vừa';

  @override
  String get thresholdHigh => 'Cao';

  @override
  String get redaction => 'Che thông tin';

  @override
  String get style => 'Phong cách';

  @override
  String get selectedByDefault => 'Chọn theo mặc định';

  @override
  String get dataPrivacy => 'Dữ liệu và quyền riêng tư';

  @override
  String get model => 'Mô hình';

  @override
  String get importModel => 'Nhập mô hình khác';

  @override
  String get advanced => 'Nâng cao';

  @override
  String get about => 'Giới thiệu';

  @override
  String get licenses => 'Giấy phép mã nguồn mở';

  @override
  String get merge => 'Gộp';

  @override
  String get split => 'Tách';

  @override
  String get mergeHint =>
      'Chạm vào một khung khác để nó trở thành một phần của cùng một giá trị';

  @override
  String get classOrganization => 'Tổ chức';

  @override
  String get classDeviceId => 'Mã thiết bị';

  @override
  String get classSecret => 'Thông tin bí mật';

  @override
  String get classPerson => 'Người';

  @override
  String get classHealth => 'Sức khỏe';

  @override
  String get classPersonalInfo => 'Thông tin cá nhân';

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
  String get openSource => 'Open source';

  @override
  String get adaptivePreselectTitle => 'Local adaptive pre-selection';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes adjusted',
      one: '1 class adjusted',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Reset local preferences';

  @override
  String get adaptiveResetDone => 'Local preferences reset';

  @override
  String get feedbackTitle => 'Report detection issue';

  @override
  String get feedbackShort => 'Feedback';

  @override
  String get feedbackMenu => 'Report issue';

  @override
  String get feedbackAction => 'Report';

  @override
  String get feedbackAttachScreenshot => 'Attach screenshot';

  @override
  String get feedbackModeMasked => 'Errors only';

  @override
  String get feedbackModeFull => 'Full image';

  @override
  String get feedbackModeText => 'No image';

  @override
  String get feedbackTagMissed => 'Missed';

  @override
  String get feedbackTagFalsePositive => 'False positive';

  @override
  String get feedbackTagBoxDrift => 'Box drift';

  @override
  String get feedbackTagWrongClass => 'Wrong class';

  @override
  String get feedbackTagOther => 'Other';

  @override
  String get feedbackNoteHint => 'Optional note…';

  @override
  String feedbackCountMasked(int count) {
    return 'Masked $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Missed $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'False positive $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Unchecked $count';
  }

  @override
  String get feedbackBoxMissed => 'Missed';

  @override
  String get feedbackBoxMissedMasked => 'Missed · masked';

  @override
  String get feedbackBoxFp => 'False positive';

  @override
  String get feedbackBoxPreference => 'Keep visible';

  @override
  String get introOfflineTitle => 'No network access';

  @override
  String get introOfflineBody =>
      'MosaicIt contains no networking code and requests no network permission. The detector is bundled inside the app, and images and videos never leave your device.';

  @override
  String get introNoNetPermTitle => 'Zero network permissions';

  @override
  String get introBundledModelTitle => 'Bundled on-device model';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · on-device';
  }

  @override
  String get resetBundledModel => 'Use bundled model';

  @override
  String get reviewIntro => 'Show intro again';

  @override
  String get feedbackOpenWeb => 'Open web form';

  @override
  String get introNoNetPermBodyIos => 'No network requests · on-device only';

  @override
  String get introNoNetPermBodyAndroid => 'No INTERNET permission declared';

  @override
  String get introNoNetPermBodyDesktop => 'No network entitlement in sandbox';

  @override
  String get customModel => 'Custom model';

  @override
  String modelClassCount(int count) {
    return '$count classes';
  }

  @override
  String get copyImage => 'Copy image';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copyFailed => 'Could not copy image';

  @override
  String get peekOriginal => 'Hold to compare original';

  @override
  String get selectMedia => 'Select photos or video';

  @override
  String get saveFailed => 'Could not save to Photos';

  @override
  String get retry => 'Retry';

  @override
  String get iosWirelessPromptTitle => 'Wireless data prompt';

  @override
  String get iosWirelessPromptBody =>
      'Opening the system photo picker may trigger an iOS wireless data prompt for iCloud thumbnails. MosaicIt does not use the network — tap “Don’t Allow”.';

  @override
  String get continueAction => 'Continue';
}

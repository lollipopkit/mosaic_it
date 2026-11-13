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
  String get reviewButton => 'Xem xét';

  @override
  String get openingLabels => 'Đang mở nhãn…';

  @override
  String noImagesIn(String name) {
    return 'Không có hình ảnh trong $name';
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
  String get reviewPseudoLabels => 'Xem lại nhãn giả (thư mục có coco.json)';

  @override
  String get regionsTooltip => 'Các vùng';

  @override
  String get notCalibrated =>
      'Mô hình chưa được hiệu chuẩn: việc chọn trước sử dụng ngưỡng cố định.';

  @override
  String calibratedUnverified(String domain) {
    return 'Đã hiệu chuẩn trên dữ liệu chưa xác minh ($domain): cam kết độ nhạy chưa áp dụng.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Đã hiệu chuẩn cho hình ảnh $domain. Các loại hình ảnh khác nằm ngoài phạm vi cam kết.';
  }

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
  String get verifyNext => 'Xác minh & tiếp theo';

  @override
  String get export => 'Xuất';

  @override
  String get pickOneModel => 'Chọn đúng một mô hình .onnx';

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
  String noLabelsIn(String name) {
    return 'Không có coco.json trong $name';
  }

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
  String get collectTitle => 'Thu thập dữ liệu huấn luyện';

  @override
  String get collectSubtitle =>
      'Lưu trên thiết bị này mỗi ảnh đã xuất, các vùng được phát hiện và lựa chọn của bạn để huấn luyện các mô hình sau này. Không có gì được tải lên.';

  @override
  String collectStats(int count, String size) {
    return '$count ảnh · $size';
  }

  @override
  String get collectDelete => 'Xóa dữ liệu đã thu thập';

  @override
  String get collectDeleteConfirm =>
      'Xóa tất cả ảnh và lựa chọn đã thu thập khỏi thiết bị này?';

  @override
  String get delete => 'Xóa';

  @override
  String collectFailed(String error) {
    return 'Không thể lưu dữ liệu huấn luyện: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Đã lưu nhãn cho $count ảnh';
  }

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
  String annotateOf(int index, int total) {
    return 'Ghi chú $index / $total';
  }

  @override
  String get suggestions => 'Gợi ý';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get nothingPrivate => 'Không có thông tin riêng tư';

  @override
  String get next => 'Tiếp theo';

  @override
  String get annotateHint =>
      'Chạm vào một dòng văn bản để tạo khung, hoặc kéo để vẽ';

  @override
  String get annotationData => 'Dữ liệu ghi chú';

  @override
  String get statLabeled => 'Đã gán nhãn';

  @override
  String get statEmpty => 'Không có thông tin riêng tư';

  @override
  String get statSkipped => 'Đã bỏ qua';

  @override
  String get boxesPerClass => 'Số khung theo lớp';

  @override
  String get imagesHeader => 'Ảnh';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khung',
      many: 'nhiều khung',
      few: 'vài khung',
      two: '2 khung',
      one: '1 khung',
      zero: '0 khung',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Xuất tất cả';

  @override
  String get deleteAll => 'Xóa tất cả';

  @override
  String get annotateDeleteConfirm =>
      'Xóa tất cả ghi chú và ảnh của chúng khỏi thiết bị này?';

  @override
  String get noAnnotations => 'Chưa có ghi chú nào. Chọn ảnh và chọn Ghi chú.';

  @override
  String get filterScreenshots => 'Ảnh chụp màn hình';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterVideos => 'Video';

  @override
  String get albums => 'Album';

  @override
  String get limitedAccess => 'MosaicIt chỉ có thể xem một số ảnh của bạn';

  @override
  String get manage => 'Quản lý';

  @override
  String selectedImages(int count) {
    return 'Đã chọn $count';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Che $count ảnh',
      many: 'Che nhiều ảnh',
      few: 'Che vài ảnh',
      two: 'Che 2 ảnh',
      one: 'Che 1 ảnh',
      zero: 'Che 0 ảnh',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Ghi chú';

  @override
  String get badgeRedacted => 'Đã che';

  @override
  String get badgeAnnotated => 'Đã ghi chú';

  @override
  String get photosDenied =>
      'MosaicIt cần quyền truy cập vào ảnh của bạn để hiển thị chúng ở đây. Ảnh không bao giờ rời khỏi thiết bị này.';

  @override
  String get openSettings => 'Mở Cài đặt';

  @override
  String get openFiles => 'Mở tệp';

  @override
  String get noPhotos => 'Không có ảnh ở đây';

  @override
  String get loading => 'Đang tải…';

  @override
  String get appearance => 'Giao diện';

  @override
  String get theme => 'Giao diện';

  @override
  String get appIcon => 'Biểu tượng ứng dụng';

  @override
  String get aspectRatioGrid => 'Lưới theo tỷ lệ gốc';

  @override
  String get modelDownloadFailed => 'Không thể tải mô hình';

  @override
  String get retry => 'Thử lại';

  @override
  String get autoUpdateModel => 'Tự động cập nhật mô hình';

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
  String get localOnly =>
      'Chỉ được giữ trên thiết bị này, không bao giờ trong iCloud hoặc bản sao lưu.';

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

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'กำลังโหลดโมเดล…';

  @override
  String get modelFileType => 'โมเดล';

  @override
  String get useModel => 'ใช้โมเดล';

  @override
  String get imagesFileType => 'รูปภาพ';

  @override
  String get detecting => 'กำลังตรวจจับ…';

  @override
  String detectingProgress(int current, int total) {
    return 'กำลังตรวจจับ $current/$total…';
  }

  @override
  String get chooseModelFirst => 'เลือกโมเดลก่อน';

  @override
  String get findingSimilar => 'กำลังค้นหาที่คล้ายกัน…';

  @override
  String similarSelected(int found, int added) {
    return 'เลือกพื้นที่ที่คล้ายกัน $found แห่ง (ใหม่ $added แห่ง)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'เลือกพื้นที่ที่คล้ายกัน $found แห่ง (ใหม่ $added แห่ง) ใน $images รูปภาพ';
  }

  @override
  String get saving => 'กำลังบันทึก…';

  @override
  String get exportHere => 'ส่งออกที่นี่';

  @override
  String exportStoppedAt(String name) {
    return 'การส่งออกหยุดที่ $name';
  }

  @override
  String exportedTo(String path) {
    return 'ส่งออกไปยัง $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'ส่งออกไปยัง $path (ไม่มีเสียง)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ส่งออก $count รูปภาพ',
      one: 'ส่งออก 1 รูปภาพ',
      zero: 'ส่งออก 0 รูปภาพ',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'กำลังตรวจสอบ $name…';
  }

  @override
  String get checkingAndExporting => 'กำลังตรวจสอบและส่งออก…';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get exportAnyway => 'ส่งออกอยู่ดี';

  @override
  String get regionsTooltip => 'พื้นที่';

  @override
  String get cameraPhoto =>
      'นี่คือภาพถ่ายจากกล้อง; ตัวตรวจจับถูกสร้างมาสำหรับภาพหน้าจอ ดังนั้นกล่องที่นี่จึงไม่น่าเชื่อถือ';

  @override
  String get modeDraw => 'วาด';

  @override
  String get fillSolid => 'สีทึบ';

  @override
  String get fillBlocks => 'โมเสกสีเทา';

  @override
  String get fillNoise => 'สัญญาณรบกวน';

  @override
  String get export => 'ส่งออก';

  @override
  String pickOneModel(String formats) {
    return 'เลือกโมเดล $formats พอดีหนึ่งตัว';
  }

  @override
  String pickSidecar(String name) {
    return 'เลือก $name.json ด้วย';
  }

  @override
  String get analysing => 'กำลังวิเคราะห์';

  @override
  String get followingRegion => 'กำลังติดตามพื้นที่';

  @override
  String get exporting => 'กำลังส่งออก';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count เฟรม';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'กำลังปิดบัง $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'การตรวจสอบการส่งออกล้มเหลวที่ $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'มีพื้นที่ที่ดูเหมือนข้อมูลส่วนตัว $count แห่งยังมองเห็นได้ที่นั่น ($classes)',
      one:
          'มีพื้นที่ที่ดูเหมือนข้อมูลส่วนตัว 1 แห่งยังมองเห็นได้ที่นั่น ($classes)',
      zero: 'ไม่มีพื้นที่ที่ดูเหมือนข้อมูลส่วนตัวเหลืออยู่ที่นั่น',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'แสดงเฟรม';

  @override
  String get drawMissedRegion => 'วาดพื้นที่ที่ตัวตรวจจับพลาด';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return 'ปิดบัง $on จาก $total การติดตาม · $keyframes เฟรมหลัก';
  }

  @override
  String get keepAudio => 'เก็บเสียง';

  @override
  String get keepAudioHint => 'เสียงพูดและเสียงแจ้งเตือนไม่ได้รับการตรวจสอบ';

  @override
  String get goToFirstAppearance => 'ไปที่การปรากฏตัวครั้งแรก';

  @override
  String get classPersonName => 'ชื่อ';

  @override
  String get classAddress => 'ที่อยู่';

  @override
  String get classPhone => 'โทรศัพท์';

  @override
  String get classEmail => 'อีเมล';

  @override
  String get classIdNumber => 'หมายเลขบัตรประชาชน';

  @override
  String get classBankCard => 'บัตรธนาคาร';

  @override
  String get classPlate => 'ป้ายทะเบียน';

  @override
  String get classAccountId => 'บัญชี';

  @override
  String get classAvatar => 'รูปโปรไฟล์';

  @override
  String get classFace => 'ใบหน้า';

  @override
  String get classQr => 'รหัส QR';

  @override
  String get classBarcode => 'บาร์โค้ด';

  @override
  String get classManual => 'ทำด้วยตนเอง';

  @override
  String savedModelFailed(String error) {
    return 'ไม่สามารถโหลดโมเดลที่บันทึกไว้ได้ กรุณาเลือกโมเดลอีกครั้ง ($error)';
  }

  @override
  String get fillSurround => 'สีพื้นหลัง';

  @override
  String get fillTinted => 'โมเสกสี';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get classFinance => 'จำนวนเงิน';

  @override
  String get delete => 'ลบ';

  @override
  String get undo => 'เลิกทำ';

  @override
  String get redo => 'ทำซ้ำ';

  @override
  String get similar => 'คล้ายกัน';

  @override
  String get thisImage => 'ภาพนี้';

  @override
  String allImagesCount(int count) {
    return 'ภาพทั้งหมด $count ภาพ';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count จุดอาจยังอ่านได้',
      many: 'หลายจุดอาจยังอ่านได้',
      few: 'หลายจุดอาจยังอ่านได้',
      two: '2 จุดอาจยังอ่านได้',
      one: '1 จุดอาจยังอ่านได้',
      zero: 'ไม่มีจุดที่อาจอ่านได้',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'หลังจากปิดบังแล้ว การตรวจสอบยังคงพบจุดเหล่านี้ในผลลัพธ์';

  @override
  String get redactThemAndExport => 'ปิดบังและส่งออก';

  @override
  String get showThem => 'แสดงจุดเหล่านี้';

  @override
  String get pickClass => 'เลือกประเภท';

  @override
  String get appearance => 'ลักษณะ';

  @override
  String get theme => 'ธีม';

  @override
  String get appIcon => 'ไอคอนแอป';

  @override
  String get threshold => 'เกณฑ์';

  @override
  String get thresholdLow => 'ต่ำ';

  @override
  String get thresholdMedium => 'กลาง';

  @override
  String get thresholdHigh => 'สูง';

  @override
  String get redaction => 'การปิดบัง';

  @override
  String get style => 'สไตล์';

  @override
  String get selectedByDefault => 'เลือกไว้ตามค่าเริ่มต้น';

  @override
  String get dataPrivacy => 'ข้อมูลและความเป็นส่วนตัว';

  @override
  String get model => 'โมเดล';

  @override
  String get importModel => 'นำเข้าโมเดลอื่น';

  @override
  String get advanced => 'ขั้นสูง';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get licenses => 'ใบอนุญาตโอเพนซอร์ส';

  @override
  String get merge => 'รวม';

  @override
  String get split => 'แยก';

  @override
  String get mergeHint => 'แตะกรอบอื่นเพื่อรวมเป็นส่วนหนึ่งของค่าเดียวกัน';

  @override
  String get classOrganization => 'องค์กร';

  @override
  String get classDeviceId => 'รหัสอุปกรณ์';

  @override
  String get classSecret => 'ข้อมูลลับ';

  @override
  String get classPerson => 'บุคคล';

  @override
  String get classHealth => 'สุขภาพ';

  @override
  String get classPersonalInfo => 'ข้อมูลส่วนตัว';

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

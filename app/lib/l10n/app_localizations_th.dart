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
  String get reviewButton => 'ตรวจสอบ';

  @override
  String get openingLabels => 'กำลังเปิดป้ายกำกับ…';

  @override
  String noImagesIn(String name) {
    return 'ไม่มีรูปภาพใน $name';
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
  String get reviewPseudoLabels =>
      'ตรวจสอบป้ายกำกับเทียม (โฟลเดอร์ที่มี coco.json)';

  @override
  String get regionsTooltip => 'พื้นที่';

  @override
  String get notCalibrated =>
      'โมเดลยังไม่ได้ปรับเทียบ: การเลือกก่อนหน้าใช้เกณฑ์คงที่';

  @override
  String calibratedUnverified(String domain) {
    return 'ปรับเทียบด้วยข้อมูลที่ยังไม่ได้รับการยืนยัน ($domain): การรับประกันการค้นหาคำตอบยังไม่ใช้';
  }

  @override
  String calibratedFor(String domain) {
    return 'ปรับเทียบสำหรับรูปภาพ $domain รูปภาพอื่น ๆ อยู่ภายนอกการรับประกัน';
  }

  @override
  String get cameraPhoto =>
      'นี่คือภาพถ่ายจากกล้อง; ตัวตรวจจับถูกสร้างมาสำหรับภาพหน้าจอ ดังนั้นกล่องที่นี่จึงไม่น่าเชื่อถือ';

  @override
  String get modeDraw => 'วาด';

  @override
  String get fillLabel => 'เติม';

  @override
  String get fillSolid => 'สีทึบ';

  @override
  String get fillBlocks => 'โมเสกสีเทา';

  @override
  String get fillNoise => 'สัญญาณรบกวน';

  @override
  String get verifyNext => 'ยืนยันและถัดไป';

  @override
  String get export => 'ส่งออก';

  @override
  String get pickOneModel => 'เลือกโมเดล .onnx พอดีหนึ่งตัว';

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
  String noLabelsIn(String name) {
    return 'ไม่มี coco.json ใน $name';
  }

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
  String get collectTitle => 'เก็บข้อมูลสำหรับฝึกโมเดล';

  @override
  String get collectSubtitle =>
      'เก็บรูปภาพที่ส่งออกแต่ละรูป พื้นที่ที่ตรวจพบ และตัวเลือกของคุณไว้ในอุปกรณ์นี้เพื่อใช้ฝึกโมเดลในอนาคต ไม่มีการอัปโหลดใดๆ';

  @override
  String collectStats(int count, String size) {
    return '$count รูป · $size';
  }

  @override
  String get collectDelete => 'ลบข้อมูลที่เก็บไว้';

  @override
  String get collectDeleteConfirm =>
      'ลบรูปภาพและตัวเลือกที่เก็บไว้ทั้งหมดออกจากอุปกรณ์นี้หรือไม่';

  @override
  String get delete => 'ลบ';

  @override
  String collectFailed(String error) {
    return 'บันทึกข้อมูลสำหรับฝึกโมเดลไม่ได้: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'บันทึกป้ายกำกับของ $count รูปแล้ว';
  }

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
  String annotateOf(int index, int total) {
    return 'ทำเครื่องหมาย $index / $total';
  }

  @override
  String get suggestions => 'คำแนะนำ';

  @override
  String get skip => 'ข้าม';

  @override
  String get nothingPrivate => 'ไม่มีข้อมูลส่วนตัว';

  @override
  String get next => 'ถัดไป';

  @override
  String get annotateHint =>
      'แตะที่บรรทัดข้อความเพื่อใส่กรอบ หรือลากเพื่อวาดกรอบ';

  @override
  String get annotationData => 'ข้อมูลการทำเครื่องหมาย';

  @override
  String get statLabeled => 'ทำเครื่องหมายแล้ว';

  @override
  String get statEmpty => 'ไม่มีข้อมูลส่วนตัว';

  @override
  String get statSkipped => 'ข้ามแล้ว';

  @override
  String get boxesPerClass => 'กรอบต่อประเภท';

  @override
  String get imagesHeader => 'รูปภาพ';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count กรอบ',
      many: 'หลายกรอบ',
      few: 'หลายกรอบ',
      two: '2 กรอบ',
      one: '1 กรอบ',
      zero: '0 กรอบ',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'ส่งออกทั้งหมด';

  @override
  String get deleteAll => 'ลบทั้งหมด';

  @override
  String get annotateDeleteConfirm =>
      'ต้องการลบข้อมูลการทำเครื่องหมายทั้งหมดและรูปภาพที่เกี่ยวข้องจากอุปกรณ์นี้หรือไม่?';

  @override
  String get noAnnotations =>
      'ยังไม่มีข้อมูลการทำเครื่องหมาย เลือกภาพแล้วเลือกทำเครื่องหมาย';

  @override
  String get filterScreenshots => 'ภาพหน้าจอ';

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get filterVideos => 'วิดีโอ';

  @override
  String get albums => 'อัลบั้ม';

  @override
  String get limitedAccess => 'MosaicIt สามารถดูได้เฉพาะบางส่วนของรูปภาพของคุณ';

  @override
  String get manage => 'จัดการ';

  @override
  String selectedImages(int count) {
    return 'เลือกแล้ว $count ภาพ';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ปิดบัง $count ภาพ',
      many: 'ปิดบังหลายภาพ',
      few: 'ปิดบังหลายภาพ',
      two: 'ปิดบัง 2 ภาพ',
      one: 'ปิดบัง 1 ภาพ',
      zero: 'ปิดบัง 0 ภาพ',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'ทำเครื่องหมาย';

  @override
  String get badgeRedacted => 'ปิดบังแล้ว';

  @override
  String get badgeAnnotated => 'ทำเครื่องหมายแล้ว';

  @override
  String get photosDenied =>
      'MosaicIt ต้องการเข้าถึงรูปภาพของคุณเพื่อแสดงที่นี่ รูปภาพจะไม่ออกจากอุปกรณ์นี้';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get openFiles => 'เปิดไฟล์';

  @override
  String get noPhotos => 'ไม่มีรูปภาพที่นี่';

  @override
  String get loading => 'กำลังโหลด…';

  @override
  String get appearance => 'ลักษณะ';

  @override
  String get theme => 'ธีม';

  @override
  String get appIcon => 'ไอคอนแอป';

  @override
  String get aspectRatioGrid => 'ตารางตามอัตราส่วนภาพ';

  @override
  String get modelDownloadFailed => 'ดาวน์โหลดโมเดลไม่ได้';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get autoUpdateModel => 'อัปเดตโมเดลอัตโนมัติ';

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
  String get localOnly =>
      'เก็บไว้ในอุปกรณ์นี้เท่านั้น ไม่เคยอยู่ใน iCloud หรือการสำรองข้อมูล';

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
}

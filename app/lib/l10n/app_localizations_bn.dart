// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'মডেল লোড হচ্ছে…';

  @override
  String get modelFileType => 'মডেল';

  @override
  String get useModel => 'মডেল ব্যবহার করুন';

  @override
  String get imagesFileType => 'ছবি';

  @override
  String get detecting => 'শনাক্ত করা হচ্ছে…';

  @override
  String detectingProgress(int current, int total) {
    return 'শনাক্ত করা হচ্ছে $current/$total…';
  }

  @override
  String get chooseModelFirst => 'আগে একটি মডেল নির্বাচন করুন';

  @override
  String get findingSimilar => 'সম্পর্কিত খোঁজা হচ্ছে…';

  @override
  String similarSelected(int found, int added) {
    return '$foundটি সম্পর্কিত অঞ্চল নির্বাচিত ($addedটি নতুন)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$imagesটি ছবির মধ্যে $foundটি সম্পর্কিত অঞ্চল নির্বাচিত ($addedটি নতুন)';
  }

  @override
  String get reviewButton => 'পর্যালোচনা';

  @override
  String get openingLabels => 'লেবেল খোলা হচ্ছে…';

  @override
  String noImagesIn(String name) {
    return '$name-এ কোনো ছবি নেই';
  }

  @override
  String get saving => 'সংরক্ষণ করা হচ্ছে…';

  @override
  String get exportHere => 'এখানে রপ্তানি করুন';

  @override
  String exportStoppedAt(String name) {
    return 'রপ্তানি $name-এ থেমে গেছে';
  }

  @override
  String exportedTo(String path) {
    return '$path-এ রপ্তানি করা হয়েছে';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path-এ রপ্তানি করা হয়েছে (অডিও নেই)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ছবি রপ্তানি করা হয়েছে',
      many: '$countটি ছবি রপ্তানি করা হয়েছে',
      few: '$countটি ছবি রপ্তানি করা হয়েছে',
      two: '২টি ছবি রপ্তানি করা হয়েছে',
      one: '১টি ছবি রপ্তানি করা হয়েছে',
      zero: '০টি ছবি রপ্তানি করা হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name পরীক্ষা করা হচ্ছে…';
  }

  @override
  String get checkingAndExporting => 'পরীক্ষা এবং রপ্তানি করা হচ্ছে…';

  @override
  String get cancel => 'বাতিল';

  @override
  String get exportAnyway => 'তবুও রপ্তানি করুন';

  @override
  String get reviewPseudoLabels =>
      'পসিউডো-লেবেল পর্যালোচনা করুন (coco.json সহ ফোল্ডার)';

  @override
  String get regionsTooltip => 'অঞ্চল';

  @override
  String get notCalibrated =>
      'মডেলটি ক্যালিব্রেট করা হয়নি: প্রি-নির্বাচন একটি নির্দিষ্ট থ্রেশহোল্ড ব্যবহার করে।';

  @override
  String calibratedUnverified(String domain) {
    return 'অনিশ্চিত ডেটা ($domain)-এ ক্যালিব্রেট করা হয়েছে: রিকল গ্যারান্টি এখনও প্রযোজ্য নয়।';
  }

  @override
  String calibratedFor(String domain) {
    return '$domain ছবির জন্য ক্যালিব্রেট করা হয়েছে। অন্যান্য ধরনের ছবি গ্যারান্টির বাইরে।';
  }

  @override
  String get cameraPhoto =>
      'এটি একটি ক্যামেরা ছবি; ডিটেক্টরটি স্ক্রিনশটের জন্য তৈরি, তাই এখানে এর বক্সগুলি নির্ভরযোগ্য নয়।';

  @override
  String get modeDraw => 'আঁকুন';

  @override
  String get fillLabel => 'ভরাট';

  @override
  String get fillSolid => 'একরঙা';

  @override
  String get fillBlocks => 'ধূসর মোজাইক';

  @override
  String get fillNoise => 'নয়েজ';

  @override
  String get verifyNext => 'যাচাই ও পরবর্তী';

  @override
  String get export => 'রপ্তানি';

  @override
  String get pickOneModel => 'ঠিক একটি .onnx মডেল নির্বাচন করুন';

  @override
  String pickSidecar(String name) {
    return '$name.json-ও নির্বাচন করুন';
  }

  @override
  String get analysing => 'বিশ্লেষণ করা হচ্ছে';

  @override
  String get followingRegion => 'অঞ্চলটি অনুসরণ করা হচ্ছে';

  @override
  String get exporting => 'রপ্তানি করা হচ্ছে';

  @override
  String busyFrames(String label, int count) {
    return '$label… $countটি ফ্রেম';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'এটি সম্পাদন করা হচ্ছে $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return '$time-এ রপ্তানি পরীক্ষা ব্যর্থ';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$countটি গোপনীয় মনে হওয়া অঞ্চল সেখানে এখনও দৃশ্যমান ($classes)।',
      many: '$countটি গোপনীয় মনে হওয়া অঞ্চল সেখানে এখনও দৃশ্যমান ($classes)।',
      few: '$countটি গোপনীয় মনে হওয়া অঞ্চল সেখানে এখনও দৃশ্যমান ($classes)।',
      two: '২টি গোপনীয় মনে হওয়া অঞ্চল সেখানে এখনও দৃশ্যমান ($classes)।',
      one: '১টি গোপনীয় মনে হওয়া অঞ্চল সেখানে এখনও দৃশ্যমান ($classes)।',
      zero: '০টি গোপনীয় মনে হওয়া অঞ্চল সেখানে এখনও দৃশ্যমান ($classes)।',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'ফ্রেম দেখান';

  @override
  String get drawMissedRegion => 'ডিটেক্টর মিস করা একটি অঞ্চল আঁকুন';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$totalটির মধ্যে $onটি ট্র্যাক সম্পাদিত · $keyframesটি কীফ্রেম';
  }

  @override
  String get keepAudio => 'অডিও রাখুন';

  @override
  String get keepAudioHint =>
      'কণ্ঠস্বর এবং নোটিফিকেশন সাউন্ড পরীক্ষা করা হয় না';

  @override
  String get goToFirstAppearance => 'প্রথম উপস্থিতিতে যান';

  @override
  String get classPersonName => 'নাম';

  @override
  String get classAddress => 'ঠিকানা';

  @override
  String get classPhone => 'ফোন';

  @override
  String get classEmail => 'ইমেইল';

  @override
  String get classIdNumber => 'আইডি নম্বর';

  @override
  String get classBankCard => 'ব্যাংক কার্ড';

  @override
  String get classPlate => 'নম্বর প্লেট';

  @override
  String get classAccountId => 'অ্যাকাউন্ট';

  @override
  String get classAvatar => 'অ্যাভাটার';

  @override
  String get classFace => 'মুখ';

  @override
  String get classQr => 'কিউআর কোড';

  @override
  String get classBarcode => 'বারকোড';

  @override
  String get classManual => 'ম্যানুয়াল';

  @override
  String noLabelsIn(String name) {
    return '$name-এ কোনো coco.json নেই';
  }

  @override
  String savedModelFailed(String error) {
    return 'সংরক্ষিত মডেলটি লোড করা যায়নি; আবার একটি মডেল নির্বাচন করুন। ($error)';
  }

  @override
  String get fillSurround => 'পটভূমির রং';

  @override
  String get fillTinted => 'রঙিন মোজাইক';

  @override
  String get settings => 'সেটিংস';

  @override
  String get classFinance => 'পরিমাণ';

  @override
  String get collectTitle => 'প্রশিক্ষণ ডেটা সংগ্রহ করুন';

  @override
  String get collectSubtitle =>
      'প্রতিটি রপ্তানি করা ছবি, শনাক্ত করা অংশ এবং আপনার বাছাই এই ডিভাইসে রাখুন, যাতে ভবিষ্যতের মডেল প্রশিক্ষণ দেওয়া যায়। কিছুই আপলোড হয় না।';

  @override
  String collectStats(int count, String size) {
    return '$countটি ছবি · $size';
  }

  @override
  String get collectDelete => 'সংগৃহীত ডেটা মুছুন';

  @override
  String get collectDeleteConfirm =>
      'এই ডিভাইস থেকে সব সংগৃহীত ছবি ও বাছাই মুছবেন?';

  @override
  String get delete => 'মুছুন';

  @override
  String collectFailed(String error) {
    return 'প্রশিক্ষণ ডেটা সংরক্ষণ করা যায়নি: $error';
  }

  @override
  String labelsSaved(int count) {
    return '$countটি ছবির লেবেল সংরক্ষিত হয়েছে';
  }

  @override
  String get undo => 'পূর্বাবস্থা';

  @override
  String get redo => 'পুনরায় করুন';

  @override
  String get similar => 'সদৃশ';

  @override
  String get thisImage => 'এই ছবিটি';

  @override
  String allImagesCount(int count) {
    return 'সব $countটি ছবি';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি এলাকা এখনও পড়া যাবে',
      many: '$countটি এলাকা এখনও পড়া যাবে',
      few: '$countটি এলাকা এখনও পড়া যাবে',
      two: '২টি এলাকা এখনও পড়া যাবে',
      one: '১টি এলাকা এখনও পড়া যাবে',
      zero: 'কোনো এলাকা পড়া যায় না',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'লুকানোর পরেও, পরীক্ষায় আউটপুটে এই এলাকাগুলো পাওয়া গেছে।';

  @override
  String get redactThemAndExport => 'এগুলোও লুকিয়ে এক্সপোর্ট করুন';

  @override
  String get showThem => 'দেখান';

  @override
  String get pickClass => 'একটি ক্লাস নির্বাচন করুন';

  @override
  String annotateOf(int index, int total) {
    return 'অ্যানোটেশন $index / $total';
  }

  @override
  String get suggestions => 'প্রস্তাব';

  @override
  String get skip => 'বাদ দিন';

  @override
  String get nothingPrivate => 'কোনো ব্যক্তিগত তথ্য নেই';

  @override
  String get next => 'পরবর্তী';

  @override
  String get annotateHint =>
      'বক্স করতে টেক্সটের লাইনে ট্যাপ করুন, অথবা আঁকতে ড্র্যাগ করুন';

  @override
  String get annotationData => 'অ্যানোটেশন ডেটা';

  @override
  String get statLabeled => 'লেবেল করা';

  @override
  String get statEmpty => 'কোনো ব্যক্তিগত তথ্য নেই';

  @override
  String get statSkipped => 'বাদ দেওয়া';

  @override
  String get boxesPerClass => 'ক্লাস অনুযায়ী বক্স';

  @override
  String get imagesHeader => 'ছবি';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি বক্স',
      many: '$countটি বক্স',
      few: '$countটি বক্স',
      two: '২টি বক্স',
      one: '১টি বক্স',
      zero: '০টি বক্স',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'সব এক্সপোর্ট করুন';

  @override
  String get deleteAll => 'সব মুছুন';

  @override
  String get annotateDeleteConfirm =>
      'এই ডিভাইস থেকে সব অ্যানোটেশন এবং তাদের ছবি মুছে ফেলবেন?';

  @override
  String get noAnnotations =>
      'এখনও কোনো অ্যানোটেশন নেই। ছবি নির্বাচন করে অ্যানোটেশন নির্বাচন করুন।';

  @override
  String get filterScreenshots => 'স্ক্রিনশট';

  @override
  String get filterAll => 'সব';

  @override
  String get filterVideos => 'ভিডিও';

  @override
  String get albums => 'অ্যালবাম';

  @override
  String get limitedAccess => 'MosaicIt আপনার কিছু ছবি দেখতে পারে';

  @override
  String get manage => 'ব্যবস্থাপনা';

  @override
  String selectedImages(int count) {
    return '$countটি নির্বাচিত';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ছবি লুকান',
      many: '$countটি ছবি লুকান',
      few: '$countটি ছবি লুকান',
      two: '২টি ছবি লুকান',
      one: '১টি ছবি লুকান',
      zero: '০টি ছবি লুকান',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'অ্যানোটেশন';

  @override
  String get badgeRedacted => 'লুকানো';

  @override
  String get badgeAnnotated => 'অ্যানোটেশন করা';

  @override
  String get photosDenied =>
      'MosaicIt-এর এখানে ছবি দেখানোর জন্য আপনার ছবিতে অ্যাক্সেসের প্রয়োজন। ছবি কখনোই এই ডিভাইস থেকে বের হয় না।';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get openFiles => 'ফাইল খুলুন';

  @override
  String get noPhotos => 'এখানে কোনো ছবি নেই';

  @override
  String get loading => 'লোড হচ্ছে…';

  @override
  String get appearance => 'দেখতে';

  @override
  String get theme => 'থিম';

  @override
  String get appIcon => 'অ্যাপ আইকন';

  @override
  String get aspectRatioGrid => 'অ্যাসপেক্ট রেশিও গ্রিড';

  @override
  String get modelDownloadFailed => 'মডেল ডাউনলোড করা যায়নি';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get autoUpdateModel => 'মডেল স্বয়ংক্রিয়ভাবে আপডেট করুন';

  @override
  String get threshold => 'থ্রেশহোল্ড';

  @override
  String get thresholdLow => 'কম';

  @override
  String get thresholdMedium => 'মাঝারি';

  @override
  String get thresholdHigh => 'বেশি';

  @override
  String get redaction => 'লুকানো';

  @override
  String get style => 'স্টাইল';

  @override
  String get selectedByDefault => 'ডিফল্টভাবে নির্বাচিত';

  @override
  String get dataPrivacy => 'ডেটা ও গোপনীয়তা';

  @override
  String get localOnly =>
      'শুধুমাত্র এই ডিভাইসে রাখা হয়, কখনোই iCloud বা ব্যাকআপে নয়।';

  @override
  String get model => 'মডেল';

  @override
  String get importModel => 'অন্য মডেল ইমপোর্ট করুন';

  @override
  String get advanced => 'উন্নত';

  @override
  String get about => 'বিষয়ে';

  @override
  String get licenses => 'ওপেন-সোর্স লাইসেন্স';

  @override
  String get merge => 'মার্জ';

  @override
  String get split => 'বিভক্ত';

  @override
  String get mergeHint => 'একই মানের অংশ হিসেবে অন্য বক্সে ট্যাপ করুন';

  @override
  String get classOrganization => 'সংগঠন';

  @override
  String get classDeviceId => 'ডিভাইস আইডি';

  @override
  String get classSecret => 'গোপন তথ্য';
}

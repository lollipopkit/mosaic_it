// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'मोडेल लोड हुँदैछ…';

  @override
  String get modelFileType => 'मोडेल';

  @override
  String get useModel => 'मोडेल प्रयोग गर्नुहोस्';

  @override
  String get imagesFileType => 'तस्बिरहरू';

  @override
  String get detecting => 'पत्ता लगाउँदैछ…';

  @override
  String detectingProgress(int current, int total) {
    return 'पत्ता लगाउँदैछ $current/$total…';
  }

  @override
  String get chooseModelFirst => 'पहिले एउटा मोडेल छान्नुहोस्';

  @override
  String get findingSimilar => 'समान खोज्दैछ…';

  @override
  String similarSelected(int found, int added) {
    return '$found समान क्षेत्रहरू छानिएको ($added नयाँ)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found समान क्षेत्रहरू छानिएको ($added नयाँ) $images तस्बिरहरूमा';
  }

  @override
  String get reviewButton => 'समीक्षा गर्नुहोस्';

  @override
  String get openingLabels => 'लेबलहरू खोल्दैछ…';

  @override
  String noImagesIn(String name) {
    return '$name मा तस्बिरहरू छैनन्';
  }

  @override
  String get saving => 'सेभ हुँदैछ…';

  @override
  String get exportHere => 'यहाँ निर्यात गर्नुहोस्';

  @override
  String exportStoppedAt(String name) {
    return 'निर्यात $name मा रोकिियो';
  }

  @override
  String exportedTo(String path) {
    return '$path मा निर्यात गरियो';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path मा निर्यात गरियो (ध्वनि छैन)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'कुल $count तस्बिरहरू निर्यात गरियो',
      many: 'कुल $count तस्बिरहरू निर्यात गरियो',
      few: 'कुल $count तस्बिरहरू निर्यात गरियो',
      two: '2 तस्बिरहरू निर्यात गरियो',
      one: '1 तस्बिर निर्यात गरियो',
      zero: '0 तस्बिरहरू निर्यात गरियो',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name जाँच हुँदैछ…';
  }

  @override
  String get checkingAndExporting => 'जाँच र निर्यात हुँदैछ…';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get exportAnyway => 'तथापि निर्यात गर्नुहोस्';

  @override
  String get reviewPseudoLabels =>
      'सूचना-लेबलहरू समीक्षा गर्नुहोस् (coco.json भएको फोल्डर)';

  @override
  String get regionsTooltip => 'क्षेत्रहरू';

  @override
  String get notCalibrated =>
      'मोडेल क्यालिब्रेट गरिएको छैन: पूर्व-छनोट एउटा निश्चित थ्रेसहोल्ड प्रयोग गर्दछ।';

  @override
  String calibratedUnverified(String domain) {
    return 'असत्यापित डेटामा ($domain) क्यालिब्रेट गरिएको: रिक्ल ग्यारेन्टी अहिले लागू हुँदैन।';
  }

  @override
  String calibratedFor(String domain) {
    return '$domain तस्बिरहरूका लागि क्यालिब्रेट गरिएको। अन्य प्रकारका तस्बिरहरू ग्यारेन्टी बाहिर छन्।';
  }

  @override
  String get cameraPhoto =>
      'यो क्यामेरा तस्बिर हो; डिटेक्टर स्क्रिनसटका लागि बनाइएको छ, त्यसैले यहाँका बक्सहरू विश्वसनीय हुँदैनन्।';

  @override
  String get modeDraw => 'आँकन गर्नुहोस्';

  @override
  String get fillLabel => 'भर्नुहोस्';

  @override
  String get fillSolid => 'ठोस रङ';

  @override
  String get fillBlocks => 'खैरो मोज़ेक';

  @override
  String get fillNoise => 'नोइज';

  @override
  String get verifyNext => 'सत्यापन र अर्को';

  @override
  String get export => 'निर्यात गर्नुहोस्';

  @override
  String get pickOneModel => 'केवल एउटा .onnx मोडेल छान्नुहोस्';

  @override
  String pickSidecar(String name) {
    return '$name.json पनि छान्नुहोस्';
  }

  @override
  String get analysing => 'विश्लेषण हुँदैछ';

  @override
  String get followingRegion => 'क्षेत्र पछ्याउँदैछ';

  @override
  String get exporting => 'निर्यात हुँदैछ';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count फ्रेमहरू';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'रेड्याक्ट हुँदैछ $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'निर्यात जाँच $time मा असफल भयो';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'कुल $count गोप्य देखिने क्षेत्रहरू त्यहाँ देखिँदैछन् ($classes)।',
      many: 'कुल $count गोप्य देखिने क्षेत्रहरू त्यहाँ देखिँदैछन् ($classes)।',
      few: 'कुल $count गोप्य देखिने क्षेत्रहरू त्यहाँ देखिँदैछन् ($classes)।',
      two: '2 गोप्य देखिने क्षेत्रहरू त्यहाँ देखिँदैछन् ($classes)।',
      one: '1 गोप्य देखिने क्षेत्र त्यहाँ देखिँदैछ ($classes)।',
      zero: '0 गोप्य देखिने क्षेत्रहरू त्यहाँ देखिँदैछन् ($classes)।',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'फ्रेम देखाउनुहोस्';

  @override
  String get drawMissedRegion => 'डिटेक्टरले चुकेको क्षेत्र आँकन गर्नुहोस्';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on of $total ट्र्याकहरू रेड्याक्ट गरियो · $keyframes कि-फ्रेमहरू';
  }

  @override
  String get keepAudio => 'ध्वनि राख्नुहोस्';

  @override
  String get keepAudioHint => 'आवाज र सूचना ध्वनिहरू जाँच गरिँदैनन्';

  @override
  String get goToFirstAppearance => 'पहिलो प्रकट हुने ठाउँमा जानुहोस्';

  @override
  String get classPersonName => 'नाम';

  @override
  String get classAddress => 'ठेगाना';

  @override
  String get classPhone => 'फोन';

  @override
  String get classEmail => 'इमेल';

  @override
  String get classIdNumber => 'आईडी नम्बर';

  @override
  String get classBankCard => 'बैंक कार्ड';

  @override
  String get classPlate => 'प्लेट';

  @override
  String get classAccountId => 'खाता';

  @override
  String get classAvatar => 'अवतार';

  @override
  String get classFace => 'अनुहार';

  @override
  String get classQr => 'QR कोड';

  @override
  String get classBarcode => 'बारकोड';

  @override
  String get classManual => 'म्यानुअल';

  @override
  String noLabelsIn(String name) {
    return '$name मा coco.json छैन';
  }

  @override
  String savedModelFailed(String error) {
    return 'सुरक्षित गरिएको मोडेल लोड गर्न सकिन; फेरि एक मोडल छान्नुहोस्। ($error)';
  }

  @override
  String get fillSurround => 'पृष्ठभूमिको रङ';

  @override
  String get fillTinted => 'रङ्गीन मोज़ेक';

  @override
  String get settings => 'सेटिङहरू';

  @override
  String get classFinance => 'रकम';

  @override
  String get collectTitle => 'तालिम डेटा सङ्कलन गर्नुहोस्';

  @override
  String get collectSubtitle =>
      'निर्यात गरिएको हरेक तस्बिर, पहिचान गरिएका क्षेत्र र तपाईंका छनोट यस यन्त्रमा राख्नुहोस्, ताकि भविष्यका मोडेल तालिम दिन सकियोस्। केही पनि अपलोड हुँदैन।';

  @override
  String collectStats(int count, String size) {
    return '$count तस्बिर · $size';
  }

  @override
  String get collectDelete => 'सङ्कलित डेटा मेटाउनुहोस्';

  @override
  String get collectDeleteConfirm =>
      'यस यन्त्रबाट सबै सङ्कलित तस्बिर र छनोट मेटाउने?';

  @override
  String get delete => 'मेटाउनुहोस्';

  @override
  String collectFailed(String error) {
    return 'तालिम डेटा सुरक्षित गर्न सकिएन: $error';
  }

  @override
  String labelsSaved(int count) {
    return '$count तस्बिरका लेबल सुरक्षित भए';
  }

  @override
  String get undo => 'पूर्ववत';

  @override
  String get redo => 'पुनः';

  @override
  String get similar => 'समान';

  @override
  String get thisImage => 'यो तस्बिर';

  @override
  String allImagesCount(int count) {
    return 'सबै $count तस्बिरहरू';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्षेत्रहरू पढ्न सकिन्छ',
      many: '$count क्षेत्रहरू पढ्न सकिन्छ',
      few: '$count क्षेत्रहरू पढ्न सकिन्छ',
      two: '२ क्षेत्रहरू पढ्न सकिन्छ',
      one: '१ क्षेत्र पढ्न सकिन्छ',
      zero: 'कुनै क्षेत्र पढ्न सकिन्छ',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'लुकाइसकेपछि, जाँचले आउटपुटमा यी क्षेत्रहरू अझै भेट्टाएको छ।';

  @override
  String get redactThemAndExport => 'यी पनि लुकाएर निर्यात गर्नुहोस्';

  @override
  String get showThem => 'यी देखाउनुहोस्';

  @override
  String get pickClass => 'एउटा कक्षा छान्नुहोस्';

  @override
  String annotateOf(int index, int total) {
    return 'एनोटेट $index / $total';
  }

  @override
  String get suggestions => 'सुझावहरू';

  @override
  String get skip => 'छुट्ट्याउनुहोस्';

  @override
  String get nothingPrivate => 'कुनै निजी कुरा छैन';

  @override
  String get next => 'अर्को';

  @override
  String get annotateHint =>
      'बक्स गर्नका लागि पाठको पंक्तिमा ट्याप गर्नुहोस्, वा तानेर बनाउनुहोस्';

  @override
  String get annotationData => 'एनोटेशन डेटा';

  @override
  String get statLabeled => 'लेबल गरिएको';

  @override
  String get statEmpty => 'कुनै निजी कुरा छैन';

  @override
  String get statSkipped => 'छुट्ट्याइएको';

  @override
  String get boxesPerClass => 'कक्षा अनुसार बक्सहरू';

  @override
  String get imagesHeader => 'तस्बिरहरू';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बक्सहरू',
      many: '$count बक्सहरू',
      few: '$count बक्सहरू',
      two: '२ बक्सहरू',
      one: '१ बक्स',
      zero: '० बक्स',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'सबै निर्यात गर्नुहोस्';

  @override
  String get deleteAll => 'सबै मेटाउनुहोस्';

  @override
  String get annotateDeleteConfirm =>
      'यो डिभाइसबाट सबै एनोटेशनहरू र तिनीहरूका तस्बिरहरू मेटाउने?';

  @override
  String get noAnnotations =>
      'अहिलेसम्म कुनै एनोटेशन छैन। तस्बिरहरू छानेर एनोटेट छान्नुहोस्।';

  @override
  String get filterScreenshots => 'स्क्रीनशटहरू';

  @override
  String get filterAll => 'सबै';

  @override
  String get filterVideos => 'भिडियोहरू';

  @override
  String get albums => 'एल्बमहरू';

  @override
  String get limitedAccess =>
      'MosaicIt ले तपाईंका केही तस्बिरहरू मात्र हेर्न सक्छ';

  @override
  String get manage => 'प्रबन्धन गर्नुहोस्';

  @override
  String selectedImages(int count) {
    return '$count छानिएको';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count तस्बिरहरू लुकाउनुहोस्',
      many: '$count तस्बिरहरू लुकाउनुहोस्',
      few: '$count तस्बिरहरू लुकाउनुहोस्',
      two: '२ तस्बिरहरू लुकाउनुहोस्',
      one: '१ तस्बिर लुकाउनुहोस्',
      zero: '० तस्बिर लुकाउनुहोस्',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'एनोटेट';

  @override
  String get badgeRedacted => 'लुकाइएको';

  @override
  String get badgeAnnotated => 'एनोटेट गरिएको';

  @override
  String get photosDenied =>
      'MosaicIt लाई यहाँ तस्बिरहरू देखाउन तपाईंका तस्बिरहरूमा पहुँच चाहिन्छ। तस्बिरहरू कहिल्यै यो डिभाइसबाट बाहिर निस्कँदैनन्।';

  @override
  String get openSettings => 'सेटिङ खोल्नुहोस्';

  @override
  String get openFiles => 'फाइलहरू खोल्नुहोस्';

  @override
  String get noPhotos => 'यहाँ कुनै तस्बिर छैन';

  @override
  String get loading => 'लोड हुँदैछ…';

  @override
  String get appearance => 'रूप';

  @override
  String get theme => 'थीम';

  @override
  String get appIcon => 'एप आइकन';

  @override
  String get aspectRatioGrid => 'आस्पेक्ट अनुपात ग्रिड';

  @override
  String get modelDownloadFailed => 'मोडेल डाउनलोड गर्न सकिएन';

  @override
  String get retry => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get autoUpdateModel => 'मोडेल स्वतः अपडेट गर्नुहोस्';

  @override
  String get threshold => 'थ्रेसहोल्ड';

  @override
  String get thresholdLow => 'कम';

  @override
  String get thresholdMedium => 'मध्यम';

  @override
  String get thresholdHigh => 'उच्च';

  @override
  String get redaction => 'लुकाइने प्रक्रिया';

  @override
  String get style => 'शैली';

  @override
  String get selectedByDefault => 'पूर्वनिर्धारित रूपमा चयन गरिएको';

  @override
  String get dataPrivacy => 'डेटा र गोपनीयता';

  @override
  String get localOnly =>
      'यो डिभाइसमा मात्र राखिन्छ, iCloud वा ब्याकअपमा कहिल्यै होइन।';

  @override
  String get model => 'मोडेल';

  @override
  String get importModel => 'अर्को मोडेल आयात गर्नुहोस्';

  @override
  String get advanced => 'उन्नत';

  @override
  String get about => 'बारेमा';

  @override
  String get licenses => 'ओपन-सोर्स लाइसेन्सहरू';

  @override
  String get merge => 'मर्ज गर्नुहोस्';

  @override
  String get split => 'विभाजन गर्नुहोस्';

  @override
  String get mergeHint => 'एउटै मानको भाग बनाउन अर्को बक्समा ट्याप गर्नुहोस्';

  @override
  String get classOrganization => 'संस्था';

  @override
  String get classDeviceId => 'उपकरण आईडी';

  @override
  String get classSecret => 'गोप्य जानकारी';
}

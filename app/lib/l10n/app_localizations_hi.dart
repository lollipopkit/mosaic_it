// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'मॉडल लोड हो रहा है…';

  @override
  String get modelFileType => 'मॉडल';

  @override
  String get useModel => 'मॉडल उपयोग करें';

  @override
  String get imagesFileType => 'छवियाँ';

  @override
  String get detecting => 'पता लगाया जा रहा है…';

  @override
  String detectingProgress(int current, int total) {
    return '$current/$total पता लगाया जा रहा है…';
  }

  @override
  String get chooseModelFirst => 'पहले एक मॉडल चुनें';

  @override
  String get findingSimilar => 'समान खोजा जा रहा है…';

  @override
  String similarSelected(int found, int added) {
    return '$found समान क्षेत्र चुने गए ($added नए)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found समान क्षेत्र चुने गए ($added नए) $images छवियों में';
  }

  @override
  String get reviewButton => 'समीक्षा करें';

  @override
  String get openingLabels => 'लेबल खोले जा रहे हैं…';

  @override
  String noImagesIn(String name) {
    return '$name में कोई छवि नहीं है';
  }

  @override
  String get saving => 'सहेजा जा रहा है…';

  @override
  String get exportHere => 'यहाँ निर्यात करें';

  @override
  String exportStoppedAt(String name) {
    return 'निर्यात $name पर रुका';
  }

  @override
  String exportedTo(String path) {
    return '$path में निर्यात किया गया';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path में निर्यात किया गया (बिना ऑडियो)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छवियाँ निर्यात की गईं',
      many: 'बहुत सारी छवियाँ निर्यात की गईं',
      few: 'कुछ छवियाँ निर्यात की गईं',
      two: '2 छवियाँ निर्यात की गईं',
      one: '1 छवि निर्यात की गई',
      zero: '0 छवियाँ निर्यात की गईं',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name की जाँच की जा रही है…';
  }

  @override
  String get checkingAndExporting => 'जाँच और निर्यात हो रहा है…';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get exportAnyway => 'फिर भी निर्यात करें';

  @override
  String get reviewPseudoLabels =>
      'प्रीसो-लेबल की समीक्षा करें (coco.json वाला फ़ोल्डर)';

  @override
  String get regionsTooltip => 'क्षेत्र';

  @override
  String get notCalibrated =>
      'मॉडल कैलिब्रेट नहीं है: पूर्व-चयन एक निश्चित थ्रेशोल्ड का उपयोग करता है।';

  @override
  String calibratedUnverified(String domain) {
    return 'असत्यापित डेटा ($domain) पर कैलिब्रेट किया गया है: रिकॉल गारंटी अभी लागू नहीं होती।';
  }

  @override
  String calibratedFor(String domain) {
    return '$domain छवियों के लिए कैलिब्रेट किया गया है। अन्य प्रकार की छवियाँ गारंटी के बाहर हैं।';
  }

  @override
  String get cameraPhoto =>
      'यह एक कैमरा फोटो है; डिटेक्टर स्क्रीनशॉट्स के लिए बनाया गया है, इसलिए यहाँ इसके बॉक्स विश्वसनीय नहीं हैं।';

  @override
  String get modeDraw => 'बनाएं';

  @override
  String get fillLabel => 'भरना';

  @override
  String get fillSolid => 'ठोस रंग';

  @override
  String get fillBlocks => 'धूसर मोज़ेक';

  @override
  String get fillNoise => 'नॉइज़';

  @override
  String get verifyNext => 'सत्यापित करें और अगला';

  @override
  String get export => 'निर्यात करें';

  @override
  String get pickOneModel => 'ठीक एक .onnx मॉडल चुनें';

  @override
  String pickSidecar(String name) {
    return '$name.json भी चुनें';
  }

  @override
  String get analysing => 'विश्लेषण हो रहा है';

  @override
  String get followingRegion => 'क्षेत्र का पालन किया जा रहा है';

  @override
  String get exporting => 'निर्यात हो रहा है';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count फ्रेम';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'इसे रेडैक्ट किया जा रहा है $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return '$time पर निर्यात जाँच विफल';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count निजी-दिखने वाले क्षेत्र अभी भी दिखाई दे रहे हैं ($classes)।',
      many:
          'वहाँ बहुत सारे निजी-दिखने वाले क्षेत्र अभी भी दिखाई दे रहे हैं ($classes)।',
      few:
          'वहाँ कुछ निजी-दिखने वाले क्षेत्र अभी भी दिखाई दे रहे हैं ($classes)।',
      two: 'वहाँ 2 निजी-दिखने वाले क्षेत्र अभी भी दिखाई दे रहे हैं ($classes)।',
      one: 'वहाँ 1 निजी-दिखने वाला क्षेत्र अभी भी दिखाई दे रहा है ($classes)।',
      zero: 'वहाँ कोई निजी-दिखने वाला क्षेत्र नहीं दिख रहा ($classes)।',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'फ्रेम दिखाएं';

  @override
  String get drawMissedRegion => 'एक क्षेत्र बनाएं जिसे डिटेक्टर ने मिस किया';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$total में से $on ट्रैक्स रेडैक्ट किए गए · $keyframes की-फ्रेम';
  }

  @override
  String get keepAudio => 'ऑडियो रखें';

  @override
  String get keepAudioHint => 'आवाज़ें और सूचना ध्वनियाँ जाँची नहीं जातीं';

  @override
  String get goToFirstAppearance => 'पहली उपस्थिति पर जाएं';

  @override
  String get classPersonName => 'नाम';

  @override
  String get classAddress => 'पता';

  @override
  String get classPhone => 'फ़ोन';

  @override
  String get classEmail => 'ईमेल';

  @override
  String get classIdNumber => 'आईडी नंबर';

  @override
  String get classBankCard => 'बैंक कार्ड';

  @override
  String get classPlate => 'प्लेट';

  @override
  String get classAccountId => 'खाता';

  @override
  String get classAvatar => 'एवेटार';

  @override
  String get classFace => 'चेहरा';

  @override
  String get classQr => 'QR कोड';

  @override
  String get classBarcode => 'बारकोड';

  @override
  String get classManual => 'मैनुअल';

  @override
  String noLabelsIn(String name) {
    return '$name में coco.json नहीं मिला';
  }

  @override
  String savedModelFailed(String error) {
    return 'सहेजा गया मॉडल लोड नहीं किया जा सका; कृपया फिर से एक मॉडल चुनें। ($error)';
  }

  @override
  String get fillSurround => 'पृष्ठभूमि का रंग';

  @override
  String get fillTinted => 'रंगीन मोज़ेक';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get classFinance => 'राशि';

  @override
  String get collectTitle => 'प्रशिक्षण डेटा एकत्र करें';

  @override
  String get collectSubtitle =>
      'हर निर्यात की गई छवि, पहचाने गए क्षेत्र और आपके चुनाव इस डिवाइस पर रखें ताकि भविष्य के मॉडल प्रशिक्षित हो सकें। कुछ भी अपलोड नहीं होता।';

  @override
  String collectStats(int count, String size) {
    return '$count छवियाँ · $size';
  }

  @override
  String get collectDelete => 'एकत्र किया गया डेटा हटाएँ';

  @override
  String get collectDeleteConfirm =>
      'इस डिवाइस से सभी एकत्र की गई छवियाँ और चुनाव हटाएँ?';

  @override
  String get delete => 'हटाएँ';

  @override
  String collectFailed(String error) {
    return 'प्रशिक्षण डेटा सहेजा नहीं जा सका: $error';
  }

  @override
  String labelsSaved(int count) {
    return '$count छवियों के लेबल सहेजे गए';
  }

  @override
  String get undo => 'पूर्ववत करें';

  @override
  String get redo => 'पुनः करें';

  @override
  String get similar => 'समान';

  @override
  String get thisImage => 'यह छवि';

  @override
  String allImagesCount(int count) {
    return 'सभी $count छवियाँ';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्षेत्र अभी भी पठनीय हो सकते हैं',
      many: '$count क्षेत्र अभी भी पठनीय हो सकते हैं',
      few: '$count क्षेत्र अभी भी पठनीय हो सकते हैं',
      two: '2 क्षेत्र अभी भी पठनीय हो सकते हैं',
      one: '1 क्षेत्र अभी भी पठनीय हो सकता है',
      zero: 'कोई क्षेत्र पठनीय नहीं है',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'छिपाए जाने के बाद, जाँच ने आउटपुट में इन क्षेत्रों को फिर से पाया।';

  @override
  String get redactThemAndExport => 'इनको छिपाएँ और निर्यात करें';

  @override
  String get showThem => 'इनको दिखाएँ';

  @override
  String get pickClass => 'एक वर्ग चुनें';

  @override
  String annotateOf(int index, int total) {
    return 'एनोटेट $index / $total';
  }

  @override
  String get suggestions => 'सुझाव';

  @override
  String get skip => 'छोड़ें';

  @override
  String get nothingPrivate => 'कोई निजी जानकारी नहीं';

  @override
  String get next => 'अगला';

  @override
  String get annotateHint =>
      'बॉक्स लगाने के लिए किसी टेक्स्ट पंक्ति पर टैप करें, या खींचकर बनाएँ';

  @override
  String get annotationData => 'एनोटेशन डेटा';

  @override
  String get statLabeled => 'लेबल किए गए';

  @override
  String get statEmpty => 'कोई निजी जानकारी नहीं';

  @override
  String get statSkipped => 'छोड़े गए';

  @override
  String get boxesPerClass => 'प्रति वर्ग बॉक्स';

  @override
  String get imagesHeader => 'छवियाँ';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बॉक्स',
      many: '$count बॉक्स',
      few: '$count बॉक्स',
      two: '2 बॉक्स',
      one: '1 बॉक्स',
      zero: '0 बॉक्स',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'सभी निर्यात करें';

  @override
  String get deleteAll => 'सभी हटाएँ';

  @override
  String get annotateDeleteConfirm =>
      'क्या इस डिवाइस से सभी एनोटेशन और उनकी छवियाँ हटाई जाएँ?';

  @override
  String get noAnnotations =>
      'अभी तक कोई एनोटेशन नहीं। छवियाँ चुनें और एनोटेट चुनें।';

  @override
  String get filterScreenshots => 'स्क्रीनशॉट';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterVideos => 'वीडियो';

  @override
  String get albums => 'एल्बम';

  @override
  String get limitedAccess => 'MosaicIt आपकी कुछ ही फ़ोटो देख सकता है';

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String selectedImages(int count) {
    return '$count चयनित';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count छवियाँ छिपाएँ',
      many: '$count छवियाँ छिपाएँ',
      few: '$count छवियाँ छिपाएँ',
      two: '2 छवियाँ छिपाएँ',
      one: '1 छवि छिपाएँ',
      zero: '0 छवियाँ छिपाएँ',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'एनोटेट';

  @override
  String get badgeRedacted => 'छिपाया गया';

  @override
  String get badgeAnnotated => 'एनोटेट किया गया';

  @override
  String get photosDenied =>
      'MosaicIt को यहाँ उन्हें दिखाने के लिए आपकी फ़ोटो तक पहुँच की आवश्यकता है। फ़ोटो कभी भी इस डिवाइस से बाहर नहीं जातीं।';

  @override
  String get openSettings => 'सेटिंग खोलें';

  @override
  String get openFiles => 'फ़ाइलें खोलें';

  @override
  String get noPhotos => 'यहाँ कोई फ़ोटो नहीं';

  @override
  String get loading => 'लोड हो रहा है…';

  @override
  String get appearance => 'दिखावट';

  @override
  String get theme => 'थीम';

  @override
  String get appIcon => 'ऐप आइकन';

  @override
  String get aspectRatioGrid => 'आस्पेक्ट रेशियो ग्रिड';

  @override
  String get modelDownloadFailed => 'मॉडल डाउनलोड नहीं हो सका';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get autoUpdateModel => 'मॉडल अपने-आप अपडेट करें';

  @override
  String get threshold => 'थ्रेशोल्ड';

  @override
  String get thresholdLow => 'कम';

  @override
  String get thresholdMedium => 'मध्यम';

  @override
  String get thresholdHigh => 'अधिक';

  @override
  String get redaction => 'छिपाई';

  @override
  String get style => 'शैली';

  @override
  String get selectedByDefault => 'डिफ़ॉल्ट रूप से चयनित';

  @override
  String get dataPrivacy => 'डेटा और गोपनीयता';

  @override
  String get localOnly =>
      'केवल इस डिवाइस पर रखा जाता है, कभी iCloud या बैकअप में नहीं।';

  @override
  String get model => 'मॉडल';

  @override
  String get importModel => 'कोई अन्य मॉडल आयात करें';

  @override
  String get advanced => 'उन्नत';

  @override
  String get about => 'बारे में';

  @override
  String get licenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get merge => 'मर्ज करें';

  @override
  String get split => 'विभाजित करें';

  @override
  String get mergeHint =>
      'एक ही मान का हिस्सा बनाने के लिए किसी अन्य बॉक्स पर टैप करें';

  @override
  String get classOrganization => 'संगठन';

  @override
  String get classDeviceId => 'डिवाइस आईडी';

  @override
  String get classSecret => 'गोपनीय क्रेडेंशियल';
}

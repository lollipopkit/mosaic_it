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
  String get regionsTooltip => 'क्षेत्र';

  @override
  String get cameraPhoto =>
      'यह एक कैमरा फोटो है; डिटेक्टर स्क्रीनशॉट्स के लिए बनाया गया है, इसलिए यहाँ इसके बॉक्स विश्वसनीय नहीं हैं।';

  @override
  String get modeDraw => 'बनाएं';

  @override
  String get fillSolid => 'ठोस रंग';

  @override
  String get fillBlocks => 'धूसर मोज़ेक';

  @override
  String get fillNoise => 'नॉइज़';

  @override
  String get export => 'निर्यात करें';

  @override
  String pickOneModel(String formats) {
    return 'ठीक एक $formats मॉडल चुनें';
  }

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
  String get delete => 'हटाएँ';

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
  String get badgeRedacted => 'छिपाया गया';

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

  @override
  String get classPerson => 'व्यक्ति';

  @override
  String get classHealth => 'स्वास्थ्य';

  @override
  String get classPersonalInfo => 'व्यक्तिगत जानकारी';

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
  String get introBundledReady => 'Bundled detector ready';

  @override
  String get introPhotosGranted => 'Photo access granted';

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
}

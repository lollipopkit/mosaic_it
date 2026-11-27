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
  String get regionsTooltip => 'क्षेत्रहरू';

  @override
  String get cameraPhoto =>
      'यो क्यामेरा तस्बिर हो; डिटेक्टर स्क्रिनसटका लागि बनाइएको छ, त्यसैले यहाँका बक्सहरू विश्वसनीय हुँदैनन्।';

  @override
  String get modeDraw => 'आँकन गर्नुहोस्';

  @override
  String get fillSolid => 'ठोस रङ';

  @override
  String get fillBlocks => 'खैरो मोज़ेक';

  @override
  String get fillNoise => 'नोइज';

  @override
  String get export => 'निर्यात गर्नुहोस्';

  @override
  String pickOneModel(String formats) {
    return 'केवल एउटा $formats मोडेल छान्नुहोस्';
  }

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
  String get delete => 'मेटाउनुहोस्';

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
  String get appearance => 'रूप';

  @override
  String get theme => 'थीम';

  @override
  String get appIcon => 'एप आइकन';

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

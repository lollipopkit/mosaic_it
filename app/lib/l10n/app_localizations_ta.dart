// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'மாதிரி ஏற்றப்படுகிறது…';

  @override
  String get modelFileType => 'மாதிரிகள்';

  @override
  String get useModel => 'மாதிரியைப் பயன்படுத்து';

  @override
  String get imagesFileType => 'படங்கள்';

  @override
  String get detecting => 'கண்டறியப்படுகிறது…';

  @override
  String detectingProgress(int current, int total) {
    return '$current/$total கண்டறியப்படுகிறது…';
  }

  @override
  String get chooseModelFirst => 'முதலில் ஒரு மாதிரியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get findingSimilar => 'ஒத்தவற்றைக் கண்டறியப்படுகிறது…';

  @override
  String similarSelected(int found, int added) {
    return '$found ஒத்த பகுதிகள் தேர்ந்தெடுக்கப்பட்டன ($added புதியவை)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$images படங்களில் $found ஒத்த பகுதிகள் தேர்ந்தெடுக்கப்பட்டன ($added புதியவை)';
  }

  @override
  String get saving => 'சேமிக்கப்படுகிறது…';

  @override
  String get exportHere => 'இங்கே ஏற்றுமதி செய்க';

  @override
  String exportStoppedAt(String name) {
    return '$name இல் ஏற்றுமதி நிறுத்தப்பட்டது';
  }

  @override
  String exportedTo(String path) {
    return '$path இல் ஏற்றுமதி செய்யப்பட்டது';
  }

  @override
  String exportedToNoAudio(String path) {
    return '$path இல் ஏற்றுமதி செய்யப்பட்டது (ஒலி இல்லை)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count படங்கள் ஏற்றுமதி செய்யப்பட்டன',
      many: 'படங்கள் ஏற்றுமதி செய்யப்பட்டன',
      few: 'படங்கள் ஏற்றுமதி செய்யப்பட்டன',
      two: '2 படங்கள் ஏற்றுமதி செய்யப்பட்டன',
      one: '1 படம் ஏற்றுமதி செய்யப்பட்டது',
      zero: '0 படங்கள் ஏற்றுமதி செய்யப்பட்டன',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name சரிபார்க்கப்படுகிறது…';
  }

  @override
  String get checkingAndExporting => 'சரிபார்த்து ஏற்றுமதி செய்யப்படுகிறது…';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get exportAnyway => 'எப்படியும் ஏற்றுமதி செய்';

  @override
  String get regionsTooltip => 'பகுதிகள்';

  @override
  String get cameraPhoto =>
      'இது ஒரு கேமரா படம்; கண்டறியும் கருவி ஸ்கிரீன்ஷாட்களுக்கு உருவாக்கப்பட்டது, எனவே இங்கு அதன் பெட்டிகள் நம்பகமானவை அல்ல.';

  @override
  String get modeDraw => 'வரை';

  @override
  String get fillSolid => 'திட நிறம்';

  @override
  String get fillBlocks => 'சாம்பல் மொசைக்';

  @override
  String get fillNoise => 'சத்தம்';

  @override
  String get export => 'ஏற்றுமதி செய்';

  @override
  String pickOneModel(String formats) {
    return 'சரியாக ஒரு $formats மாதிரியைத் தேர்ந்தெடுக்கவும்';
  }

  @override
  String pickSidecar(String name) {
    return '$name.json ஐயும் தேர்ந்தெடுக்கவும்';
  }

  @override
  String get analysing => 'பகுப்பாய்வு செய்யப்படுகிறது';

  @override
  String get followingRegion => 'பகுதியைப் பின்தொடர்கிறது';

  @override
  String get exporting => 'ஏற்றுமதி செய்யப்படுகிறது';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count ஃபிரேம்கள்';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'அதை மறைக்கிறது $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return '$time இல் ஏற்றுமதி சரிபார்ப்பு தோல்வியடைந்தது';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count தனியுரிமை பகுதிகள் அங்கு வெளியே தெரிகின்றன ($classes)',
      many: 'தனியுரிமை பகுதிகள் அங்கு வெளியே தெரிகின்றன ($classes)',
      few: 'தனியுரிமை பகுதிகள் அங்கு வெளியே தெரிகின்றன ($classes)',
      two: '2 தனியுரிமை பகுதிகள் அங்கு வெளியே தெரிகின்றன ($classes)',
      one: '1 தனியுரிமை பகுதி அங்கு வெளியே தெரிகிறது ($classes)',
      zero: '0 தனியுரிமை பகுதிகள் அங்கு வெளியே தெரிகின்றன ($classes)',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'ஃபிரேமைக் காட்டு';

  @override
  String get drawMissedRegion => 'கண்டறியும் கருவி தவறிய ஒரு பகுதியை வரையவும்';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$total டிராக்க்களில் $on மறைக்கப்பட்டன · $keyframes முக்கிய ஃபிரேம்கள்';
  }

  @override
  String get keepAudio => 'ஒலியை வைத்திரு';

  @override
  String get keepAudioHint =>
      'குரல்கள் மற்றும் அறிவிப்பு ஒலிகள் சரிபார்க்கப்படாது';

  @override
  String get goToFirstAppearance => 'முதல் தோற்றத்திற்குச் செல்';

  @override
  String get classPersonName => 'பெயர்';

  @override
  String get classAddress => 'முகவரி';

  @override
  String get classPhone => 'தொலைபேசி';

  @override
  String get classEmail => 'மின்னஞ்சல்';

  @override
  String get classIdNumber => 'அடையாள எண்';

  @override
  String get classBankCard => 'வங்கி அட்டை';

  @override
  String get classPlate => 'பிளேட்';

  @override
  String get classAccountId => 'கணக்கு';

  @override
  String get classAvatar => 'அவதார்';

  @override
  String get classFace => 'முகம்';

  @override
  String get classQr => 'QR குறியீடு';

  @override
  String get classBarcode => 'பார் கோடு';

  @override
  String get classManual => 'கைமுறை';

  @override
  String savedModelFailed(String error) {
    return 'சேமிக்கப்பட்ட மாதிரியை ஏற்ற முடியவில்லை; மீண்டும் ஒரு மாதிரியைத் தேர்ந்தெடுக்கவும். ($error)';
  }

  @override
  String get fillSurround => 'பின்னணி நிறம்';

  @override
  String get fillTinted => 'வண்ண மொசைக்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get classFinance => 'தொகை';

  @override
  String get delete => 'நீக்கு';

  @override
  String get undo => 'மீட்டமை';

  @override
  String get redo => 'மீண்டும் செய்';

  @override
  String get similar => 'ஒத்தவை';

  @override
  String get thisImage => 'இந்தப் படம்';

  @override
  String allImagesCount(int count) {
    return 'அனைத்து $count படங்களும்';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பகுதிகள் இன்னும் படிக்கக்கூடியதாக இருக்கலாம்',
      many: '$count பகுதிகள் இன்னும் படிக்கக்கூடியதாக இருக்கலாம்',
      few: '$count பகுதிகள் இன்னும் படிக்கக்கூடியதாக இருக்கலாம்',
      two: '2 பகுதிகள் இன்னும் படிக்கக்கூடியதாக இருக்கலாம்',
      one: '1 பகுதி இன்னும் படிக்கக்கூடியதாக இருக்கலாம்',
      zero: '0 பகுதிகள் இன்னும் படிக்கக்கூடியதாக இருக்கலாம்',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'மறைத்த பிறகு, சோதனை இன்னும் இந்தப் பகுதிகளை வெளியீட்டில் கண்டறியப்பட்டது.';

  @override
  String get redactThemAndExport => 'அவற்றை மறைத்து ஏற்றுமதி செய்';

  @override
  String get showThem => 'அவற்றைக் காட்டு';

  @override
  String get pickClass => 'ஒரு வகையைத் தேர்ந்தெடு';

  @override
  String get appearance => 'தோற்றம்';

  @override
  String get theme => 'தீம்';

  @override
  String get appIcon => 'ஆப்ஸ் ஐகான்';

  @override
  String get threshold => 'வரம்பு';

  @override
  String get thresholdLow => 'குறைவு';

  @override
  String get thresholdMedium => 'நடுத்தரம்';

  @override
  String get thresholdHigh => 'அதிகம்';

  @override
  String get redaction => 'மறைப்பு';

  @override
  String get style => 'தொகுப்பு';

  @override
  String get selectedByDefault => 'இயல்பாகத் தேர்ந்தெடுக்கப்பட்டது';

  @override
  String get dataPrivacy => 'தரவு மற்றும் தனியுரிமை';

  @override
  String get model => 'மாதிரி';

  @override
  String get importModel => 'மற்றொரு மாதிரியை இறக்குமதி செய்';

  @override
  String get advanced => 'மேம்பட்டது';

  @override
  String get about => 'பற்றி';

  @override
  String get licenses => 'திறந்த மூல உரிமங்கள்';

  @override
  String get merge => 'இணை';

  @override
  String get split => 'பிரி';

  @override
  String get mergeHint =>
      'அதே மதிப்பின் ஒரு பகுதியாக மாக்க மற்றொரு பெட்டியைத் தட்டவும்';

  @override
  String get classOrganization => 'நிறுவனம்';

  @override
  String get classDeviceId => 'சாதன ஐடி';

  @override
  String get classSecret => 'ரகசியத் தகவல்';

  @override
  String get classPerson => 'நபர்';

  @override
  String get classHealth => 'உடல்நலம்';

  @override
  String get classPersonalInfo => 'தனிப்பட்ட தகவல்';

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

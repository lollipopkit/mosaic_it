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
  String get reviewButton => 'சரிபார்க்கவும்';

  @override
  String get openingLabels => 'லேபிள்கள் திறக்கப்படுகின்றன…';

  @override
  String noImagesIn(String name) {
    return '$name இல் படங்கள் இல்லை';
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
  String get reviewPseudoLabels =>
      'நேரடி லேபிள்களை மதிப்பாய்வு செய்யவும் (coco.json உள்ள கோப்புறை)';

  @override
  String get regionsTooltip => 'பகுதிகள்';

  @override
  String get notCalibrated =>
      'மாதிரி கலிபிரேட் செய்யப்படவில்லை: முன்-தேர்வு ஒரு நிலையான தரநிலையைப் பயன்படுத்துகிறது.';

  @override
  String calibratedUnverified(String domain) {
    return 'சரிபார்க்கப்படாத தரவு ($domain) மீது கலிபிரேட் செய்யப்பட்டது: நினைவு உத்தரவாதம் இன்னும் பொருந்தாது.';
  }

  @override
  String calibratedFor(String domain) {
    return '$domain படங்களுக்கு கலிபிரேட் செய்யப்பட்டது. மற்ற வகையான படங்கள் உத்தரவாதத்திற்கு வெளியே உள்ளன.';
  }

  @override
  String get cameraPhoto =>
      'இது ஒரு கேமரா படம்; கண்டறியும் கருவி ஸ்கிரீன்ஷாட்களுக்கு உருவாக்கப்பட்டது, எனவே இங்கு அதன் பெட்டிகள் நம்பகமானவை அல்ல.';

  @override
  String get modeDraw => 'வரை';

  @override
  String get fillLabel => 'நிரப்பு';

  @override
  String get fillSolid => 'திட நிறம்';

  @override
  String get fillBlocks => 'சாம்பல் மொசைக்';

  @override
  String get fillNoise => 'சத்தம்';

  @override
  String get verifyNext => 'சரிபார் & அடுத்தது';

  @override
  String get export => 'ஏற்றுமதி செய்';

  @override
  String get pickOneModel => 'சரியாக ஒரு .onnx மாதிரியைத் தேர்ந்தெடுக்கவும்';

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
  String noLabelsIn(String name) {
    return '$name இல் coco.json இல்லை';
  }

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
  String get collectTitle => 'பயிற்சித் தரவைச் சேகரி';

  @override
  String get collectSubtitle =>
      'ஏற்றுமதி செய்த ஒவ்வொரு படம், கண்டறிந்த பகுதிகள் மற்றும் உங்கள் தேர்வுகளை எதிர்கால மாதிரிகளைப் பயிற்றுவிக்க இந்தச் சாதனத்தில் வைத்திருக்கவும். எதுவும் பதிவேற்றப்படாது.';

  @override
  String collectStats(int count, String size) {
    return '$count படங்கள் · $size';
  }

  @override
  String get collectDelete => 'சேகரித்த தரவை நீக்கு';

  @override
  String get collectDeleteConfirm =>
      'சேகரித்த எல்லாப் படங்களையும் தேர்வுகளையும் இந்தச் சாதனத்திலிருந்து நீக்கவா?';

  @override
  String get delete => 'நீக்கு';

  @override
  String collectFailed(String error) {
    return 'பயிற்சித் தரவைச் சேமிக்க முடியவில்லை: $error';
  }

  @override
  String labelsSaved(int count) {
    return '$count படங்களுக்கான லேபிள்கள் சேமிக்கப்பட்டன';
  }

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
  String annotateOf(int index, int total) {
    return '$index / $total குறிப்பிடவும்';
  }

  @override
  String get suggestions => 'பரிந்துரைகள்';

  @override
  String get skip => 'தவிர்';

  @override
  String get nothingPrivate => 'தனியுரிமை எதுவும் இல்லை';

  @override
  String get next => 'அடுத்தது';

  @override
  String get annotateHint =>
      'ஒரு உரை வரிசையைத் தட்டி பெட்டி இடவும், அல்லது வரையத் தள்ளவும்';

  @override
  String get annotationData => 'குறிப்புத் தரவு';

  @override
  String get statLabeled => 'குறிக்கப்பட்டவை';

  @override
  String get statEmpty => 'தனியுரிமை எதுவும் இல்லை';

  @override
  String get statSkipped => 'தவிர்க்கப்பட்டவை';

  @override
  String get boxesPerClass => 'வகைக்கு பெட்டிகள்';

  @override
  String get imagesHeader => 'படங்கள்';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பெட்டிகள்',
      many: '$count பெட்டிகள்',
      few: '$count பெட்டிகள்',
      two: '2 பெட்டிகள்',
      one: '1 பெட்டி',
      zero: '0 பெட்டிகள்',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'அனைத்தையும் ஏற்றுமதி செய்';

  @override
  String get deleteAll => 'அனைத்தையும் நீக்கு';

  @override
  String get annotateDeleteConfirm =>
      'இந்தச் சாதனத்திலிருந்து அனைத்து குறிப்புகளையும் மற்றும் அவற்றின் படங்களையும் நீக்கவா?';

  @override
  String get noAnnotations =>
      'இன்னும் குறிப்புகள் இல்லை. படங்களைத் தேர்ந்தெடுத்து \'குறிப்பிடவும்\' என்பதைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get filterScreenshots => 'ஸ்கிரீன்ஷாட்கள்';

  @override
  String get filterAll => 'அனைத்தும்';

  @override
  String get filterVideos => 'வீடியோக்கள்';

  @override
  String get albums => 'அலபங்கள்';

  @override
  String get limitedAccess =>
      'MosaicIt உங்கள் சில படங்களை மட்டுமே காண முடியும்';

  @override
  String get manage => 'நிர்வகி';

  @override
  String selectedImages(int count) {
    return '$count தேர்ந்தெடுக்கப்பட்டவை';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count படங்களை மறை',
      many: '$count படங்களை மறை',
      few: '$count படங்களை மறை',
      two: '2 படங்களை மறை',
      one: '1 படத்தை மறை',
      zero: '0 படங்களை மறை',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'குறிப்பிடவும்';

  @override
  String get badgeRedacted => 'மறைக்கப்பட்டது';

  @override
  String get badgeAnnotated => 'குறிக்கப்பட்டது';

  @override
  String get photosDenied =>
      'MosaicIt இங்கே அவற்றைக் காட்ட உங்கள் படங்களுக்கு அணுகல் தேவை. படங்கள் இந்தச் சாதனத்திலிருந்து வெளியேறாது.';

  @override
  String get openSettings => 'அமைப்புகளைத் திற';

  @override
  String get openFiles => 'கோப்புகளைத் திற';

  @override
  String get noPhotos => 'இங்கே படங்கள் இல்லை';

  @override
  String get loading => 'ஏற்றுகிறது…';

  @override
  String get appearance => 'தோற்றம்';

  @override
  String get theme => 'தீம்';

  @override
  String get appIcon => 'ஆப்ஸ் ஐகான்';

  @override
  String get aspectRatioGrid => 'தோற்ற விகிதக் கட்டம்';

  @override
  String get modelDownloadFailed => 'மாடலைப் பதிவிறக்க முடியவில்லை';

  @override
  String get retry => 'மீண்டும் முயல்';

  @override
  String get autoUpdateModel => 'மாடலைத் தானாகப் புதுப்பி';

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
  String get localOnly =>
      'இந்தச் சாதனத்தில் மட்டுமே வைக்கப்படுகிறது, iCloud அல்லது காப்பகங்களில் இல்லை.';

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
}

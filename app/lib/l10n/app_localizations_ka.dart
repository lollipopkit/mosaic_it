// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'მოდელის ჩატვირთვა…';

  @override
  String get modelFileType => 'მოდელი';

  @override
  String get useModel => 'მოდელის გამოყენება';

  @override
  String get imagesFileType => 'სურათები';

  @override
  String get detecting => 'დეტექტირება…';

  @override
  String detectingProgress(int current, int total) {
    return 'დეტექტირება $current/$total…';
  }

  @override
  String get chooseModelFirst => 'ჯერ აირჩიეთ მოდელი';

  @override
  String get findingSimilar => 'მსგავსების ძიება…';

  @override
  String similarSelected(int found, int added) {
    return 'აირჩიეს $found მსგავსი რეგიონი ($added ახალი)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'აირჩიეს $found მსგავსი რეგიონი ($added ახალი) $images სურათზე';
  }

  @override
  String get saving => 'შენახვა…';

  @override
  String get exportHere => 'ექსპორტი აქ';

  @override
  String exportStoppedAt(String name) {
    return 'ექსპორტი შეჩერდა $name-ზე';
  }

  @override
  String exportedTo(String path) {
    return 'ექსპორტირებულია $path-ში';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'ექსპორტირებულია $path-ში (აუდიო გარეშე)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ექსპორტირებულია $count სურათი',
      many: 'ექსპორტირებულია $count სურათი',
      few: 'ექსპორტირებულია $count სურათი',
      two: 'ექსპორტირებულია 2 სურათი',
      one: 'ექსპორტირებულია 1 სურათი',
      zero: 'ექსპორტირებულია 0 სურათი',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name-ის შემოწმება…';
  }

  @override
  String get checkingAndExporting => 'შემოწმება და ექსპორტი…';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get exportAnyway => 'ექსპორტი მაინც';

  @override
  String get regionsTooltip => 'რეგიონები';

  @override
  String get cameraPhoto =>
      'ეს კამერის ფოტოა; დეტექტორი ეკრანის სურათებისთვისაა შექმნილი, ამიტომ აქ მისი ყუთები არაიმედოვანია.';

  @override
  String get modeDraw => 'ხაზვა';

  @override
  String get fillSolid => 'ერთფეროვანი';

  @override
  String get fillBlocks => 'ნაცრისფერი მოზაიკა';

  @override
  String get fillNoise => 'ხმაური';

  @override
  String get export => 'ექსპორტი';

  @override
  String pickOneModel(String formats) {
    return 'აირჩიეთ ზუსტად ერთი $formats მოდელი';
  }

  @override
  String pickSidecar(String name) {
    return 'ასევე აირჩიეთ $name.json';
  }

  @override
  String get analysing => 'ანალიზი';

  @override
  String get followingRegion => 'რეგიონის მიყოლა';

  @override
  String get exporting => 'ექსპორტი';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count კადრი';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'რედაქტირება $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'ექსპორტის შემოწმება ვერ მოხერხდა $time-ზე';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count პირადი მონაცემების მსგავსი რეგიონი კვლავ ხილულია იქ ($classes).',
      many:
          '$count პირადი მონაცემების მსგავსი რეგიონი კვლავ ხილულია იქ ($classes).',
      few:
          '$count პირადი მონაცემების მსგავსი რეგიონი კვლავ ხილულია იქ ($classes).',
      two: '2 პირადი მონაცემების მსგავსი რეგიონი კვლავ ხილულია იქ ($classes).',
      one: '1 პირადი მონაცემების მსგავსი რეგიონი კვლავ ხილულია იქ ($classes).',
      zero:
          'პირადი მონაცემების მსგავსი რეგიონები არ არის ხილული იქ ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'კადრის ჩვენება';

  @override
  String get drawMissedRegion => 'ხაზეთ რეგიონი, რომელიც დეტექტორმა გამოტოვა';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on ტრეკი $total-დან რედაქტირებულია · $keyframes მთავარი კადრი';
  }

  @override
  String get keepAudio => 'აუდიოს შენახვა';

  @override
  String get keepAudioHint =>
      'ხმები და შეტყობინებების ჟღერადობები არ შემოწმდება';

  @override
  String get goToFirstAppearance => 'გადასვლა პირველ გამოჩენაზე';

  @override
  String get classPersonName => 'სახელი';

  @override
  String get classAddress => 'მისამართი';

  @override
  String get classPhone => 'ტელეფონი';

  @override
  String get classEmail => 'ელფოსტა';

  @override
  String get classIdNumber => 'იდენტიფიკაციის ნომერი';

  @override
  String get classBankCard => 'ბანკის ბარათი';

  @override
  String get classPlate => 'ნომრის ნიშანი';

  @override
  String get classAccountId => 'ანგარიში';

  @override
  String get classAvatar => 'ავატარი';

  @override
  String get classFace => 'სახე';

  @override
  String get classQr => 'QR კოდი';

  @override
  String get classBarcode => 'ბარკოდი';

  @override
  String get classManual => 'ხელით';

  @override
  String savedModelFailed(String error) {
    return 'შენახული მოდელი ვერ ჩაიტვირთა; აირჩიეთ მოდელი ხელახლა. ($error)';
  }

  @override
  String get fillSurround => 'ფონის ფერი';

  @override
  String get fillTinted => 'ფერადი მოზაიკა';

  @override
  String get settings => 'პარამეტრები';

  @override
  String get classFinance => 'თანხა';

  @override
  String get delete => 'წაშლა';

  @override
  String get undo => 'უკან დაბრუნება';

  @override
  String get redo => 'განმეორება';

  @override
  String get similar => 'მსგავსი';

  @override
  String get thisImage => 'ეს სურათი';

  @override
  String allImagesCount(int count) {
    return 'ყველა $count სურათი';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count არეა შეიძლება კიდევაც წაკითხვადი იყოს',
      many: '$count არეა შეიძლება კიდევაც წაკითხვადი იყოს',
      few: '$count არეა შეიძლება კიდევაც წაკითხვადი იყოს',
      two: '2 არეა შეიძლება კიდევაც წაკითხვადი იყოს',
      one: '1 არეა შეიძლება კიდევაც წაკითხვადი იყოს',
      zero: '0 არეა შეიძლება კიდევაც წაკითხვადი იყოს',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'დაფარვის შემდეგ, შემოწმებამ ამ არეალები კვლავ იპოვა გამოსავალში.';

  @override
  String get redactThemAndExport => 'დაფარე ისინი და ექსპორტი';

  @override
  String get showThem => 'ჩვენება';

  @override
  String get pickClass => 'კლასის არჩევა';

  @override
  String get appearance => 'გარეგნობა';

  @override
  String get theme => 'თემა';

  @override
  String get appIcon => 'აპის ხატულა';

  @override
  String get threshold => 'ზღვარი';

  @override
  String get thresholdLow => 'დაბალი';

  @override
  String get thresholdMedium => 'საშუალო';

  @override
  String get thresholdHigh => 'მაღალი';

  @override
  String get redaction => 'დაფარვა';

  @override
  String get style => 'სტილი';

  @override
  String get selectedByDefault => 'ნაგულისხმევად არჩეული';

  @override
  String get dataPrivacy => 'მონაცემები და კონფიდენციალურობა';

  @override
  String get model => 'მოდელი';

  @override
  String get importModel => 'სხვა მოდელის იმპორტი';

  @override
  String get advanced => 'გაფართოებული';

  @override
  String get about => 'აპლიკაციის შესახებ';

  @override
  String get licenses => 'ღია წყაროს ლიცენზიები';

  @override
  String get merge => 'შერწყმა';

  @override
  String get split => 'განცალკევება';

  @override
  String get mergeHint =>
      'დააწკაპუნეთ სხვა კოლოფზე, რომ ის იყოს იმავე მნიშვნელობის ნაწილი';

  @override
  String get classOrganization => 'ორგანიზაცია';

  @override
  String get classDeviceId => 'მოწყობილობის ID';

  @override
  String get classSecret => 'საიდუმლო მონაცემი';

  @override
  String get classPerson => 'პირი';

  @override
  String get classHealth => 'ჯანმრთელობა';

  @override
  String get classPersonalInfo => 'პირადი ინფორმაცია';

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
  String get selectMedia => 'Select photos';

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

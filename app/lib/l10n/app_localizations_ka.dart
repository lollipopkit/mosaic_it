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
  String get reviewButton => 'შემოწმება';

  @override
  String get openingLabels => 'მონიშვნების გახსნა…';

  @override
  String noImagesIn(String name) {
    return '$name-ში სურათები არ არის';
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
  String get reviewPseudoLabels =>
      'ფსევდომიწერების გადახედვა (coco.json-ის ფოლდერი)';

  @override
  String get regionsTooltip => 'რეგიონები';

  @override
  String get notCalibrated =>
      'მოდელი არ არის კალიბრირებული: წინასწარი არჩევა ფიქსირებულ ზღვარს იყენებს.';

  @override
  String calibratedUnverified(String domain) {
    return 'კალიბრირებულია ვერაფრად დადასტურებულ მონაცემებზე ($domain): დახსოვნის გარანტია ჯერ არ მოქმედებს.';
  }

  @override
  String calibratedFor(String domain) {
    return 'კალიბრირებულია $domain სურათებისთვის. სხვა ტიპის სურათები გარანტიის გარეთაა.';
  }

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
  String get verifyNext => 'დადასტურება და შემდეგი';

  @override
  String get export => 'ექსპორტი';

  @override
  String get pickOneModel => 'აირჩიეთ ზუსტად ერთი .onnx მოდელი';

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
  String noLabelsIn(String name) {
    return '$name-ში coco.json არ არის';
  }

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
  String get collectTitle => 'სასწავლო მონაცემების შეგროვება';

  @override
  String get collectSubtitle =>
      'ყოველი ექსპორტირებული სურათის, აღმოჩენილი არეების და თქვენი არჩევანის შენახვა ამ მოწყობილობაზე მომავალი მოდელების გასაწვრთნელად. არაფერი იტვირთება.';

  @override
  String collectStats(int count, String size) {
    return 'სურათები: $count · $size';
  }

  @override
  String get collectDelete => 'შეგროვებული მონაცემების წაშლა';

  @override
  String get collectDeleteConfirm =>
      'წაიშალოს ამ მოწყობილობიდან ყველა შეგროვებული სურათი და არჩევანი?';

  @override
  String get delete => 'წაშლა';

  @override
  String collectFailed(String error) {
    return 'სასწავლო მონაცემების შენახვა ვერ მოხერხდა: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'ჭდეები შენახულია $count სურათისთვის';
  }

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
  String annotateOf(int index, int total) {
    return 'ანოტაცია $index / $total';
  }

  @override
  String get suggestions => 'პროპოზიციები';

  @override
  String get skip => 'გადახტომა';

  @override
  String get nothingPrivate => 'არაფერი პირადი';

  @override
  String get next => 'შემდეგი';

  @override
  String get annotateHint =>
      'დააწკაპუნეთ ტექსტის სطرზე, რომ დააფაროთ ის, ან გადაათრიეთ ხაზის შესაქმნელად';

  @override
  String get annotationData => 'ანოტაციის მონაცემები';

  @override
  String get statLabeled => 'დასანიშნი';

  @override
  String get statEmpty => 'არაფერი პირადი';

  @override
  String get statSkipped => 'გადახტომილი';

  @override
  String get boxesPerClass => 'კოლოფები კლასის მიხედვით';

  @override
  String get imagesHeader => 'სურათები';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ყუთი',
      many: '$count ყუთი',
      few: '$count ყუთი',
      two: '2 ყუთი',
      one: '1 ყუთი',
      zero: '0 ყუთი',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'ყველას ექსპორტი';

  @override
  String get deleteAll => 'ყველას წაშლა';

  @override
  String get annotateDeleteConfirm =>
      'წაიშალოს ყველა ანოტაცია და მათი სურათები ამ მოწყობილობიდან?';

  @override
  String get noAnnotations =>
      'ჯერ არ არის ანოტაციები. აირჩიეთ სურათები და აირჩიეთ ანოტაცია.';

  @override
  String get filterScreenshots => 'ეკრანის სურათები';

  @override
  String get filterAll => 'ყველა';

  @override
  String get filterVideos => 'ვიდეოები';

  @override
  String get albums => 'ალბომები';

  @override
  String get limitedAccess => 'MosaicIt ხედავს მხოლოდ თქვენი ფოტოების ნაწილს';

  @override
  String get manage => 'მართვა';

  @override
  String selectedImages(int count) {
    return '$count არჩეული';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'დაფარეთ $count სურათი',
      many: 'დაფარეთ $count სურათი',
      few: 'დაფარეთ $count სურათი',
      two: 'დაფარეთ 2 სურათი',
      one: 'დაფარეთ 1 სურათი',
      zero: 'დაფარეთ 0 სურათი',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'ანოტაცია';

  @override
  String get badgeRedacted => 'დაფარული';

  @override
  String get badgeAnnotated => 'ანოტირებული';

  @override
  String get photosDenied =>
      'MosaicIt-ს სჭირდება თქვენი ფოტოების წვდომა, რომ აქ გამოიჩინოს ისინი. ფოტოები არასოდეს ტოვებენ ამ მოწყობილობას.';

  @override
  String get openSettings => 'პარამეტრების გახსნა';

  @override
  String get openFiles => 'ფაილების გახსნა';

  @override
  String get noPhotos => 'აქ ფოტოები არ არის';

  @override
  String get loading => 'იტვირთება…';

  @override
  String get appearance => 'გარეგნობა';

  @override
  String get theme => 'თემა';

  @override
  String get appIcon => 'აპის ხატულა';

  @override
  String get aspectRatioGrid => 'ბადე თანაფარდობის შენარჩუნებით';

  @override
  String get modelDownloadFailed => 'მოდელის ჩამოტვირთვა ვერ მოხერხდა';

  @override
  String get retry => 'ხელახლა ცდა';

  @override
  String get autoUpdateModel => 'მოდელის ავტომატური განახლება';

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
  String get localOnly =>
      'შენახულია მხოლოდ ამ მოწყობილობაზე, არასოდეს iCloud-ში ან სარეზერვო ასლებში.';

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
  String get downloadingDetector => 'Downloading the detector';

  @override
  String percent(int value) {
    return '$value%';
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Բեռնում է մոդելը…';

  @override
  String get modelFileType => 'Մոդել';

  @override
  String get useModel => 'Օգտագործել մոդելը';

  @override
  String get imagesFileType => 'Նկարներ';

  @override
  String get detecting => 'Նույնացնում է…';

  @override
  String detectingProgress(int current, int total) {
    return 'Նույնացնում է $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Նախ ընտրեք մոդել';

  @override
  String get findingSimilar => 'Որոնում է նմանատիպ…';

  @override
  String similarSelected(int found, int added) {
    return 'Ընտրված է $found նմանատիպ տարածք ($added նոր)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Ընտրված է $found նմանատիպ տարածք ($added նոր) $images նկարների մեջ';
  }

  @override
  String get reviewButton => 'Դիտարկել';

  @override
  String get openingLabels => 'Բացում է նշումները…';

  @override
  String noImagesIn(String name) {
    return 'Չկան նկարներ $name-ում';
  }

  @override
  String get saving => 'Պահպանում է…';

  @override
  String get exportHere => 'Արտահանել այստեղ';

  @override
  String exportStoppedAt(String name) {
    return 'Արտահանումը կանգնեցված է $name-ում';
  }

  @override
  String exportedTo(String path) {
    return 'Արտահանված է $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Արտահանված է $path (առանց ձայնի)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Արտահանված են $count նկար',
      many: 'Արտահանված են $count նկար',
      few: 'Արտահանված են $count նկար',
      two: 'Արտահանված են 2 նկար',
      one: 'Արտահանված է 1 նկար',
      zero: 'Արտահանված է 0 նկար',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Ստուգում է $name…';
  }

  @override
  String get checkingAndExporting => 'Ստուգում և արտահանում է…';

  @override
  String get cancel => 'Չեղարկել';

  @override
  String get exportAnyway => 'Արտահանել այնուամենայնիվ';

  @override
  String get reviewPseudoLabels =>
      'Դիտարկել կեղծ-նշումները (coco.json պարունակող թղթապանակ)';

  @override
  String get regionsTooltip => 'Տարածքներ';

  @override
  String get notCalibrated =>
      'Մոդելը չի կալիբրված. նախնական ընտրությունը օգտագործում է ֆիքսված շեմ։';

  @override
  String calibratedUnverified(String domain) {
    return 'Կալիբրված է ստուգված տվյալների վրա ($domain). Հիշողության երաշխիքը դեռ չի կիրառվում։';
  }

  @override
  String calibratedFor(String domain) {
    return 'Կալիբրված է $domain նկարների համար։ Այլ տեսակի նկարները երաշխիքի սահմաններից դուրս են։';
  }

  @override
  String get cameraPhoto =>
      'Սա ֆոտոխցիկի նկար է. հայտնաբերիչը նախատեսված է էկրանի նկարների համար, ուստի այստեղ նրա քառակուսիները անհուսալի են։';

  @override
  String get modeDraw => 'Նկարել';

  @override
  String get fillSolid => 'Միագույն';

  @override
  String get fillBlocks => 'Մոխրագույն խճանկար';

  @override
  String get fillNoise => 'Շեղում';

  @override
  String get verifyNext => 'Ստուգել և հաջորդը';

  @override
  String get export => 'Արտահանել';

  @override
  String get pickOneModel => 'Ընտրեք ճիշտ մեկ .onnx մոդել';

  @override
  String pickSidecar(String name) {
    return 'Ընտրեք նաև $name.json';
  }

  @override
  String get analysing => 'Վերլուծում է';

  @override
  String get followingRegion => 'Հետևում է տարածքին';

  @override
  String get exporting => 'Արտահանում է';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count կադրեր';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Ծածկում է $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Արտահանման ստուգումը ձախողվեց $time-ին';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count անձնական տեսքի տարածքներ դեռ երևում են այնտեղ ($classes)։',
      many: '$count անձնական տեսքի տարածքներ դեռ երևում են այնտեղ ($classes)։',
      few: '$count անձնական տեսքի տարածքներ դեռ երևում են այնտեղ ($classes)։',
      two: '2 անձնական տեսքի տարածքներ դեռ երևում են այնտեղ ($classes)։',
      one: '1 անձնական տեսքի տարածք դեռ երևում է այնտեղ ($classes)։',
      zero: '0 անձնական տեսքի տարածք չի երևում այնտեղ ($classes)։',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Ցուցադրել կադրը';

  @override
  String get drawMissedRegion => 'Նկարեք տարածք, որը բաց թողեց հայտնաբերիչը';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on / $total հետագաներ ծածկված · $keyframes հիմնական կադրեր';
  }

  @override
  String get keepAudio => 'Պահպանել ձայնը';

  @override
  String get keepAudioHint => 'Ձայները և ծանուցումների ձայները չեն ստուգվում';

  @override
  String get goToFirstAppearance => 'Ուղղվել առաջին հայտնվելուն';

  @override
  String get classPersonName => 'Անուն';

  @override
  String get classAddress => 'Հասցե';

  @override
  String get classPhone => 'Հեռախոս';

  @override
  String get classEmail => 'Էլ. փոստ';

  @override
  String get classIdNumber => 'Համարանիշ';

  @override
  String get classBankCard => 'Բանկային քարտ';

  @override
  String get classPlate => 'Նշան';

  @override
  String get classAccountId => 'Հաշիվ';

  @override
  String get classAvatar => 'Ավատար';

  @override
  String get classFace => 'Դեմք';

  @override
  String get classQr => 'QR կոդ';

  @override
  String get classBarcode => 'Շտրիխ-կոդ';

  @override
  String get classManual => 'Ձեռքով';

  @override
  String noLabelsIn(String name) {
    return '$name-ում coco.json չկա';
  }

  @override
  String savedModelFailed(String error) {
    return 'Պահպանված մոդելը չի կարող լիցքավորվել։ Ընտրեք մոդելը նորից։ ($error)';
  }

  @override
  String get fillSurround => 'Ֆոնի գույն';

  @override
  String get fillTinted => 'Գունավոր խճանկար';

  @override
  String get settings => 'Կարգավորումներ';

  @override
  String get classFinance => 'Գումար';

  @override
  String get collectTitle => 'Հավաքել ուսուցման տվյալներ';

  @override
  String get collectSubtitle =>
      'Պահել այս սարքում յուրաքանչյուր արտահանված պատկեր, հայտնաբերված տարածքները և ձեր ընտրությունները՝ ապագա մոդելներ ուսուցանելու համար։ Ոչինչ չի վերբեռնվում։';

  @override
  String collectStats(int count, String size) {
    return 'Պատկերներ՝ $count · $size';
  }

  @override
  String get collectDelete => 'Ջնջել հավաքված տվյալները';

  @override
  String get collectDeleteConfirm =>
      'Ջնջե՞լ այս սարքից բոլոր հավաքված պատկերներն ու ընտրությունները։';

  @override
  String get delete => 'Ջնջել';

  @override
  String collectFailed(String error) {
    return 'Չհաջողվեց պահել ուսուցման տվյալները՝ $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Պիտակները պահվեցին $count պատկերի համար';
  }

  @override
  String get undo => 'Վերադարձնել';

  @override
  String get redo => 'Կրկին կատարել';

  @override
  String get similar => 'Նմանատիպ';

  @override
  String get thisImage => 'Այս պատկերը';

  @override
  String allImagesCount(int count) {
    return 'Բոլոր $count պատկերները';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count տարածք կարող է դեռևս կարդալի լինել',
      many: '$count տարածք կարող է դեռևս կարդալի լինել',
      few: '$count տարածք կարող է դեռևս կարդալի լինել',
      two: '2 տարածք կարող է դեռևս կարդալի լինել',
      one: '1 տարածք կարող է դեռևս կարդալի լինել',
      zero: '0 տարածք կարող է դեռևս կարդալի լինել',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Թաքցումից հետո ստուգումը դեռևս գտավ այս տարածքները արդյունքում։';

  @override
  String get redactThemAndExport => 'Թաքցնել և արտահանել';

  @override
  String get showThem => 'Ցույց տալ';

  @override
  String get pickClass => 'Ընտրել դաս';

  @override
  String annotateOf(int index, int total) {
    return 'Կարգավորել $index / $total';
  }

  @override
  String get suggestions => 'Հուշումներ';

  @override
  String get skip => 'Բաց թողնել';

  @override
  String get nothingPrivate => 'Ոչինչ գաղտնի';

  @override
  String get next => 'Հաջորդը';

  @override
  String get annotateHint =>
      'Սեղմեք տեքստի տողին՝ փակելու համար, կամ քաշեք՝ նկարելու համար';

  @override
  String get annotationData => 'Կարգավորման տվյալներ';

  @override
  String get statLabeled => 'Կարգավորված';

  @override
  String get statEmpty => 'Ոչինչ գաղտնի';

  @override
  String get statSkipped => 'Բաց թողնված';

  @override
  String get boxesPerClass => 'Բաքսեր ըստ դասի';

  @override
  String get imagesHeader => 'Պատկերներ';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count քառակուսի',
      many: '$count քառակուսի',
      few: '$count քառակուսի',
      two: '2 քառակուսի',
      one: '1 քառակուսի',
      zero: '0 քառակուսի',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Արտահանել բոլորը';

  @override
  String get deleteAll => 'Ջնջել բոլորը';

  @override
  String get annotateDeleteConfirm =>
      'Ջնջե՞լ բոլոր կարգավորումները և դրանց պատկերները այս սարքից։';

  @override
  String get noAnnotations =>
      'Դեռ կարգավորումներ չկան։ Ընտրեք պատկերներ և ընտրեք «Կարգավորել»։';

  @override
  String get filterScreenshots => 'Էկրանի նկարներ';

  @override
  String get filterAll => 'Բոլորը';

  @override
  String get filterVideos => 'Տեսանյութեր';

  @override
  String get albums => 'Ալբոմներ';

  @override
  String get limitedAccess =>
      'MosaicIt-ը կարող է տեսնել ձեր լուսանկարների միայն մի մասը';

  @override
  String get manage => 'Կառավարել';

  @override
  String selectedImages(int count) {
    return '$count ընտրված';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Թաքցնել $count պատկեր',
      many: 'Թաքցնել $count պատկեր',
      few: 'Թաքցնել $count պատկեր',
      two: 'Թաքցնել 2 պատկեր',
      one: 'Թաքցնել 1 պատկեր',
      zero: 'Թաքցնել 0 պատկեր',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Կարգավորել';

  @override
  String get badgeRedacted => 'Թաքցված';

  @override
  String get badgeAnnotated => 'Կարգավորված';

  @override
  String get photosDenied =>
      'MosaicIt-ը ձեր լուսանկարներին հասանելիություն է պահանջում՝ դրանք այստեղ ցույց տալու համար։ Լուսանկարները երբեք չեն լքում այս սարքը։';

  @override
  String get openSettings => 'Բացել Կարգավորումները';

  @override
  String get openFiles => 'Բացել ֆայլերը';

  @override
  String get noPhotos => 'Այստեղ լուսանկարներ չկան';

  @override
  String get loading => 'Բեռնվում է…';

  @override
  String get appearance => 'Երևույթ';

  @override
  String get theme => 'Թեմա';

  @override
  String get appIcon => 'Հավելվածի պատկերակ';

  @override
  String get aspectRatioGrid => 'Ցանց՝ սկզբնական համամասնությամբ';

  @override
  String get modelDownloadFailed => 'Չհաջողվեց ներբեռնել մոդելը';

  @override
  String get retry => 'Կրկնել';

  @override
  String get autoUpdateModel => 'Ինքնաշխատ թարմացնել մոդելը';

  @override
  String get threshold => 'Շեմ';

  @override
  String get thresholdLow => 'Ցածր';

  @override
  String get thresholdMedium => 'Միջին';

  @override
  String get thresholdHigh => 'Բարձր';

  @override
  String get redaction => 'Թաքցում';

  @override
  String get style => 'Ստիլ';

  @override
  String get selectedByDefault => 'Ընտրված ըստ լռելյայնի';

  @override
  String get dataPrivacy => 'Տվյալներ և գաղտնիություն';

  @override
  String get localOnly =>
      'Պահվում է միայն այս սարքում, երբեք չի լինում iCloud-ում կամ պահուստներում։';

  @override
  String get model => 'Մոդել';

  @override
  String get importModel => 'Ներմուծել այլ մոդել';

  @override
  String get advanced => 'Առաջադեմ';

  @override
  String get about => 'Մասին';

  @override
  String get licenses => 'Բաց աղբյուրի թույլատրագրեր';

  @override
  String get merge => 'Միավորել';

  @override
  String get split => 'Վերաբաժանել';

  @override
  String get mergeHint =>
      'Սեղմեք մեկ այլ բաքս՝ դարձնելու համար նույն արժեքի մաս';

  @override
  String get classOrganization => 'Կազմակերպություն';

  @override
  String get classDeviceId => 'Սարքի ID';

  @override
  String get classSecret => 'Գաղտնի տվյալ';

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

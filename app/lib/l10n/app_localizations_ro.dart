// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Se încarcă modelul…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Folosește modelul';

  @override
  String get imagesFileType => 'Imagini';

  @override
  String get detecting => 'Se detectează…';

  @override
  String detectingProgress(int current, int total) {
    return 'Se detectează $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Alege mai întâi un model';

  @override
  String get findingSimilar => 'Se caută elemente similare…';

  @override
  String similarSelected(int found, int added) {
    return 'Au fost selectate $found regiuni similare ($added noi)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Au fost selectate $found regiuni similare ($added noi) în $images imagini';
  }

  @override
  String get saving => 'Se salvează…';

  @override
  String get exportHere => 'Exportă aici';

  @override
  String exportStoppedAt(String name) {
    return 'Exportul a fost oprit la $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exportat în $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exportat în $path (fără audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagini exportate',
      many: '$count imagini exportate',
      few: '$count imagini exportate',
      two: '2 imagini exportate',
      one: '1 imagine exportată',
      zero: '0 imagini exportate',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Se verifică $name…';
  }

  @override
  String get checkingAndExporting => 'Se verifică și se exportă…';

  @override
  String get cancel => 'Anulează';

  @override
  String get exportAnyway => 'Exportă oricum';

  @override
  String get regionsTooltip => 'Regiuni';

  @override
  String get notCalibrated =>
      'Modelul nu este calibrat: preselecția folosește un prag fix.';

  @override
  String calibratedUnverified(String domain) {
    return 'Calibrat pe date neverificate ($domain): garanția de recuperare nu se aplică încă.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Calibrat pentru imagini $domain. Alte tipuri de imagini sunt în afara garanției.';
  }

  @override
  String get cameraPhoto =>
      'Aceasta este o fotografie de cameră; detectorul este conceput pentru capturi de ecran, deci casetele de aici sunt nede-fiabile.';

  @override
  String get modeDraw => 'Desenare';

  @override
  String get fillSolid => 'Culoare uniformă';

  @override
  String get fillBlocks => 'Mozaic gri';

  @override
  String get fillNoise => 'Zgomot';

  @override
  String get export => 'Exportă';

  @override
  String pickOneModel(String formats) {
    return 'Alege exact un model $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Alege și $name.json';
  }

  @override
  String get analysing => 'Se analizează';

  @override
  String get followingRegion => 'Se urmărește regiunea';

  @override
  String get exporting => 'Se exportă';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count cadre';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Se redactează $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Verificarea exportului a eșuat la $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count regiuni care par private sunt încă vizibile acolo ($classes).',
      many:
          '$count regiuni care par private sunt încă vizibile acolo ($classes).',
      few:
          '$count regiuni care par private sunt încă vizibile acolo ($classes).',
      two: '2 regiuni care par private sunt încă vizibile acolo ($classes).',
      one: '1 regiune care pare privată este încă vizibilă acolo ($classes).',
      zero:
          'Nicio regiune care pare privată nu este vizibilă acolo ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Afișează cadrul';

  @override
  String get drawMissedRegion =>
      'Desenează o regiune pe care detectorul a ratat-o';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on din $total trasee redactate · $keyframes cadre cheie';
  }

  @override
  String get keepAudio => 'Păstrează audio';

  @override
  String get keepAudioHint =>
      'Vocile și sunetele de notificare nu sunt verificate';

  @override
  String get goToFirstAppearance => 'Mergi la prima apariție';

  @override
  String get classPersonName => 'Nume';

  @override
  String get classAddress => 'Adresă';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'Număr de identitate';

  @override
  String get classBankCard => 'Card bancar';

  @override
  String get classPlate => 'Plachetă';

  @override
  String get classAccountId => 'Cont';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Față';

  @override
  String get classQr => 'Cod QR';

  @override
  String get classBarcode => 'Cod de bare';

  @override
  String get classManual => 'Manual';

  @override
  String savedModelFailed(String error) {
    return 'Modelul salvat nu a putut fi încărcat; selectați din nou un model. ($error)';
  }

  @override
  String get fillSurround => 'Culoarea fundalului';

  @override
  String get fillTinted => 'Mozaic color';

  @override
  String get settings => 'Setări';

  @override
  String get classFinance => 'Sumă';

  @override
  String get delete => 'Șterge';

  @override
  String get undo => 'Anulează';

  @override
  String get redo => 'Refă';

  @override
  String get similar => 'Similar';

  @override
  String get thisImage => 'Această imagine';

  @override
  String allImagesCount(int count) {
    return 'Toate cele $count imagini';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de zone pot fi încă lizibile',
      many: 'multe zone pot fi încă lizibile',
      few: 'câteva zone pot fi încă lizibile',
      two: '2 zone pot fi încă lizibile',
      one: '1 zonă poate fi încă lizibilă',
      zero: '0 zone poate fi încă lizibilă',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'După redactare, verificarea a găsit totuși aceste zone în ieșire.';

  @override
  String get redactThemAndExport => 'Redactează-le și exportă';

  @override
  String get showThem => 'Afișează-le';

  @override
  String get pickClass => 'Alege o clasă';

  @override
  String get filterScreenshots => 'Capturi de ecran';

  @override
  String get filterAll => 'Toate';

  @override
  String get filterVideos => 'Videoclipuri';

  @override
  String get albums => 'Albume';

  @override
  String get limitedAccess =>
      'MosaicIt poate vedea doar unele dintre fotografiile tale';

  @override
  String get manage => 'Gestionează';

  @override
  String selectedImages(int count) {
    return '$count selectate';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redactează $count de imagini',
      many: 'Redactează multe imagini',
      few: 'Redactează câteva imagini',
      two: 'Redactează 2 imagini',
      one: 'Redactează 1 imagine',
      zero: 'Redactează 0 imagini',
    );
    return '$_temp0';
  }

  @override
  String get badgeRedacted => 'Redactată';

  @override
  String get photosDenied =>
      'MosaicIt are nevoie de acces la fotografiile tale pentru a le afișa aici. Fotografiile nu părăsc niciodată acest dispozitiv.';

  @override
  String get openSettings => 'Deschide Setări';

  @override
  String get openFiles => 'Deschide fișiere';

  @override
  String get noPhotos => 'Nicio fotografie aici';

  @override
  String get loading => 'Se încarcă…';

  @override
  String get appearance => 'Aspect';

  @override
  String get theme => 'Temă';

  @override
  String get appIcon => 'Pictograma aplicației';

  @override
  String get aspectRatioGrid => 'Grilă cu raport de aspect';

  @override
  String get threshold => 'Prag';

  @override
  String get thresholdLow => 'Scăzut';

  @override
  String get thresholdMedium => 'Mediu';

  @override
  String get thresholdHigh => 'Ridicat';

  @override
  String get redaction => 'Redactare';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Selectate implicit';

  @override
  String get dataPrivacy => 'Date și confidențialitate';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Importă alt model';

  @override
  String get advanced => 'Avansat';

  @override
  String get about => 'Despre';

  @override
  String get licenses => 'Licențe open-source';

  @override
  String get merge => 'Îmbină';

  @override
  String get split => 'Desparte';

  @override
  String get mergeHint =>
      'Atinge o altă casetă pentru a o face parte din aceeași valoare';

  @override
  String get classOrganization => 'Organizație';

  @override
  String get classDeviceId => 'ID dispozitiv';

  @override
  String get classSecret => 'Secret';

  @override
  String get classPerson => 'Persoană';

  @override
  String get classHealth => 'Sănătate';

  @override
  String get classPersonalInfo => 'Date personale';

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
  String get introNoNetPermBody =>
      'No Android INTERNET permission · no macOS network entitlement';

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
}

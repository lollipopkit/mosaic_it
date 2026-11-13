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
  String get reviewButton => 'Verifică';

  @override
  String get openingLabels => 'Se deschid etichetele…';

  @override
  String noImagesIn(String name) {
    return 'Nu există imagini în $name';
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
  String get reviewPseudoLabels =>
      'Verificați etichetele pseudo (dosar cu coco.json)';

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
  String get fillLabel => 'Umplere';

  @override
  String get fillSolid => 'Culoare uniformă';

  @override
  String get fillBlocks => 'Mozaic gri';

  @override
  String get fillNoise => 'Zgomot';

  @override
  String get verifyNext => 'Verifică și următorul';

  @override
  String get export => 'Exportă';

  @override
  String get pickOneModel => 'Alege exact un model .onnx';

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
  String noLabelsIn(String name) {
    return 'Nu există coco.json în $name';
  }

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
  String get collectTitle => 'Colectează date de antrenare';

  @override
  String get collectSubtitle =>
      'Păstrează pe acest dispozitiv fiecare imagine exportată, zonele detectate și alegerile tale pentru antrenarea modelelor viitoare. Nimic nu este încărcat.';

  @override
  String collectStats(int count, String size) {
    return '$count imagini · $size';
  }

  @override
  String get collectDelete => 'Șterge datele colectate';

  @override
  String get collectDeleteConfirm =>
      'Ștergi de pe acest dispozitiv toate imaginile și alegerile colectate?';

  @override
  String get delete => 'Șterge';

  @override
  String collectFailed(String error) {
    return 'Datele de antrenare nu au putut fi salvate: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Etichete salvate pentru $count imagini';
  }

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
  String annotateOf(int index, int total) {
    return 'Anotează $index / $total';
  }

  @override
  String get suggestions => 'Sugestii';

  @override
  String get skip => 'Omite';

  @override
  String get nothingPrivate => 'Nimic privat';

  @override
  String get next => 'Următorul';

  @override
  String get annotateHint =>
      'Atinge o linie de text pentru a o încadra sau trage pentru a desena';

  @override
  String get annotationData => 'Date de anotație';

  @override
  String get statLabeled => 'Etichetate';

  @override
  String get statEmpty => 'Nimic privat';

  @override
  String get statSkipped => 'Omise';

  @override
  String get boxesPerClass => 'Casete pe clasă';

  @override
  String get imagesHeader => 'Imagini';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de casete',
      many: 'multe casete',
      few: 'câteva casete',
      two: '2 casete',
      one: '1 casetă',
      zero: '0 casete',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Exportă tot';

  @override
  String get deleteAll => 'Șterge tot';

  @override
  String get annotateDeleteConfirm =>
      'Ștergi toate anotațiile și imaginile lor de pe acest dispozitiv?';

  @override
  String get noAnnotations =>
      'Nicio anotație încă. Selectează imagini și alege Anotează.';

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
  String get annotate => 'Anotează';

  @override
  String get badgeRedacted => 'Redactată';

  @override
  String get badgeAnnotated => 'Anotată';

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
  String get modelDownloadFailed => 'Modelul nu a putut fi descărcat';

  @override
  String get retry => 'Reîncearcă';

  @override
  String get autoUpdateModel => 'Actualizează modelul automat';

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
  String get localOnly =>
      'Păstrate doar pe acest dispozitiv, niciodată în iCloud sau în copii de rezervă.';

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
}

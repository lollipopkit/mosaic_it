// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Učitavanje modela…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Koristi model';

  @override
  String get imagesFileType => 'Slike';

  @override
  String get detecting => 'Pretraživanje…';

  @override
  String detectingProgress(int current, int total) {
    return 'Pretraživanje $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Prvo odaberite model';

  @override
  String get findingSimilar => 'Pronalaženje sličnih…';

  @override
  String similarSelected(int found, int added) {
    return 'Odabrano $found sličnih područja ($added novih)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Odabrano $found sličnih područja ($added novih) u $images slika';
  }

  @override
  String get reviewButton => 'Pregledaj';

  @override
  String get openingLabels => 'Otvarama oznake…';

  @override
  String noImagesIn(String name) {
    return 'Nema slika u $name';
  }

  @override
  String get saving => 'Spremanje…';

  @override
  String get exportHere => 'Izvezi ovdje';

  @override
  String exportStoppedAt(String name) {
    return 'Izvoz zaustavljen na $name';
  }

  @override
  String exportedTo(String path) {
    return 'Izvezeno u $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Izvezeno u $path (bez zvuka)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izvezeno $count slika',
      many: 'Izvezeno $count slika',
      few: 'Izvezeno $count slike',
      one: 'Izvezena 1 slika',
      zero: 'Izvezeno 0 slika',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Provjeravanje $name…';
  }

  @override
  String get checkingAndExporting => 'Provjeravanje i izvoz…';

  @override
  String get cancel => 'Odustani';

  @override
  String get exportAnyway => 'Izvezi ipak';

  @override
  String get reviewPseudoLabels =>
      'Pregledajte lažne oznake (mapa s coco.json)';

  @override
  String get regionsTooltip => 'Područja';

  @override
  String get notCalibrated =>
      'Model nije kalibriran: preodabir koristi fiksni prag.';

  @override
  String calibratedUnverified(String domain) {
    return 'Kalibrirano na neprovjerenim podacima ($domain): garancija prepoznavanja još ne vrijedi.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Kalibrirano za slike $domain. Ostale vrste slika nisu pokrivene garancijom.';
  }

  @override
  String get cameraPhoto =>
      'Ovo je fotografija s kamere; detektor je namijenjen za snimke ekrana, pa su ovdje njegovi okviri nepouzdani.';

  @override
  String get modeDraw => 'Crtaj';

  @override
  String get fillSolid => 'Jednobojno';

  @override
  String get fillBlocks => 'Sivi mozaik';

  @override
  String get fillNoise => 'Šum';

  @override
  String get verifyNext => 'Provjeri i sljedeće';

  @override
  String get export => 'Izvezi';

  @override
  String get pickOneModel => 'Odaberite točno jedan .onnx model';

  @override
  String pickSidecar(String name) {
    return 'Također odaberite $name.json';
  }

  @override
  String get analysing => 'Analiziranje';

  @override
  String get followingRegion => 'Praćenje područja';

  @override
  String get exporting => 'Izvoz';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count slika';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Cenzuriranje $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Neuspjela provjera izvoza u $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count područja koja izgledaju kao privatna još su vidljiva tamo ($classes).',
      many:
          '$count područja koja izgledaju kao privatna još su vidljiva tamo ($classes).',
      few:
          '$count područja koja izgledaju kao privatna još su vidljiva tamo ($classes).',
      one:
          '1 područje koje izgleda kao privatno još je vidljivo tamo ($classes).',
      zero:
          '0 područja koja izgledaju kao privatna još je vidljivo tamo ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Prikaži sliku';

  @override
  String get drawMissedRegion =>
      'Nacrtajte područje koje je detektor propustio';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return 'Cenzurirano $on od $total staza · $keyframes ključnih slika';
  }

  @override
  String get keepAudio => 'Zadrži zvuk';

  @override
  String get keepAudioHint => 'Glasovi i zvukovi obavijesti se ne provjeravaju';

  @override
  String get goToFirstAppearance => 'Idi na prvo pojavljivanje';

  @override
  String get classPersonName => 'Ime';

  @override
  String get classAddress => 'Adresa';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-pošta';

  @override
  String get classIdNumber => 'OIB';

  @override
  String get classBankCard => 'Bankovna kartica';

  @override
  String get classPlate => 'Registracija';

  @override
  String get classAccountId => 'Račun';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Lice';

  @override
  String get classQr => 'QR kod';

  @override
  String get classBarcode => 'Crtasti kod';

  @override
  String get classManual => 'Ručno';

  @override
  String noLabelsIn(String name) {
    return 'Nema coco.json u $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Spremljeni model nije moguće učitati; odaberite model ponovno. ($error)';
  }

  @override
  String get fillSurround => 'Boja pozadine';

  @override
  String get fillTinted => 'Mozaik u boji';

  @override
  String get settings => 'Postavke';

  @override
  String get classFinance => 'Iznos';

  @override
  String get collectTitle => 'Prikupljaj podatke za učenje';

  @override
  String get collectSubtitle =>
      'Spremi na ovaj uređaj svaku izvezenu sliku, pronađena područja i tvoje odabire za učenje budućih modela. Ništa se ne prenosi.';

  @override
  String collectStats(int count, String size) {
    return 'Slike: $count · $size';
  }

  @override
  String get collectDelete => 'Izbriši prikupljene podatke';

  @override
  String get collectDeleteConfirm =>
      'Izbrisati s ovog uređaja sve prikupljene slike i odabire?';

  @override
  String get delete => 'Izbriši';

  @override
  String collectFailed(String error) {
    return 'Podaci za učenje nisu spremljeni: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Oznake spremljene za slike: $count';
  }

  @override
  String get undo => 'Poništi';

  @override
  String get redo => 'Ponovi';

  @override
  String get similar => 'Slično';

  @override
  String get thisImage => 'Ova slika';

  @override
  String allImagesCount(int count) {
    return 'Sve $count slika';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count područja mogu još uvijek biti čitljiva',
      many: 'Nekoliko područja može još uvijek biti čitljivo',
      few: 'Nekoliko područja može još uvijek biti čitljivo',
      two: '2 područja mogu još uvijek biti čitljiva',
      one: '1 područje može još uvijek biti čitljivo',
      zero: 'Nijedno područje nije više čitljivo',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Nakon maskiranja, provjera je u izlazu i dalje pronašla ova područja.';

  @override
  String get redactThemAndExport => 'Maskiraj ih i izvezi';

  @override
  String get showThem => 'Prikaži ih';

  @override
  String get pickClass => 'Odaberite klasu';

  @override
  String annotateOf(int index, int total) {
    return 'Označi $index / $total';
  }

  @override
  String get suggestions => 'Prijedlozi';

  @override
  String get skip => 'Preskoči';

  @override
  String get nothingPrivate => 'Nema privatnih podataka';

  @override
  String get next => 'Dalje';

  @override
  String get annotateHint =>
      'Dodirnite redak teksta da ga okružite ili povucite da nacrtate okvir';

  @override
  String get annotationData => 'Podaci za označavanje';

  @override
  String get statLabeled => 'Označeno';

  @override
  String get statEmpty => 'Nema privatnih podataka';

  @override
  String get statSkipped => 'Preskočeno';

  @override
  String get boxesPerClass => 'Okviri po klasi';

  @override
  String get imagesHeader => 'Slike';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count okvira',
      many: 'Nekoliko okvira',
      few: 'Nekoliko okvira',
      two: '2 okvira',
      one: '1 okvir',
      zero: '0 okvira',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Izvezi sve';

  @override
  String get deleteAll => 'Izbriši sve';

  @override
  String get annotateDeleteConfirm =>
      'Želite li izbrisati sva označavanja i njihove slike s ovog uređaja?';

  @override
  String get noAnnotations =>
      'Još nema označavanja. Odaberite slike i odaberite Označi.';

  @override
  String get filterScreenshots => 'Snimke ekrana';

  @override
  String get filterAll => 'Sve';

  @override
  String get filterVideos => 'Videi';

  @override
  String get albums => 'Albumi';

  @override
  String get limitedAccess =>
      'MosaicIt može vidjeti samo neke od vaših fotografija';

  @override
  String get manage => 'Upravljanje';

  @override
  String selectedImages(int count) {
    return '$count odabrano';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cenzuriraj $count slika',
      many: 'Cenzuriraj nekoliko slika',
      few: 'Cenzuriraj nekoliko slika',
      two: 'Cenzuriraj 2 slike',
      one: 'Cenzuriraj 1 sliku',
      zero: 'Cenzuriraj 0 slika',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Označi';

  @override
  String get badgeRedacted => 'Maskirano';

  @override
  String get badgeAnnotated => 'Označeno';

  @override
  String get photosDenied =>
      'MosaicItu je potreban pristup vašim fotografijama kako bi ih prikazao ovdje. Fotografije nikada ne napuštaju ovaj uređaj.';

  @override
  String get openSettings => 'Otvori Postavke';

  @override
  String get openFiles => 'Otvori datoteke';

  @override
  String get noPhotos => 'Nema fotografija ovdje';

  @override
  String get loading => 'Učitavanje…';

  @override
  String get appearance => 'Izgled';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Ikona aplikacije';

  @override
  String get aspectRatioGrid => 'Rešetka s omjerom slike';

  @override
  String get modelDownloadFailed => 'Model se nije mogao preuzeti';

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get autoUpdateModel => 'Automatski ažuriraj model';

  @override
  String get threshold => 'Prag';

  @override
  String get thresholdLow => 'Nizak';

  @override
  String get thresholdMedium => 'Srednji';

  @override
  String get thresholdHigh => 'Visok';

  @override
  String get redaction => 'Maskiranje';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Zadano odabrano';

  @override
  String get dataPrivacy => 'Podaci i privatnost';

  @override
  String get localOnly =>
      'Čuva se samo na ovom uređaju, nikada u iCloudu ili sigurnosnim kopijama.';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Uvezi drugi model';

  @override
  String get advanced => 'Napredno';

  @override
  String get about => 'O aplikaciji';

  @override
  String get licenses => 'Licence otvorenog koda';

  @override
  String get merge => 'Spoji';

  @override
  String get split => 'Razdvoji';

  @override
  String get mergeHint =>
      'Dodirnite drugi okvir da postane dio iste vrijednosti';

  @override
  String get classOrganization => 'Organizacija';

  @override
  String get classDeviceId => 'ID uređaja';

  @override
  String get classSecret => 'Tajna';

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

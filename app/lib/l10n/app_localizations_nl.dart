// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Model wordt geladen…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Model gebruiken';

  @override
  String get imagesFileType => 'Afbeeldingen';

  @override
  String get detecting => 'Detecteren…';

  @override
  String detectingProgress(int current, int total) {
    return 'Detecteren $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Kies eerst een model';

  @override
  String get findingSimilar => 'Soortgelijke zoeken…';

  @override
  String similarSelected(int found, int added) {
    return '$found soortgelijke regio’s geselecteerd ($added nieuw)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found soortgelijke regio’s geselecteerd ($added nieuw) in $images afbeeldingen';
  }

  @override
  String get reviewButton => 'Controleren';

  @override
  String get openingLabels => 'Labels openen…';

  @override
  String noImagesIn(String name) {
    return 'Geen afbeeldingen in $name';
  }

  @override
  String get saving => 'Opslaan…';

  @override
  String get exportHere => 'Hier exporteren';

  @override
  String exportStoppedAt(String name) {
    return 'Export gestopt bij $name';
  }

  @override
  String exportedTo(String path) {
    return 'Geëxporteerd naar $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Geëxporteerd naar $path (geen audio)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count afbeeldingen geëxporteerd',
      one: '1 afbeelding geëxporteerd',
      zero: '0 afbeeldingen geëxporteerd',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name controleren…';
  }

  @override
  String get checkingAndExporting => 'Controleren en exporteren…';

  @override
  String get cancel => 'Annuleren';

  @override
  String get exportAnyway => 'Toch exporteren';

  @override
  String get reviewPseudoLabels =>
      'Pseudolabels controleren (map met coco.json)';

  @override
  String get regionsTooltip => 'Regio’s';

  @override
  String get notCalibrated =>
      'Model is niet gekalibreerd: de voorselectie gebruikt een vaste drempelwaarde.';

  @override
  String calibratedUnverified(String domain) {
    return 'Gekalibreerd op ongeverifieerde gegevens ($domain): de recall-garantie geldt nog niet.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Gekalibreerd voor $domain-afbeeldingen. Andere soorten afbeeldingen vallen buiten de garantie.';
  }

  @override
  String get cameraPhoto =>
      'Dit is een camerfoto; de detector is gemaakt voor screenshots, dus de kaders hier zijn onbetrouwbaar.';

  @override
  String get modeDraw => 'Tekenen';

  @override
  String get fillLabel => 'Vulling';

  @override
  String get fillSolid => 'Effen kleur';

  @override
  String get fillBlocks => 'Grijs mozaïek';

  @override
  String get fillNoise => 'Ruis';

  @override
  String get verifyNext => 'Verifiëren & volgende';

  @override
  String get export => 'Exporteren';

  @override
  String get pickOneModel => 'Kies exact één .onnx-model';

  @override
  String pickSidecar(String name) {
    return 'Kies ook $name.json';
  }

  @override
  String get analysing => 'Analyseren';

  @override
  String get followingRegion => 'Regio volgen';

  @override
  String get exporting => 'Exporteren';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count frames';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redigeren $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Exportcontrole mislukt op $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count privé-achtige regio’s zijn nog zichtbaar daar ($classes).',
      one: '1 privé-achtige regio is nog zichtbaar daar ($classes).',
      zero: '0 privé-achtige regio’s zijn nog zichtbaar daar ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Frame tonen';

  @override
  String get drawMissedRegion => 'Teken een regio die de detector miste';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on van $total tracks geredigeerd · $keyframes sleutelframes';
  }

  @override
  String get keepAudio => 'Audio behouden';

  @override
  String get keepAudioHint =>
      'Stemmen en meldinggeluiden worden niet gecontroleerd';

  @override
  String get goToFirstAppearance => 'Ga naar eerste verschijning';

  @override
  String get classPersonName => 'Naam';

  @override
  String get classAddress => 'Adres';

  @override
  String get classPhone => 'Telefoon';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'ID-nummer';

  @override
  String get classBankCard => 'Bankpas';

  @override
  String get classPlate => 'Kenteken';

  @override
  String get classAccountId => 'Account';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Gezicht';

  @override
  String get classQr => 'QR-code';

  @override
  String get classBarcode => 'Streepjescode';

  @override
  String get classManual => 'Handmatig';

  @override
  String noLabelsIn(String name) {
    return 'Geen coco.json in $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Het opgeslagen model kon niet worden geladen; kies opnieuw een model. ($error)';
  }

  @override
  String get fillSurround => 'Achtergrondkleur';

  @override
  String get fillTinted => 'Kleurenmozaïek';

  @override
  String get settings => 'Instellingen';

  @override
  String get classFinance => 'Bedrag';

  @override
  String get collectTitle => 'Trainingsgegevens verzamelen';

  @override
  String get collectSubtitle =>
      'Elke geëxporteerde afbeelding, de gevonden vakken en je keuzes op dit apparaat bewaren om toekomstige modellen te trainen. Er wordt niets geüpload.';

  @override
  String collectStats(int count, String size) {
    return '$count afbeeldingen · $size';
  }

  @override
  String get collectDelete => 'Verzamelde gegevens verwijderen';

  @override
  String get collectDeleteConfirm =>
      'Alle verzamelde afbeeldingen en keuzes van dit apparaat verwijderen?';

  @override
  String get delete => 'Verwijderen';

  @override
  String collectFailed(String error) {
    return 'Trainingsgegevens konden niet worden opgeslagen: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Labels opgeslagen voor $count afbeeldingen';
  }

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get redo => 'Opnieuw uitvoeren';

  @override
  String get similar => 'Vergelijkbaar';

  @override
  String get thisImage => 'Deze afbeelding';

  @override
  String allImagesCount(int count) {
    return 'Alle $count afbeeldingen';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gebieden zijn mogelijk nog leesbaar',
      one: '1 gebied is mogelijk nog leesbaar',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Na het redigeren vond de controle nog steeds deze gebieden in de uitvoer.';

  @override
  String get redactThemAndExport => 'Redigeer en exporteer';

  @override
  String get showThem => 'Toon ze';

  @override
  String get pickClass => 'Kies een klasse';

  @override
  String annotateOf(int index, int total) {
    return 'Annoteer $index / $total';
  }

  @override
  String get suggestions => 'Suggesties';

  @override
  String get skip => 'Overslaan';

  @override
  String get nothingPrivate => 'Geen privé-informatie';

  @override
  String get next => 'Volgende';

  @override
  String get annotateHint =>
      'Tik op een tekstregel om een vak te plaatsen, of sleep om te tekenen';

  @override
  String get annotationData => 'Annotatiegegevens';

  @override
  String get statLabeled => 'Gelabeld';

  @override
  String get statEmpty => 'Geen privé-informatie';

  @override
  String get statSkipped => 'Overgeslagen';

  @override
  String get boxesPerClass => 'Vakken per klasse';

  @override
  String get imagesHeader => 'Afbeeldingen';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vakken',
      one: '1 vak',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Alles exporteren';

  @override
  String get deleteAll => 'Alles verwijderen';

  @override
  String get annotateDeleteConfirm =>
      'Alle annotaties en bijbehorende afbeeldingen van dit apparaat verwijderen?';

  @override
  String get noAnnotations =>
      'Nog geen annotaties. Selecteer afbeeldingen en kies Annoteren.';

  @override
  String get filterScreenshots => 'Schermafbeeldingen';

  @override
  String get filterAll => 'Alles';

  @override
  String get filterVideos => 'Video\'s';

  @override
  String get albums => 'Albums';

  @override
  String get limitedAccess => 'MosaicIt kan alleen sommige van je foto\'s zien';

  @override
  String get manage => 'Beheren';

  @override
  String selectedImages(int count) {
    return '$count geselecteerd';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count afbeeldingen redigeren',
      one: '1 afbeelding redigeren',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annoteren';

  @override
  String get badgeRedacted => 'Geredigeerd';

  @override
  String get badgeAnnotated => 'Geannoteerd';

  @override
  String get photosDenied =>
      'MosaicIt heeft toegang tot je foto\'s nodig om ze hier te tonen. Foto\'s verlaten dit apparaat nooit.';

  @override
  String get openSettings => 'Open Instellingen';

  @override
  String get openFiles => 'Bestanden openen';

  @override
  String get noPhotos => 'Geen foto\'s hier';

  @override
  String get loading => 'Laden…';

  @override
  String get appearance => 'Weergave';

  @override
  String get theme => 'Thema';

  @override
  String get appIcon => 'App-symbool';

  @override
  String get aspectRatioGrid => 'Raster met originele verhouding';

  @override
  String get modelDownloadFailed => 'Het model kon niet worden gedownload';

  @override
  String get retry => 'Opnieuw';

  @override
  String get autoUpdateModel => 'Model automatisch bijwerken';

  @override
  String get threshold => 'Drempel';

  @override
  String get thresholdLow => 'Laag';

  @override
  String get thresholdMedium => 'Middel';

  @override
  String get thresholdHigh => 'Hoog';

  @override
  String get redaction => 'Redigeren';

  @override
  String get style => 'Stijl';

  @override
  String get selectedByDefault => 'Standaard geselecteerd';

  @override
  String get dataPrivacy => 'Gegevens en privacy';

  @override
  String get localOnly =>
      'Alleen op dit apparaat opgeslagen, nooit in iCloud of back-ups.';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Ander model importeren';

  @override
  String get advanced => 'Geavanceerd';

  @override
  String get about => 'Over';

  @override
  String get licenses => 'Open-source licenties';

  @override
  String get merge => 'Samenvoegen';

  @override
  String get split => 'Splitsen';

  @override
  String get mergeHint =>
      'Tik op een ander vak om het deel te maken van dezelfde waarde';

  @override
  String get classOrganization => 'Organisatie';

  @override
  String get classDeviceId => 'Apparaat-ID';

  @override
  String get classSecret => 'Geheim';
}

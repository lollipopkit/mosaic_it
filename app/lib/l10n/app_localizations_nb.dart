// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Laster modell…';

  @override
  String get modelFileType => 'Modeller';

  @override
  String get useModel => 'Bruk modell';

  @override
  String get imagesFileType => 'Bilder';

  @override
  String get detecting => 'Søker…';

  @override
  String detectingProgress(int current, int total) {
    return 'Søker $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Velg en modell først';

  @override
  String get findingSimilar => 'Søker etter lignende…';

  @override
  String similarSelected(int found, int added) {
    return '$found lignende områder valgt ($added nye)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found lignende områder valgt ($added nye) i $images bilder';
  }

  @override
  String get reviewButton => 'Gjennomgå';

  @override
  String get openingLabels => 'Åpner etiketter…';

  @override
  String noImagesIn(String name) {
    return 'Ingen bilder i $name';
  }

  @override
  String get saving => 'Lagrer…';

  @override
  String get exportHere => 'Eksporter hit';

  @override
  String exportStoppedAt(String name) {
    return 'Eksportering stoppet ved $name';
  }

  @override
  String exportedTo(String path) {
    return 'Eksportert til $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Eksportert til $path (uten lyd)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eksportert $count bilder',
      many: 'Eksportert $count bilder',
      few: 'Eksportert $count bilder',
      two: 'Eksportert 2 bilder',
      one: 'Eksportert 1 bilde',
      zero: 'Eksportert 0 bilder',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Sjekker $name…';
  }

  @override
  String get checkingAndExporting => 'Sjekker og eksporterer…';

  @override
  String get cancel => 'Avbryt';

  @override
  String get exportAnyway => 'Eksporter likevel';

  @override
  String get reviewPseudoLabels =>
      'Gjennomgå pseudoetiketter (mappe med coco.json)';

  @override
  String get regionsTooltip => 'Områder';

  @override
  String get notCalibrated =>
      'Modellen er ikke kalibrert: forhåndsvalg bruker en fast terskel.';

  @override
  String calibratedUnverified(String domain) {
    return 'Kalibrert på uverifiserte data ($domain): garanti for treffsikkerhet gjelder ennå ikke.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Kalibrert for $domain-bilder. Andre typer bilder ligger utenfor garantien.';
  }

  @override
  String get cameraPhoto =>
      'Dette er et kamerafoto; detektoren er laget for skjermbilder, så boksene her er upålitelige.';

  @override
  String get modeDraw => 'Tegn';

  @override
  String get fillLabel => 'Fyll';

  @override
  String get fillSolid => 'Ensfarget';

  @override
  String get fillBlocks => 'Grå mosaikk';

  @override
  String get fillNoise => 'Støy';

  @override
  String get verifyNext => 'Verifiser og neste';

  @override
  String get export => 'Eksporter';

  @override
  String get pickOneModel => 'Velg nøyaktig én .onnx-modell';

  @override
  String pickSidecar(String name) {
    return 'Velg også $name.json';
  }

  @override
  String get analysing => 'Analyserer';

  @override
  String get followingRegion => 'Følger området';

  @override
  String get exporting => 'Eksporterer';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count bilder';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redigerer den $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Eksportsjekk feilet ved $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count private-seende områder er fortsatt synlige der ($classes).',
      many: '$count private-seende områder er fortsatt synlige der ($classes).',
      few: '$count private-seende områder er fortsatt synlige der ($classes).',
      two: '2 private-seende områder er fortsatt synlige der ($classes).',
      one: '1 private-seende område er fortsatt synlig der ($classes).',
      zero: '0 private-seende områder er fortsatt synlige der ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Vis bilde';

  @override
  String get drawMissedRegion => 'Tegn et område detektoren gikk glipp av';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on av $total spor redigert · $keyframes nøkkelbilder';
  }

  @override
  String get keepAudio => 'Behold lyd';

  @override
  String get keepAudioHint => 'Røster og varselløyd sjekkes ikke';

  @override
  String get goToFirstAppearance => 'Gå til første opptreden';

  @override
  String get classPersonName => 'Navn';

  @override
  String get classAddress => 'Adresse';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-post';

  @override
  String get classIdNumber => 'ID-nummer';

  @override
  String get classBankCard => 'Bankkort';

  @override
  String get classPlate => 'Skilt';

  @override
  String get classAccountId => 'Konto';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Ansikt';

  @override
  String get classQr => 'QR-kode';

  @override
  String get classBarcode => 'Strekode';

  @override
  String get classManual => 'Manuell';

  @override
  String noLabelsIn(String name) {
    return 'Ingen coco.json i $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Den lagrede modellen kunne ikke lastes. Velg en modell på nytt. ($error)';
  }

  @override
  String get fillSurround => 'Bakgrunnsfarge';

  @override
  String get fillTinted => 'Fargemosaikk';

  @override
  String get settings => 'Innstillinger';

  @override
  String get classFinance => 'Beløp';

  @override
  String get collectTitle => 'Samle treningsdata';

  @override
  String get collectSubtitle =>
      'Lagre hvert eksporterte bilde, de funnede områdene og valgene dine på denne enheten for å trene fremtidige modeller. Ingenting lastes opp.';

  @override
  String collectStats(int count, String size) {
    return '$count bilder · $size';
  }

  @override
  String get collectDelete => 'Slett innsamlede data';

  @override
  String get collectDeleteConfirm =>
      'Slette alle innsamlede bilder og valg fra denne enheten?';

  @override
  String get delete => 'Slett';

  @override
  String collectFailed(String error) {
    return 'Kunne ikke lagre treningsdata: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Etiketter lagret for $count bilder';
  }

  @override
  String get undo => 'Angre';

  @override
  String get redo => 'Gjør om';

  @override
  String get similar => 'Lignende';

  @override
  String get thisImage => 'Dette bildet';

  @override
  String allImagesCount(int count) {
    return 'Alle $count bilder';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count områder kan fortsatt leses',
      many: '$count områder kan fortsatt leses',
      few: '$count områder kan fortsatt leses',
      two: '2 områder kan fortsatt leses',
      one: '1 område kan fortsatt leses',
      zero: '0 områder kan fortsatt leses',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Etter redigering fant sjekken fortsatt disse områdene i utdataene.';

  @override
  String get redactThemAndExport => 'Rediger dem og eksporter';

  @override
  String get showThem => 'Vis dem';

  @override
  String get pickClass => 'Velg en klasse';

  @override
  String annotateOf(int index, int total) {
    return 'Annoter $index / $total';
  }

  @override
  String get suggestions => 'Forslag';

  @override
  String get skip => 'Hopp over';

  @override
  String get nothingPrivate => 'Ingenting privat';

  @override
  String get next => 'Neste';

  @override
  String get annotateHint =>
      'Trykk på en tekstlinje for å boks den, eller dra for å tegne';

  @override
  String get annotationData => 'Annotasjonsdata';

  @override
  String get statLabeled => 'Merket';

  @override
  String get statEmpty => 'Ingenting privat';

  @override
  String get statSkipped => 'Hoppet over';

  @override
  String get boxesPerClass => 'Bokser per klasse';

  @override
  String get imagesHeader => 'Bilder';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bokser',
      many: '$count bokser',
      few: '$count bokser',
      two: '2 bokser',
      one: '1 boks',
      zero: '0 bokser',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Eksporter alle';

  @override
  String get deleteAll => 'Slett alle';

  @override
  String get annotateDeleteConfirm =>
      'Slette alle annotasjoner og bildene deres fra denne enheten?';

  @override
  String get noAnnotations =>
      'Ingen annotasjoner ennå. Velg bilder og velg Annoter.';

  @override
  String get filterScreenshots => 'Skjermbilder';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterVideos => 'Videoer';

  @override
  String get albums => 'Album';

  @override
  String get limitedAccess => 'MosaicIt kan bare se noen av bildene dine';

  @override
  String get manage => 'Administrer';

  @override
  String selectedImages(int count) {
    return '$count valgt';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rediger $count bilder',
      many: 'Rediger $count bilder',
      few: 'Rediger $count bilder',
      two: 'Rediger 2 bilder',
      one: 'Rediger 1 bilde',
      zero: 'Rediger 0 bilder',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annoter';

  @override
  String get badgeRedacted => 'Redigert';

  @override
  String get badgeAnnotated => 'Annotert';

  @override
  String get photosDenied =>
      'MosaicIt trenger tilgang til bildene dine for å vise dem her. Bildene forlater aldri denne enheten.';

  @override
  String get openSettings => 'Åpne Innstillinger';

  @override
  String get openFiles => 'Åpne filer';

  @override
  String get noPhotos => 'Ingen bilder her';

  @override
  String get loading => 'Laster…';

  @override
  String get appearance => 'Utseende';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Appsymbol';

  @override
  String get aspectRatioGrid => 'Rutenett med sideforhold';

  @override
  String get modelDownloadFailed => 'Kunne ikke laste ned modellen';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get autoUpdateModel => 'Oppdater modellen automatisk';

  @override
  String get threshold => 'Terskel';

  @override
  String get thresholdLow => 'Lav';

  @override
  String get thresholdMedium => 'Middels';

  @override
  String get thresholdHigh => 'Høy';

  @override
  String get redaction => 'Redigering';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Valgt som standard';

  @override
  String get dataPrivacy => 'Data og personvern';

  @override
  String get localOnly =>
      'Lagres bare på denne enheten, aldri i iCloud eller sikkerhetskopier.';

  @override
  String get model => 'Modell';

  @override
  String get importModel => 'Importer en annen modell';

  @override
  String get advanced => 'Avansert';

  @override
  String get about => 'Om';

  @override
  String get licenses => 'Åpen kildekode-lisenser';

  @override
  String get merge => 'Slå sammen';

  @override
  String get split => 'Del opp';

  @override
  String get mergeHint =>
      'Trykk på en annen boks for å gjøre den til en del av samme verdi';

  @override
  String get classOrganization => 'Organisasjon';

  @override
  String get classDeviceId => 'Enhets-ID';

  @override
  String get classSecret => 'Hemmelighet';
}

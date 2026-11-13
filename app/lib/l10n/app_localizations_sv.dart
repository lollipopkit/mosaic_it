// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Läser in modell…';

  @override
  String get modelFileType => 'Modeller';

  @override
  String get useModel => 'Använd modell';

  @override
  String get imagesFileType => 'Bilder';

  @override
  String get detecting => 'Detekterar…';

  @override
  String detectingProgress(int current, int total) {
    return 'Detekterar $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Välj en modell först';

  @override
  String get findingSimilar => 'Söker efter liknande…';

  @override
  String similarSelected(int found, int added) {
    return '$found liknande områden markerade ($added nya)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found liknande områden markerade ($added nya) i $images bilder';
  }

  @override
  String get reviewButton => 'Granska';

  @override
  String get openingLabels => 'Öppnar etiketter…';

  @override
  String noImagesIn(String name) {
    return 'Inga bilder i $name';
  }

  @override
  String get saving => 'Sparar…';

  @override
  String get exportHere => 'Exportera hit';

  @override
  String exportStoppedAt(String name) {
    return 'Exporten stoppades vid $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exporterad till $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exporterad till $path (ingen ljudspår)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilder exporterade',
      many: 'Många bilder exporterade',
      few: 'Få bilder exporterade',
      two: '2 bilder exporterade',
      one: '1 bild exporterad',
      zero: '0 bilder exporterade',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Kontrollerar $name…';
  }

  @override
  String get checkingAndExporting => 'Kontrollerar och exporterar…';

  @override
  String get cancel => 'Avbryt';

  @override
  String get exportAnyway => 'Exportera ändå';

  @override
  String get reviewPseudoLabels => 'Granska pseudomärken (mapp med coco.json)';

  @override
  String get regionsTooltip => 'Områden';

  @override
  String get notCalibrated =>
      'Modellen är inte kalibrerad: förval använder en fast tröskelvärde.';

  @override
  String calibratedUnverified(String domain) {
    return 'Kalibrerad på verifierad data ($domain): garanti för träffsäkerhet gäller inte ännu.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Kalibrerad för $domain-bilder. Andra typer av bilder ligger utanför garantin.';
  }

  @override
  String get cameraPhoto =>
      'Detta är ett kamerabild; detektorn är gjord för skärmdumpar, så rutor här är opålitliga.';

  @override
  String get modeDraw => 'Rita';

  @override
  String get fillLabel => 'Fyll';

  @override
  String get fillSolid => 'Enfärgad';

  @override
  String get fillBlocks => 'Grå mosaik';

  @override
  String get fillNoise => 'Brus';

  @override
  String get verifyNext => 'Verifiera & nästa';

  @override
  String get export => 'Exportera';

  @override
  String get pickOneModel => 'Välj exakt en .onnx-modell';

  @override
  String pickSidecar(String name) {
    return 'Välj också $name.json';
  }

  @override
  String get analysing => 'Analyserar';

  @override
  String get followingRegion => 'Följer området';

  @override
  String get exporting => 'Exporterar';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count bildrutor';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redigerar den $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Exportkontrollen misslyckades vid $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count privata områden är fortfarande synliga där ($classes).',
      many: 'Många privata områden är fortfarande synliga där ($classes).',
      few: 'Få privata områden är fortfarande synliga där ($classes).',
      two: '2 privata områden är fortfarande synliga där ($classes).',
      one: '1 privat område är fortfarande synligt där ($classes).',
      zero: 'Inga privata områden är synliga där.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Visa bildruta';

  @override
  String get drawMissedRegion => 'Rita ett område detektorn missade';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on av $total spår redigerade · $keyframes nyckelbilder';
  }

  @override
  String get keepAudio => 'Behåll ljud';

  @override
  String get keepAudioHint => 'Röster och notisljud kontrolleras inte';

  @override
  String get goToFirstAppearance => 'Gå till första framträdandet';

  @override
  String get classPersonName => 'Namn';

  @override
  String get classAddress => 'Adress';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-post';

  @override
  String get classIdNumber => 'Personnummer';

  @override
  String get classBankCard => 'Bankkort';

  @override
  String get classPlate => 'Registreringsnummer';

  @override
  String get classAccountId => 'Konto';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Ansikte';

  @override
  String get classQr => 'QR-kod';

  @override
  String get classBarcode => 'Streckkod';

  @override
  String get classManual => 'Manuell';

  @override
  String noLabelsIn(String name) {
    return 'Ingen coco.json i $name';
  }

  @override
  String savedModelFailed(String error) {
    return 'Den sparade modellen kunde inte läsas in; välj en modell igen. ($error)';
  }

  @override
  String get fillSurround => 'Bakgrundsfärg';

  @override
  String get fillTinted => 'Färgmosaik';

  @override
  String get settings => 'Inställningar';

  @override
  String get classFinance => 'Belopp';

  @override
  String get collectTitle => 'Samla träningsdata';

  @override
  String get collectSubtitle =>
      'Spara varje exporterad bild, de hittade områdena och dina val på den här enheten för att träna framtida modeller. Inget laddas upp.';

  @override
  String collectStats(int count, String size) {
    return '$count bilder · $size';
  }

  @override
  String get collectDelete => 'Radera insamlad data';

  @override
  String get collectDeleteConfirm =>
      'Radera alla insamlade bilder och val från den här enheten?';

  @override
  String get delete => 'Radera';

  @override
  String collectFailed(String error) {
    return 'Det gick inte att spara träningsdata: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Etiketter sparade för $count bilder';
  }

  @override
  String get undo => 'Ångra';

  @override
  String get redo => 'Gör om';

  @override
  String get similar => 'Liknande';

  @override
  String get thisImage => 'Den här bilden';

  @override
  String allImagesCount(int count) {
    return 'Alla $count bilder';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count områden kan fortfarande vara läsbara',
      many: 'Många områden kan fortfarande vara läsbara',
      few: 'Få områden kan fortfarande vara läsbara',
      two: '2 områden kan fortfarande vara läsbara',
      one: '1 område kan fortfarande vara läsbar',
      zero: '0 områden kan fortfarande vara läsbara',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Efter redigering hittade kontrollen fortfarande dessa områden i utdata.';

  @override
  String get redactThemAndExport => 'Redigera dem och exportera';

  @override
  String get showThem => 'Visa dem';

  @override
  String get pickClass => 'Välj en klass';

  @override
  String annotateOf(int index, int total) {
    return 'Annotera $index / $total';
  }

  @override
  String get suggestions => 'Förslag';

  @override
  String get skip => 'Hoppa över';

  @override
  String get nothingPrivate => 'Inget privat';

  @override
  String get next => 'Nästa';

  @override
  String get annotateHint =>
      'Tryck på en textrad för att rama in den, eller dra för att rita';

  @override
  String get annotationData => 'Annoteringsdata';

  @override
  String get statLabeled => 'Etiketterade';

  @override
  String get statEmpty => 'Inget privat';

  @override
  String get statSkipped => 'Hoppade över';

  @override
  String get boxesPerClass => 'Rutor per klass';

  @override
  String get imagesHeader => 'Bilder';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rutor',
      many: 'Många rutor',
      few: 'Få rutor',
      two: '2 rutor',
      one: '1 ruta',
      zero: '0 rutor',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Exportera alla';

  @override
  String get deleteAll => 'Ta bort alla';

  @override
  String get annotateDeleteConfirm =>
      'Vill du ta bort alla annoteringar och deras bilder från den här enheten?';

  @override
  String get noAnnotations =>
      'Inga annoteringar ännu. Välj bilder och välj Annotera.';

  @override
  String get filterScreenshots => 'Skärmdumpar';

  @override
  String get filterAll => 'Alla';

  @override
  String get filterVideos => 'Videor';

  @override
  String get albums => 'Album';

  @override
  String get limitedAccess => 'MosaicIt kan bara se en del av dina foton';

  @override
  String get manage => 'Hantera';

  @override
  String selectedImages(int count) {
    return '$count valda';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Redigera $count bilder',
      many: 'Redigera många bilder',
      few: 'Redigera få bilder',
      two: 'Redigera 2 bilder',
      one: 'Redigera 1 bild',
      zero: 'Redigera 0 bilder',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Annotera';

  @override
  String get badgeRedacted => 'Redigerad';

  @override
  String get badgeAnnotated => 'Annoterad';

  @override
  String get photosDenied =>
      'MosaicIt behöver åtkomst till dina foton för att visa dem här. Foton lämnar aldrig den här enheten.';

  @override
  String get openSettings => 'Öppna Inställningar';

  @override
  String get openFiles => 'Öppna filer';

  @override
  String get noPhotos => 'Inga foton här';

  @override
  String get loading => 'Läser in…';

  @override
  String get appearance => 'Utseende';

  @override
  String get theme => 'Tema';

  @override
  String get appIcon => 'Appsymbol';

  @override
  String get aspectRatioGrid => 'Rutnät med bildförhållande';

  @override
  String get modelDownloadFailed => 'Modellen kunde inte hämtas';

  @override
  String get retry => 'Försök igen';

  @override
  String get autoUpdateModel => 'Uppdatera modellen automatiskt';

  @override
  String get threshold => 'Tröskel';

  @override
  String get thresholdLow => 'Låg';

  @override
  String get thresholdMedium => 'Medel';

  @override
  String get thresholdHigh => 'Hög';

  @override
  String get redaction => 'Redigering';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Valt som standard';

  @override
  String get dataPrivacy => 'Data och integritet';

  @override
  String get localOnly =>
      'Förvaras endast på den här enheten, aldrig i iCloud eller säkerhetskopior.';

  @override
  String get model => 'Modell';

  @override
  String get importModel => 'Importera en annan modell';

  @override
  String get advanced => 'Avancerat';

  @override
  String get about => 'Om';

  @override
  String get licenses => 'Öppen källkodslicenser';

  @override
  String get merge => 'Slå ihop';

  @override
  String get split => 'Dela';

  @override
  String get mergeHint =>
      'Tryck på en annan ruta för att göra den till en del av samma värde';

  @override
  String get classOrganization => 'Organisation';

  @override
  String get classDeviceId => 'Enhets-ID';

  @override
  String get classSecret => 'Hemlighet';
}

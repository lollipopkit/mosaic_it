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
  String get regionsTooltip => 'Regio’s';

  @override
  String get cameraPhoto =>
      'Dit is een camerafoto; de detector is gemaakt voor screenshots, dus de kaders hier zijn onbetrouwbaar.';

  @override
  String get modeDraw => 'Tekenen';

  @override
  String get fillSolid => 'Effen kleur';

  @override
  String get fillBlocks => 'Grijs mozaïek';

  @override
  String get fillNoise => 'Ruis';

  @override
  String get export => 'Exporteren';

  @override
  String pickOneModel(String formats) {
    return 'Kies exact één $formats-model';
  }

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
  String get delete => 'Verwijderen';

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
  String get appearance => 'Weergave';

  @override
  String get theme => 'Thema';

  @override
  String get appIcon => 'App-symbool';

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

  @override
  String get classPerson => 'Persoon';

  @override
  String get classHealth => 'Gezondheid';

  @override
  String get classPersonalInfo => 'Persoonlijke gegevens';

  @override
  String selectedOf(int selected, int total) {
    return '$selected / $total geselecteerd';
  }

  @override
  String get fillStyle => 'Vulstijl';

  @override
  String get colour => 'Kleur';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images afbeeldingen',
      one: '1 afbeelding',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions regio’s',
      one: '1 regio',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Delen';

  @override
  String get saveToPhotos => 'Opslaan in Foto’s';

  @override
  String get saveAs => 'Opslaan…';

  @override
  String get exportFormat => 'Indeling';

  @override
  String get exportSize => 'Grootte';

  @override
  String get sizeOriginal => 'Origineel';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count afbeeldingen opgeslagen in Foto’s',
      one: '1 afbeelding opgeslagen in Foto’s',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Alles';

  @override
  String get selectNone => 'Geen';

  @override
  String get suggested => 'voorgesteld';

  @override
  String scoreValue(String score) {
    return 'Score $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Na het redigeren vond de controle nog steeds deze gebieden in de uitvoer van afbeelding $index.';
  }

  @override
  String get reasonNotSelected => 'niet geselecteerd';

  @override
  String get reasonBoxTooSmall => 'kader te klein';

  @override
  String get reasonFillShowsThrough => 'vulling schijnt door';

  @override
  String get openSource => 'Opensource';

  @override
  String get adaptivePreselectTitle => 'Lokale adaptieve voorselectie';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klassen aangepast',
      one: '1 klasse aangepast',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Lokale voorkeuren herstellen';

  @override
  String get adaptiveResetDone => 'Lokale voorkeuren hersteld';

  @override
  String get feedbackTitle => 'Detectieprobleem melden';

  @override
  String get feedbackShort => 'Feedback';

  @override
  String get feedbackMenu => 'Probleem melden';

  @override
  String get feedbackAction => 'Melden';

  @override
  String get feedbackAttachScreenshot => 'Schermafbeelding bijvoegen';

  @override
  String get feedbackModeMasked => 'Alleen fouten';

  @override
  String get feedbackModeFull => 'Volledige afbeelding';

  @override
  String get feedbackModeText => 'Geen afbeelding';

  @override
  String get feedbackTagMissed => 'Gemist';

  @override
  String get feedbackTagFalsePositive => 'Fout-positief';

  @override
  String get feedbackTagBoxDrift => 'Kader verschoven';

  @override
  String get feedbackTagWrongClass => 'Verkeerde klasse';

  @override
  String get feedbackTagOther => 'Overig';

  @override
  String get feedbackNoteHint => 'Optionele opmerking…';

  @override
  String feedbackCountMasked(int count) {
    return 'Gemaskeerd $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Gemist $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Fout-positief $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Uitgevinkt $count';
  }

  @override
  String get feedbackBoxMissed => 'Gemist';

  @override
  String get feedbackBoxMissedMasked => 'Gemist · gemaskeerd';

  @override
  String get feedbackBoxFp => 'Fout-positief';

  @override
  String get feedbackBoxPreference => 'Zichtbaar houden';

  @override
  String get introOfflineTitle => 'Geen netwerktoegang';

  @override
  String get introOfflineBody =>
      'MosaicIt bevat geen netwerkcode en vraagt geen netwerkmachtiging aan. De detector is in de app ingebouwd en afbeeldingen verlaten nooit uw apparaat.';

  @override
  String get introNoNetPermTitle => 'Geen netwerkmachtigingen';

  @override
  String get introBundledModelTitle => 'Ingebouwd model op het apparaat';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · op het apparaat';
  }

  @override
  String get resetBundledModel => 'Ingebouwd model gebruiken';

  @override
  String get reviewIntro => 'Introductie opnieuw tonen';

  @override
  String get feedbackOpenWeb => 'Webformulier openen';

  @override
  String get introNoNetPermBodyIos =>
      'Geen netwerkverzoeken · alleen op het apparaat';

  @override
  String get introNoNetPermBodyAndroid =>
      'Geen INTERNET-machtiging gedeclareerd';

  @override
  String get introNoNetPermBodyDesktop => 'Geen netwerkrechten in de sandbox';

  @override
  String get customModel => 'Aangepast model';

  @override
  String modelClassCount(int count) {
    return '$count klassen';
  }

  @override
  String get copyImage => 'Afbeelding kopiëren';

  @override
  String get copiedToClipboard => 'Gekopieerd naar klembord';

  @override
  String get copyFailed => 'Kan afbeelding niet kopiëren';

  @override
  String get peekOriginal => 'Houd ingedrukt om origineel te vergelijken';

  @override
  String get selectMedia => 'Foto’s selecteren';

  @override
  String get saveFailed => 'Kan niet opslaan in Foto’s';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get iosWirelessPromptTitle => 'Melding voor draadloze gegevens';

  @override
  String get iosWirelessPromptBody =>
      'Het openen van de systeemfotokiezer kan op iOS een melding voor draadloze gegevens tonen voor iCloud-miniaturen. MosaicIt gebruikt geen netwerk — tik op ‘Sta niet toe’.';

  @override
  String get continueAction => 'Doorgaan';
}

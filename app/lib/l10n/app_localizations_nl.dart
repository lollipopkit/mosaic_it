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
      'Dit is een camerfoto; de detector is gemaakt voor screenshots, dus de kaders hier zijn onbetrouwbaar.';

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

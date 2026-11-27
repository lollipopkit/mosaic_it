// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Modell betöltése…';

  @override
  String get modelFileType => 'Modell';

  @override
  String get useModel => 'Modell használata';

  @override
  String get imagesFileType => 'Képek';

  @override
  String get detecting => 'Észlelés…';

  @override
  String detectingProgress(int current, int total) {
    return 'Észlelés $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Először válasszon modellt';

  @override
  String get findingSimilar => 'Hasonlók keresése…';

  @override
  String similarSelected(int found, int added) {
    return '$found hasonló régió kiválasztva ($added új)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found hasonló régió kiválasztva ($added új) $images képen';
  }

  @override
  String get saving => 'Mentés…';

  @override
  String get exportHere => 'Exportálás ide';

  @override
  String exportStoppedAt(String name) {
    return 'Az exportálás megszakadt: $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exportálva ide: $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exportálva ide: $path (hang nélkül)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kép exportálva',
      many: '$count kép exportálva',
      few: '$count kép exportálva',
      two: '2 kép exportálva',
      one: '1 kép exportálva',
      zero: '0 kép exportálva',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Ellenőrzés: $name…';
  }

  @override
  String get checkingAndExporting => 'Ellenőrzés és exportálás…';

  @override
  String get cancel => 'Mégse';

  @override
  String get exportAnyway => 'Exportálás mindenképpen';

  @override
  String get regionsTooltip => 'Régiók';

  @override
  String get cameraPhoto =>
      'Ez egy fényképezőgépes felvétel; az érzékelő képernyőfotókra készült, ezért itt a keretei nem megbízhatóak.';

  @override
  String get modeDraw => 'Rajzolás';

  @override
  String get fillSolid => 'Egyszínű';

  @override
  String get fillBlocks => 'Szürke mozaik';

  @override
  String get fillNoise => 'Zaj';

  @override
  String get export => 'Exportálás';

  @override
  String pickOneModel(String formats) {
    return 'Válasszon pontosan egy $formats modellt';
  }

  @override
  String pickSidecar(String name) {
    return 'Válassza ki a(z) $name.json fájlt is';
  }

  @override
  String get analysing => 'Elemzés';

  @override
  String get followingRegion => 'A régió követése';

  @override
  String get exporting => 'Exportálás';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count képkocka';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Törlés: $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Az exportálás ellenőrzése sikertelen: $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count privát jellegű régió látható még ott ($classes).',
      many: '$count privát jellegű régió látható még ott ($classes).',
      few: '$count privát jellegű régió látható még ott ($classes).',
      two: '2 privát jellegű régió látható még ott ($classes).',
      one: '1 privát jellegű régió látható még ott ($classes).',
      zero: 'Nincsenek látható privát jellegű régiók ott ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Képkocka megjelenítése';

  @override
  String get drawMissedRegion =>
      'Rajzoljon egy régiót, amelyet az érzékelő elhagyott';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on / $total követés törölve · $keyframes kulcsképkocka';
  }

  @override
  String get keepAudio => 'Hang megtartása';

  @override
  String get keepAudioHint => 'A hangok és értesítési hangok nem ellenőrzöttek';

  @override
  String get goToFirstAppearance => 'Ugrás az első megjelenéshez';

  @override
  String get classPersonName => 'Név';

  @override
  String get classAddress => 'Cím';

  @override
  String get classPhone => 'Telefonszám';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'Személyi azonosító';

  @override
  String get classBankCard => 'Bankkártya';

  @override
  String get classPlate => 'Rendszám';

  @override
  String get classAccountId => 'Fiók';

  @override
  String get classAvatar => 'Profilkép';

  @override
  String get classFace => 'Arc';

  @override
  String get classQr => 'QR-kód';

  @override
  String get classBarcode => 'Vonalkód';

  @override
  String get classManual => 'Kézi';

  @override
  String savedModelFailed(String error) {
    return 'A mentett modell nem tölthető be; válasszon újra egy modellt. ($error)';
  }

  @override
  String get fillSurround => 'Háttérszín';

  @override
  String get fillTinted => 'Színes mozaik';

  @override
  String get settings => 'Beállítások';

  @override
  String get classFinance => 'Összeg';

  @override
  String get delete => 'Törlés';

  @override
  String get undo => 'Visszavonás';

  @override
  String get redo => 'Újra';

  @override
  String get similar => 'Hasonló';

  @override
  String get thisImage => 'Ez a kép';

  @override
  String allImagesCount(int count) {
    return 'Minden $count kép';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count terület olvasható maradhat',
      many: 'sok terület olvasható maradhat',
      few: 'néhány terület olvasható maradhat',
      two: '2 terület olvasható maradhat',
      one: '1 terület olvasható maradhat',
      zero: '0 terület olvasható maradhat',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Az eltakarás után az ellenőrzés ezeket a területeket találta a kimenetben.';

  @override
  String get redactThemAndExport => 'Eltakarás és exportálás';

  @override
  String get showThem => 'Megjelenítés';

  @override
  String get pickClass => 'Osztály kiválasztása';

  @override
  String get appearance => 'Megjelenés';

  @override
  String get theme => 'Téma';

  @override
  String get appIcon => 'Alkalmazásikon';

  @override
  String get threshold => 'Küszöb';

  @override
  String get thresholdLow => 'Alacsony';

  @override
  String get thresholdMedium => 'Közepes';

  @override
  String get thresholdHigh => 'Magas';

  @override
  String get redaction => 'Eltakarás';

  @override
  String get style => 'Stílus';

  @override
  String get selectedByDefault => 'Alapértelmezetten kijelölve';

  @override
  String get dataPrivacy => 'Adatok és adatvédelem';

  @override
  String get model => 'Modell';

  @override
  String get importModel => 'Egyéb modell importálása';

  @override
  String get advanced => 'Haladó';

  @override
  String get about => 'Névjegy';

  @override
  String get licenses => 'Nyílt forráskódú licencek';

  @override
  String get merge => 'Egyesítés';

  @override
  String get split => 'Szétválasztás';

  @override
  String get mergeHint =>
      'Érintsen meg egy másik keretet, hogy ugyanannak az értéknek a része legyen';

  @override
  String get classOrganization => 'Szervezet';

  @override
  String get classDeviceId => 'Eszközazonosító';

  @override
  String get classSecret => 'Titkos adat';

  @override
  String get classPerson => 'Személy';

  @override
  String get classHealth => 'Egészség';

  @override
  String get classPersonalInfo => 'Személyes adatok';

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
  String get selectMedia => 'Select photos or video';

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

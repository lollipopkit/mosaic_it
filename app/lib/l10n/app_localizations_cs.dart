// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Načítání modelu…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Použít model';

  @override
  String get imagesFileType => 'Obrázky';

  @override
  String get detecting => 'Detekce…';

  @override
  String detectingProgress(int current, int total) {
    return 'Detekce $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Nejprve vyberte model';

  @override
  String get findingSimilar => 'Hledání podobných…';

  @override
  String similarSelected(int found, int added) {
    return 'Vybráno $found podobných oblastí ($added nových)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Vybráno $found podobných oblastí ($added nových) v $images obrázcích';
  }

  @override
  String get saving => 'Ukládání…';

  @override
  String get exportHere => 'Exportovat sem';

  @override
  String exportStoppedAt(String name) {
    return 'Export přerušen u $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exportováno do $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exportováno do $path (bez zvuku)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Exportováno $count obrázků',
      many: 'Exportováno $count obrázků',
      few: 'Exportovány $count obrázky',
      one: 'Exportován 1 obrázek',
      zero: 'Exportováno 0 obrázků',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Kontrola $name…';
  }

  @override
  String get checkingAndExporting => 'Kontrola a export…';

  @override
  String get cancel => 'Zrušit';

  @override
  String get exportAnyway => 'Exportovat přesto';

  @override
  String get regionsTooltip => 'Oblasti';

  @override
  String get cameraPhoto =>
      'Toto je foto z kamery; detektor je určen pro snímky obrazovky, takže jeho rámečky zde nejsou spolehlivé.';

  @override
  String get modeDraw => 'Kreslit';

  @override
  String get fillSolid => 'Plná barva';

  @override
  String get fillBlocks => 'Šedá mozaika';

  @override
  String get fillNoise => 'Šum';

  @override
  String get export => 'Exportovat';

  @override
  String pickOneModel(String formats) {
    return 'Vyberte přesně jeden model $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Vyberte také $name.json';
  }

  @override
  String get analysing => 'Analyzování';

  @override
  String get followingRegion => 'Sledování oblasti';

  @override
  String get exporting => 'Exportování';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count snímků';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redigování $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Kontrola exportu selhala v $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count soukromých oblastí je tam stále vidět ($classes).',
      many: '$count soukromých oblastí je tam stále vidět ($classes).',
      few: '$count soukromé oblasti jsou tam stále vidět ($classes).',
      one: '1 soukromá oblast je tam stále vidět ($classes).',
      zero: 'Žádná soukromá oblast není tam vidět ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Zobrazit snímek';

  @override
  String get drawMissedRegion => 'Nakreslete oblast, kterou detektor přehlédl';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return 'Redigováno $on z $total stop · $keyframes klíčových snímků';
  }

  @override
  String get keepAudio => 'Ponechat zvuk';

  @override
  String get keepAudioHint => 'Hlasy a zvuky oznámení se nekontrolují';

  @override
  String get goToFirstAppearance => 'Přejít na první výskyt';

  @override
  String get classPersonName => 'Jméno';

  @override
  String get classAddress => 'Adresa';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'Číslo dokladu';

  @override
  String get classBankCard => 'Bankovní karta';

  @override
  String get classPlate => 'Spz';

  @override
  String get classAccountId => 'Účet';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Obličej';

  @override
  String get classQr => 'QR kód';

  @override
  String get classBarcode => 'Čárový kód';

  @override
  String get classManual => 'Ruční';

  @override
  String savedModelFailed(String error) {
    return 'Uložený model se nepodařilo načíst; vyberte model znovu. ($error)';
  }

  @override
  String get fillSurround => 'Barva pozadí';

  @override
  String get fillTinted => 'Barevná mozaika';

  @override
  String get settings => 'Nastavení';

  @override
  String get classFinance => 'Částka';

  @override
  String get delete => 'Smazat';

  @override
  String get undo => 'Zpět';

  @override
  String get redo => 'Znovu';

  @override
  String get similar => 'Podobné';

  @override
  String get thisImage => 'Tento obrázek';

  @override
  String allImagesCount(int count) {
    return 'Všechny $count obrázky';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oblastí může být stále čitelná',
      many: '$count oblastí může být stále čitelná',
      few: '$count oblasti mohou být stále čitelné',
      one: '1 oblast může být stále čitelná',
      zero: '0 oblastí může být stále čitelná',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Po zakrytí stále našla kontrola tyto oblasti ve výstupu.';

  @override
  String get redactThemAndExport => 'Zakryt a exportovat';

  @override
  String get showThem => 'Zobrazit';

  @override
  String get pickClass => 'Vyberte třídu';

  @override
  String get filterScreenshots => 'Snímky obrazovky';

  @override
  String get filterAll => 'Vše';

  @override
  String get filterVideos => 'Videa';

  @override
  String get albums => 'Alba';

  @override
  String get limitedAccess =>
      'MosaicIt má přístup pouze k některým z vašich fotografií';

  @override
  String get manage => 'Spravovat';

  @override
  String selectedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vybráno',
      many: '$count vybráno',
      few: '$count vybráno',
      one: '1 vybráno',
      zero: '0 vybráno',
    );
    return '$_temp0';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zakryt $count obrázků',
      many: 'Zakryt $count obrázků',
      few: 'Zakryt $count obrázky',
      one: 'Zakryt 1 obrázek',
      zero: 'Zakryt 0 obrázků',
    );
    return '$_temp0';
  }

  @override
  String get badgeRedacted => 'Zakryto';

  @override
  String get photosDenied =>
      'MosaicIt potřebuje přístup k vašim fotografiím, aby je mohl zobrazit zde. Fotografie nikdy neopustí toto zařízení.';

  @override
  String get openSettings => 'Otevřít Nastavení';

  @override
  String get openFiles => 'Otevřít soubory';

  @override
  String get noPhotos => 'Zde nejsou žádné fotografie';

  @override
  String get loading => 'Načítání…';

  @override
  String get appearance => 'Vzhled';

  @override
  String get theme => 'Motiv';

  @override
  String get appIcon => 'Ikona aplikace';

  @override
  String get aspectRatioGrid => 'Mřížka s poměrem stran';

  @override
  String get threshold => 'Práh';

  @override
  String get thresholdLow => 'Nízký';

  @override
  String get thresholdMedium => 'Střední';

  @override
  String get thresholdHigh => 'Vysoký';

  @override
  String get redaction => 'Zakrývání';

  @override
  String get style => 'Styl';

  @override
  String get selectedByDefault => 'Ve výchozím stavu vybráno';

  @override
  String get dataPrivacy => 'Data a soukromí';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Importovat jiný model';

  @override
  String get advanced => 'Pokročilé';

  @override
  String get about => 'O aplikaci';

  @override
  String get licenses => 'Licence open-source';

  @override
  String get merge => 'Sloučit';

  @override
  String get split => 'Rozdělit';

  @override
  String get mergeHint =>
      'Klepnutím na jiný rámeček jej zařadíte do stejné hodnoty';

  @override
  String get classOrganization => 'Organizace';

  @override
  String get classDeviceId => 'ID zařízení';

  @override
  String get classSecret => 'Tajný údaj';

  @override
  String get classPerson => 'Osoba';

  @override
  String get classHealth => 'Zdraví';

  @override
  String get classPersonalInfo => 'Osobní údaje';

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
}

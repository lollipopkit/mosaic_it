// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Modell wird geladen…';

  @override
  String get modelFileType => 'Modell';

  @override
  String get useModel => 'Modell verwenden';

  @override
  String get imagesFileType => 'Bilder';

  @override
  String get detecting => 'Wird erkannt…';

  @override
  String detectingProgress(int current, int total) {
    return 'Wird erkannt $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Wähle zuerst ein Modell';

  @override
  String get findingSimilar => 'Ähnliche werden gesucht…';

  @override
  String similarSelected(int found, int added) {
    return '$found ähnliche Bereiche ausgewählt ($added neu)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return '$found ähnliche Bereiche ausgewählt ($added neu) in $images Bildern';
  }

  @override
  String get saving => 'Wird gespeichert…';

  @override
  String get exportHere => 'Hier exportieren';

  @override
  String exportStoppedAt(String name) {
    return 'Export gestoppt bei $name';
  }

  @override
  String exportedTo(String path) {
    return 'Exportiert nach $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Exportiert nach $path (ohne Ton)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bilder exportiert',
      many: '$count Bilder exportiert',
      few: '$count Bilder exportiert',
      two: '2 Bilder exportiert',
      one: '1 Bild exportiert',
      zero: '0 Bilder exportiert',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return '$name wird geprüft…';
  }

  @override
  String get checkingAndExporting => 'Wird geprüft und exportiert…';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get exportAnyway => 'Trotzdem exportieren';

  @override
  String get regionsTooltip => 'Bereiche';

  @override
  String get cameraPhoto =>
      'Dies ist ein Kamerabild; der Detektor ist für Screenshots ausgelegt, daher sind die Rahmen hier unzuverlässig.';

  @override
  String get modeDraw => 'Zeichnen';

  @override
  String get fillSolid => 'Volltonfarbe';

  @override
  String get fillBlocks => 'Graues Mosaik';

  @override
  String get fillNoise => 'Rauschen';

  @override
  String get export => 'Exportieren';

  @override
  String pickOneModel(String formats) {
    return 'Wähle genau ein $formats-Modell';
  }

  @override
  String pickSidecar(String name) {
    return 'Wähle auch $name.json';
  }

  @override
  String get analysing => 'Wird analysiert';

  @override
  String get followingRegion => 'Bereich wird verfolgt';

  @override
  String get exporting => 'Wird exportiert';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count Frames';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Wird zensiert $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Exportprüfung fehlgeschlagen bei $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count private aussehende Bereiche sind dort noch sichtbar ($classes).',
      many:
          '$count private aussehende Bereiche sind dort noch sichtbar ($classes).',
      few:
          '$count private aussehende Bereiche sind dort noch sichtbar ($classes).',
      two: '2 private aussehende Bereiche sind dort noch sichtbar ($classes).',
      one: '1 private aussehender Bereich ist dort noch sichtbar ($classes).',
      zero: '0 private aussehende Bereiche sind dort noch sichtbar ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Frame anzeigen';

  @override
  String get drawMissedRegion =>
      'Zeichne einen Bereich, den der Detektor verpasst hat';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return '$on von $total Tracks zensiert · $keyframes Keyframes';
  }

  @override
  String get keepAudio => 'Ton beibehalten';

  @override
  String get keepAudioHint =>
      'Stimmen und Benachrichtigungstöne werden nicht geprüft';

  @override
  String get goToFirstAppearance => 'Zum ersten Erscheinen springen';

  @override
  String get classPersonName => 'Name';

  @override
  String get classAddress => 'Adresse';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-Mail';

  @override
  String get classIdNumber => 'ID-Nummer';

  @override
  String get classBankCard => 'Bankkarte';

  @override
  String get classPlate => 'Kennzeichen';

  @override
  String get classAccountId => 'Konto';

  @override
  String get classAvatar => 'Avatar';

  @override
  String get classFace => 'Gesicht';

  @override
  String get classQr => 'QR-Code';

  @override
  String get classBarcode => 'Strichcode';

  @override
  String get classManual => 'Manuell';

  @override
  String savedModelFailed(String error) {
    return 'Das gespeicherte Modell konnte nicht geladen werden; wählen Sie ein Modell erneut aus. ($error)';
  }

  @override
  String get fillSurround => 'Hintergrundfarbe';

  @override
  String get fillTinted => 'Farbiges Mosaik';

  @override
  String get settings => 'Einstellungen';

  @override
  String get classFinance => 'Betrag';

  @override
  String get delete => 'Löschen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get redo => 'Wiederholen';

  @override
  String get similar => 'Ähnlich';

  @override
  String get thisImage => 'Dieses Bild';

  @override
  String allImagesCount(int count) {
    return 'Alle $count Bilder';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bereiche sind möglicherweise noch lesbar',
      many: '$count Bereiche sind möglicherweise noch lesbar',
      few: '$count Bereiche sind möglicherweise noch lesbar',
      two: '2 Bereiche sind möglicherweise noch lesbar',
      one: '1 Bereich ist möglicherweise noch lesbar',
      zero: 'Keine Bereiche lesbar',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Nach der Unkenntlichmachung hat die Prüfung diese Bereiche in der Ausgabe weiterhin gefunden.';

  @override
  String get redactThemAndExport => 'Unkenntlich machen und exportieren';

  @override
  String get showThem => 'Anzeigen';

  @override
  String get pickClass => 'Klasse auswählen';

  @override
  String get filterScreenshots => 'Screenshots';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterVideos => 'Videos';

  @override
  String get albums => 'Alben';

  @override
  String get limitedAccess => 'MosaicIt kann nur einige deiner Fotos sehen';

  @override
  String get manage => 'Verwalten';

  @override
  String selectedImages(int count) {
    return '$count ausgewählt';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bilder unkenntlich machen',
      many: '$count Bilder unkenntlich machen',
      few: '$count Bilder unkenntlich machen',
      two: '2 Bilder unkenntlich machen',
      one: '1 Bild unkenntlich machen',
      zero: '0 Bilder unkenntlich machen',
    );
    return '$_temp0';
  }

  @override
  String get badgeRedacted => 'Unkenntlich gemacht';

  @override
  String get photosDenied =>
      'MosaicIt benötigt Zugriff auf deine Fotos, um sie hier anzuzeigen. Fotos verlassen dieses Gerät nie.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get openFiles => 'Dateien öffnen';

  @override
  String get noPhotos => 'Keine Fotos hier';

  @override
  String get loading => 'Wird geladen…';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get theme => 'Design';

  @override
  String get appIcon => 'App-Symbol';

  @override
  String get aspectRatioGrid => 'Raster im Seitenverhältnis';

  @override
  String get threshold => 'Schwelle';

  @override
  String get thresholdLow => 'Niedrig';

  @override
  String get thresholdMedium => 'Mittel';

  @override
  String get thresholdHigh => 'Hoch';

  @override
  String get redaction => 'Unkenntlichmachung';

  @override
  String get style => 'Stil';

  @override
  String get selectedByDefault => 'Standardmäßig ausgewählt';

  @override
  String get dataPrivacy => 'Daten und Datenschutz';

  @override
  String get model => 'Modell';

  @override
  String get importModel => 'Anderes Modell importieren';

  @override
  String get advanced => 'Erweitert';

  @override
  String get about => 'Über';

  @override
  String get licenses => 'Open-Source-Lizenzen';

  @override
  String get merge => 'Zusammenführen';

  @override
  String get split => 'Trennen';

  @override
  String get mergeHint =>
      'Tippe auf einen anderen Rahmen, um ihn Teil desselben Werts zu machen';

  @override
  String get classOrganization => 'Organisation';

  @override
  String get classDeviceId => 'Geräte-ID';

  @override
  String get classSecret => 'Zugangsdaten';

  @override
  String get classPerson => 'Person';

  @override
  String get classHealth => 'Gesundheit';

  @override
  String get classPersonalInfo => 'Persönliche Angaben';

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
  String get introOfflineTitle => 'Kein Netzwerkzugriff';

  @override
  String get introOfflineBody =>
      'MosaicIt enthält keinen Netzwerkcode und fordert keine Netzwerkberechtigung an. Das Erkennungsmodell ist integriert; Bilder und Videos verlassen das Gerät nie.';

  @override
  String get introNoNetPermTitle => 'Keine Netzwerkberechtigungen';

  @override
  String get introBundledModelTitle => 'Integriertes On-Device-Modell';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · lokal integriert';
  }

  @override
  String get introBundledReady => 'Integriertes Modell bereit';

  @override
  String get introPhotosGranted => 'Fotozugriff erteilt';

  @override
  String get resetBundledModel => 'Integriertes Modell verwenden';

  @override
  String get reviewIntro => 'Einführung erneut anzeigen';

  @override
  String get feedbackOpenWeb => 'Im Browser senden';

  @override
  String get introNoNetPermBodyIos => 'Keine Netzwerkanfragen · rein lokal';

  @override
  String get introNoNetPermBodyAndroid => 'Keine INTERNET-Berechtigung';

  @override
  String get introNoNetPermBodyDesktop =>
      'Keine Netzwerkberechtigung in der Sandbox';

  @override
  String get customModel => 'Eigenes Modell';

  @override
  String modelClassCount(int count) {
    return '$count Klassen';
  }

  @override
  String get copyImage => 'Bild kopieren';

  @override
  String get copiedToClipboard => 'In Zwischenablage kopiert';

  @override
  String get copyFailed => 'Bild konnte nicht kopiert werden';

  @override
  String get peekOriginal => 'Gedrückt halten für Original';
}

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
  String get reviewButton => 'Prüfen';

  @override
  String get openingLabels => 'Labels werden geöffnet…';

  @override
  String noImagesIn(String name) {
    return 'Keine Bilder in $name';
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
  String get reviewPseudoLabels =>
      'Pseudo-Labels überprüfen (Ordner mit coco.json)';

  @override
  String get regionsTooltip => 'Bereiche';

  @override
  String get notCalibrated =>
      'Modell ist nicht kalibriert: Die Vorauswahl verwendet einen festen Schwellenwert.';

  @override
  String calibratedUnverified(String domain) {
    return 'Auf unbestätigten Daten kalibriert ($domain): Die Recall-Garantie gilt noch nicht.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Für $domain-Bilder kalibriert. Andere Bildtypen fallen nicht unter die Garantie.';
  }

  @override
  String get cameraPhoto =>
      'Dies ist ein Kamerabild; der Detektor ist für Screenshots ausgelegt, daher sind die Rahmen hier unzuverlässig.';

  @override
  String get modeDraw => 'Zeichnen';

  @override
  String get fillLabel => 'Füllung';

  @override
  String get fillSolid => 'Volltonfarbe';

  @override
  String get fillBlocks => 'Graues Mosaik';

  @override
  String get fillNoise => 'Rauschen';

  @override
  String get verifyNext => 'Bestätigen & weiter';

  @override
  String get export => 'Exportieren';

  @override
  String get pickOneModel => 'Wähle genau ein .onnx-Modell';

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
  String noLabelsIn(String name) {
    return 'Kein coco.json in $name';
  }

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
  String get collectTitle => 'Trainingsdaten sammeln';

  @override
  String get collectSubtitle =>
      'Jedes exportierte Bild, die erkannten Bereiche und deine Auswahl auf diesem Gerät speichern, um künftige Modelle zu trainieren. Es wird nichts hochgeladen.';

  @override
  String collectStats(int count, String size) {
    return '$count Bilder · $size';
  }

  @override
  String get collectDelete => 'Gesammelte Daten löschen';

  @override
  String get collectDeleteConfirm =>
      'Alle gesammelten Bilder und Auswahlen von diesem Gerät löschen?';

  @override
  String get delete => 'Löschen';

  @override
  String collectFailed(String error) {
    return 'Trainingsdaten konnten nicht gespeichert werden: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Labels für $count Bilder gespeichert';
  }

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
  String annotateOf(int index, int total) {
    return 'Annotieren $index / $total';
  }

  @override
  String get suggestions => 'Vorschläge';

  @override
  String get skip => 'Überspringen';

  @override
  String get nothingPrivate => 'Nichts Privates';

  @override
  String get next => 'Weiter';

  @override
  String get annotateHint =>
      'Tippe auf eine Textzeile, um sie zu rahmen, oder ziehe, um zu zeichnen';

  @override
  String get annotationData => 'Annotationsdaten';

  @override
  String get statLabeled => 'Beschriftet';

  @override
  String get statEmpty => 'Nichts Privates';

  @override
  String get statSkipped => 'Übersprungen';

  @override
  String get boxesPerClass => 'Rahmen pro Klasse';

  @override
  String get imagesHeader => 'Bilder';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kästen',
      many: '$count Kästen',
      few: '$count Kästen',
      two: '2 Kästen',
      one: '1 Kasten',
      zero: '0 Kästen',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Alle exportieren';

  @override
  String get deleteAll => 'Alle löschen';

  @override
  String get annotateDeleteConfirm =>
      'Alle Annotationen und ihre Bilder von diesem Gerät löschen?';

  @override
  String get noAnnotations =>
      'Noch keine Annotationen. Wähle Bilder aus und tippe auf Annotieren.';

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
  String get annotate => 'Annotieren';

  @override
  String get badgeRedacted => 'Unkenntlich gemacht';

  @override
  String get badgeAnnotated => 'Annotiert';

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
  String get modelDownloadFailed => 'Das Modell konnte nicht geladen werden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get autoUpdateModel => 'Modell automatisch aktualisieren';

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
  String get localOnly =>
      'Nur auf diesem Gerät gespeichert, nie in iCloud oder Backups.';

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
}

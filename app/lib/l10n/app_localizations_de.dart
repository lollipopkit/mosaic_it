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
          '$count privat aussehende Bereiche sind dort noch sichtbar ($classes).',
      many:
          '$count privat aussehende Bereiche sind dort noch sichtbar ($classes).',
      few:
          '$count privat aussehende Bereiche sind dort noch sichtbar ($classes).',
      two: '2 privat aussehende Bereiche sind dort noch sichtbar ($classes).',
      one: '1 privat aussehender Bereich ist dort noch sichtbar ($classes).',
      zero: '0 privat aussehende Bereiche sind dort noch sichtbar ($classes).',
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
  String get appearance => 'Erscheinungsbild';

  @override
  String get theme => 'Design';

  @override
  String get appIcon => 'App-Symbol';

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
    return '$selected / $total ausgewählt';
  }

  @override
  String get fillStyle => 'Füllstil';

  @override
  String get colour => 'Farbe';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images Bilder',
      one: '1 Bild',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions Bereiche',
      one: '1 Bereich',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Teilen';

  @override
  String get saveToPhotos => 'In Fotos sichern';

  @override
  String get saveAs => 'Sichern…';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportSize => 'Größe';

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
      other: '$count Bilder in Fotos gesichert',
      one: '1 Bild in Fotos gesichert',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Alle';

  @override
  String get selectNone => 'Keine';

  @override
  String get suggested => 'vorgeschlagen';

  @override
  String scoreValue(String score) {
    return 'Wert $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Nach der Unkenntlichmachung hat die Prüfung diese Bereiche in der Ausgabe von Bild $index weiterhin gefunden.';
  }

  @override
  String get reasonNotSelected => 'nicht ausgewählt';

  @override
  String get reasonBoxTooSmall => 'Rahmen zu klein';

  @override
  String get reasonFillShowsThrough => 'Füllung deckt nicht ab';

  @override
  String get openSource => 'Quelloffen';

  @override
  String get adaptivePreselectTitle => 'Lokale adaptive Vorauswahl';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Klassen angepasst',
      one: '1 Klasse angepasst',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Lokale Einstellungen zurücksetzen';

  @override
  String get adaptiveResetDone => 'Lokale Einstellungen zurückgesetzt';

  @override
  String get feedbackTitle => 'Erkennungsproblem melden';

  @override
  String get feedbackShort => 'Rückmeldung';

  @override
  String get feedbackMenu => 'Problem melden';

  @override
  String get feedbackAction => 'Melden';

  @override
  String get feedbackAttachScreenshot => 'Screenshot anhängen';

  @override
  String get feedbackModeMasked => 'Nur Fehler';

  @override
  String get feedbackModeFull => 'Gesamtes Bild';

  @override
  String get feedbackModeText => 'Kein Bild';

  @override
  String get feedbackTagMissed => 'Übersehen';

  @override
  String get feedbackTagFalsePositive => 'Fehlalarm';

  @override
  String get feedbackTagBoxDrift => 'Rahmen verschoben';

  @override
  String get feedbackTagWrongClass => 'Falsche Klasse';

  @override
  String get feedbackTagOther => 'Sonstiges';

  @override
  String get feedbackNoteHint => 'Optionale Notiz…';

  @override
  String feedbackCountMasked(int count) {
    return 'Verdeckt $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Übersehen $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Fehlalarm $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Abgewählt $count';
  }

  @override
  String get feedbackBoxMissed => 'Übersehen';

  @override
  String get feedbackBoxMissedMasked => 'Übersehen · verdeckt';

  @override
  String get feedbackBoxFp => 'Fehlalarm';

  @override
  String get feedbackBoxPreference => 'Sichtbar lassen';

  @override
  String get introOfflineTitle => 'Kein Netzwerkzugriff';

  @override
  String get introOfflineBody =>
      'MosaicIt enthält keinen Netzwerkcode und fordert keine Netzwerkberechtigung an. Das Erkennungsmodell ist integriert; Bilder verlassen das Gerät nie.';

  @override
  String get introNoNetPermTitle => 'Keine Netzwerkberechtigungen';

  @override
  String get introBundledModelTitle => 'Integriertes On-Device-Modell';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · lokal integriert';
  }

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

  @override
  String get selectMedia => 'Fotos auswählen';

  @override
  String get saveFailed => 'Speichern in Fotos fehlgeschlagen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get iosWirelessPromptTitle => 'Hinweis zu WLAN- & Mobilfunkdaten';

  @override
  String get iosWirelessPromptBody =>
      'Beim Öffnen der System-Fotoauswahl zeigt iOS ggf. eine Datenabfrage für iCloud-Vorschaubilder. MosaicIt nutzt kein Netzwerk – tippe auf „Nicht erlauben“.';

  @override
  String get continueAction => 'Weiter';
}

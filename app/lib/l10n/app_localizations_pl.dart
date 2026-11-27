// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Ładowanie modelu…';

  @override
  String get modelFileType => 'Model';

  @override
  String get useModel => 'Użyj modelu';

  @override
  String get imagesFileType => 'Obrazy';

  @override
  String get detecting => 'Wykrywanie…';

  @override
  String detectingProgress(int current, int total) {
    return 'Wykrywanie $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Najpierw wybierz model';

  @override
  String get findingSimilar => 'Szukanie podobnych…';

  @override
  String similarSelected(int found, int added) {
    return 'Wybrano $found podobne obszary ($added nowe)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Wybrano $found podobne obszary ($added nowe) na $images obrazach';
  }

  @override
  String get saving => 'Zapisywanie…';

  @override
  String get exportHere => 'Eksportuj tutaj';

  @override
  String exportStoppedAt(String name) {
    return 'Eksport zatrzymany na $name';
  }

  @override
  String exportedTo(String path) {
    return 'Wyeksportowano do $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Wyeksportowano do $path (bez dźwięku)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wyeksportowano $count obrazów',
      many: 'Wyeksportowano $count obrazów',
      few: 'Wyeksportowano $count obrazy',
      one: 'Wyeksportowano 1 obraz',
      zero: 'Wyeksportowano 0 obrazów',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Sprawdzanie $name…';
  }

  @override
  String get checkingAndExporting => 'Sprawdzanie i eksportowanie…';

  @override
  String get cancel => 'Anuluj';

  @override
  String get exportAnyway => 'Eksportuj mimo to';

  @override
  String get regionsTooltip => 'Obszary';

  @override
  String get cameraPhoto =>
      'To zdjęcie z aparatu; detektor jest przeznaczony do zrzutów ekranu, więc jego ramki tutaj są nieprawdziwe.';

  @override
  String get modeDraw => 'Rysuj';

  @override
  String get fillSolid => 'Jednolity kolor';

  @override
  String get fillBlocks => 'Szara mozaika';

  @override
  String get fillNoise => 'Szum';

  @override
  String get export => 'Eksportuj';

  @override
  String pickOneModel(String formats) {
    return 'Wybierz dokładnie jeden model $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Wybierz również $name.json';
  }

  @override
  String get analysing => 'Analizowanie';

  @override
  String get followingRegion => 'Śledzenie obszaru';

  @override
  String get exporting => 'Eksportowanie';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count klatek';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Redagowanie $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Błąd sprawdzania eksportu o $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count obszarów wyglądających na prywatne jest nadal widocznych tam ($classes).',
      many:
          '$count obszarów wyglądających na prywatne jest nadal widocznych tam ($classes).',
      few:
          '$count obszary wyglądające na prywatne są nadal widoczne tam ($classes).',
      one:
          '1 obszar wyglądający na prywatny jest nadal widoczny tam ($classes).',
      zero:
          '0 obszarów wyglądających na prywatne jest nadal widocznych tam ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Pokaż klatkę';

  @override
  String get drawMissedRegion => 'Narysuj obszar, którego detektor nie wykrył';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return 'Zredagowano $on z $total śladów · $keyframes klatek kluczowych';
  }

  @override
  String get keepAudio => 'Zachowaj dźwięk';

  @override
  String get keepAudioHint => 'Głosy i dźwięki powiadomień nie są sprawdzane';

  @override
  String get goToFirstAppearance => 'Przejdź do pierwszego wystąpienia';

  @override
  String get classPersonName => 'Imię i nazwisko';

  @override
  String get classAddress => 'Adres';

  @override
  String get classPhone => 'Telefon';

  @override
  String get classEmail => 'E-mail';

  @override
  String get classIdNumber => 'Numer identyfikacyjny';

  @override
  String get classBankCard => 'Karta bankowa';

  @override
  String get classPlate => 'Tablica rejestracyjna';

  @override
  String get classAccountId => 'Konto';

  @override
  String get classAvatar => 'Awatar';

  @override
  String get classFace => 'Twarz';

  @override
  String get classQr => 'Kod QR';

  @override
  String get classBarcode => 'Kod kreskowy';

  @override
  String get classManual => 'Ręczny';

  @override
  String savedModelFailed(String error) {
    return 'Nie udało się załadować zapisanego modelu; wybierz model ponownie. ($error)';
  }

  @override
  String get fillSurround => 'Kolor tła';

  @override
  String get fillTinted => 'Kolorowa mozaika';

  @override
  String get settings => 'Ustawienia';

  @override
  String get classFinance => 'Kwota';

  @override
  String get delete => 'Usuń';

  @override
  String get undo => 'Cofnij';

  @override
  String get redo => 'Ponów';

  @override
  String get similar => 'Podobne';

  @override
  String get thisImage => 'To zdjęcie';

  @override
  String allImagesCount(int count) {
    return 'Wszystkie $count obrazy';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obszarów może być nadal czytelnych',
      many: '$count obszarów może być nadal czytelnych',
      few: '$count obszary mogą być nadal czytelne',
      one: '1 obszar może być nadal czytelny',
      zero: 'Brak obszarów, które mogą być nadal czytelne',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Po zamaskowaniu kontrola nadal wykryła te obszary w pliku wyjściowym.';

  @override
  String get redactThemAndExport => 'Zamaskuj i wyeksportuj';

  @override
  String get showThem => 'Pokaż';

  @override
  String get pickClass => 'Wybierz klasę';

  @override
  String get appearance => 'Wygląd';

  @override
  String get theme => 'Motyw';

  @override
  String get appIcon => 'Ikona aplikacji';

  @override
  String get threshold => 'Próg';

  @override
  String get thresholdLow => 'Niski';

  @override
  String get thresholdMedium => 'Średni';

  @override
  String get thresholdHigh => 'Wysoki';

  @override
  String get redaction => 'Maskowanie';

  @override
  String get style => 'Styl';

  @override
  String get selectedByDefault => 'Domyślnie zaznaczone';

  @override
  String get dataPrivacy => 'Dane i prywatność';

  @override
  String get model => 'Model';

  @override
  String get importModel => 'Importuj inny model';

  @override
  String get advanced => 'Zaawansowane';

  @override
  String get about => 'O aplikacji';

  @override
  String get licenses => 'Licencje open source';

  @override
  String get merge => 'Scal';

  @override
  String get split => 'Rozdziel';

  @override
  String get mergeHint =>
      'Dotknij innej ramki, aby uczynić ją częścią tej samej wartości';

  @override
  String get classOrganization => 'Organizacja';

  @override
  String get classDeviceId => 'Identyfikator urządzenia';

  @override
  String get classSecret => 'Dane uwierzytelniające';

  @override
  String get classPerson => 'Osoba';

  @override
  String get classHealth => 'Zdrowie';

  @override
  String get classPersonalInfo => 'Dane osobowe';

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
}

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
  String get reviewButton => 'Przeglądaj';

  @override
  String get openingLabels => 'Otwieranie etykiet…';

  @override
  String noImagesIn(String name) {
    return 'Brak obrazów w $name';
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
  String get reviewPseudoLabels =>
      'Przeglądaj etykiety pseudo (folder z plikiem coco.json)';

  @override
  String get regionsTooltip => 'Obszary';

  @override
  String get notCalibrated =>
      'Model nie jest skalibrowany: preselekcja używa stałego progu.';

  @override
  String calibratedUnverified(String domain) {
    return 'Skalibrowany na niesprawdzonych danych ($domain): gwarancja czułości nie obowiązuje jeszcze.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Skalibrowany dla obrazów $domain. Inne rodzaje obrazów są poza gwarancją.';
  }

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
  String get verifyNext => 'Zweryfikuj i następny';

  @override
  String get export => 'Eksportuj';

  @override
  String get pickOneModel => 'Wybierz dokładnie jeden model .onnx';

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
  String noLabelsIn(String name) {
    return 'Brak pliku coco.json w $name';
  }

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
  String get collectTitle => 'Zbieraj dane treningowe';

  @override
  String get collectSubtitle =>
      'Zapisuj na tym urządzeniu każdy wyeksportowany obraz, wykryte obszary i Twoje wybory, aby trenować przyszłe modele. Nic nie jest wysyłane.';

  @override
  String collectStats(int count, String size) {
    return 'Obrazy: $count · $size';
  }

  @override
  String get collectDelete => 'Usuń zebrane dane';

  @override
  String get collectDeleteConfirm =>
      'Usunąć z tego urządzenia wszystkie zebrane obrazy i wybory?';

  @override
  String get delete => 'Usuń';

  @override
  String collectFailed(String error) {
    return 'Nie udało się zapisać danych treningowych: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Zapisano etykiety dla obrazów: $count';
  }

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
  String annotateOf(int index, int total) {
    return 'Oznacz $index / $total';
  }

  @override
  String get suggestions => 'Sugestie';

  @override
  String get skip => 'Pomiń';

  @override
  String get nothingPrivate => 'Brak danych prywatnych';

  @override
  String get next => 'Dalej';

  @override
  String get annotateHint =>
      'Dotknij linii tekstu, aby ją obramować, lub przeciągnij, aby narysować';

  @override
  String get annotationData => 'Dane oznaczeń';

  @override
  String get statLabeled => 'Oznaczone';

  @override
  String get statEmpty => 'Brak danych prywatnych';

  @override
  String get statSkipped => 'Pominięte';

  @override
  String get boxesPerClass => 'Ramki według klasy';

  @override
  String get imagesHeader => 'Zdjęcia';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ramek',
      many: '$count ramek',
      few: '$count ramki',
      one: '1 ramka',
      zero: '0 ramki',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Eksportuj wszystko';

  @override
  String get deleteAll => 'Usuń wszystko';

  @override
  String get annotateDeleteConfirm =>
      'Usunąć wszystkie oznaczenia i ich zdjęcia z tego urządzenia?';

  @override
  String get noAnnotations =>
      'Brak oznaczeń. Wybierz zdjęcia i wybierz Oznacz.';

  @override
  String get filterScreenshots => 'Zrzuty ekranu';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get filterVideos => 'Wideo';

  @override
  String get albums => 'Albumy';

  @override
  String get limitedAccess =>
      'MosaicIt może wyświetlać tylko niektóre z Twoich zdjęć';

  @override
  String get manage => 'Zarządzaj';

  @override
  String selectedImages(int count) {
    return '$count zaznaczone';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zamaskuj $count obrazów',
      many: 'Zamaskuj $count obrazów',
      few: 'Zamaskuj $count obrazy',
      one: 'Zamaskuj 1 obraz',
      zero: 'Zamaskuj 0 obrazów',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Oznacz';

  @override
  String get badgeRedacted => 'Zamaskowane';

  @override
  String get badgeAnnotated => 'Oznaczone';

  @override
  String get photosDenied =>
      'MosaicIt potrzebuje dostępu do Twoich zdjęć, aby je wyświetlić tutaj. Zdjęcia nigdy nie opuszczają tego urządzenia.';

  @override
  String get openSettings => 'Otwórz Ustawienia';

  @override
  String get openFiles => 'Otwórz pliki';

  @override
  String get noPhotos => 'Brak zdjęć';

  @override
  String get loading => 'Ładowanie…';

  @override
  String get appearance => 'Wygląd';

  @override
  String get theme => 'Motyw';

  @override
  String get appIcon => 'Ikona aplikacji';

  @override
  String get aspectRatioGrid => 'Siatka z zachowaniem proporcji';

  @override
  String get modelDownloadFailed => 'Nie udało się pobrać modelu';

  @override
  String get retry => 'Ponów';

  @override
  String get autoUpdateModel => 'Aktualizuj model automatycznie';

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
  String get localOnly =>
      'Przechowywane tylko na tym urządzeniu, nigdy w iCloud ani w kopii zapasowej.';

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
  String get downloadingDetector => 'Downloading the detector';

  @override
  String percent(int value) {
    return '$value%';
  }
}

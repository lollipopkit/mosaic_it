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
  String get reviewButton => 'Áttekintés';

  @override
  String get openingLabels => 'Címkék megnyitása…';

  @override
  String noImagesIn(String name) {
    return 'Nincsenek képek a(z) $name mappában';
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
  String get reviewPseudoLabels =>
      'Álnyilvántartások áttekintése (coco.json mappával)';

  @override
  String get regionsTooltip => 'Régiók';

  @override
  String get notCalibrated =>
      'A modell nem kalibrált: az előválasztás rögzített küszöbértéket használ.';

  @override
  String calibratedUnverified(String domain) {
    return 'Nem ellenőrzött adatokon kalibrálva ($domain): a felismerési garancia még nem vonatkozik.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Kalibrálva $domain típusú képekre. Más típusú képek nem tartoznak a garancia körébe.';
  }

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
  String get verifyNext => 'Ellenőrzés és következő';

  @override
  String get export => 'Exportálás';

  @override
  String get pickOneModel => 'Válasszon pontosan egy .onnx modellt';

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
  String noLabelsIn(String name) {
    return 'Nincs coco.json a(z) $name mappában';
  }

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
  String get collectTitle => 'Tanítóadatok gyűjtése';

  @override
  String get collectSubtitle =>
      'Minden exportált kép, a felismert területek és a választásaid mentése erre az eszközre a jövőbeli modellek tanításához. Semmi sem kerül feltöltésre.';

  @override
  String collectStats(int count, String size) {
    return '$count kép · $size';
  }

  @override
  String get collectDelete => 'Gyűjtött adatok törlése';

  @override
  String get collectDeleteConfirm =>
      'Törlöd az összes gyűjtött képet és választást erről az eszközről?';

  @override
  String get delete => 'Törlés';

  @override
  String collectFailed(String error) {
    return 'A tanítóadatok mentése nem sikerült: $error';
  }

  @override
  String labelsSaved(int count) {
    return '$count kép címkéi mentve';
  }

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
  String annotateOf(int index, int total) {
    return 'Jelölés: $index / $total';
  }

  @override
  String get suggestions => 'Javaslatok';

  @override
  String get skip => 'Kihagyás';

  @override
  String get nothingPrivate => 'Nincs privát adat';

  @override
  String get next => 'Következő';

  @override
  String get annotateHint =>
      'Érintsen meg egy szövegsort a bekeretezéshez, vagy húzzon a rajzoláshoz';

  @override
  String get annotationData => 'Jelölési adatok';

  @override
  String get statLabeled => 'Jelölve';

  @override
  String get statEmpty => 'Nincs privát adat';

  @override
  String get statSkipped => 'Kihagyva';

  @override
  String get boxesPerClass => 'Keretek osztályonként';

  @override
  String get imagesHeader => 'Képek';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keret',
      many: 'sok keret',
      few: 'néhány keret',
      two: '2 keret',
      one: '1 keret',
      zero: '0 keret',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Összes exportálása';

  @override
  String get deleteAll => 'Összes törlése';

  @override
  String get annotateDeleteConfirm =>
      'Törli az összes jelölést és a hozzá tartozó képeket erről az eszközről?';

  @override
  String get noAnnotations =>
      'Még nincsenek jelölések. Válasszon ki képeket, és érintse meg a Jelölés gombot.';

  @override
  String get filterScreenshots => 'Képernyőfotók';

  @override
  String get filterAll => 'Összes';

  @override
  String get filterVideos => 'Videók';

  @override
  String get albums => 'Albumok';

  @override
  String get limitedAccess => 'Az MosaicIt csak a fotóinak egy részét látja';

  @override
  String get manage => 'Kezelés';

  @override
  String selectedImages(int count) {
    return '$count kiválasztva';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kép elrejtése',
      many: 'sok kép elrejtése',
      few: 'néhány kép elrejtése',
      two: '2 kép elrejtése',
      one: '1 kép elrejtése',
      zero: '0 kép elrejtése',
    );
    return '$_temp0';
  }

  @override
  String get annotate => 'Jelölés';

  @override
  String get badgeRedacted => 'Eltakarva';

  @override
  String get badgeAnnotated => 'Jelölve';

  @override
  String get photosDenied =>
      'Az MosaicIt-hoz hozzáférés szükséges a fotók megjelenítéséhez. A fotók sosem hagyják el ezt az eszközt.';

  @override
  String get openSettings => 'Beállítások megnyitása';

  @override
  String get openFiles => 'Fájlok megnyitása';

  @override
  String get noPhotos => 'Nincsenek itt fotók';

  @override
  String get loading => 'Betöltés…';

  @override
  String get appearance => 'Megjelenés';

  @override
  String get theme => 'Téma';

  @override
  String get appIcon => 'Alkalmazásikon';

  @override
  String get aspectRatioGrid => 'Rács eredeti képaránnyal';

  @override
  String get modelDownloadFailed => 'A modell letöltése nem sikerült';

  @override
  String get retry => 'Újra';

  @override
  String get autoUpdateModel => 'A modell automatikus frissítése';

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
  String get localOnly =>
      'Csak ezen az eszközön tárolva, sosem az iCloud-ban vagy mentésekben.';

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

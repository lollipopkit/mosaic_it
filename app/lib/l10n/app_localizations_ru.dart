// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Загрузка модели…';

  @override
  String get modelFileType => 'Модель';

  @override
  String get useModel => 'Использовать модель';

  @override
  String get imagesFileType => 'Изображения';

  @override
  String get detecting => 'Поиск…';

  @override
  String detectingProgress(int current, int total) {
    return 'Поиск $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Сначала выберите модель';

  @override
  String get findingSimilar => 'Поиск похожих…';

  @override
  String similarSelected(int found, int added) {
    return 'Выбрано $found похожих областей ($added новых)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Выбрано $found похожих областей ($added новых) на $images изображениях';
  }

  @override
  String get saving => 'Сохранение…';

  @override
  String get exportHere => 'Экспортировать сюда';

  @override
  String exportStoppedAt(String name) {
    return 'Экспорт остановлен на $name';
  }

  @override
  String exportedTo(String path) {
    return 'Экспортировано в $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Экспортировано в $path (без звука)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Экспортировано $count изображений',
      many: 'Экспортировано $count изображений',
      few: 'Экспортировано $count изображения',
      one: 'Экспортировано 1 изображение',
      zero: 'Экспортировано 0 изображений',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Проверка $name…';
  }

  @override
  String get checkingAndExporting => 'Проверка и экспорт…';

  @override
  String get cancel => 'Отмена';

  @override
  String get exportAnyway => 'Экспортировать всё равно';

  @override
  String get regionsTooltip => 'Области';

  @override
  String get notCalibrated =>
      'Модель не откалибрована: предварительный выбор использует фиксированный порог.';

  @override
  String calibratedUnverified(String domain) {
    return 'Откалибрована на неподтверждённых данных ($domain): гарантия полноты пока не действует.';
  }

  @override
  String calibratedFor(String domain) {
    return 'Откалибрована для изображений типа $domain. Другие типы изображений не покрываются гарантией.';
  }

  @override
  String get cameraPhoto =>
      'Это фото с камеры; детектор предназначен для скриншотов, поэтому его рамки здесь ненадёжны.';

  @override
  String get modeDraw => 'Рисование';

  @override
  String get fillSolid => 'Сплошной цвет';

  @override
  String get fillBlocks => 'Серая мозаика';

  @override
  String get fillNoise => 'Шум';

  @override
  String get export => 'Экспорт';

  @override
  String pickOneModel(String formats) {
    return 'Выберите ровно одну модель $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Также выберите $name.json';
  }

  @override
  String get analysing => 'Анализ';

  @override
  String get followingRegion => 'Отслеживание области';

  @override
  String get exporting => 'Экспорт';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count кадров';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Цензурирование $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Ошибка проверки экспорта в $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count областей с конфиденциальной информацией всё ещё видны там ($classes).',
      many:
          '$count областей с конфиденциальной информацией всё ещё видны там ($classes).',
      few:
          '$count области с конфиденциальной информацией всё ещё видны там ($classes).',
      one:
          '1 область с конфиденциальной информацией всё ещё видна там ($classes).',
      zero: 'Там нет видимых областей с конфиденциальной информацией.',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Показать кадр';

  @override
  String get drawMissedRegion =>
      'Нарисуйте область, которую пропустил детектор';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return 'Зацензурено треков: $on из $total · ключевых кадров: $keyframes';
  }

  @override
  String get keepAudio => 'Сохранить звук';

  @override
  String get keepAudioHint => 'Голоса и звуки уведомлений не проверяются';

  @override
  String get goToFirstAppearance => 'Перейти к первому появлению';

  @override
  String get classPersonName => 'Имя';

  @override
  String get classAddress => 'Адрес';

  @override
  String get classPhone => 'Телефон';

  @override
  String get classEmail => 'Эл. почта';

  @override
  String get classIdNumber => 'Номер документа';

  @override
  String get classBankCard => 'Банковская карта';

  @override
  String get classPlate => 'Номерной знак';

  @override
  String get classAccountId => 'Аккаунт';

  @override
  String get classAvatar => 'Аватар';

  @override
  String get classFace => 'Лицо';

  @override
  String get classQr => 'QR-код';

  @override
  String get classBarcode => 'Штрих-код';

  @override
  String get classManual => 'Вручную';

  @override
  String savedModelFailed(String error) {
    return 'Не удалось загрузить сохранённую модель; выберите модель снова. ($error)';
  }

  @override
  String get fillSurround => 'Цвет фона';

  @override
  String get fillTinted => 'Цветная мозаика';

  @override
  String get settings => 'Настройки';

  @override
  String get classFinance => 'Сумма';

  @override
  String get delete => 'Удалить';

  @override
  String get undo => 'Отменить';

  @override
  String get redo => 'Повторить';

  @override
  String get similar => 'Похожие';

  @override
  String get thisImage => 'Текущее изображение';

  @override
  String allImagesCount(int count) {
    return 'Все $count изображения';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Областей могут быть читаемыми: $count',
      many: 'Областей могут быть читаемыми: $count',
      few: 'Области могут быть читаемыми: $count',
      one: '1 область может быть читаемой',
      zero: 'Областей не найдено',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'После скрытия данных проверка снова обнаружила эти области в выводе.';

  @override
  String get redactThemAndExport => 'Скрыть и экспортировать';

  @override
  String get showThem => 'Показать';

  @override
  String get pickClass => 'Выберите класс';

  @override
  String get filterScreenshots => 'Скриншоты';

  @override
  String get filterAll => 'Все';

  @override
  String get filterVideos => 'Видео';

  @override
  String get albums => 'Альбомы';

  @override
  String get limitedAccess =>
      'MosaicIt имеет доступ только к некоторым вашим фотографиям';

  @override
  String get manage => 'Управлять';

  @override
  String selectedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано: $count',
      many: 'Выбрано: $count',
      few: 'Выбрано: $count',
      one: 'Выбрано: $count',
      zero: 'Выбрано: 0',
    );
    return '$_temp0';
  }

  @override
  String redactImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скрыть данные в $count изображениях',
      many: 'Скрыть данные в $count изображениях',
      few: 'Скрыть данные в $count изображениях',
      one: 'Скрыть данные в 1 изображении',
      zero: 'Скрыть данные: 0',
    );
    return '$_temp0';
  }

  @override
  String get badgeRedacted => 'Скрыто';

  @override
  String get photosDenied =>
      'MosaicIt требует доступа к вашим фотографиям, чтобы отображать их здесь. Фотографии никогда не покидают это устройство.';

  @override
  String get openSettings => 'Открыть «Настройки»';

  @override
  String get openFiles => 'Открыть файлы';

  @override
  String get noPhotos => 'Здесь нет фотографий';

  @override
  String get loading => 'Загрузка…';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get theme => 'Тема';

  @override
  String get appIcon => 'Значок приложения';

  @override
  String get aspectRatioGrid => 'Сетка с исходными пропорциями';

  @override
  String get threshold => 'Порог';

  @override
  String get thresholdLow => 'Низкий';

  @override
  String get thresholdMedium => 'Средний';

  @override
  String get thresholdHigh => 'Высокий';

  @override
  String get redaction => 'Скрытие данных';

  @override
  String get style => 'Стиль';

  @override
  String get selectedByDefault => 'Выбрано по умолчанию';

  @override
  String get dataPrivacy => 'Данные и конфиденциальность';

  @override
  String get model => 'Модель';

  @override
  String get importModel => 'Импортировать другую модель';

  @override
  String get advanced => 'Дополнительно';

  @override
  String get about => 'О приложении';

  @override
  String get licenses => 'Лицензии с открытым исходным кодом';

  @override
  String get merge => 'Объединить';

  @override
  String get split => 'Разделить';

  @override
  String get mergeHint =>
      'Нажмите на другую рамку, чтобы сделать её частью того же значения';

  @override
  String get classOrganization => 'Организация';

  @override
  String get classDeviceId => 'Идентификатор устройства';

  @override
  String get classSecret => 'Секретные данные';

  @override
  String get classPerson => 'Человек';

  @override
  String get classHealth => 'Здоровье';

  @override
  String get classPersonalInfo => 'Личные данные';

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
  String get introNoNetPermBody =>
      'No Android INTERNET permission · no macOS network entitlement';

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
}

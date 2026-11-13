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
  String get reviewButton => 'Просмотреть';

  @override
  String get openingLabels => 'Открытие меток…';

  @override
  String noImagesIn(String name) {
    return 'Нет изображений в $name';
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
  String get reviewPseudoLabels =>
      'Просмотреть псевдо-метки (папка с coco.json)';

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
  String get fillLabel => 'Заполнение';

  @override
  String get fillSolid => 'Сплошной цвет';

  @override
  String get fillBlocks => 'Серая мозаика';

  @override
  String get fillNoise => 'Шум';

  @override
  String get verifyNext => 'Проверить и далее';

  @override
  String get export => 'Экспорт';

  @override
  String get pickOneModel => 'Выберите ровно одну модель .onnx';

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
  String noLabelsIn(String name) {
    return 'Нет coco.json в $name';
  }

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
  String get collectTitle => 'Собирать данные для обучения';

  @override
  String get collectSubtitle =>
      'Сохранять на этом устройстве каждое экспортированное изображение, найденные области и ваш выбор для обучения будущих моделей. Ничего не загружается.';

  @override
  String collectStats(int count, String size) {
    return 'Изображений: $count · $size';
  }

  @override
  String get collectDelete => 'Удалить собранные данные';

  @override
  String get collectDeleteConfirm =>
      'Удалить с этого устройства все собранные изображения и выбор?';

  @override
  String get delete => 'Удалить';

  @override
  String collectFailed(String error) {
    return 'Не удалось сохранить данные для обучения: $error';
  }

  @override
  String labelsSaved(int count) {
    return 'Разметка сохранена для изображений: $count';
  }

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
  String annotateOf(int index, int total) {
    return 'Аннотация $index / $total';
  }

  @override
  String get suggestions => 'Предложения';

  @override
  String get skip => 'Пропустить';

  @override
  String get nothingPrivate => 'Нет личных данных';

  @override
  String get next => 'Далее';

  @override
  String get annotateHint =>
      'Нажмите на строку текста, чтобы выделить её, или проведите пальцем, чтобы нарисовать рамку';

  @override
  String get annotationData => 'Данные аннотаций';

  @override
  String get statLabeled => 'Аннотировано';

  @override
  String get statEmpty => 'Нет личных данных';

  @override
  String get statSkipped => 'Пропущено';

  @override
  String get boxesPerClass => 'Рамки по классам';

  @override
  String get imagesHeader => 'Изображения';

  @override
  String boxCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Рамок: $count',
      many: 'Рамок: $count',
      few: 'Рамки: $count',
      one: '1 рамка',
      zero: '0 рамок',
    );
    return '$_temp0';
  }

  @override
  String get exportAll => 'Экспортировать все';

  @override
  String get deleteAll => 'Удалить все';

  @override
  String get annotateDeleteConfirm =>
      'Удалить все аннотации и связанные с ними изображения с этого устройства?';

  @override
  String get noAnnotations =>
      'Аннотаций пока нет. Выберите изображения и нажмите «Аннотировать».';

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
  String get annotate => 'Аннотировать';

  @override
  String get badgeRedacted => 'Скрыто';

  @override
  String get badgeAnnotated => 'Аннотировано';

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
  String get modelDownloadFailed => 'Не удалось загрузить модель';

  @override
  String get retry => 'Повторить';

  @override
  String get autoUpdateModel => 'Обновлять модель автоматически';

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
  String get localOnly =>
      'Хранится только на этом устройстве, никогда в iCloud или резервных копиях.';

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
}

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
      one: 'Экспортировано $count изображение',
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
          '$count область с конфиденциальной информацией всё ещё видна там ($classes).',
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
      one: '$count область может быть читаемой',
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
  String get appearance => 'Внешний вид';

  @override
  String get theme => 'Тема';

  @override
  String get appIcon => 'Значок приложения';

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
    return 'Выбрано $selected / $total';
  }

  @override
  String get fillStyle => 'Стиль заливки';

  @override
  String get colour => 'Цвет';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images изображений',
      many: '$images изображений',
      few: '$images изображения',
      one: '$images изображение',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions областей',
      many: '$regions областей',
      few: '$regions области',
      one: '$regions область',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Поделиться';

  @override
  String get saveToPhotos => 'Сохранить в Фото';

  @override
  String get saveAs => 'Сохранить…';

  @override
  String get exportFormat => 'Формат';

  @override
  String get exportSize => 'Размер';

  @override
  String get sizeOriginal => 'Оригинал';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count изображений сохранено в Фото',
      many: '$count изображений сохранено в Фото',
      few: '$count изображения сохранены в Фото',
      one: '$count изображение сохранено в Фото',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Все';

  @override
  String get selectNone => 'Ничего';

  @override
  String get suggested => 'предложено';

  @override
  String scoreValue(String score) {
    return 'Оценка $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'После скрытия данных проверка снова обнаружила эти области в выводе изображения $index.';
  }

  @override
  String get reasonNotSelected => 'не выбрано';

  @override
  String get reasonBoxTooSmall => 'рамка слишком мала';

  @override
  String get reasonFillShowsThrough => 'заливка просвечивает';

  @override
  String get openSource => 'Открытый исходный код';

  @override
  String get adaptivePreselectTitle => 'Локальный адаптивный предвыбор';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Настроено $count классов',
      many: 'Настроено $count классов',
      few: 'Настроено $count класса',
      one: 'Настроен $count класс',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Сбросить локальные предпочтения';

  @override
  String get adaptiveResetDone => 'Локальные предпочтения сброшены';

  @override
  String get feedbackTitle => 'Сообщить об ошибке распознавания';

  @override
  String get feedbackShort => 'Отзыв';

  @override
  String get feedbackMenu => 'Сообщить об ошибке';

  @override
  String get feedbackAction => 'Сообщить';

  @override
  String get feedbackAttachScreenshot => 'Прикрепить скриншот';

  @override
  String get feedbackModeMasked => 'Только ошибки';

  @override
  String get feedbackModeFull => 'Полное изображение';

  @override
  String get feedbackModeText => 'Без изображения';

  @override
  String get feedbackTagMissed => 'Пропущено';

  @override
  String get feedbackTagFalsePositive => 'Ложное срабатывание';

  @override
  String get feedbackTagBoxDrift => 'Смещение рамки';

  @override
  String get feedbackTagWrongClass => 'Неверный класс';

  @override
  String get feedbackTagOther => 'Другое';

  @override
  String get feedbackNoteHint => 'Необязательная заметка…';

  @override
  String feedbackCountMasked(int count) {
    return 'Скрыто: $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Пропущено: $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Ложные: $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Снято: $count';
  }

  @override
  String get feedbackBoxMissed => 'Пропущено';

  @override
  String get feedbackBoxMissedMasked => 'Пропущено · скрыто';

  @override
  String get feedbackBoxFp => 'Ложное срабатывание';

  @override
  String get feedbackBoxPreference => 'Оставить видимым';

  @override
  String get introOfflineTitle => 'Без доступа к сети';

  @override
  String get introOfflineBody =>
      'MosaicIt не содержит сетевого кода и не запрашивает сетевых разрешений. Модель встроена в приложение, а изображения не покидают устройство.';

  @override
  String get introNoNetPermTitle => 'Без сетевых разрешений';

  @override
  String get introBundledModelTitle => 'Встроенная локальная модель';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · встроена';
  }

  @override
  String get resetBundledModel => 'Использовать встроенную модель';

  @override
  String get reviewIntro => 'Показать введение снова';

  @override
  String get feedbackOpenWeb => 'Открыть веб-форму';

  @override
  String get introNoNetPermBodyIos =>
      'Без сетевых запросов · только на устройстве';

  @override
  String get introNoNetPermBodyAndroid => 'Разрешение INTERNET отсутствует';

  @override
  String get introNoNetPermBodyDesktop => 'Без сетевого доступа в песочнице';

  @override
  String get customModel => 'Пользовательская модель';

  @override
  String modelClassCount(int count) {
    return '$count классов';
  }

  @override
  String get copyImage => 'Копировать изображение';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get copyFailed => 'Не удалось скопировать изображение';

  @override
  String get peekOriginal => 'Удерживайте для просмотра оригинала';

  @override
  String get selectMedia => 'Выбрать фото';

  @override
  String get saveFailed => 'Не удалось сохранить в Фото';

  @override
  String get retry => 'Повторить';

  @override
  String get iosWirelessPromptTitle => 'Запрос беспроводных данных';

  @override
  String get iosWirelessPromptBody =>
      'При открытии системного выбора фото iOS может показать запрос данных для миниатюр iCloud. MosaicIt не использует сеть — выберите «Не разрешать».';

  @override
  String get continueAction => 'Продолжить';
}

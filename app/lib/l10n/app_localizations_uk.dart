// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'MosaicIt';

  @override
  String get loadingModel => 'Завантаження моделі…';

  @override
  String get modelFileType => 'Модель';

  @override
  String get useModel => 'Використати модель';

  @override
  String get imagesFileType => 'Зображення';

  @override
  String get detecting => 'Виявлення…';

  @override
  String detectingProgress(int current, int total) {
    return 'Виявлення $current/$total…';
  }

  @override
  String get chooseModelFirst => 'Спочатку оберіть модель';

  @override
  String get findingSimilar => 'Пошук подібних…';

  @override
  String similarSelected(int found, int added) {
    return 'Вибрано $found подібних областей ($added нових)';
  }

  @override
  String similarSelectedAcross(int found, int added, int images) {
    return 'Вибрано $found подібних областей ($added нових) на $images зображеннях';
  }

  @override
  String get saving => 'Збереження…';

  @override
  String get exportHere => 'Експортувати сюди';

  @override
  String exportStoppedAt(String name) {
    return 'Експорт зупинено на $name';
  }

  @override
  String exportedTo(String path) {
    return 'Експортовано в $path';
  }

  @override
  String exportedToNoAudio(String path) {
    return 'Експортовано в $path (без аудіо)';
  }

  @override
  String exportedImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Експортовано $count зображень',
      many: 'Експортовано $count зображень',
      few: 'Експортовано $count зображення',
      one: 'Експортовано $count зображення',
      zero: 'Експортовано 0 зображень',
    );
    return '$_temp0';
  }

  @override
  String checkingImage(String name) {
    return 'Перевірка $name…';
  }

  @override
  String get checkingAndExporting => 'Перевірка та експорт…';

  @override
  String get cancel => 'Скасувати';

  @override
  String get exportAnyway => 'Експортувати все одно';

  @override
  String get regionsTooltip => 'Області';

  @override
  String get cameraPhoto =>
      'Це фото з камери; детектор призначений для знімків екрана, тому його рамки тут ненадійні.';

  @override
  String get modeDraw => 'Малювання';

  @override
  String get fillSolid => 'Суцільний колір';

  @override
  String get fillBlocks => 'Сіра мозаїка';

  @override
  String get fillNoise => 'Шум';

  @override
  String get export => 'Експорт';

  @override
  String pickOneModel(String formats) {
    return 'Оберіть рівно одну модель $formats';
  }

  @override
  String pickSidecar(String name) {
    return 'Також оберіть $name.json';
  }

  @override
  String get analysing => 'Аналіз';

  @override
  String get followingRegion => 'Стеження за областю';

  @override
  String get exporting => 'Експорт';

  @override
  String busyFrames(String label, int count) {
    return '$label… $count кадрів';
  }

  @override
  String redactingSpan(String start, String end) {
    return 'Зачорнення $start – $end';
  }

  @override
  String exportCheckFailedAt(String time) {
    return 'Помилка перевірки експорту о $time';
  }

  @override
  String videoRegionsVisible(int count, String classes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count приватних областей все ще видимі там ($classes).',
      many: '$count приватних областей все ще видимі там ($classes).',
      few: '$count приватні області все ще видимі там ($classes).',
      one: '$count приватна область все ще видима там ($classes).',
      zero: 'Немає приватних областей, що залишилися видимими там ($classes).',
    );
    return '$_temp0';
  }

  @override
  String get showFrame => 'Показати кадр';

  @override
  String get drawMissedRegion => 'Намалюйте область, яку детектор пропустив';

  @override
  String tracksSummary(int on, int total, int keyframes) {
    return 'Зачорнено $on з $total треків · $keyframes ключових кадрів';
  }

  @override
  String get keepAudio => 'Зберегти аудіо';

  @override
  String get keepAudioHint => 'Голоси та звуки сповіщень не перевіряються';

  @override
  String get goToFirstAppearance => 'Перейти до першого з\'явлення';

  @override
  String get classPersonName => 'Ім\'я';

  @override
  String get classAddress => 'Адреса';

  @override
  String get classPhone => 'Телефон';

  @override
  String get classEmail => 'Ел. пошта';

  @override
  String get classIdNumber => 'Номер ID';

  @override
  String get classBankCard => 'Банківська картка';

  @override
  String get classPlate => 'Номерний знак';

  @override
  String get classAccountId => 'Рахунок';

  @override
  String get classAvatar => 'Аватар';

  @override
  String get classFace => 'Обличчя';

  @override
  String get classQr => 'QR-код';

  @override
  String get classBarcode => 'Штрих-код';

  @override
  String get classManual => 'Ручне';

  @override
  String savedModelFailed(String error) {
    return 'Не вдалося завантажити збережену модель; оберіть модель знову. ($error)';
  }

  @override
  String get fillSurround => 'Колір тла';

  @override
  String get fillTinted => 'Кольорова мозаїка';

  @override
  String get settings => 'Налаштування';

  @override
  String get classFinance => 'Сума';

  @override
  String get delete => 'Видалити';

  @override
  String get undo => 'Скасувати';

  @override
  String get redo => 'Повторити';

  @override
  String get similar => 'Схожі';

  @override
  String get thisImage => 'Це зображення';

  @override
  String allImagesCount(int count) {
    return 'Усі $count зображення';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count областей можуть усе ще бути читабельними',
      many: '$count областей можуть усе ще бути читабельними',
      few: '$count області можуть усе ще бути читабельними',
      one: '$count область може все ще бути читабельною',
      zero: 'Немає областей, які можуть бути прочитані',
    );
    return '$_temp0';
  }

  @override
  String get exportCheckBody =>
      'Після приховування перевірка все одно знайшла ці області в результаті.';

  @override
  String get redactThemAndExport => 'Приховати та експортувати';

  @override
  String get showThem => 'Показати';

  @override
  String get pickClass => 'Оберіть клас';

  @override
  String get appearance => 'Вигляд';

  @override
  String get theme => 'Тема';

  @override
  String get appIcon => 'Іконка програми';

  @override
  String get threshold => 'Поріг';

  @override
  String get thresholdLow => 'Низький';

  @override
  String get thresholdMedium => 'Середній';

  @override
  String get thresholdHigh => 'Високий';

  @override
  String get redaction => 'Приховування';

  @override
  String get style => 'Стиль';

  @override
  String get selectedByDefault => 'Вибрано за замовчуванням';

  @override
  String get dataPrivacy => 'Дані та конфіденційність';

  @override
  String get model => 'Модель';

  @override
  String get importModel => 'Імпортувати іншу модель';

  @override
  String get advanced => 'Розширені';

  @override
  String get about => 'Про додаток';

  @override
  String get licenses => 'Ліцензії з відкритим кодом';

  @override
  String get merge => 'Об\'єднати';

  @override
  String get split => 'Розділити';

  @override
  String get mergeHint =>
      'Торкніться іншої рамки, щоб зробити її частиною того самого значення';

  @override
  String get classOrganization => 'Організація';

  @override
  String get classDeviceId => 'Ідентифікатор пристрою';

  @override
  String get classSecret => 'Секретні дані';

  @override
  String get classPerson => 'Людина';

  @override
  String get classHealth => 'Здоров’я';

  @override
  String get classPersonalInfo => 'Особисті дані';

  @override
  String selectedOf(int selected, int total) {
    return 'Вибрано $selected / $total';
  }

  @override
  String get fillStyle => 'Стиль заповнення';

  @override
  String get colour => 'Колір';

  @override
  String exportSummary(num images, num regions) {
    String _temp0 = intl.Intl.pluralLogic(
      images,
      locale: localeName,
      other: '$images зображень',
      many: '$images зображень',
      few: '$images зображення',
      one: '$images зображення',
    );
    String _temp1 = intl.Intl.pluralLogic(
      regions,
      locale: localeName,
      other: '$regions областей',
      many: '$regions областей',
      few: '$regions області',
      one: '$regions область',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get share => 'Поділитися';

  @override
  String get saveToPhotos => 'Зберегти у Фото';

  @override
  String get saveAs => 'Зберегти…';

  @override
  String get exportFormat => 'Формат';

  @override
  String get exportSize => 'Розмір';

  @override
  String get sizeOriginal => 'Оригінал';

  @override
  String sizePixels(int px) {
    return '$px px';
  }

  @override
  String savedToPhotos(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зображень збережено у Фото',
      many: '$count зображень збережено у Фото',
      few: '$count зображення збережено у Фото',
      one: '$count зображення збережено у Фото',
    );
    return '$_temp0';
  }

  @override
  String get selectAll => 'Усі';

  @override
  String get selectNone => 'Жодної';

  @override
  String get suggested => 'запропоновано';

  @override
  String scoreValue(String score) {
    return 'Оцінка $score';
  }

  @override
  String exportCheckBodyOf(int index) {
    return 'Після приховування перевірка все одно знайшла ці області в результаті зображення $index.';
  }

  @override
  String get reasonNotSelected => 'не вибрано';

  @override
  String get reasonBoxTooSmall => 'рамка замала';

  @override
  String get reasonFillShowsThrough => 'заповнення просвічується';

  @override
  String get openSource => 'Відкритий код';

  @override
  String get adaptivePreselectTitle => 'Локальний адаптивний передвибір';

  @override
  String adaptiveLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Налаштовано $count класів',
      many: 'Налаштовано $count класів',
      few: 'Налаштовано $count класи',
      one: 'Налаштовано $count клас',
    );
    return '$_temp0';
  }

  @override
  String get adaptiveReset => 'Скинути локальні налаштування';

  @override
  String get adaptiveResetDone => 'Локальні налаштування скинуто';

  @override
  String get feedbackTitle => 'Повідомити про помилку виявлення';

  @override
  String get feedbackShort => 'Відгук';

  @override
  String get feedbackMenu => 'Повідомити про проблему';

  @override
  String get feedbackAction => 'Повідомити';

  @override
  String get feedbackAttachScreenshot => 'Додати знімок екрана';

  @override
  String get feedbackModeMasked => 'Лише помилки';

  @override
  String get feedbackModeFull => 'Повне зображення';

  @override
  String get feedbackModeText => 'Без зображення';

  @override
  String get feedbackTagMissed => 'Пропущено';

  @override
  String get feedbackTagFalsePositive => 'Хибне спрацювання';

  @override
  String get feedbackTagBoxDrift => 'Зміщення рамки';

  @override
  String get feedbackTagWrongClass => 'Неправильний клас';

  @override
  String get feedbackTagOther => 'Інше';

  @override
  String get feedbackNoteHint => 'Необов’язкова примітка…';

  @override
  String feedbackCountMasked(int count) {
    return 'Приховано: $count';
  }

  @override
  String feedbackCountMissed(int count) {
    return 'Пропущено: $count';
  }

  @override
  String feedbackCountFp(int count) {
    return 'Хибні: $count';
  }

  @override
  String feedbackCountPreference(int count) {
    return 'Знято: $count';
  }

  @override
  String get feedbackBoxMissed => 'Пропущено';

  @override
  String get feedbackBoxMissedMasked => 'Пропущено · приховано';

  @override
  String get feedbackBoxFp => 'Хибне спрацювання';

  @override
  String get feedbackBoxPreference => 'Залишити видимим';

  @override
  String get introOfflineTitle => 'Без доступу до мережі';

  @override
  String get introOfflineBody =>
      'MosaicIt не містить мережевого коду й не запитує дозволів на мережу. Детектор вбудовано в додаток, а зображення ніколи не залишають ваш пристрій.';

  @override
  String get introNoNetPermTitle => 'Жодних мережевих дозволів';

  @override
  String get introBundledModelTitle => 'Вбудована модель на пристрої';

  @override
  String introBundledModelBody(String version) {
    return 'unseen-det $version · на пристрої';
  }

  @override
  String get resetBundledModel => 'Використати вбудовану модель';

  @override
  String get reviewIntro => 'Показати вступ знову';

  @override
  String get feedbackOpenWeb => 'Відкрити вебформу';

  @override
  String get introNoNetPermBodyIos =>
      'Жодних мережевих запитів · лише на пристрої';

  @override
  String get introNoNetPermBodyAndroid => 'Дозвіл INTERNET не оголошено';

  @override
  String get introNoNetPermBodyDesktop => 'Без мережевого доступу в пісочниці';

  @override
  String get customModel => 'Власна модель';

  @override
  String modelClassCount(int count) {
    return '$count класів';
  }

  @override
  String get copyImage => 'Копіювати зображення';

  @override
  String get copiedToClipboard => 'Скопійовано в буфер обміну';

  @override
  String get copyFailed => 'Не вдалося скопіювати зображення';

  @override
  String get peekOriginal => 'Утримуйте, щоб порівняти з оригіналом';

  @override
  String get selectMedia => 'Вибрати фото';

  @override
  String get saveFailed => 'Не вдалося зберегти у Фото';

  @override
  String get retry => 'Повторити';

  @override
  String get iosWirelessPromptTitle => 'Запит на бездротові дані';

  @override
  String get iosWirelessPromptBody =>
      'Відкриття системного вибору фото може викликати запит iOS на бездротові дані для мініатюр iCloud. MosaicIt не використовує мережу — натисніть «Не дозволяти».';

  @override
  String get continueAction => 'Продовжити';
}

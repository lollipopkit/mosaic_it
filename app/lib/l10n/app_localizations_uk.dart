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
      one: 'Експортовано 1 зображення',
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
      one: '1 приватна область все ще видима там ($classes).',
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
  String get thisImage => 'Ця зображення';

  @override
  String allImagesCount(int count) {
    return 'Усі $count зображення';
  }

  @override
  String exportCheckTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count областей можуть бути ще прочитано',
      many: '$count областей можуть бути ще прочитано',
      few: '$count області можуть бути ще прочитано',
      one: '1 область може бути ще прочитано',
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

  @override
  String get iosWirelessPromptTitle => 'Wireless data prompt';

  @override
  String get iosWirelessPromptBody =>
      'Opening the system photo picker may trigger an iOS wireless data prompt for iCloud thumbnails. MosaicIt does not use the network — tap “Don’t Allow”.';

  @override
  String get continueAction => 'Continue';
}

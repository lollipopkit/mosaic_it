import type { Copy } from './types';

export const ru: Copy = {
  meta: {
    lang: 'ru',
    dir: 'ltr',
    title: 'MosaicIt — Локальное скрытие приватных данных',
    description:
      'Находите и скрывайте конфиденциальные данные на скриншотах и фотографиях полностью офлайн. Без OCR, без сетевых запросов и без доступа на чтение фототеки.',
  },
  nav: {
    screenshots: 'Скриншоты',
    features: 'Возможности',
    privacy: 'Приватность',
    download: 'Скачать',
    docs: 'Документация',
    feedback: 'Отзыв',
    github: 'GitHub',
    languageLabel: 'Язык',
    cta: 'Скачать',
  },
  hero: {
    titlePrefix: 'Скрывайте личные данные,',
    titleSuffix: 'полностью офлайн.',
    subtitle:
      'MosaicIt распознаёт имена, номера телефонов, адреса, суммы, номера документов, QR-коды и лица прямо на устройстве — без OCR, без сетевого кода и без чтения вашей фототеки.',
    primaryAction: 'Скачать MosaicIt',
    feedbackAction: 'Веб-отзыв',
    githubAction: 'GitHub',
  },
  features: {
    title: 'Создано для быстрого и проверяемого скрытия данных.',
    cards: [
      {
        tag: 'unseen-det 0.6.0',
        title: 'Быстрое и энергоэффективное распознавание на ANE / GPU',
        description:
          'Встроенные лёгкие веса FP16 работают на Apple Neural Engine (ANE / NPU через CoreML) и мобильном GPU Android (LiteRT), обеспечивая миллисекундный и экономичный инференс: 18 классов персональных данных и лица YuNet определяются напрямую без OCR, словарей и регулярных выражений.',
      },
      {
        tag: '5 стилей',
        title: 'Необратимая перезапись пикселей',
        description:
          'Выберите Заливка, В тон фона, Блоки, Цветные блоки или Шум. Ни один стиль не читает пиксели внутри скрытой области, исключая восстановление после пикселизации или размытия.',
      },
      {
        tag: 'Самопроверка',
        title: 'Повторная проверка перед экспортом',
        description:
          'Перед сохранением или отправкой MosaicIt может повторно прогнать детектор по обработанному изображению, чтобы выявить оставшиеся незакрытые области.',
      },
      {
        tag: 'Пакетно и адаптивно',
        title: 'Пакетная обработка и локальное обучение',
        description:
          'Открывайте сразу несколько скриншотов, запускайте поиск похожих областей по всей серии, а локальное обучение предпочтений подстроит пороги под ваши действия.',
      },
      {
        tag: 'Сразу в редактор',
        title: 'Предпросмотр оригинала, копирование и «Поделиться»',
        description:
          'Приложение открывается прямо в редакторе. Удерживайте значок глаза для сравнения с оригиналом, копируйте в буфер обмена или принимайте файлы через «Поделиться», «Открыть с помощью» и перетаскивание.',
      },
      {
        tag: 'Ядро Rust + CLI',
        title: 'Скриптуемый CLI unseen',
        description:
          'Общий движок unseen-core лежит в основе приложения Flutter и автономной утилиты CLI для пакетной обработки и проверки моделей по BLAKE3.',
      },
    ],
    classesTitle: '19 поддерживаемых классов',
  },
  privacy: {
    title: 'Никакой сети. Никакого чтения фототеки.',
    factors: [
      {
        tag: 'Офлайн-сборка',
        title: 'В приложении нет сетевого кода',
        description:
          'Веса моделей встроены в пакет приложения; в нём нет HTTP-клиента, SDK аналитики, отправки отчётов о сбоях и сетевых прав. CI проверяет отсутствие сетевых зависимостей при каждой сборке.',
      },
      {
        tag: 'Только системный выбор',
        title: 'Без доступа на чтение фототеки',
        description:
          'На iOS используется изолированный PHPickerViewController и сохранение только с правом .addOnly. На Android задействован системный Photo Picker, а транзитивные разрешения удаляются из релизных манифестов.',
      },
    ],
    tableColArea: 'Граница',
    tableColDetail: 'Реализация',
    rows: [
      {
        area: 'Обработка изображений',
        detail:
          'Обнаружение областей, обработка ориентации EXIF и перезапись пикселей выполняются локально на Rust (unseen-core) через FFI.',
      },
      {
        area: 'Необратимость скрытия',
        detail:
          'Стили Заливка, Блоки и Шум полностью игнорируют исходные пиксели. В тон фона и Цветные блоки берут пробу только из кольца шириной 4 px снаружи рамки.',
      },
      {
        area: 'Добровольный отзыв о детекции',
        detail:
          'Отправка пропусков или ложных срабатываний открывает mosaic.lollipopkit.com/feedback в системном браузере через URL #fragment, который не попадает в логи HTTP GET и сразу очищается через history.replaceState.',
      },
      {
        area: 'Воспроизводимый открытый код',
        detail:
          'Приложение, ядро на Rust, сервис отзывов и опубликованные веса моделей распространяются под лицензией AGPL-3.0 с контрольными суммами BLAKE3.',
      },
    ],
  },
  download: {
    title: 'Нативно на смартфонах и компьютерах.',
    currentBadge: 'Текущая платформа',
    releasesAction: 'Релизы GitHub',
    sourceAction: 'Собрать из исходников',
    cliPrompt: '# Собрать Rust CLI (unseen)',
    appPrompt: '# Запустить приложение Flutter из исходников',
    copy: 'Копировать',
    copied: 'Скопировано',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Без разрешений в релизе' },
      linux: { name: 'Linux', meta: 'Десктопное приложение (tar.gz) и unseen CLI' },
      windows: { name: 'Windows', meta: 'Десктопное приложение (ZIP) и unseen CLI' },
    },
  },
  cta: {
    title: 'Открытый исходный код под AGPL-3.0.',
    feedbackAction: 'Открыть веб-отзыв',
    releasesAction: 'Релизы GitHub',
    githubAction: 'Исходный код',
  },
  more: {
    title: 'Другие проекты lollipopkit.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Мониторинг серверов, сенсорный SSH-терминал, SFTP, Docker, systemd и инструменты S.M.A.R.T. в одном нативном приложении.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Монтируйте SFTP, S3, WebDAV и удалённые хранилища прямо в Finder на macOS через Apple File Provider без расширений ядра.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Нативный клиент для OpenAI и совместимых LLM API с локальным хранением истории чатов, вызовом инструментов и пользовательскими эндпоинтами.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Возможности',
    privacy: 'Приватность',
    download: 'Скачать',
    docs: 'Документация',
    feedback: 'Отзыв',
    releases: 'Релизы',
    license: 'AGPL-3.0',
  },
};

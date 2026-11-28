import type { Copy } from './types';

export const uk: Copy = {
  meta: {
    lang: 'uk',
    dir: 'ltr',
    title: 'MosaicIt — Локальне приховування приватних даних',
    description:
      'Виявляйте та приховуйте конфіденційну інформацію на знімках екрана й фото повністю офлайн. Без OCR, без мережевих запитів і без доступу на читання фототеки.',
  },
  nav: {
    screenshots: 'Знімки екрана',
    features: 'Можливості',
    privacy: 'Приватність',
    download: 'Завантажити',
    feedback: 'Відгук',
    github: 'GitHub',
    languageLabel: 'Мова',
    cta: 'Завантажити',
  },
  hero: {
    titlePrefix: 'Приховуйте особисті дані,',
    titleSuffix: 'повністю офлайн.',
    subtitle:
      'MosaicIt виявляє імена, номери телефонів, адреси, фінансові суми, документи, QR-коди та обличчя прямо на пристрої — без OCR, без мережевого коду й без читання вашої фототеки.',
    primaryAction: 'Завантажити MosaicIt',
    feedbackAction: 'Вебвідгук',
    githubAction: 'GitHub',
  },
  features: {
    title: 'Створено для швидкого й перевіреного приховування даних.',
    cards: [
      {
        tag: 'unseen-det 0.6.0',
        title: 'Швидке й енергоефективне виявлення на ANE / GPU',
        description:
          'Вбудовані легкі ваги FP16 працюють на Apple Neural Engine (ANE / NPU через CoreML) і мобільному GPU Android (LiteRT) із мілісекундним та ощадливим інференсом: 18 класів персональних даних і обличчя YuNet визначаються напряму без OCR, словників чи регулярних виразів.',
      },
      {
        tag: '5 стилів',
        title: 'Незворотний перезапис пікселів',
        description:
          'Оберіть Суцільний, У тон фону, Блоки, Кольорові блоки або Шум. Жоден стиль не зчитує пікселі всередині прихованої області, унеможливлюючи відновлення після пікселізації чи розмиття.',
      },
      {
        tag: 'Самоперевірка',
        title: 'Повторне сканування перед експортом',
        description:
          'Перед збереженням або поширенням MosaicIt може повторно запустити детектор на обробленому зображенні, щоб підсвітити будь-які неприховані ділянки.',
      },
      {
        tag: 'Пакетно й адаптивно',
        title: 'Пакетна обробка та локальне навчання',
        description:
          'Відкривайте кілька скриншотів одночасно, шукайте схожі ділянки в усій серії, а локальне навчання вподобань автоматично підлаштує пороги під ваш вибір.',
      },
      {
        tag: 'Одразу в редактор',
        title: 'Перегляд оригіналу, копіювання та системний «Поділитися»',
        description:
          'Запускається безпосередньо в редакторі. Утримуйте значок ока для порівняння з оригіналом, копіюйте в буфер обміну або приймайте файли через «Поділитися», «Відкрити за допомогою» та перетягування.',
      },
      {
        tag: 'Ядро Rust + CLI',
        title: 'Скриптований CLI unseen',
        description:
          'Спільний рушій unseen-core забезпечує роботу Flutter-застосунку та автономного CLI для пакетного приховування й перевірки моделей через BLAKE3.',
      },
    ],
    classesTitle: '19 підтримуваних класів',
  },
  privacy: {
    title: 'Нуль мережі. Нуль доступу на читання фототеки.',
    factors: [
      {
        tag: 'Офлайн-збірка',
        title: 'У застосунку немає мережевого коду',
        description:
          'Застосунок постачається з вбудованими вагами моделей і не містить HTTP-клієнта, SDK аналітики, звітів про збої чи мережевих прав. CI перевіряє відсутність мережевих залежностей у кожній збірці.',
      },
      {
        tag: 'Лише системний вибір',
        title: 'Без дозволу на читання фототеки',
        description:
          'iOS використовує ізольований PHPickerViewController і збереження лише з правом .addOnly. Android використовує системний Photo Picker та видаляє транзитивні дозволи з релізних маніфестів.',
      },
    ],
    tableColArea: 'Межа',
    tableColDetail: 'Реалізація',
    rows: [
      {
        area: 'Обробка зображень',
        detail:
          'Виявлення, корекція орієнтації EXIF та перезапис пікселів виконуються локально на Rust (unseen-core) через FFI.',
      },
      {
        area: 'Незворотність приховування',
        detail:
          'Стилі Суцільний, Блоки та Шум повністю ігнорують вихідні пікселі. У тон фону та Кольорові блоки беруть зразок лише з кільця завширшки 4 px зовні рамки.',
      },
      {
        area: 'Необовʼязковий відгук про виявлення',
        detail:
          'Надсилання пропусків або хибних спрацьовувань відкриває mosaic.lollipopkit.com/feedback у системному браузері через URL #fragment, який ніколи не потрапляє в журнали HTTP GET і миттєво очищується через history.replaceState.',
      },
      {
        area: 'Відтворюваний відкритий код',
        detail:
          'Застосунок, ядро на Rust, сервіс відгуків та опубліковані ваги моделей доступні під ліцензією AGPL-3.0 із контрольними сумами BLAKE3.',
      },
    ],
  },
  download: {
    title: 'Нативно для смартфонів і компʼютерів.',
    currentBadge: 'Поточна платформа',
    releasesAction: 'Релізи GitHub',
    sourceAction: 'Зібрати з коду',
    cliPrompt: '# Зібрати Rust CLI (unseen)',
    appPrompt: '# Запустити Flutter-застосунок із вихідного коду',
    copy: 'Копіювати',
    copied: 'Скопійовано',
    platforms: {
      ios: { name: 'iOS', meta: 'IPA · ONNX' },
      macos: { name: 'macOS', meta: 'DMG · Apple Silicon' },
      android: { name: 'Android', meta: 'APK · LiteRT · Нуль дозволів у релізі' },
      linux: { name: 'Linux', meta: 'Десктопний застосунок (tar.gz) та unseen CLI' },
      windows: { name: 'Windows', meta: 'Десктопний застосунок (ZIP) та unseen CLI' },
    },
  },
  cta: {
    title: 'Відкритий код під ліцензією AGPL-3.0.',
    feedbackAction: 'Відкрити вебвідгук',
    releasesAction: 'Релізи GitHub',
    githubAction: 'Переглянути код',
  },
  more: {
    title: 'Більше від lollipopkit.',
    apps: [
      {
        title: 'ServerBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Моніторинг стану серверів, сенсорний SSH-термінал, SFTP, Docker, systemd та інструменти S.M.A.R.T. в одному нативному середовищі.',
        action: 'serverbox.lollipopkit.com',
        href: 'https://serverbox.lollipopkit.com',
      },
      {
        title: 'MFuse',
        tag: 'macOS · File Provider',
        description:
          'Монтуйте SFTP, S3, WebDAV та віддалені сховища у Finder на macOS через Apple File Provider без розширень ядра.',
        action: 'mfuse.lollipopkit.com',
        href: 'https://mfuse.lollipopkit.com',
      },
      {
        title: 'LLMBox',
        tag: 'iOS · Android · macOS · Linux · Windows',
        description:
          'Нативний клієнт для OpenAI та сумісних LLM API з локальним зберіганням історії чатів, викликом інструментів і власними кінцевими точками.',
        action: 'GitHub',
        href: 'https://github.com/lollipopkit/llmbox',
      },
    ],
  },
  footer: {
    features: 'Можливості',
    privacy: 'Приватність',
    download: 'Завантажити',
    feedback: 'Відгук',
    releases: 'Релізи',
    license: 'AGPL-3.0',
  },
};

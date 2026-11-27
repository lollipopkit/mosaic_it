export type Locale =
  | 'en'
  | 'zh-CN'
  | 'zh-TW'
  | 'ja'
  | 'ko'
  | 'de'
  | 'es'
  | 'fr'
  | 'it'
  | 'nl'
  | 'pt'
  | 'ru'
  | 'uk'
  | 'tr'
  | 'id'
  | 'fa'
  | 'az';

export type StyleKey = 'solid' | 'surround' | 'blocks' | 'tinted' | 'noise';

export interface Copy {
  meta: {
    lang: string;
    dir: 'ltr' | 'rtl';
    title: string;
    description: string;
  };
  nav: {
    features: string;
    privacy: string;
    download: string;
    feedback: string;
    github: string;
    languageLabel: string;
    cta: string;
  };
  hero: {
    titlePrefix: string;
    titleSuffix: string;
    subtitle: string;
    primaryAction: string;
    feedbackAction: string;
    githubAction: string;
  };
  demo: {
    ariaLabel: string;
    peekLabel: string;
    resetLabel: string;
    receiptTitle: string;
    recipientLabel: string;
    recipientValue: string;
    phoneLabel: string;
    phoneValue: string;
    addressLabel: string;
    addressValue: string;
    amountLabel: string;
    amountValue: string;
    cardLabel: string;
    cardValue: string;
    qrLabel: string;
    styles: Record<StyleKey, string>;
    classes: {
      person_name: string;
      phone: string;
      address: string;
      finance: string;
      bank_card: string;
      qr: string;
    };
  };
  features: {
    title: string;
    subtitle: string;
    cards: Array<{ tag: string; title: string; description: string }>;
    classesTitle: string;
    classesNote: string;
  };
  privacy: {
    title: string;
    subtitle: string;
    factors: Array<{ tag: string; title: string; description: string }>;
    tableColArea: string;
    tableColDetail: string;
    rows: Array<{ area: string; detail: string }>;
  };
  download: {
    title: string;
    subtitle: string;
    currentBadge: string;
    releasesAction: string;
    sourceAction: string;
    cliPrompt: string;
    appPrompt: string;
    copy: string;
    copied: string;
    platforms: {
      ios: { name: string; meta: string };
      macos: { name: string; meta: string };
      android: { name: string; meta: string };
      linux: { name: string; meta: string };
      windows: { name: string; meta: string };
    };
  };
  cta: {
    title: string;
    subtitle: string;
    feedbackAction: string;
    releasesAction: string;
    githubAction: string;
  };
  more: {
    title: string;
    subtitle: string;
    apps: Array<{
      title: string;
      tag: string;
      description: string;
      action: string;
      href: string;
    }>;
  };
  footer: {
    features: string;
    privacy: string;
    download: string;
    feedback: string;
    releases: string;
    license: string;
  };
}

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

export interface Copy {
  meta: {
    lang: string;
    dir: 'ltr' | 'rtl';
    title: string;
    description: string;
  };
  nav: {
    screenshots: string;
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
  features: {
    title: string;
    cards: Array<{ tag: string; title: string; description: string }>;
    classesTitle: string;
  };
  privacy: {
    title: string;
    factors: Array<{ tag: string; title: string; description: string }>;
    tableColArea: string;
    tableColDetail: string;
    rows: Array<{ area: string; detail: string }>;
  };
  download: {
    title: string;
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
    feedbackAction: string;
    releasesAction: string;
    githubAction: string;
  };
  more: {
    title: string;
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

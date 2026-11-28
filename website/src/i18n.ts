import type { Copy, Locale } from './locales/types';
import { az } from './locales/az';
import { de } from './locales/de';
import { en } from './locales/en';
import { es } from './locales/es';
import { fa } from './locales/fa';
import { fr } from './locales/fr';
import { id } from './locales/id';
import { it } from './locales/it';
import { ja } from './locales/ja';
import { ko } from './locales/ko';
import { nl } from './locales/nl';
import { pt } from './locales/pt';
import { ru } from './locales/ru';
import { tr } from './locales/tr';
import { uk } from './locales/uk';
import { zhCN } from './locales/zh-CN';
import { zhTW } from './locales/zh-TW';

export type { Copy, Locale };

export const LOCALES: { code: Locale; label: string }[] = [
  { code: 'en', label: 'English' },
  { code: 'zh-CN', label: '简体中文' },
  { code: 'zh-TW', label: '繁體中文' },
  { code: 'ja', label: '日本語' },
  { code: 'ko', label: '한국어' },
  { code: 'de', label: 'Deutsch' },
  { code: 'es', label: 'Español' },
  { code: 'fr', label: 'Français' },
  { code: 'it', label: 'Italiano' },
  { code: 'nl', label: 'Nederlands' },
  { code: 'pt', label: 'Português' },
  { code: 'ru', label: 'Русский' },
  { code: 'uk', label: 'Українська' },
  { code: 'tr', label: 'Türkçe' },
  { code: 'id', label: 'Bahasa Indonesia' },
  { code: 'fa', label: 'فارسی' },
  { code: 'az', label: 'Azərbaycanca' },
];

export const DETECTED_CLASSES = [
  'person_name',
  'address',
  'phone',
  'email',
  'id_number',
  'bank_card',
  'plate',
  'account_id',
  'avatar',
  'qr',
  'barcode',
  'finance',
  'organization',
  'device_id',
  'secret',
  'person',
  'health',
  'personal_info',
  'face',
] as const;

export const TRANSLATIONS: Record<Locale, Copy> = {
  en,
  'zh-CN': zhCN,
  'zh-TW': zhTW,
  ja,
  ko,
  de,
  es,
  fr,
  it,
  nl,
  pt,
  ru,
  uk,
  tr,
  id,
  fa,
  az,
};

const STORAGE_KEY = 'mosaic-locale';
const LOCALE_SET = new Set<string>(LOCALES.map((l) => l.code));

export function matchLocale(raw: string | null | undefined): Locale | null {
  if (!raw) return null;
  const norm = raw.trim().toLowerCase().replace(/_/g, '-');
  if (!norm) return null;
  const parts = norm.split('-').filter(Boolean);
  if (parts.length === 0) return null;
  if (parts[0] === 'zh') {
    return parts.some((p) => p === 'tw' || p === 'hk' || p === 'mo' || p === 'hant') ? 'zh-TW' : 'zh-CN';
  }
  const base = parts[0];
  if (LOCALE_SET.has(base)) return base as Locale;
  return null;
}

export function detectInitialLocale(): Locale {
  if (typeof window === 'undefined') return 'en';
  const params = new URLSearchParams(window.location.search);
  const fromQuery = matchLocale(params.get('lang'));
  if (fromQuery) return fromQuery;
  try {
    const fromStorage = matchLocale(window.localStorage.getItem(STORAGE_KEY));
    if (fromStorage) return fromStorage;
  } catch {
    // Ignore storage access restrictions.
  }
  for (const lang of navigator.languages ?? [navigator.language]) {
    const matched = matchLocale(lang);
    if (matched) return matched;
  }
  return 'en';
}

export function persistLocale(locale: Locale): void {
  if (typeof window === 'undefined') return;
  try {
    window.localStorage.setItem(STORAGE_KEY, locale);
  } catch {
    // Ignore storage access restrictions.
  }
}

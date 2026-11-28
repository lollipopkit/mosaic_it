import type { Locale } from '../locales/types';
import { docsEn } from './en';
import { docsZhCN } from './zh-CN';
import { docsZhTW } from './zh-TW';
import type { DocSlug, DocsBundle } from './types';

export type { DocBlock, DocPage, DocSlug, DocsBundle } from './types';

export const DOC_SLUGS: readonly DocSlug[] = ['quick-start', 'editor', 'models', 'cli', 'privacy'] as const;

export function docHref(slug: DocSlug): string {
  return slug === 'quick-start' ? '/docs' : `/docs/${slug}`;
}

export function parseDocSlug(pathname: string): DocSlug | null {
  const clean = pathname.replace(/\/+$/, '');
  if (clean === '/docs') return 'quick-start';
  if (!clean.startsWith('/docs/')) return null;
  const slug = clean.slice('/docs/'.length) as DocSlug;
  return DOC_SLUGS.includes(slug) ? slug : 'quick-start';
}

export function getDocsBundle(locale: Locale): DocsBundle {
  if (locale === 'zh-CN') return docsZhCN;
  if (locale === 'zh-TW') return docsZhTW;
  return docsEn;
}

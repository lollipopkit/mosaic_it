export type DocSlug = 'quick-start' | 'editor' | 'models' | 'cli' | 'privacy';

export type DocBlock =
  | { kind: 'p'; text: string }
  | { kind: 'h3'; text: string }
  | { kind: 'ul'; items: string[] }
  | { kind: 'code'; label?: string; code: string }
  | { kind: 'table'; headers: [string, string]; rows: [string, string][] }
  | { kind: 'note'; text: string };

export interface DocPage {
  slug: DocSlug;
  title: string;
  blocks: DocBlock[];
}

export interface DocsBundle {
  lang: string;
  dir: 'ltr' | 'rtl';
  pageTitle: string;
  sidebarLabel: string;
  paginationLabel: string;
  backHome: string;
  copy: string;
  copied: string;
  prevLabel: string;
  nextLabel: string;
  pages: DocPage[];
}

<script lang="ts">
  import { docHref, type DocSlug, type DocsBundle } from './docs';

  interface Props {
    bundle: DocsBundle;
    activeSlug: DocSlug;
    onSelectSlug: (slug: DocSlug) => void;
    onGoHome: () => void;
  }

  let { bundle, activeSlug, onSelectSlug, onGoHome }: Props = $props();
  let copiedKey = $state<string | null>(null);
  let copyTimer = 0;

  let activeIndex = $derived(
    Math.max(
      0,
      bundle.pages.findIndex((p) => p.slug === activeSlug),
    ),
  );
  let activePage = $derived(bundle.pages[activeIndex] ?? bundle.pages[0]);
  let prevPage = $derived(activeIndex > 0 ? bundle.pages[activeIndex - 1] : null);
  let nextPage = $derived(activeIndex + 1 < bundle.pages.length ? bundle.pages[activeIndex + 1] : null);

  async function copyCode(key: string, text: string) {
    try {
      await navigator.clipboard.writeText(text);
      copiedKey = key;
      if (copyTimer) window.clearTimeout(copyTimer);
      copyTimer = window.setTimeout(() => {
        copiedKey = null;
        copyTimer = 0;
      }, 2000);
    } catch {
      // Clipboard API unavailable.
    }
  }

  $effect(() => {
    return () => {
      if (copyTimer) {
        window.clearTimeout(copyTimer);
        copyTimer = 0;
      }
    };
  });
</script>

<div class="docs-shell" lang={bundle.lang} dir={bundle.dir}>
  <aside class="docs-sidebar">
    <a
      href="/"
      class="docs-back"
      onclick={(e) => {
        if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey || e.button !== 0) return;
        e.preventDefault();
        onGoHome();
      }}
    >
      <span aria-hidden="true">←</span> {bundle.backHome}
    </a>
    <nav class="docs-nav" aria-label={bundle.sidebarLabel}>
      {#each bundle.pages as page}
        <a
          href={docHref(page.slug)}
          class="docs-nav-link"
          class:active={page.slug === activePage.slug}
          aria-current={page.slug === activePage.slug ? 'page' : undefined}
          onclick={(e) => {
            if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey || e.button !== 0) return;
            e.preventDefault();
            onSelectSlug(page.slug);
          }}
        >
          {page.title}
        </a>
      {/each}
    </nav>
  </aside>

  <article class="docs-article">
    <h1>{activePage.title}</h1>

    {#each activePage.blocks as block, idx}
      {#if block.kind === 'p'}
        <p>{block.text}</p>
      {:else if block.kind === 'h3'}
        <h2>{block.text}</h2>
      {:else if block.kind === 'ul'}
        <ul class="docs-list">
          {#each block.items as item}
            <li>{item}</li>
          {/each}
        </ul>
      {:else if block.kind === 'note'}
        <div class="docs-note">{block.text}</div>
      {:else if block.kind === 'table'}
        <div class="docs-table-wrap">
          <table class="docs-table">
            <thead>
              <tr>
                <th scope="col">{block.headers[0]}</th>
                <th scope="col">{block.headers[1]}</th>
              </tr>
            </thead>
            <tbody>
              {#each block.rows as row}
                <tr>
                  <td><strong>{row[0]}</strong></td>
                  <td>{row[1]}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      {:else if block.kind === 'code'}
        {@const key = `${activePage.slug}-${idx}`}
        <div class="code-block docs-code" dir="ltr">
          <div class="code-block-head">
            <span class="prompt">{block.label ?? ''}</span>
            <button type="button" class="copy-btn" onclick={() => copyCode(key, block.code)}>
              {copiedKey === key ? bundle.copied : bundle.copy}
            </button>
          </div>
          <pre class="docs-pre"><code>{block.code}</code></pre>
        </div>
      {/if}
    {/each}

    <nav class="docs-pager" aria-label={bundle.paginationLabel}>
      {#if prevPage}
        <a
          class="docs-pager-link"
          href={docHref(prevPage.slug)}
          onclick={(e) => {
            if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey || e.button !== 0) return;
            e.preventDefault();
            onSelectSlug(prevPage.slug);
          }}
        >
          <span class="docs-pager-label"><span aria-hidden="true">←</span> {bundle.prevLabel}</span>
          <span class="docs-pager-title">{prevPage.title}</span>
        </a>
      {/if}
      {#if nextPage}
        <a
          class="docs-pager-link docs-pager-link--next"
          href={docHref(nextPage.slug)}
          onclick={(e) => {
            if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey || e.button !== 0) return;
            e.preventDefault();
            onSelectSlug(nextPage.slug);
          }}
        >
          <span class="docs-pager-label">{bundle.nextLabel} <span aria-hidden="true">→</span></span>
          <span class="docs-pager-title">{nextPage.title}</span>
        </a>
      {/if}
    </nav>
  </article>
</div>

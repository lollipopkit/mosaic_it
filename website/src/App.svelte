<script lang="ts">
  import EditorDemo from './lib/EditorDemo.svelte';
  import {
    DETECTED_CLASSES,
    LOCALES,
    TRANSLATIONS,
    detectInitialLocale,
    persistLocale,
    type Locale,
  } from './i18n';

  type PlatformId = 'ios' | 'macos' | 'android' | 'linux' | 'windows';

  const REPO_URL = 'https://github.com/lollipopkit/mosaic_it';
  const RELEASES_URL = `${REPO_URL}/releases`;
  const LICENSE_URL = `${REPO_URL}/blob/main/LICENSE`;
  const FEEDBACK_URL = '/feedback';

  const BUILD_COMMANDS = [
    'git clone --recurse-submodules https://github.com/lollipopkit/mosaic_it',
    'cd mosaic_it',
    'cargo build --release -p unseen-cli',
    'cd app && flutter run -d macos',
  ].join('\n');

  function detectPlatform(): PlatformId | null {
    if (typeof navigator === 'undefined') return null;
    const ua = navigator.userAgent.toLowerCase();
    const platform = (navigator.platform ?? '').toLowerCase();
    if (/iphone|ipad|ipod/.test(ua) || (platform === 'macintel' && navigator.maxTouchPoints > 1)) {
      return 'ios';
    }
    if (ua.includes('android')) return 'android';
    if (platform.includes('mac') || ua.includes('mac os')) return 'macos';
    if (platform.includes('win') || ua.includes('windows')) return 'windows';
    if (platform.includes('linux') || ua.includes('linux')) return 'linux';
    return null;
  }

  let locale = $state<Locale>(detectInitialLocale());
  let copied = $state(false);
  const currentPlatform = detectPlatform();

  let copy = $derived(TRANSLATIONS[locale]);

  let orderedPlatforms = $derived.by((): PlatformId[] => {
    const base: PlatformId[] = ['ios', 'macos', 'android', 'linux', 'windows'];
    if (!currentPlatform) return base;
    return [currentPlatform, ...base.filter((p) => p !== currentPlatform)];
  });

  $effect(() => {
    const c = copy;
    document.documentElement.lang = c.meta.lang;
    document.documentElement.dir = c.meta.dir;
    document.title = c.meta.title;
    const desc = document.querySelector('meta[name="description"]');
    if (desc) desc.setAttribute('content', c.meta.description);
    persistLocale(locale);
  });

  async function copyBuildCommands() {
    try {
      await navigator.clipboard.writeText(BUILD_COMMANDS);
      copied = true;
      window.setTimeout(() => {
        copied = false;
      }, 2000);
    } catch {
      // Clipboard API unavailable.
    }
  }
</script>

<header class="site-nav">
  <a class="brand" href="#top">
    <img src="/app_icon.png" alt="" width="28" height="28" />
    <span>MosaicIt</span>
  </a>

  <nav aria-label="Primary">
    <a href="#features">{copy.nav.features}</a>
    <a href="#privacy">{copy.nav.privacy}</a>
    <a href="#download">{copy.nav.download}</a>
    <a href={FEEDBACK_URL}>{copy.nav.feedback}</a>
    <a href={REPO_URL} target="_blank" rel="noopener noreferrer">{copy.nav.github}</a>
  </nav>

  <div class="nav-actions">
    <label class="language-switcher">
      <span class="sr-only">{copy.nav.languageLabel}</span>
      <select bind:value={locale} aria-label={copy.nav.languageLabel}>
        {#each LOCALES as item}
          <option value={item.code}>{item.label}</option>
        {/each}
      </select>
    </label>
    <a class="nav-cta" href="#download">{copy.nav.cta}</a>
  </div>
</header>

<main id="top">
  <section class="hero">
    <div class="hero-copy">
      <h1>
        {copy.hero.titlePrefix}
        <span>{copy.hero.titleSuffix}</span>
      </h1>
      <p class="hero-subtitle">{copy.hero.subtitle}</p>
      <div class="hero-actions">
        <a class="btn-primary" href="#download">{copy.hero.primaryAction}</a>
        <a class="btn-secondary" href={FEEDBACK_URL}>{copy.hero.feedbackAction}</a>
        <a class="btn-secondary" href={REPO_URL} target="_blank" rel="noopener noreferrer">
          {copy.hero.githubAction}
        </a>
      </div>
    </div>

    <div class="hero-stage">
      <EditorDemo {copy} />
    </div>
  </section>

  <section id="features" class="page-section">
    <div class="section-head">
      <h2>{copy.features.title}</h2>
      <p>{copy.features.subtitle}</p>
    </div>

    <div class="feature-grid">
      {#each copy.features.cards as card}
        <article class="feature-card">
          <span class="card-tag">{card.tag}</span>
          <h3>{card.title}</h3>
          <p>{card.description}</p>
        </article>
      {/each}
    </div>

    <div class="classes-block">
      <div class="classes-head">
        <h3>{copy.features.classesTitle}</h3>
        <span>{copy.features.classesNote}</span>
      </div>
      <div class="protocol-badges">
        {#each DETECTED_CLASSES as cls}
          <span class="protocol-badge">{cls}</span>
        {/each}
      </div>
    </div>
  </section>

  <section id="privacy" class="page-section">
    <div class="section-head">
      <h2>{copy.privacy.title}</h2>
      <p>{copy.privacy.subtitle}</p>
    </div>

    <div class="sec-factors">
      {#each copy.privacy.factors as factor}
        <article class="feature-card">
          <span class="card-tag">{factor.tag}</span>
          <h3>{factor.title}</h3>
          <p>{factor.description}</p>
        </article>
      {/each}
    </div>

    <div class="sec-threat-table">
      <div class="sec-threat-head">
        <span>{copy.privacy.tableColArea}</span>
        <span>{copy.privacy.tableColDetail}</span>
      </div>
      {#each copy.privacy.rows as row}
        <div class="sec-threat-row">
          <h3>{row.area}</h3>
          <p>{row.detail}</p>
        </div>
      {/each}
    </div>
  </section>

  <section id="download" class="page-section">
    <div class="section-head">
      <h2>{copy.download.title}</h2>
      <p>{copy.download.subtitle}</p>
    </div>

    <div class="download-list">
      {#each orderedPlatforms as pid}
        {@const item = copy.download.platforms[pid]}
        {@const isCurrent = pid === currentPlatform}
        <div class="download-platform" class:current={isCurrent}>
          <div class="download-platform-copy">
            <h3>
              {#if isCurrent}
                <span class="platform-dot" title={copy.download.currentBadge}></span>
              {/if}
              {item.name}
            </h3>
            <small>{item.meta}</small>
          </div>
          <div class="download-actions">
            <a class="download-icon-btn" href={RELEASES_URL} target="_blank" rel="noopener noreferrer">
              {copy.download.releasesAction}
            </a>
            <a class="download-icon-btn" href={REPO_URL} target="_blank" rel="noopener noreferrer">
              {copy.download.sourceAction}
            </a>
          </div>
        </div>
      {/each}
    </div>

    <div class="code-block" dir="ltr">
      <div class="code-block-head">
        <span class="prompt">{copy.download.cliPrompt}</span>
        <button type="button" class="copy-btn" onclick={copyBuildCommands}>
          {copied ? copy.download.copied : copy.download.copy}
        </button>
      </div>
      <code class="command">git clone --recurse-submodules https://github.com/lollipopkit/mosaic_it &amp;&amp; cd mosaic_it</code>
      <code class="command">cargo build --release -p unseen-cli</code>
      <span class="prompt">{copy.download.appPrompt}</span>
      <code class="command">cd app &amp;&amp; flutter run -d macos</code>
    </div>
  </section>

  <section class="cta-section">
    <div class="cta-block">
      <h2>{copy.cta.title}</h2>
      <p>{copy.cta.subtitle}</p>
      <div class="cta-actions">
        <a class="btn-primary" href={FEEDBACK_URL}>{copy.cta.feedbackAction}</a>
        <a class="btn-secondary" href={RELEASES_URL} target="_blank" rel="noopener noreferrer">
          {copy.cta.releasesAction}
        </a>
        <a class="btn-secondary" href={REPO_URL} target="_blank" rel="noopener noreferrer">
          {copy.cta.githubAction}
        </a>
      </div>
    </div>
  </section>

  <section id="more" class="page-section">
    <div class="section-head">
      <h2>{copy.more.title}</h2>
      <p>{copy.more.subtitle}</p>
    </div>

    <div class="other-apps-grid">
      {#each copy.more.apps as app}
        <article class="feature-card other-app-card">
          <div class="other-app-head">
            <span class="card-tag">{app.tag}</span>
            <h3>
              <a class="other-app-title-link" href={app.href} target="_blank" rel="noopener noreferrer">
                {app.title}
              </a>
            </h3>
            <p>{app.description}</p>
          </div>
          <a class="other-app-link" href={app.href} target="_blank" rel="noopener noreferrer">
            {app.action} →
          </a>
        </article>
      {/each}
    </div>
  </section>
</main>

<footer class="site-footer">
  <span>© 2026 lollipopkit</span>
  <div class="footer-links">
    <a href="#features">{copy.footer.features}</a>
    <a href="#privacy">{copy.footer.privacy}</a>
    <a href="#download">{copy.footer.download}</a>
    <a href={FEEDBACK_URL}>{copy.footer.feedback}</a>
    <a href={REPO_URL} target="_blank" rel="noopener noreferrer">GitHub</a>
    <a href={RELEASES_URL} target="_blank" rel="noopener noreferrer">{copy.footer.releases}</a>
    <a href={LICENSE_URL} target="_blank" rel="noopener noreferrer">{copy.footer.license}</a>
  </div>
</footer>

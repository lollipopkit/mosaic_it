<script lang="ts">
  import { tick } from 'svelte';
  import { fade, scale } from 'svelte/transition';
  import { cubicOut } from 'svelte/easing';
  import {
    DETECTED_CLASSES,
    LOCALES,
    TRANSLATIONS,
    detectInitialLocale,
    persistLocale,
    type Locale,
  } from './i18n';
  import DocsPage from './DocsPage.svelte';
  import { docHref, getDocsBundle, parseDocSlug, type DocSlug } from './docs';

  type PlatformId = 'ios' | 'macos' | 'android' | 'linux' | 'windows';
  type DeviceKey = 'iphone' | 'iphone-duo';
  type FrameKey = DeviceKey | 'cli';
  type SceneKey = '1-chat' | '2-bank' | '4-fill' | '6-batch' | '7-export' | '8-selfcheck';
  type FeatureMedia = { kind: 'app'; scene: SceneKey } | { kind: 'cli' };

  const REPO_URL = 'https://github.com/lollipopkit/mosaic_it';
  const RELEASES_URL = `${REPO_URL}/releases`;
  const LICENSE_URL = `${REPO_URL}/blob/main/LICENSE`;
  const FEEDBACK_URL = '/feedback';

  const DEVICE_VIEWS: { key: DeviceKey; label: string }[] = [
    { key: 'iphone', label: 'iPhone' },
    { key: 'iphone-duo', label: 'iPhone Duo' },
  ];

  const HERO_SHOTS: {
    scene: SceneKey;
    x: number;
    y: number;
    hoverSlot: number;
    rotate: number;
    hoverRotate: number;
    motion: number;
  }[] = [
    { scene: '1-chat', x: -24, y: 8, hoverSlot: -1.5, rotate: -8, hoverRotate: -1.8, motion: 18 },
    { scene: '4-fill', x: -8, y: -4, hoverSlot: -0.5, rotate: -2.5, hoverRotate: -0.6, motion: 12 },
    { scene: '8-selfcheck', x: 9, y: 4, hoverSlot: 0.5, rotate: 3, hoverRotate: 0.6, motion: 14 },
    { scene: '2-bank', x: 24, y: -2, hoverSlot: 1.5, rotate: 8.5, hoverRotate: 1.8, motion: 20 },
  ];

  // 1-to-1 real capture for each feature card in copy.features.cards.
  const FEATURE_MEDIA: FeatureMedia[] = [
    { kind: 'app', scene: '1-chat' },
    { kind: 'app', scene: '4-fill' },
    { kind: 'app', scene: '8-selfcheck' },
    { kind: 'app', scene: '6-batch' },
    { kind: 'app', scene: '7-export' },
    { kind: 'cli' },
  ];

  const BUILD_COMMANDS = [
    'git clone --recurse-submodules https://github.com/lollipopkit/mosaic_it',
    'cd mosaic_it',
    'cargo build --release -p unseen-cli',
    'cd app && flutter run -d macos',
  ].join('\n');

  function prefersReducedMotion(): boolean {
    return typeof window !== 'undefined' && window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;
  }

  function transitionMs(ms: number): number {
    return prefersReducedMotion() ? 0 : ms;
  }

  function scrollBehavior(): ScrollBehavior {
    return prefersReducedMotion() ? 'auto' : 'smooth';
  }

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

  function detectInitialDevice(): DeviceKey {
    if (typeof navigator === 'undefined' || typeof window === 'undefined') return 'iphone';
    const ua = navigator.userAgent || '';
    const platform = navigator.platform || '';
    const minSide = Math.min(window.innerWidth, window.innerHeight);
    const isIpad = /\biPad\b/i.test(ua) || (platform === 'MacIntel' && navigator.maxTouchPoints > 1);
    if (isIpad && minSide >= 540) return 'iphone-duo';
    if (/\bAndroid\b/i.test(ua) && (!/\bMobile\b/i.test(ua) || minSide >= 540)) return 'iphone-duo';
    if (/\biPhone\b/i.test(ua) && minSide >= 540) return 'iphone-duo';
    return 'iphone';
  }

  let locale = $state<Locale>(detectInitialLocale());
  let activeDocSlug = $state<DocSlug | null>(
    typeof window !== 'undefined' ? parseDocSlug(window.location.pathname) : null,
  );
  let copied = $state(false);
  const currentPlatform = detectPlatform();

  let activeDevice = $state<DeviceKey>(detectInitialDevice());
  let userSelectedDevice = false;
  let activeHeroShot = $state(0);
  let activeFeature = $state(0);
  let isDesktopTour = $state(
    typeof window !== 'undefined' && window.matchMedia('(min-width: 861px)').matches,
  );
  let featureItems = $state<(HTMLLIElement | undefined)[]>([]);
  let heroViewportEl = $state<HTMLDivElement | undefined>(undefined);
  let tourEl = $state<HTMLDivElement | undefined>(undefined);
  let heroViewportHeight = $state<number | undefined>(undefined);
  let animateHeroHeight = $state(false);
  let stackMotion = $state({ x: 0, y: 0 });
  let heroAnimTimer = 0;
  let copyTimer = 0;
  let deviceSwitchSeq = 0;

  let copy = $derived(TRANSLATIONS[locale]);
  let docsBundle = $derived(getDocsBundle(locale));
  let shotLocale = $derived(locale === 'zh-CN' ? 'zh' : 'en');
  let isWideDevice = $derived(activeDevice === 'iphone-duo');

  function shotUrl(device: DeviceKey, scene: SceneKey): string {
    const prefix = device === 'iphone-duo' ? 'iphoneduo-inner-landscape' : 'iphone18pro';
    return `/screenshots/${shotLocale}/${prefix}-${scene}.webp`;
  }

  function featureShot(index: number, device: DeviceKey): { frame: FrameKey; src: string } {
    const media = FEATURE_MEDIA[index] ?? FEATURE_MEDIA[0];
    if (media.kind === 'cli') {
      return { frame: 'cli', src: '/screenshots/cli.webp' };
    }
    return { frame: device, src: shotUrl(device, media.scene) };
  }

  let activeFeatureShot = $derived(featureShot(activeFeature, activeDevice));

  function handleStackMove(event: MouseEvent) {
    if (prefersReducedMotion()) return;
    const el = event.currentTarget as HTMLElement;
    const rect = el.getBoundingClientRect();
    const nx = (event.clientX - rect.left) / rect.width - 0.5;
    const ny = (event.clientY - rect.top) / rect.height - 0.5;
    stackMotion = {
      x: Math.max(-0.5, Math.min(0.5, nx)),
      y: Math.max(-0.5, Math.min(0.5, ny)),
    };
  }

  function resetStack() {
    stackMotion = { x: 0, y: 0 };
  }

  function syncActiveFeature() {
    if (typeof window === 'undefined' || !window.matchMedia('(min-width: 861px)').matches) return;
    const items = featureItems.filter((el): el is HTMLLIElement => Boolean(el));
    if (!items.length) return;
    const middle = window.innerHeight / 2;
    let best = 0;
    let bestDistance = Infinity;
    items.forEach((item, index) => {
      const rect = item.getBoundingClientRect();
      const distance = Math.abs(rect.top + rect.height / 2 - middle);
      if (distance < bestDistance) {
        bestDistance = distance;
        best = index;
      }
    });
    activeFeature = best;
  }

  async function selectDevice(device: DeviceKey) {
    userSelectedDevice = true;
    if (device === activeDevice) return;

    const seq = ++deviceSwitchSeq;
    const heroRect = heroViewportEl?.getBoundingClientRect();
    const heroInView = Boolean(heroRect && heroRect.top >= 0 && heroRect.bottom <= window.innerHeight + 160);

    if (heroInView && !prefersReducedMotion()) {
      animateHeroHeight = true;
      if (heroAnimTimer) window.clearTimeout(heroAnimTimer);
      heroAnimTimer = window.setTimeout(() => {
        animateHeroHeight = false;
        heroAnimTimer = 0;
      }, 420);
      activeDevice = device;
      await tick();
      if (seq === deviceSwitchSeq) syncActiveFeature();
      return;
    }

    if (heroAnimTimer) {
      window.clearTimeout(heroAnimTimer);
      heroAnimTimer = 0;
    }
    animateHeroHeight = false;
    const anchor = featureItems[activeFeature] ?? tourEl;
    const beforeTop = anchor?.getBoundingClientRect().top;

    activeDevice = device;
    await tick();
    await tick();
    if (seq !== deviceSwitchSeq) return;

    if (anchor && typeof beforeTop === 'number' && Number.isFinite(beforeTop)) {
      const afterTop = anchor.getBoundingClientRect().top;
      const delta = afterTop - beforeTop;
      if (Math.abs(delta) > 0.5) {
        window.scrollBy({ left: 0, top: delta, behavior: 'instant' });
      }
    }
    syncActiveFeature();
  }

  function measureHeroHeight(node: HTMLElement, deviceKey: DeviceKey) {
    const update = () => {
      if (deviceKey !== activeDevice) return;
      const next = Math.ceil(node.offsetHeight);
      if (next > 0) heroViewportHeight = next;
    };
    update();
    const ro = typeof ResizeObserver !== 'undefined' ? new ResizeObserver(update) : undefined;
    ro?.observe(node);
    return {
      destroy() {
        ro?.disconnect();
      },
    };
  }

  function syncNavOffset(node: HTMLElement) {
    const update = () => {
      const top = parseFloat(getComputedStyle(node).top) || 0;
      const bottom = Math.ceil(top + node.offsetHeight);
      if (bottom > 0) {
        document.documentElement.style.setProperty('--nav-bottom', `${bottom}px`);
      }
    };
    update();
    window.addEventListener('resize', update, { passive: true });
    const ro = typeof ResizeObserver !== 'undefined' ? new ResizeObserver(update) : undefined;
    ro?.observe(node);
    return {
      destroy() {
        window.removeEventListener('resize', update);
        ro?.disconnect();
      },
    };
  }

  $effect(() => {
    const items = featureItems.filter(Boolean);
    if (!items.length) return;
    let frame = 0;
    const update = () => {
      frame = 0;
      syncActiveFeature();
    };
    const onViewportChange = () => {
      if (!frame) frame = requestAnimationFrame(update);
    };
    window.addEventListener('scroll', onViewportChange, { passive: true });
    window.addEventListener('resize', onViewportChange, { passive: true });
    update();
    return () => {
      window.removeEventListener('scroll', onViewportChange);
      window.removeEventListener('resize', onViewportChange);
      if (frame) cancelAnimationFrame(frame);
    };
  });

  $effect(() => {
    const mq = window.matchMedia('(min-width: 861px)');
    const onMq = () => {
      isDesktopTour = mq.matches;
    };
    onMq();
    mq.addEventListener('change', onMq);

    const syncDevice = () => {
      if (userSelectedDevice) return;
      const detected = detectInitialDevice();
      if (detected !== activeDevice) activeDevice = detected;
    };
    window.addEventListener('resize', syncDevice, { passive: true });
    return () => {
      mq.removeEventListener('change', onMq);
      window.removeEventListener('resize', syncDevice);
      if (heroAnimTimer) {
        window.clearTimeout(heroAnimTimer);
        heroAnimTimer = 0;
      }
      if (copyTimer) {
        window.clearTimeout(copyTimer);
        copyTimer = 0;
      }
    };
  });

  let orderedPlatforms = $derived.by((): PlatformId[] => {
    const base: PlatformId[] = ['ios', 'macos', 'android', 'linux', 'windows'];
    if (!currentPlatform) return base;
    return [currentPlatform, ...base.filter((p) => p !== currentPlatform)];
  });

  function navigateToDocs(slug: DocSlug = 'quick-start') {
    activeDocSlug = slug;
    if (typeof window !== 'undefined') {
      const target = docHref(slug);
      if (`${window.location.pathname}${window.location.hash}` !== target) {
        window.history.pushState({}, '', target);
      }
      window.scrollTo({ top: 0, behavior: 'instant' });
    }
  }

  async function navigateHome(hash?: string) {
    const wasDocs = activeDocSlug !== null;
    activeDocSlug = null;
    if (typeof window !== 'undefined') {
      const target = hash ? `/${hash}` : '/';
      if (`${window.location.pathname}${window.location.hash}` !== target) {
        window.history.pushState({}, '', target);
      }
      await tick();
      if (hash) {
        const el = document.querySelector(hash);
        if (el) {
          el.scrollIntoView({ behavior: scrollBehavior() });
          return;
        }
      }
      window.scrollTo({ top: 0, behavior: wasDocs ? 'instant' : scrollBehavior() });
    }
  }

  function handleInternalLink(event: MouseEvent, action: () => void) {
    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey || event.button !== 0) {
      return;
    }
    event.preventDefault();
    action();
  }

  $effect(() => {
    const onPopState = async () => {
      const nextSlug = parseDocSlug(window.location.pathname);
      activeDocSlug = nextSlug;
      await tick();
      if (nextSlug !== null) {
        window.scrollTo({ top: 0, behavior: 'instant' });
      } else if (window.location.hash) {
        const el = document.querySelector(window.location.hash);
        if (el) {
          el.scrollIntoView({ behavior: 'instant' });
        }
      }
    };
    window.addEventListener('popstate', onPopState);
    return () => window.removeEventListener('popstate', onPopState);
  });

  $effect(() => {
    const c = copy;
    document.documentElement.lang = c.meta.lang;
    document.documentElement.dir = c.meta.dir;
    if (activeDocSlug) {
      const page = docsBundle.pages.find((p) => p.slug === activeDocSlug);
      document.title = page ? `${page.title} · ${docsBundle.pageTitle}` : docsBundle.pageTitle;
    } else {
      document.title = c.meta.title;
    }
    const desc = document.querySelector('meta[name="description"]');
    if (desc) desc.setAttribute('content', c.meta.description);
    persistLocale(locale);
  });

  async function copyBuildCommands() {
    try {
      await navigator.clipboard.writeText(BUILD_COMMANDS);
      copied = true;
      if (copyTimer) window.clearTimeout(copyTimer);
      copyTimer = window.setTimeout(() => {
        copied = false;
        copyTimer = 0;
      }, 2000);
    } catch {
      // Clipboard API unavailable.
    }
  }
</script>

<header class="site-nav" use:syncNavOffset>
  <a class="brand" href="/" onclick={(e) => handleInternalLink(e, () => navigateHome())}>
    <img src="/app_icon.png" alt="" width="28" height="28" />
    <span>MosaicIt</span>
  </a>

  <nav aria-label="Primary">
    <a href="/#features" onclick={(e) => handleInternalLink(e, () => navigateHome('#features'))}>
      {copy.nav.features}
    </a>
    <a href="/#privacy" onclick={(e) => handleInternalLink(e, () => navigateHome('#privacy'))}>
      {copy.nav.privacy}
    </a>
    <a href="/#download" onclick={(e) => handleInternalLink(e, () => navigateHome('#download'))}>
      {copy.nav.download}
    </a>
    <a
      href="/docs"
      class:active={activeDocSlug !== null}
      aria-current={activeDocSlug !== null ? 'page' : undefined}
      onclick={(e) => handleInternalLink(e, () => navigateToDocs('quick-start'))}
    >
      {copy.nav.docs}
    </a>
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
    <a class="nav-cta" href="/#download" onclick={(e) => handleInternalLink(e, () => navigateHome('#download'))}>
      {copy.nav.cta}
    </a>
  </div>
</header>

<main id="top">
{#if activeDocSlug !== null}
  <DocsPage
    bundle={docsBundle}
    activeSlug={activeDocSlug}
    onSelectSlug={navigateToDocs}
    onGoHome={() => navigateHome()}
  />
{:else}
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
      <div
        class="hero-viewport"
        class:hero-viewport--animating={animateHeroHeight}
        bind:this={heroViewportEl}
        style={heroViewportHeight ? `height:${heroViewportHeight}px` : undefined}
      >
        {#key activeDevice}
          <div
            class="hero-panel"
            use:measureHeroHeight={activeDevice}
            in:scale={{ start: 0.96, duration: transitionMs(340), easing: cubicOut }}
            out:fade={{ duration: transitionMs(180) }}
          >
            {#if activeDevice === 'iphone'}
              <div
                class="screenshot-stack"
                aria-label={copy.nav.screenshots}
                onmousemove={handleStackMove}
                onmouseleave={resetStack}
                role="img"
              >
                {#each HERO_SHOTS as item, index}
                  <img
                    class="screenshot-card"
                    src={shotUrl('iphone', item.scene)}
                    alt=""
                    loading={index === 0 ? 'eager' : 'lazy'}
                    decoding="async"
                    style={`--base-x:${item.x}%; --base-y:${item.y}%; --hover-slot:${item.hoverSlot}; --base-r:${item.rotate}deg; --hover-r:${item.hoverRotate}deg; --move-x:${stackMotion.x * item.motion}px; --move-y:${stackMotion.y * item.motion}px; --tilt-x:${-stackMotion.y * 6}deg; --tilt-y:${stackMotion.x * 8}deg; --z:${HERO_SHOTS.length - index};`}
                  />
                {/each}
              </div>
            {:else}
              <div class="hero-gallery">
                <div
                  class="hero-showcase hero-showcase--iphone-duo"
                  role="presentation"
                  onmousemove={handleStackMove}
                  onmouseleave={resetStack}
                  style={`--tilt-x:${-stackMotion.y * 4}deg; --tilt-y:${stackMotion.x * 5}deg;`}
                >
                  {#each HERO_SHOTS as item, index}
                    <img
                      class="hero-showcase-img"
                      class:shown={index === activeHeroShot}
                      src={shotUrl('iphone-duo', item.scene)}
                      alt=""
                      aria-hidden={index !== activeHeroShot}
                      loading={index === 0 ? 'eager' : 'lazy'}
                      decoding="async"
                    />
                  {/each}
                </div>
                <div class="hero-thumbs" role="group" aria-label={copy.nav.screenshots}>
                  {#each HERO_SHOTS as item, index}
                    <button
                      type="button"
                      class="hero-thumb hero-thumb--iphone-duo"
                      class:active={index === activeHeroShot}
                      aria-pressed={index === activeHeroShot}
                      aria-label={`${copy.nav.screenshots} ${index + 1}`}
                      onclick={() => {
                        activeHeroShot = index;
                      }}
                    >
                      <img
                        src={shotUrl('iphone-duo', item.scene)}
                        alt=""
                        loading="lazy"
                        decoding="async"
                      />
                    </button>
                  {/each}
                </div>
              </div>
            {/if}
          </div>
        {/key}
      </div>
    </div>
  </section>

  <section id="features" class="page-section">
    <div class="section-head">
      <h2>{copy.features.title}</h2>
    </div>

    <div class="tour-switcher-bar" class:tour-switcher-bar--wide={isWideDevice}>
      <div class="device-switcher" role="group" aria-label={copy.nav.screenshots}>
        {#each DEVICE_VIEWS as view}
          <button
            type="button"
            class="device-pill"
            class:active={activeDevice === view.key}
            aria-pressed={activeDevice === view.key}
            onclick={() => selectDevice(view.key)}
          >
            {view.label}
          </button>
        {/each}
      </div>
    </div>

    <div class="tour" class:tour--wide={isWideDevice} bind:this={tourEl}>
      <ol class="tour-list">
        {#each copy.features.cards as card, index}
          {@const itemShot = featureShot(index, activeDevice)}
          <li bind:this={featureItems[index]} class={`tour-card--${itemShot.frame}`}>
            <button
              type="button"
              class="tour-item"
              class:active={index === activeFeature}
              aria-pressed={isDesktopTour ? index === activeFeature : undefined}
              onclick={() => {
                if (!isDesktopTour) return;
                activeFeature = index;
                featureItems[index]?.scrollIntoView({ behavior: scrollBehavior(), block: 'center' });
              }}
            >
              <span class="tour-tag">{String(index + 1).padStart(2, '0')} · {card.tag}</span>
              <span class="tour-title">{card.title}</span>
              <span class="tour-desc">{card.description}</span>
            </button>
            <img
              class={`tour-shot-inline tour-shot-inline--${itemShot.frame}`}
              src={itemShot.src}
              alt=""
              loading="lazy"
              decoding="async"
            />
          </li>
        {/each}
      </ol>

      <div class="tour-device" class:tour-device--wide={activeFeatureShot.frame !== 'iphone'}>
        <div class={`device-frame device-frame--${activeFeatureShot.frame}`}>
          {#key activeFeatureShot.frame}
            <div
              class="device-frame-layer"
              in:scale={{ start: 0.96, duration: transitionMs(340), easing: cubicOut }}
              out:fade={{ duration: transitionMs(180) }}
            >
              {#each copy.features.cards as _card, index}
                {@const itemShot = featureShot(index, activeDevice)}
                {#if itemShot.frame === activeFeatureShot.frame}
                  <img
                    class:shown={index === activeFeature}
                    src={itemShot.src}
                    alt=""
                    loading="lazy"
                    decoding="async"
                  />
                {/if}
              {/each}
            </div>
          {/key}
        </div>
      </div>
    </div>

    <div class="classes-block">
      <div class="classes-head">
        <h3>{copy.features.classesTitle}</h3>
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
{/if}
</main>

<footer class="site-footer">
  <span>© 2026 lollipopkit</span>
  <div class="footer-links">
    <a href="/#features" onclick={(e) => handleInternalLink(e, () => navigateHome('#features'))}>
      {copy.footer.features}
    </a>
    <a href="/#privacy" onclick={(e) => handleInternalLink(e, () => navigateHome('#privacy'))}>
      {copy.footer.privacy}
    </a>
    <a href="/#download" onclick={(e) => handleInternalLink(e, () => navigateHome('#download'))}>
      {copy.footer.download}
    </a>
    <a href="/docs" onclick={(e) => handleInternalLink(e, () => navigateToDocs('quick-start'))}>
      {copy.footer.docs}
    </a>
    <a href={FEEDBACK_URL}>{copy.footer.feedback}</a>
    <a href={REPO_URL} target="_blank" rel="noopener noreferrer">GitHub</a>
    <a href={RELEASES_URL} target="_blank" rel="noopener noreferrer">{copy.footer.releases}</a>
    <a href={LICENSE_URL} target="_blank" rel="noopener noreferrer">{copy.footer.license}</a>
  </div>
</footer>

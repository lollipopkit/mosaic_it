<script lang="ts">
  import type { Copy, StyleKey } from '../i18n';

  let { copy }: { copy: Copy } = $props();

  type RegionId = 'name' | 'phone' | 'address' | 'amount' | 'card' | 'qr';
  const ALL_IDS: RegionId[] = ['name', 'phone', 'address', 'amount', 'card', 'qr'];
  const STYLE_KEYS: StyleKey[] = ['solid', 'surround', 'blocks', 'tinted', 'noise'];

  let style = $state<StyleKey>('solid');
  let peeking = $state(false);
  let masked = $state<Record<RegionId, boolean>>({
    name: true,
    phone: true,
    address: true,
    amount: true,
    card: true,
    qr: true,
  });

  let tiltX = $state(0);
  let tiltY = $state(0);

  let activeCount = $derived(ALL_IDS.filter((id) => masked[id]).length);

  function toggleRegion(id: RegionId) {
    masked[id] = !masked[id];
  }

  function resetAll() {
    for (const id of ALL_IDS) masked[id] = true;
  }

  function onPointerMove(e: PointerEvent) {
    if (e.pointerType !== 'mouse') return;
    const el = e.currentTarget as HTMLElement;
    const rect = el.getBoundingClientRect();
    const nx = (e.clientX - rect.left) / rect.width - 0.5;
    const ny = (e.clientY - rect.top) / rect.height - 0.5;
    tiltY = Number((nx * 7).toFixed(2));
    tiltX = Number((-ny * 7).toFixed(2));
  }

  function onPointerLeave() {
    tiltX = 0;
    tiltY = 0;
  }

  function startPeek() {
    peeking = true;
  }

  function endPeek() {
    peeking = false;
  }
</script>

<div
  class="demo-phone"
  role="region"
  aria-label={copy.demo.ariaLabel}
  style="--tilt-x: {tiltX}deg; --tilt-y: {tiltY}deg;"
  onpointermove={onPointerMove}
  onpointerleave={onPointerLeave}
>
  <div class="demo-screen">
    <div class="demo-topbar">
      <div class="demo-topbar-group">
        <button
          type="button"
          class="demo-icon-btn"
          title={copy.demo.resetLabel}
          aria-label={copy.demo.resetLabel}
          onclick={resetAll}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M3 12a9 9 0 1 0 3-6.7L3 8" />
            <path d="M3 3v5h5" />
          </svg>
        </button>
      </div>

      <div class="demo-topbar-group">
        <button
          type="button"
          class="demo-icon-btn"
          class:peeking
          title={copy.demo.peekLabel}
          aria-label={copy.demo.peekLabel}
          aria-pressed={peeking}
          onpointerdown={startPeek}
          onpointerup={endPeek}
          onpointercancel={endPeek}
          onpointerleave={endPeek}
          onkeydown={(e) => {
            if (e.key === ' ' || e.key === 'Enter') {
              e.preventDefault();
              startPeek();
            }
          }}
          onkeyup={(e) => {
            if (e.key === ' ' || e.key === 'Enter') endPeek();
          }}
          onblur={endPeek}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7Z" />
            <circle cx="12" cy="12" r="3" />
          </svg>
          <span class="demo-badge">{activeCount}</span>
        </button>
      </div>
    </div>

    <div class="demo-canvas">
      <div class="demo-receipt-head">
        <span class="demo-receipt-title">{copy.demo.receiptTitle}</span>
        <span class="demo-receipt-status">OK</span>
      </div>

      <div class="demo-rows">
        <div class="demo-row">
          <span class="demo-row-label">{copy.demo.recipientLabel}</span>
          <button
            type="button"
            class="demo-pii"
            class:masked={masked.name}
            class:unmasked={!masked.name}
            class:peeking={peeking && masked.name}
            aria-pressed={masked.name}
            title={copy.demo.classes.person_name}
            onclick={() => toggleRegion('name')}
          >
            <span class="demo-pii-text">{copy.demo.recipientValue}</span>
            {#if masked.name}
              <span class="demo-pii-mask mask-{style}" aria-hidden="true"></span>
            {/if}
          </button>
        </div>

        <div class="demo-row">
          <span class="demo-row-label">{copy.demo.phoneLabel}</span>
          <button
            type="button"
            class="demo-pii"
            class:masked={masked.phone}
            class:unmasked={!masked.phone}
            class:peeking={peeking && masked.phone}
            aria-pressed={masked.phone}
            title={copy.demo.classes.phone}
            onclick={() => toggleRegion('phone')}
          >
            <span class="demo-pii-text">{copy.demo.phoneValue}</span>
            {#if masked.phone}
              <span class="demo-pii-mask mask-{style}" aria-hidden="true"></span>
            {/if}
          </button>
        </div>

        <div class="demo-row">
          <span class="demo-row-label">{copy.demo.addressLabel}</span>
          <button
            type="button"
            class="demo-pii"
            class:masked={masked.address}
            class:unmasked={!masked.address}
            class:peeking={peeking && masked.address}
            aria-pressed={masked.address}
            title={copy.demo.classes.address}
            onclick={() => toggleRegion('address')}
          >
            <span class="demo-pii-text">{copy.demo.addressValue}</span>
            {#if masked.address}
              <span class="demo-pii-mask mask-{style}" aria-hidden="true"></span>
            {/if}
          </button>
        </div>

        <div class="demo-row">
          <span class="demo-row-label">{copy.demo.amountLabel}</span>
          <button
            type="button"
            class="demo-pii"
            class:masked={masked.amount}
            class:unmasked={!masked.amount}
            class:peeking={peeking && masked.amount}
            aria-pressed={masked.amount}
            title={copy.demo.classes.finance}
            onclick={() => toggleRegion('amount')}
          >
            <span class="demo-pii-text">{copy.demo.amountValue}</span>
            {#if masked.amount}
              <span class="demo-pii-mask mask-{style}" aria-hidden="true"></span>
            {/if}
          </button>
        </div>

        <div class="demo-row">
          <span class="demo-row-label">{copy.demo.cardLabel}</span>
          <button
            type="button"
            class="demo-pii"
            class:masked={masked.card}
            class:unmasked={!masked.card}
            class:peeking={peeking && masked.card}
            aria-pressed={masked.card}
            title={copy.demo.classes.bank_card}
            onclick={() => toggleRegion('card')}
          >
            <span class="demo-pii-text">{copy.demo.cardValue}</span>
            {#if masked.card}
              <span class="demo-pii-mask mask-{style}" aria-hidden="true"></span>
            {/if}
          </button>
        </div>
      </div>

      <div class="demo-qr-row">
        <span class="demo-row-label">{copy.demo.qrLabel}</span>
        <button
          type="button"
          class="demo-pii demo-qr-btn"
          class:masked={masked.qr}
          class:unmasked={!masked.qr}
          class:peeking={peeking && masked.qr}
          aria-pressed={masked.qr}
          aria-label={copy.demo.qrLabel}
          title={copy.demo.classes.qr}
          onclick={() => toggleRegion('qr')}
        >
          <svg class="demo-qr-svg demo-pii-text" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
            <path d="M3 3h7v7H3V3Zm2 2v3h3V5H5Zm9-2h7v7h-7V3Zm2 2v3h3V5h-3ZM3 14h7v7H3v-7Zm2 2v3h3v-3H5Zm9-2h3v3h-3v-3Zm4 0h3v3h-3v-3Zm-4 4h3v3h-3v-3Zm4 0h3v3h-3v-3Z" />
          </svg>
          {#if masked.qr}
            <span class="demo-pii-mask mask-{style}" aria-hidden="true"></span>
          {/if}
        </button>
      </div>
    </div>

    <div class="demo-styles" role="group" aria-label="Redaction style">
      {#each STYLE_KEYS as key}
        <button
          type="button"
          aria-pressed={style === key}
          class="demo-style-btn"
          class:active={style === key}
          onclick={() => (style = key)}
        >
          {copy.demo.styles[key]}
        </button>
      {/each}
    </div>
  </div>
</div>

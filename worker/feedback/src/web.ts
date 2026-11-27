// Self-contained, zero-dependency web feedback page served by GET /.
// Accepts optional URL hash handoff from the offline MosaicIt app:
//   #v=1&d=<base64url(deflate-raw(utf8(json)))>[&i=<base64url(jpeg)>][&m=1]
// Immediately strips location.hash via history.replaceState so screenshot
// data never lingers in browser history.

export const FEEDBACK_WEB_HTML = `<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="referrer" content="no-referrer">
<title>MosaicIt Feedback</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  :root {
    --bg: #fff8f8;
    --card: #fff0f3;
    --card-hi: #f8e8ec;
    --text: #20181c;
    --muted: #5e4c52;
    --faint: #857076;
    --border: #e0d4d8;
    --primary: #880e4f;
    --on-primary: #ffffff;
    --primary-ct: #ffd9e4;
    --on-primary-ct: #3b0021;
    --ok: #15803d;
    --ok-bg: rgba(21, 128, 61, 0.11);
    --err: #b81818;
    --err-bg: #fdeaea;
    --input: #ffffff;
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #151313;
      --card: #1d1b1c;
      --card-hi: #2c292a;
      --text: #e5e1e2;
      --muted: #cec3c7;
      --faint: #998d91;
      --border: #4d4447;
      --primary: #ffa9c9;
      --on-primary: #5a0833;
      --primary-ct: #781f49;
      --on-primary-ct: #ffd6e4;
      --ok: #4ade80;
      --ok-bg: rgba(34, 197, 94, 0.14);
      --err: #f2b8b5;
      --err-bg: #3d181a;
      --input: #242122;
    }
  }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI", Roboto, "PingFang SC", sans-serif;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
    padding: 20px 14px 48px;
  }
  .wrap { max-width: 560px; margin: 0 auto; display: flex; flex-direction: column; gap: 14px; }
  header { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
  h1 { font-size: 22px; font-weight: 600; letter-spacing: -0.2px; }
  .lang-btn {
    border: 1px solid var(--border);
    background: var(--card);
    color: var(--text);
    font: inherit;
    font-size: 12px;
    padding: 5px 11px;
    border-radius: 999px;
    cursor: pointer;
  }
  .card {
    background: var(--card);
    border-radius: 14px;
    padding: 14px;
    display: flex;
    flex-direction: column;
    gap: 12px;
  }
  .banner {
    border-radius: 12px;
    padding: 10px 12px;
    font-size: 13px;
    line-height: 1.45;
  }
  .banner.ok { background: var(--ok-bg); color: var(--ok); }
  .banner.err { background: var(--err-bg); color: var(--err); }
  .banner.info { background: var(--card-hi); color: var(--muted); }
  .meta-row {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    font-size: 12px;
    color: var(--faint);
  }
  .pill {
    background: var(--card-hi);
    color: var(--muted);
    padding: 3px 9px;
    border-radius: 999px;
    font-variant-numeric: tabular-nums;
  }
  .canvas-box {
    position: relative;
    background: var(--card-hi);
    border-radius: 12px;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 140px;
  }
  canvas {
    display: block;
    max-width: 100%;
    max-height: 440px;
    width: auto;
    height: auto;
    touch-action: none;
    cursor: crosshair;
  }
  .canvas-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 8px;
    font-size: 12px;
    color: var(--muted);
  }
  .legend { display: flex; flex-wrap: wrap; gap: 10px; font-size: 12px; color: var(--muted); }
  .dot {
    display: inline-block;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    margin-right: 4px;
    vertical-align: middle;
  }
  .dropzone {
    border: 1.5px dashed var(--border);
    border-radius: 12px;
    padding: 20px 14px;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
    font-size: 13px;
    color: var(--muted);
  }
  .dropzone.drag { border-color: var(--primary); background: var(--card-hi); }
  .btn-row { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; justify-content: center; }
  .btn {
    border: 0;
    border-radius: 999px;
    font: inherit;
    font-size: 13px;
    font-weight: 500;
    padding: 8px 14px;
    cursor: pointer;
    background: var(--card-hi);
    color: var(--text);
  }
  .btn.tonal { background: var(--primary-ct); color: var(--on-primary-ct); }
  .btn.primary {
    background: var(--primary);
    color: var(--on-primary);
    font-weight: 600;
    height: 44px;
    width: 100%;
    font-size: 14.5px;
  }
  .btn:disabled { opacity: 0.45; cursor: not-allowed; }
  .chips { display: flex; flex-wrap: wrap; gap: 7px; }
  .chip {
    border: 1px solid var(--border);
    background: transparent;
    color: var(--muted);
    font: inherit;
    font-size: 13px;
    padding: 6px 12px;
    border-radius: 999px;
    cursor: pointer;
  }
  .chip.on {
    background: var(--primary-ct);
    color: var(--on-primary-ct);
    border-color: transparent;
    font-weight: 500;
  }
  textarea {
    width: 100%;
    min-height: 76px;
    resize: vertical;
    border-radius: 10px;
    border: 1px solid var(--border);
    background: var(--input);
    color: var(--text);
    font: inherit;
    font-size: 13.5px;
    padding: 10px 12px;
    outline: none;
  }
  textarea:focus { border-color: var(--primary); }
  .counter { font-size: 11.5px; color: var(--faint); text-align: right; }
  .receipt {
    font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
    font-size: 15px;
    font-weight: 600;
    padding: 10px 12px;
    border-radius: 10px;
    background: var(--card-hi);
    user-select: all;
  }
  .hidden { display: none !important; }
  input[type="file"] { display: none; }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <h1 id="hTitle">MosaicIt 反馈</h1>
    <button class="lang-btn" id="btnLang" type="button">EN</button>
  </header>

  <div id="statusBanner" class="banner hidden"></div>

  <div id="receiptCard" class="card hidden">
    <div id="receiptTitle" style="font-weight:600"></div>
    <div class="receipt" id="receiptId"></div>
    <button class="btn tonal" id="btnNew" type="button"></button>
  </div>

  <form id="fbForm" class="wrap" style="padding:0">
    <div id="metaCard" class="card hidden">
      <div class="meta-row" id="metaPills"></div>
    </div>

    <div id="imageCard" class="card">
      <div id="canvasWrap" class="hidden" style="display:flex;flex-direction:column;gap:10px">
        <div class="canvas-box">
          <canvas id="preview"></canvas>
        </div>
        <div class="canvas-bar">
          <span id="maskHint"></span>
          <div class="btn-row">
            <button class="btn" id="btnUndoMask" type="button"></button>
            <button class="btn" id="btnClearImg" type="button"></button>
          </div>
        </div>
        <div class="legend" id="legend"></div>
      </div>

      <div id="dropzone" class="dropzone">
        <div id="dropText"></div>
        <div class="btn-row">
          <button class="btn tonal" id="btnPick" type="button"></button>
          <button class="btn" id="btnPaste" type="button"></button>
          <button class="btn hidden" id="btnSwitchText" type="button"></button>
        </div>
        <input id="fileInput" type="file" accept="image/png,image/jpeg,image/webp">
      </div>
    </div>

    <div class="card">
      <div class="chips" id="tagChips"></div>
      <textarea id="noteInput" maxlength="500"></textarea>
      <div class="counter" id="noteCount">0 / 500</div>
    </div>

    <button class="btn primary" id="btnSubmit" type="submit"></button>
  </form>
</div>

<script>
const TAG_IDS = ['missed', 'false_positive', 'box_drift', 'wrong_class', 'other'];
const VALID_MODES = ['masked', 'full', 'text'];
const VALID_MIMES = new Set(['image/jpeg', 'image/png', 'image/webp']);
const COPY = {
  zh: {
    title: 'MosaicIt 检测反馈',
    lang: 'EN',
    prefilled: '已从 MosaicIt 载入标注与截图，核对后直接提交即可。',
    prefilledNoImg: '已从 MosaicIt 载入全部标注与遮挡框；由于图片体积超出 URL 上限，请补选或粘贴原截图（提交前将自动涂黑遮挡区域）。',
    badHash: '无法解析来自应用的预填数据，仍可手动填写提交。',
    badImg: '无法读取该图片格式，请选择 PNG、JPEG 或 WebP 图片。',
    drop: '可选：拖入、选择或粘贴截图（支持提交前直接涂黑遮挡隐私）',
    pick: '选择图片',
    paste: '粘贴剪贴板图片',
    switchText: '改为仅文字提交',
    maskHint: '在图上拖动可追加黑色遮挡框',
    undoMask: '撤销遮挡',
    clearImg: '移除图片',
    notePh: '补充说明（可选，例如场景或漏检/误检类型）',
    submit: '提交反馈',
    submitting: '正在提交…',
    sentTitle: '反馈已收到',
    newBtn: '提交另一条',
    needContent: '请至少选择标签、填写说明或附带一张图片。',
    needImgForMode: '当前模式包含标注框，请先选择或粘贴对应截图，或点击“改为仅文字提交”。',
    noClipboardImg: '剪贴板中没有图片',
    tags: { missed: '漏检', false_positive: '误检', box_drift: '框偏移', wrong_class: '分类错误', other: '其他' },
    legendMasked: n => '已遮挡 ' + n,
    legendFn: n => '漏检 ' + n,
    legendFp: n => '误检 ' + n,
    legendExtra: n => '网页追加遮挡 ' + n,
    modeNames: { masked: '脱敏图', full: '原图', text: '仅文字' },
  },
  en: {
    title: 'MosaicIt Feedback',
    lang: '中文',
    prefilled: 'Loaded annotations and screenshot from MosaicIt. Review and submit.',
    prefilledNoImg: 'Loaded annotations and mask boxes from MosaicIt. Image exceeded URL limit; pick or paste the screenshot (masked areas will be blacked out automatically before upload).',
    badHash: 'Could not decode app handoff data; you can still submit manually.',
    badImg: 'Could not read that image. Please pick a PNG, JPEG, or WebP image.',
    drop: 'Optional: drop, pick, or paste a screenshot (drag on image to black out sensitive areas)',
    pick: 'Choose image',
    paste: 'Paste image',
    switchText: 'Switch to text-only',
    maskHint: 'Drag on image to add black mask boxes',
    undoMask: 'Undo mask',
    clearImg: 'Remove image',
    notePh: 'Optional note (e.g. app or missed/false-positive type)',
    submit: 'Submit feedback',
    submitting: 'Submitting…',
    sentTitle: 'Feedback received',
    newBtn: 'Submit another',
    needContent: 'Select a tag, enter a note, or attach an image.',
    needImgForMode: 'Annotations are attached; pick/paste the screenshot or click "Switch to text-only".',
    noClipboardImg: 'No image found in clipboard',
    tags: { missed: 'Missed', false_positive: 'False positive', box_drift: 'Box drift', wrong_class: 'Wrong class', other: 'Other' },
    legendMasked: n => 'Masked ' + n,
    legendFn: n => 'Missed ' + n,
    legendFp: n => 'False positive ' + n,
    legendExtra: n => 'Extra masks ' + n,
    modeNames: { masked: 'Masked', full: 'Full image', text: 'Text only' },
  },
};

const state = {
  lang: (navigator.language || '').toLowerCase().startsWith('zh') ? 'zh' : 'en',
  handoff: null,          // validated unseen.feedback.v1 object from #d
  imageDeferred: false,   // true when app omitted #i= (e.g. Windows / >96 KiB)
  applyHandoffMasks: false, // true when user provides an unmasked image for a masked handoff
  imgEl: null,            // HTMLImageElement
  imgBlob: null,          // original Blob before masking/re-encoding
  imgMime: 'image/jpeg',
  extraMasks: [],         // [x, y, w, h] in image pixel coords drawn on web canvas
  dragStart: null,
  dragCur: null,
  tags: new Set(),
  note: '',
  banner: null,           // { kind, key?, text? }
  submitting: false,
};

function isValidBbox(b) {
  return Array.isArray(b) && b.length === 4 &&
    typeof b[0] === 'number' && Number.isFinite(b[0]) && b[0] >= 0 &&
    typeof b[1] === 'number' && Number.isFinite(b[1]) && b[1] >= 0 &&
    typeof b[2] === 'number' && Number.isFinite(b[2]) && b[2] > 0 &&
    typeof b[3] === 'number' && Number.isFinite(b[3]) && b[3] > 0;
}

function sanitizeHandoff(raw) {
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return null;
  if (raw.schema !== 'unseen.feedback.v1') return null;
  if (typeof raw.privacy_mode !== 'string' || !VALID_MODES.includes(raw.privacy_mode)) return null;
  let image = null;
  if (raw.privacy_mode !== 'text') {
    if (!raw.image || typeof raw.image !== 'object' || Array.isArray(raw.image)) return null;
    const w = raw.image.width, h = raw.image.height;
    if (typeof w !== 'number' || typeof h !== 'number' || !Number.isFinite(w) || !Number.isFinite(h) || w < 1 || h < 1) {
      return null;
    }
    const maskedRegions = Array.isArray(raw.image.masked_regions)
      ? raw.image.masked_regions.filter(isValidBbox).slice(0, 200)
      : [];
    image = { width: w, height: h, masked_regions: maskedRegions };
  }
  const diffs = Array.isArray(raw.diffs)
    ? raw.diffs.filter(d => d && typeof d === 'object' && (d.kind === 'fn_missed' || d.kind === 'fp_confirmed') && isValidBbox(d.bbox)).slice(0, 200)
    : [];
  const tags = Array.isArray(raw.tags) ? raw.tags.filter(t => TAG_IDS.includes(t)) : [];
  const excluded = Number.isInteger(raw.excluded_preference_count) && raw.excluded_preference_count >= 0
    ? Math.min(500, raw.excluded_preference_count)
    : 0;
  return {
    schema: 'unseen.feedback.v1',
    app_version: typeof raw.app_version === 'string' && raw.app_version ? raw.app_version.slice(0, 32) : 'web',
    platform: typeof raw.platform === 'string' && raw.platform ? raw.platform : 'web',
    model_id: typeof raw.model_id === 'string' ? raw.model_id.slice(0, 128) : 'web',
    privacy_mode: raw.privacy_mode,
    tags,
    note: typeof raw.note === 'string' ? raw.note.slice(0, 500) : null,
    image,
    diffs,
    excluded_preference_count: excluded,
  };
}

function b64urlToBytes(s) {
  let b64 = s.replace(/-/g, '+').replace(/_/g, '/');
  while (b64.length % 4) b64 += '=';
  const bin = atob(b64);
  const out = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
  return out;
}

async function inflateRaw(bytes) {
  const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream('deflate-raw'));
  return await new Response(stream).text();
}

function setBannerKey(kind, key) {
  state.banner = key ? { kind, key } : null;
  renderBanner();
}

function setBannerText(kind, text) {
  state.banner = text ? { kind, text } : null;
  renderBanner();
}

function renderBanner() {
  const el = document.getElementById('statusBanner');
  if (!state.banner) { el.className = 'banner hidden'; el.textContent = ''; return; }
  const t = COPY[state.lang];
  el.className = 'banner ' + state.banner.kind;
  el.textContent = state.banner.key ? (t[state.banner.key] || '') : (state.banner.text || '');
}

function loadBlobAsImage(blob) {
  return new Promise((resolve, reject) => {
    const url = URL.createObjectURL(blob);
    const img = new Image();
    img.onload = () => { URL.revokeObjectURL(url); resolve(img); };
    img.onerror = () => { URL.revokeObjectURL(url); reject(new Error('invalid image')); };
    img.src = url;
  });
}

async function setImageBlob(blob, fromInlineHandoff) {
  const img = await loadBlobAsImage(blob);
  state.imgEl = img;
  state.imgBlob = blob;
  state.imgMime = blob.type || '';
  state.extraMasks = [];
  // If the app could not inline the redacted JPEG (m=1 / Windows) and the user
  // supplies an unmasked screenshot for a masked handoff, burn handoff masks on upload.
  state.applyHandoffMasks = !fromInlineHandoff &&
    !!(state.handoff && state.handoff.privacy_mode === 'masked' &&
       state.handoff.image && state.handoff.image.masked_regions.length > 0);
  state.imageDeferred = false;
  render();
}

function drawHandoffMasks(ctx, targetW, targetH) {
  if (!state.applyHandoffMasks || !state.handoff || !state.handoff.image) return;
  const sx = targetW / state.handoff.image.width;
  const sy = targetH / state.handoff.image.height;
  // Match Rust core's 4 px padding proportionally so edges cannot leak.
  const padX = 4 * sx;
  const padY = 4 * sy;
  ctx.fillStyle = '#000000';
  for (const [x, y, w, h] of state.handoff.image.masked_regions) {
    ctx.fillRect(
      Math.max(0, x * sx - padX),
      Math.max(0, y * sy - padY),
      w * sx + padX * 2,
      h * sy + padY * 2,
    );
  }
}

function drawCanvas() {
  const canvas = document.getElementById('preview');
  const img = state.imgEl;
  if (!img) return;
  canvas.width = img.naturalWidth;
  canvas.height = img.naturalHeight;
  const ctx = canvas.getContext('2d');
  ctx.drawImage(img, 0, 0);

  // Burn preview of handoff masked_regions when user attached an unmasked image.
  drawHandoffMasks(ctx, img.naturalWidth, img.naturalHeight);

  // User-drawn extra masks on web
  ctx.fillStyle = '#000000';
  for (const [x, y, w, h] of state.extraMasks) {
    ctx.fillRect(x, y, w, h);
  }
  if (state.dragStart && state.dragCur) {
    const x = Math.min(state.dragStart.x, state.dragCur.x);
    const y = Math.min(state.dragStart.y, state.dragCur.y);
    const w = Math.abs(state.dragCur.x - state.dragStart.x);
    const h = Math.abs(state.dragCur.y - state.dragStart.y);
    ctx.fillStyle = 'rgba(0,0,0,0.65)';
    ctx.fillRect(x, y, w, h);
    ctx.strokeStyle = '#ffa9c9';
    ctx.lineWidth = Math.max(2, img.naturalWidth / 320);
    ctx.strokeRect(x, y, w, h);
  }

  // Overlay prefilled diff boxes (visual only, not burned into uploaded image)
  if (state.handoff && state.handoff.image && Array.isArray(state.handoff.diffs)) {
    const sx = img.naturalWidth / state.handoff.image.width;
    const sy = img.naturalHeight / state.handoff.image.height;
    const lw = Math.max(2, img.naturalWidth / 280);
    for (const d of state.handoff.diffs) {
      const [bx, by, bw, bh] = d.bbox;
      ctx.save();
      ctx.lineWidth = lw;
      if (d.kind === 'fn_missed') {
        ctx.strokeStyle = '#e5484d';
        ctx.fillStyle = 'rgba(229,72,77,0.14)';
        if (d.masked_by_user) ctx.setLineDash([lw * 3, lw * 2]);
      } else {
        ctx.strokeStyle = '#e08200';
        ctx.fillStyle = 'rgba(224,130,0,0.16)';
      }
      ctx.fillRect(bx * sx, by * sy, bw * sx, bh * sy);
      ctx.strokeRect(bx * sx, by * sy, bw * sx, bh * sy);
      ctx.restore();
    }
  }
}

function canvasPoint(ev) {
  const canvas = document.getElementById('preview');
  const rect = canvas.getBoundingClientRect();
  if (rect.width <= 0 || rect.height <= 0) return { x: 0, y: 0 };
  return {
    x: Math.max(0, Math.min(canvas.width, (ev.clientX - rect.left) * (canvas.width / rect.width))),
    y: Math.max(0, Math.min(canvas.height, (ev.clientY - rect.top) * (canvas.height / rect.height))),
  };
}

async function exportUploadBlob() {
  if (!state.imgEl) return null;
  const srcW = state.imgEl.naturalWidth;
  const srcH = state.imgEl.naturalHeight;
  const canPassthrough =
    !state.applyHandoffMasks &&
    state.extraMasks.length === 0 &&
    state.imgBlob &&
    VALID_MIMES.has(state.imgMime) &&
    srcW <= 16384 &&
    srcH <= 16384 &&
    state.imgBlob.size <= 3.8 * 1024 * 1024;
  if (canPassthrough) return state.imgBlob;

  const maxSide = 1280;
  const scale = Math.min(1, maxSide / Math.max(srcW, srcH));
  const w = Math.max(1, Math.round(srcW * scale));
  const h = Math.max(1, Math.round(srcH * scale));
  const off = document.createElement('canvas');
  off.width = w;
  off.height = h;
  const ctx = off.getContext('2d');
  ctx.drawImage(state.imgEl, 0, 0, w, h);
  drawHandoffMasks(ctx, w, h);
  ctx.fillStyle = '#000000';
  for (const [x, y, rw, rh] of state.extraMasks) {
    ctx.fillRect(x * scale, y * scale, rw * scale, rh * scale);
  }
  return new Promise((resolve, reject) => {
    off.toBlob(b => (b ? resolve(b) : reject(new Error('encode failed'))), 'image/jpeg', 0.82);
  });
}

function buildFinalPayload(uploadSize) {
  const base = state.handoff;
  const hasImg = !!state.imgEl && !!uploadSize;
  const tags = [...state.tags];
  const note = state.note.trim() || null;

  if (!hasImg) {
    return {
      schema: 'unseen.feedback.v1',
      app_version: (base && base.app_version) || 'web',
      platform: (base && base.platform) || 'web',
      model_id: (base && base.model_id) || 'web',
      privacy_mode: 'text',
      tags,
      note,
      image: null,
      diffs: [],
      excluded_preference_count: 0,
    };
  }

  const w = uploadSize.width;
  const h = uploadSize.height;
  const sx = state.imgEl.naturalWidth > 0 ? w / state.imgEl.naturalWidth : 1;
  const sy = state.imgEl.naturalHeight > 0 ? h / state.imgEl.naturalHeight : 1;

  const existingMasked = [];
  if (base && base.image && Array.isArray(base.image.masked_regions)) {
    const bsx = w / base.image.width;
    const bsy = h / base.image.height;
    for (const r of base.image.masked_regions) {
      existingMasked.push([
        +(r[0] * bsx).toFixed(1),
        +(r[1] * bsy).toFixed(1),
        Math.max(0.1, +(r[2] * bsx).toFixed(1)),
        Math.max(0.1, +(r[3] * bsy).toFixed(1)),
      ]);
    }
  }
  for (const [x, y, rw, rh] of state.extraMasks) {
    existingMasked.push([
      +(x * sx).toFixed(1),
      +(y * sy).toFixed(1),
      Math.max(0.1, +(rw * sx).toFixed(1)),
      Math.max(0.1, +(rh * sy).toFixed(1)),
    ]);
  }

  let mode = base && base.privacy_mode && base.privacy_mode !== 'text'
    ? base.privacy_mode
    : (existingMasked.length > 0 ? 'masked' : 'full');
  if (existingMasked.length > 0) mode = 'masked';

  const diffs = [];
  if (base && Array.isArray(base.diffs) && base.image) {
    const bsx = w / base.image.width;
    const bsy = h / base.image.height;
    for (const d of base.diffs) {
      const [bx, by, bw, bh] = d.bbox;
      diffs.push({
        ...d,
        bbox: [
          +(bx * bsx).toFixed(1),
          +(by * bsy).toFixed(1),
          Math.max(0.1, +(bw * bsx).toFixed(1)),
          Math.max(0.1, +(bh * bsy).toFixed(1)),
        ],
      });
    }
  }

  return {
    schema: 'unseen.feedback.v1',
    app_version: (base && base.app_version) || 'web',
    platform: (base && base.platform) || 'web',
    model_id: (base && base.model_id) || 'web',
    privacy_mode: mode,
    tags,
    note,
    image: {
      width: Math.round(w),
      height: Math.round(h),
      masked_regions: mode === 'masked' ? existingMasked.slice(0, 200) : [],
    },
    diffs: diffs.slice(0, 200),
    excluded_preference_count: (base && base.excluded_preference_count) || 0,
  };
}

function render() {
  const t = COPY[state.lang];
  document.documentElement.lang = state.lang === 'zh' ? 'zh-CN' : 'en';
  document.getElementById('hTitle').textContent = t.title;
  document.getElementById('btnLang').textContent = t.lang;
  document.getElementById('dropText').textContent = t.drop;
  document.getElementById('btnPick').textContent = t.pick;
  document.getElementById('btnPaste').textContent = t.paste;
  const switchBtn = document.getElementById('btnSwitchText');
  switchBtn.textContent = t.switchText;
  switchBtn.classList.toggle('hidden', !(state.handoff && state.handoff.privacy_mode !== 'text' && !state.imgEl));
  document.getElementById('maskHint').textContent = t.maskHint;
  document.getElementById('btnUndoMask').textContent = t.undoMask;
  document.getElementById('btnUndoMask').disabled = state.extraMasks.length === 0;
  document.getElementById('btnClearImg').textContent = t.clearImg;
  document.getElementById('noteInput').placeholder = t.notePh;
  document.getElementById('noteCount').textContent = state.note.length + ' / 500';
  document.getElementById('btnSubmit').textContent = state.submitting ? t.submitting : t.submit;
  document.getElementById('btnSubmit').disabled = state.submitting;
  document.getElementById('receiptTitle').textContent = t.sentTitle;
  document.getElementById('btnNew').textContent = t.newBtn;
  renderBanner();

  // Meta pills
  const metaCard = document.getElementById('metaCard');
  const metaPills = document.getElementById('metaPills');
  if (state.handoff) {
    metaCard.classList.remove('hidden');
    const pills = [
      state.handoff.platform,
      'v' + state.handoff.app_version,
      state.handoff.model_id,
      t.modeNames[state.handoff.privacy_mode] || state.handoff.privacy_mode,
    ].filter(Boolean);
    metaPills.innerHTML = '';
    for (const p of pills) {
      const span = document.createElement('span');
      span.className = 'pill';
      span.textContent = p;
      metaPills.appendChild(span);
    }
  } else {
    metaCard.classList.add('hidden');
  }

  // Image vs dropzone
  const canvasWrap = document.getElementById('canvasWrap');
  const dropzone = document.getElementById('dropzone');
  if (state.imgEl) {
    canvasWrap.classList.remove('hidden');
    dropzone.classList.add('hidden');
    drawCanvas();

    const legend = document.getElementById('legend');
    legend.innerHTML = '';
    const maskedN = (state.handoff && state.handoff.image ? state.handoff.image.masked_regions.length : 0);
    const fnN = state.handoff ? state.handoff.diffs.filter(d => d.kind === 'fn_missed').length : 0;
    const fpN = state.handoff ? state.handoff.diffs.filter(d => d.kind === 'fp_confirmed').length : 0;
    const items = [];
    if (maskedN > 0) items.push(['#000', t.legendMasked(maskedN)]);
    if (fnN > 0) items.push(['#e5484d', t.legendFn(fnN)]);
    if (fpN > 0) items.push(['#e08200', t.legendFp(fpN)]);
    if (state.extraMasks.length > 0) items.push(['#ffa9c9', t.legendExtra(state.extraMasks.length)]);
    for (const [color, label] of items) {
      const span = document.createElement('span');
      const dot = document.createElement('span');
      dot.className = 'dot';
      dot.style.background = color;
      span.appendChild(dot);
      span.appendChild(document.createTextNode(label));
      legend.appendChild(span);
    }
  } else {
    canvasWrap.classList.add('hidden');
    dropzone.classList.remove('hidden');
  }

  // Tag chips
  const chipsEl = document.getElementById('tagChips');
  chipsEl.innerHTML = '';
  for (const id of TAG_IDS) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'chip' + (state.tags.has(id) ? ' on' : '');
    btn.textContent = t.tags[id];
    btn.onclick = () => {
      if (state.tags.has(id)) state.tags.delete(id);
      else state.tags.add(id);
      render();
    };
    chipsEl.appendChild(btn);
  }
}

function switchToTextOnly() {
  state.imgEl = null;
  state.imgBlob = null;
  state.extraMasks = [];
  state.imageDeferred = false;
  state.applyHandoffMasks = false;
  if (state.handoff) {
    state.handoff = { ...state.handoff, privacy_mode: 'text', image: null, diffs: [] };
  }
  setBannerKey('', '');
  render();
}

async function initFromHash() {
  const rawHash = location.hash ? location.hash.slice(1) : '';
  if (!rawHash) return;
  try {
    history.replaceState(null, '', location.pathname + location.search);
  } catch (_) {}
  const params = new URLSearchParams(rawHash);
  const v = params.get('v');
  const d = params.get('d');
  if (!d || (v !== '1' && v !== '1u')) return;
  try {
    const rawBytes = b64urlToBytes(d);
    const jsonStr = v === '1' ? await inflateRaw(rawBytes) : new TextDecoder('utf-8').decode(rawBytes);
    const payload = sanitizeHandoff(JSON.parse(jsonStr));
    if (!payload) throw new Error('invalid payload');
    state.handoff = payload;
    state.tags = new Set(payload.tags);
    state.note = payload.note || '';
    document.getElementById('noteInput').value = state.note;

    const imgB64 = params.get('i');
    if (imgB64) {
      const imgBytes = b64urlToBytes(imgB64);
      const blob = new Blob([imgBytes], { type: 'image/jpeg' });
      await setImageBlob(blob, true);
      setBannerKey('ok', 'prefilled');
    } else if (params.get('m') === '1' || payload.privacy_mode !== 'text') {
      state.imageDeferred = true;
      setBannerKey('info', 'prefilledNoImg');
    } else {
      setBannerKey('ok', 'prefilled');
    }
  } catch (_) {
    setBannerKey('err', 'badHash');
  }
}

async function handleUserImage(blob) {
  try {
    await setImageBlob(blob, false);
    setBannerKey('', '');
  } catch (_) {
    setBannerKey('err', 'badImg');
  }
}

// Event wiring
document.getElementById('btnLang').onclick = () => {
  state.lang = state.lang === 'zh' ? 'en' : 'zh';
  render();
};
document.getElementById('noteInput').addEventListener('input', e => {
  state.note = e.target.value;
  document.getElementById('noteCount').textContent = state.note.length + ' / 500';
});
document.getElementById('btnPick').onclick = () => document.getElementById('fileInput').click();
document.getElementById('btnSwitchText').onclick = switchToTextOnly;
document.getElementById('fileInput').onchange = async e => {
  const f = e.target.files && e.target.files[0];
  if (f) await handleUserImage(f);
  e.target.value = '';
};
document.getElementById('btnPaste').onclick = async () => {
  try {
    const items = await navigator.clipboard.read();
    for (const item of items) {
      const type = item.types.find(tp => tp.startsWith('image/'));
      if (type) {
        const blob = await item.getType(type);
        await handleUserImage(blob);
        return;
      }
    }
    setBannerKey('info', 'noClipboardImg');
  } catch (_) {
    setBannerKey('info', 'noClipboardImg');
  }
};
window.addEventListener('paste', async e => {
  const items = e.clipboardData && e.clipboardData.items;
  if (!items) return;
  for (const it of items) {
    if (it.type && it.type.startsWith('image/')) {
      const f = it.getAsFile();
      if (f) { await handleUserImage(f); break; }
    }
  }
});

const dz = document.getElementById('dropzone');
dz.addEventListener('dragover', e => { e.preventDefault(); dz.classList.add('drag'); });
dz.addEventListener('dragleave', () => dz.classList.remove('drag'));
dz.addEventListener('drop', async e => {
  e.preventDefault();
  dz.classList.remove('drag');
  const f = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
  if (f) await handleUserImage(f);
});

const canvas = document.getElementById('preview');
canvas.addEventListener('pointerdown', e => {
  if (!state.imgEl) return;
  canvas.setPointerCapture(e.pointerId);
  state.dragStart = canvasPoint(e);
  state.dragCur = state.dragStart;
  drawCanvas();
});
canvas.addEventListener('pointermove', e => {
  if (!state.dragStart) return;
  state.dragCur = canvasPoint(e);
  drawCanvas();
});
canvas.addEventListener('pointercancel', () => {
  state.dragStart = null;
  state.dragCur = null;
  drawCanvas();
});
canvas.addEventListener('pointerup', e => {
  if (!state.dragStart) return;
  const end = canvasPoint(e);
  const x = Math.min(state.dragStart.x, end.x);
  const y = Math.min(state.dragStart.y, end.y);
  const w = Math.abs(end.x - state.dragStart.x);
  const h = Math.abs(end.y - state.dragStart.y);
  state.dragStart = null;
  state.dragCur = null;
  if (w >= 8 && h >= 8) state.extraMasks.push([x, y, w, h]);
  render();
});

document.getElementById('btnUndoMask').onclick = () => { state.extraMasks.pop(); render(); };
document.getElementById('btnClearImg').onclick = switchToTextOnly;

document.getElementById('btnNew').onclick = () => {
  state.handoff = null;
  state.imgEl = null;
  state.imgBlob = null;
  state.extraMasks = [];
  state.imageDeferred = false;
  state.applyHandoffMasks = false;
  state.tags.clear();
  state.note = '';
  document.getElementById('noteInput').value = '';
  document.getElementById('receiptCard').classList.add('hidden');
  document.getElementById('fbForm').classList.remove('hidden');
  setBannerKey('', '');
  render();
};

document.getElementById('fbForm').addEventListener('submit', async e => {
  e.preventDefault();
  if (state.submitting) return;
  if (!state.imgEl && state.handoff && state.handoff.privacy_mode !== 'text') {
    setBannerKey('err', 'needImgForMode');
    return;
  }
  if (!state.imgEl && state.tags.size === 0 && !state.note.trim()) {
    setBannerKey('err', 'needContent');
    return;
  }
  state.submitting = true;
  setBannerKey('', '');
  render();
  try {
    let resp;
    if (state.imgEl) {
      const blob = await exportUploadBlob();
      const upImg = await loadBlobAsImage(blob);
      const payload = buildFinalPayload({ width: upImg.naturalWidth, height: upImg.naturalHeight });
      const form = new FormData();
      form.set('payload', JSON.stringify(payload));
      form.set('image', blob, 'screenshot.jpg');
      resp = await fetch('/v1/feedback', { method: 'POST', body: form });
    } else {
      const payload = buildFinalPayload(null);
      resp = await fetch('/v1/feedback', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
    }
    const body = await resp.json().catch(() => ({}));
    if (!resp.ok || !body.id) {
      throw new Error(body.error || ('HTTP ' + resp.status));
    }
    document.getElementById('receiptId').textContent = body.id;
    document.getElementById('fbForm').classList.add('hidden');
    document.getElementById('receiptCard').classList.remove('hidden');
    setBannerKey('', '');
  } catch (err) {
    setBannerText('err', String(err && err.message ? err.message : err));
  } finally {
    state.submitting = false;
    render();
  }
});

initFromHash().finally(() => render());
</script>
</body>
</html>
`;

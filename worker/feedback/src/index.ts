import { FEEDBACK_WEB_HTML } from './web.ts';

export interface R2PutOptions {
  httpMetadata?: { contentType?: string };
  customMetadata?: Record<string, string>;
}

export interface R2BucketLike {
  put(key: string, value: ArrayBuffer | Uint8Array | string, options?: R2PutOptions): Promise<unknown>;
}

export interface RateLimiterLike {
  limit(opts: { key: string }): Promise<{ success: boolean }>;
}

export interface Env {
  FEEDBACK_BUCKET: R2BucketLike;
  RATE_LIMITER?: RateLimiterLike;
  MAX_IMAGE_BYTES?: string;
  MAX_PAYLOAD_BYTES?: string;
}

const VALID_MODES = new Set(['masked', 'full', 'text']);
const VALID_PLATFORMS = new Set(['ios', 'android', 'macos', 'linux', 'windows', 'web']);
const VALID_TAGS = new Set(['missed', 'false_positive', 'box_drift', 'wrong_class', 'other']);
const VALID_DIFF_KINDS = new Set(['fn_missed', 'fp_confirmed']);
const MAX_BOXES = 200;
const MAX_EXCLUDED_PREFS = 500;
const MAX_IMAGE_DIM = 16384;
const MAX_NOTE_LEN = 500;
const DEFAULT_MAX_IMAGE_BYTES = 4 * 1024 * 1024;
const DEFAULT_MAX_PAYLOAD_BYTES = 64 * 1024;

interface ValidatedPayload {
  schema: 'unseen.feedback.v1';
  app_version: string;
  platform: string;
  model_id: string;
  privacy_mode: 'masked' | 'full' | 'text';
  tags: string[];
  note: string | null;
  image: {
    width: number;
    height: number;
    masked_regions: [number, number, number, number][];
  } | null;
  diffs: Array<{
    kind: 'fn_missed' | 'fp_confirmed';
    bbox: [number, number, number, number];
    class?: string;
    initial_class?: string;
    score?: number | null;
    masked_by_user?: boolean;
  }>;
  excluded_preference_count: number;
}

type ValidationResult = { ok: true; data: ValidatedPayload } | { ok: false; error: string };

const SECURITY_HEADERS: Record<string, string> = {
  'Content-Type': 'application/json; charset=utf-8',
  'Cache-Control': 'no-store',
  'X-Content-Type-Options': 'nosniff',
};

const HTML_HEADERS: Record<string, string> = {
  'Content-Type': 'text/html; charset=utf-8',
  'Cache-Control': 'public, max-age=300',
  'X-Content-Type-Options': 'nosniff',
  'Referrer-Policy': 'no-referrer',
  'Content-Security-Policy':
    "default-src 'none'; style-src 'unsafe-inline'; script-src 'unsafe-inline'; img-src blob: data:; connect-src 'self'; form-action 'none'; base-uri 'none'; frame-ancestors 'none'",
};

function jsonResponse(body: Record<string, unknown>, status: number): Response {
  return new Response(JSON.stringify(body), { status, headers: SECURITY_HEADERS });
}

function isPositiveFinite(v: unknown): v is number {
  return typeof v === 'number' && Number.isFinite(v) && v > 0;
}

function isBbox(v: unknown): v is [number, number, number, number] {
  if (!Array.isArray(v) || v.length !== 4) return false;
  const [x, y, w, h] = v;
  return (
    typeof x === 'number' && Number.isFinite(x) && x >= 0 &&
    typeof y === 'number' && Number.isFinite(y) && y >= 0 &&
    isPositiveFinite(w) &&
    isPositiveFinite(h)
  );
}

export function detectImageFormat(bytes: Uint8Array): { ext: string; mime: string } | null {
  if (bytes.length < 12) return null;
  // JPEG: FF D8 FF
  if (bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff) {
    return { ext: 'jpg', mime: 'image/jpeg' };
  }
  // PNG: 89 50 4E 47 0D 0A 1A 0A
  if (
    bytes[0] === 0x89 && bytes[1] === 0x50 && bytes[2] === 0x4e && bytes[3] === 0x47 &&
    bytes[4] === 0x0d && bytes[5] === 0x0a && bytes[6] === 0x1a && bytes[7] === 0x0a
  ) {
    return { ext: 'png', mime: 'image/png' };
  }
  // WebP: RIFF .... WEBP
  if (
    bytes[0] === 0x52 && bytes[1] === 0x49 && bytes[2] === 0x46 && bytes[3] === 0x46 &&
    bytes[8] === 0x57 && bytes[9] === 0x45 && bytes[10] === 0x42 && bytes[11] === 0x50
  ) {
    return { ext: 'webp', mime: 'image/webp' };
  }
  return null;
}

export function validatePayload(raw: unknown): ValidationResult {
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) {
    return { ok: false, error: 'payload must be a JSON object' };
  }
  const o = raw as Record<string, unknown>;
  if (o.schema !== 'unseen.feedback.v1') {
    return { ok: false, error: 'unsupported schema' };
  }
  if (typeof o.app_version !== 'string' || o.app_version.length === 0 || o.app_version.length > 32) {
    return { ok: false, error: 'invalid app_version' };
  }
  if (typeof o.platform !== 'string' || !VALID_PLATFORMS.has(o.platform)) {
    return { ok: false, error: 'invalid platform' };
  }
  if (typeof o.model_id !== 'string' || o.model_id.length > 128) {
    return { ok: false, error: 'invalid model_id' };
  }
  if (typeof o.privacy_mode !== 'string' || !VALID_MODES.has(o.privacy_mode)) {
    return { ok: false, error: 'invalid privacy_mode' };
  }
  const privacyMode = o.privacy_mode as 'masked' | 'full' | 'text';

  if (!Array.isArray(o.tags) || o.tags.length > 10) {
    return { ok: false, error: 'invalid tags' };
  }
  const tags: string[] = [];
  for (const t of o.tags) {
    if (typeof t !== 'string' || !VALID_TAGS.has(t)) {
      return { ok: false, error: `invalid tag: ${String(t)}` };
    }
    if (!tags.includes(t)) tags.push(t);
  }

  let note: string | null = null;
  if (o.note !== null && o.note !== undefined) {
    if (typeof o.note !== 'string' || o.note.length > MAX_NOTE_LEN) {
      return { ok: false, error: 'invalid note' };
    }
    note = o.note.trim() || null;
  }

  const excluded = o.excluded_preference_count ?? 0;
  if (
    typeof excluded !== 'number' ||
    !Number.isInteger(excluded) ||
    excluded < 0 ||
    excluded > MAX_EXCLUDED_PREFS
  ) {
    return { ok: false, error: 'invalid excluded_preference_count' };
  }

  if (!Array.isArray(o.diffs) || o.diffs.length > MAX_BOXES) {
    return { ok: false, error: 'invalid diffs' };
  }
  const diffs: ValidatedPayload['diffs'] = [];
  for (const d of o.diffs) {
    if (!d || typeof d !== 'object' || Array.isArray(d)) {
      return { ok: false, error: 'invalid diff entry' };
    }
    const item = d as Record<string, unknown>;
    if (typeof item.kind !== 'string' || !VALID_DIFF_KINDS.has(item.kind)) {
      return { ok: false, error: 'invalid diff kind' };
    }
    if (!isBbox(item.bbox)) {
      return { ok: false, error: 'invalid diff bbox' };
    }
    const entry: ValidatedPayload['diffs'][number] = {
      kind: item.kind as 'fn_missed' | 'fp_confirmed',
      bbox: item.bbox,
    };
    if (item.class !== undefined) {
      if (typeof item.class !== 'string' || item.class.length > 64) {
        return { ok: false, error: 'invalid diff class' };
      }
      entry.class = item.class;
    }
    if (item.initial_class !== undefined) {
      if (typeof item.initial_class !== 'string' || item.initial_class.length > 64) {
        return { ok: false, error: 'invalid diff initial_class' };
      }
      entry.initial_class = item.initial_class;
    }
    if (item.score !== undefined && item.score !== null) {
      if (typeof item.score !== 'number' || !Number.isFinite(item.score) || item.score < 0 || item.score > 1) {
        return { ok: false, error: 'invalid diff score' };
      }
      entry.score = item.score;
    }
    if (item.masked_by_user !== undefined) {
      if (typeof item.masked_by_user !== 'boolean') {
        return { ok: false, error: 'invalid masked_by_user' };
      }
      entry.masked_by_user = item.masked_by_user;
    }
    diffs.push(entry);
  }

  let image: ValidatedPayload['image'] = null;
  if (privacyMode === 'text') {
    if (o.image !== null && o.image !== undefined) {
      return { ok: false, error: 'text mode must not include image metadata' };
    }
    if (diffs.length > 0) {
      return { ok: false, error: 'text mode must not include diffs' };
    }
    if (tags.length === 0 && !note) {
      return { ok: false, error: 'text feedback requires a tag or note' };
    }
  } else {
    if (!o.image || typeof o.image !== 'object' || Array.isArray(o.image)) {
      return { ok: false, error: 'image metadata required for image privacy modes' };
    }
    const im = o.image as Record<string, unknown>;
    if (
      typeof im.width !== 'number' ||
      typeof im.height !== 'number' ||
      !Number.isInteger(im.width) ||
      !Number.isInteger(im.height) ||
      im.width < 1 ||
      im.width > MAX_IMAGE_DIM ||
      im.height < 1 ||
      im.height > MAX_IMAGE_DIM
    ) {
      return { ok: false, error: 'invalid image dimensions' };
    }
    if (!Array.isArray(im.masked_regions) || im.masked_regions.length > MAX_BOXES) {
      return { ok: false, error: 'invalid masked_regions' };
    }
    if (privacyMode === 'full' && im.masked_regions.length > 0) {
      return { ok: false, error: 'full mode must have empty masked_regions' };
    }
    const maskedRegions: [number, number, number, number][] = [];
    for (const r of im.masked_regions) {
      if (!isBbox(r)) return { ok: false, error: 'invalid masked_regions bbox' };
      maskedRegions.push(r);
    }
    image = { width: im.width, height: im.height, masked_regions: maskedRegions };
  }

  return {
    ok: true,
    data: {
      schema: 'unseen.feedback.v1',
      app_version: o.app_version,
      platform: o.platform,
      model_id: o.model_id,
      privacy_mode: privacyMode,
      tags,
      note,
      image,
      diffs,
      excluded_preference_count: excluded,
    },
  };
}

function generateId(now: Date): string {
  const y = now.getUTCFullYear();
  const m = String(now.getUTCMonth() + 1).padStart(2, '0');
  const d = String(now.getUTCDate()).padStart(2, '0');
  const buf = new Uint8Array(6);
  crypto.getRandomValues(buf);
  const rand = Array.from(buf, (b) => b.toString(16).padStart(2, '0')).join('');
  return `FB-${y}${m}${d}-${rand}`;
}

async function sha256Hex(bytes: Uint8Array): Promise<string> {
  const digest = await crypto.subtle.digest('SHA-256', bytes as BufferSource);
  return Array.from(new Uint8Array(digest), (b) => b.toString(16).padStart(2, '0')).join('');
}

async function readBoundedBody(request: Request, maxBytes: number): Promise<Uint8Array | null> {
  if (!request.body) return new Uint8Array(0);
  const reader = request.body.getReader();
  const chunks: Uint8Array[] = [];
  let total = 0;
  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      if (!value) continue;
      total += value.byteLength;
      if (total > maxBytes) {
        await reader.cancel();
        return null;
      }
      chunks.push(value);
    }
  } finally {
    reader.releaseLock();
  }
  const out = new Uint8Array(total);
  let offset = 0;
  for (const c of chunks) {
    out.set(c, offset);
    offset += c.byteLength;
  }
  return out;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const isGetOrHead = request.method === 'GET' || request.method === 'HEAD';
    if (
      isGetOrHead &&
      (url.pathname === '/' ||
        url.pathname === '/index.html' ||
        url.pathname === '/feedback' ||
        url.pathname === '/feedback/' ||
        url.pathname === '/feedback/index.html')
    ) {
      return new Response(request.method === 'HEAD' ? null : FEEDBACK_WEB_HTML, {
        status: 200,
        headers: HTML_HEADERS,
      });
    }
    if (isGetOrHead && url.pathname === '/health') {
      return request.method === 'HEAD'
        ? new Response(null, { status: 200, headers: SECURITY_HEADERS })
        : jsonResponse({ ok: true }, 200);
    }
    if (request.method !== 'POST' || url.pathname !== '/v1/feedback') {
      return jsonResponse({ error: 'not found' }, 404);
    }

    if (env.RATE_LIMITER) {
      const ip = request.headers.get('CF-Connecting-IP') ?? 'unknown';
      const { success } = await env.RATE_LIMITER.limit({ key: ip });
      if (!success) {
        return jsonResponse({ error: 'rate limit exceeded' }, 429);
      }
    }

    const maxImageBytes = Number(env.MAX_IMAGE_BYTES) || DEFAULT_MAX_IMAGE_BYTES;
    const maxPayloadBytes = Number(env.MAX_PAYLOAD_BYTES) || DEFAULT_MAX_PAYLOAD_BYTES;
    const rawCt = request.headers.get('Content-Type') ?? '';
    const ct = rawCt.toLowerCase();

    const maxBodyBytes = ct.startsWith('multipart/form-data')
      ? maxImageBytes + maxPayloadBytes + 65536
      : ct.startsWith('application/json')
      ? maxPayloadBytes
      : null;
    if (maxBodyBytes === null) {
      return jsonResponse({ error: 'unsupported content-type' }, 415);
    }

    const contentLength = Number(request.headers.get('Content-Length') ?? '0');
    if (Number.isFinite(contentLength) && contentLength > maxBodyBytes) {
      return jsonResponse({ error: 'request too large' }, 413);
    }

    const bodyBytes = await readBoundedBody(request, maxBodyBytes);
    if (bodyBytes === null) {
      return jsonResponse({ error: 'request too large' }, 413);
    }

    let payloadText: string;
    let imageBytes: Uint8Array | null = null;

    if (ct.startsWith('multipart/form-data')) {
      let form: FormData;
      try {
        form = await new Response(bodyBytes, { headers: { 'Content-Type': rawCt } }).formData();
      } catch {
        return jsonResponse({ error: 'invalid multipart form' }, 400);
      }
      const rawPayload = form.get('payload');
      if (typeof rawPayload !== 'string') {
        return jsonResponse({ error: 'missing payload field' }, 400);
      }
      payloadText = rawPayload;
      const rawImage = form.get('image');
      if (rawImage !== null) {
        if (typeof rawImage === 'string') {
          return jsonResponse({ error: 'image must be a file' }, 400);
        }
        if (rawImage.size > maxImageBytes) {
          return jsonResponse({ error: 'image too large' }, 413);
        }
        imageBytes = new Uint8Array(await rawImage.arrayBuffer());
      }
    } else {
      payloadText = new TextDecoder('utf-8', { fatal: false }).decode(bodyBytes);
    }

    if (new TextEncoder().encode(payloadText).byteLength > maxPayloadBytes) {
      return jsonResponse({ error: 'payload too large' }, 413);
    }

    let parsed: unknown;
    try {
      parsed = JSON.parse(payloadText);
    } catch {
      return jsonResponse({ error: 'invalid JSON payload' }, 400);
    }

    const valid = validatePayload(parsed);
    if (!valid.ok) {
      return jsonResponse({ error: valid.error }, 400);
    }
    const data = valid.data;

    let imgInfo: { ext: string; mime: string } | null = null;
    if (data.privacy_mode === 'text') {
      if (imageBytes && imageBytes.length > 0) {
        return jsonResponse({ error: 'text mode must not attach image' }, 400);
      }
      imageBytes = null;
    } else {
      if (!imageBytes || imageBytes.length === 0) {
        return jsonResponse({ error: 'image file required' }, 400);
      }
      if (imageBytes.length > maxImageBytes) {
        return jsonResponse({ error: 'image too large' }, 413);
      }
      imgInfo = detectImageFormat(imageBytes);
      if (!imgInfo) {
        return jsonResponse({ error: 'unsupported or corrupt image format' }, 415);
      }
    }

    const now = new Date();
    const id = generateId(now);
    const y = now.getUTCFullYear();
    const m = String(now.getUTCMonth() + 1).padStart(2, '0');
    const d = String(now.getUTCDate()).padStart(2, '0');
    const prefix = `feedback/${y}/${m}/${d}/${id}`;

    let imageHash: string | null = null;
    if (imageBytes && imgInfo) {
      imageHash = await sha256Hex(imageBytes);
      await env.FEEDBACK_BUCKET.put(`${prefix}/image.${imgInfo.ext}`, imageBytes, {
        httpMetadata: { contentType: imgInfo.mime },
      });
    }

    const record = {
      id,
      received_at: now.toISOString(),
      ...data,
      image: data.image && imgInfo
        ? {
            ...data.image,
            file: `image.${imgInfo.ext}`,
            bytes: imageBytes!.length,
            sha256: imageHash,
          }
        : null,
    };

    await env.FEEDBACK_BUCKET.put(`${prefix}/meta.json`, JSON.stringify(record, null, 2), {
      httpMetadata: { contentType: 'application/json; charset=utf-8' },
    });

    return jsonResponse({ id, received_at: record.received_at }, 201);
  },
};

import assert from 'node:assert/strict';
import test from 'node:test';
import worker, { detectImageFormat, validatePayload, type Env } from '../src/index.ts';

const PNG_BYTES = new Uint8Array([
  0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a,
  0x00, 0x00, 0x00, 0x0d, 0x49, 0x48, 0x44, 0x52,
]);
const JPEG_BYTES = new Uint8Array([
  0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10, 0x4a, 0x46, 0x49, 0x46, 0x00, 0x01,
]);
const WEBP_BYTES = new Uint8Array([
  0x52, 0x49, 0x46, 0x46, 0x24, 0x00, 0x00, 0x00, 0x57, 0x45, 0x42, 0x50,
]);

function makeEnv(rateOk = true) {
  const stored = new Map<string, { value: unknown; options: unknown }>();
  const env: Env = {
    FEEDBACK_BUCKET: {
      async put(key, value, options) {
        stored.set(key, { value, options });
      },
    },
    RATE_LIMITER: {
      async limit() {
        return { success: rateOk };
      },
    },
    MAX_IMAGE_BYTES: '1024',
    MAX_PAYLOAD_BYTES: '4096',
  };
  return { env, stored };
}

function validMaskedPayload() {
  return {
    schema: 'unseen.feedback.v1',
    app_version: '1.0.0',
    platform: 'ios',
    model_id: 'v19-rel-fp16',
    privacy_mode: 'masked',
    tags: ['missed', 'false_positive'],
    note: 'WeChat QR',
    image: {
      width: 1080,
      height: 2400,
      masked_regions: [[48, 296, 126, 126]],
    },
    diffs: [
      { kind: 'fn_missed', bbox: [180, 1256, 283, 48], class: 'manual', masked_by_user: false },
      { kind: 'fp_confirmed', bbox: [640, 1045, 290, 46], initial_class: 'address', score: 0.62 },
    ],
    excluded_preference_count: 1,
  };
}

test('detectImageFormat checks JPEG, PNG, WebP magic bytes', () => {
  assert.deepEqual(detectImageFormat(PNG_BYTES), { ext: 'png', mime: 'image/png' });
  assert.deepEqual(detectImageFormat(JPEG_BYTES), { ext: 'jpg', mime: 'image/jpeg' });
  assert.deepEqual(detectImageFormat(WEBP_BYTES), { ext: 'webp', mime: 'image/webp' });
  assert.equal(detectImageFormat(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])), null);
});

test('health endpoint returns 200', async () => {
  const { env } = makeEnv();
  const res = await worker.fetch(new Request('https://fb.test/health'), env);
  assert.equal(res.status, 200);
  assert.deepEqual(await res.json(), { ok: true });
});

test('accepts masked multipart feedback and writes image + meta.json to R2', async () => {
  const { env, stored } = makeEnv();
  const form = new FormData();
  form.set('payload', JSON.stringify(validMaskedPayload()));
  form.set('image', new Blob([PNG_BYTES], { type: 'image/png' }), 'shot.png');

  const res = await worker.fetch(new Request('https://fb.test/v1/feedback', { method: 'POST', body: form }), env);
  assert.equal(res.status, 201);
  const body = (await res.json()) as { id: string; received_at: string };
  assert.match(body.id, /^FB-\d{8}-[0-9a-f]{12}$/);

  const keys = [...stored.keys()];
  assert.equal(keys.length, 2);
  const imgKey = keys.find((k) => k.endsWith('/image.png'));
  const metaKey = keys.find((k) => k.endsWith('/meta.json'));
  assert.ok(imgKey && metaKey);
  const meta = JSON.parse(stored.get(metaKey)!.value as string);
  assert.equal(meta.id, body.id);
  assert.equal(meta.excluded_preference_count, 1);
  assert.equal(meta.image.file, 'image.png');
  assert.equal(meta.image.bytes, PNG_BYTES.length);
  assert.equal(meta.image.masked_regions.length, 1);
});

test('accepts text-only JSON feedback without image', async () => {
  const { env, stored } = makeEnv();
  const payload = {
    schema: 'unseen.feedback.v1',
    app_version: '1.0.0',
    platform: 'android',
    model_id: 'v19-rel-fp16',
    privacy_mode: 'text',
    tags: ['false_positive'],
    note: 'Price tags in delivery app',
    image: null,
    diffs: [],
    excluded_preference_count: 0,
  };
  const res = await worker.fetch(
    new Request('https://fb.test/v1/feedback', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    }),
    env,
  );
  assert.equal(res.status, 201);
  assert.equal(stored.size, 1);
  const [metaEntry] = [...stored.values()];
  assert.equal(JSON.parse(metaEntry.value as string).image, null);
});

test('rejects invalid image magic bytes, oversized images, text mode with image, and rate-limited requests', async () => {
  const { env } = makeEnv();

  // Bad magic bytes
  const badForm = new FormData();
  badForm.set('payload', JSON.stringify(validMaskedPayload()));
  badForm.set('image', new Blob([new Uint8Array(24)], { type: 'image/png' }), 'fake.png');
  const rBad = await worker.fetch(new Request('https://fb.test/v1/feedback', { method: 'POST', body: badForm }), env);
  assert.equal(rBad.status, 415);

  // Oversized image (> 1024 in test env)
  const bigBytes = new Uint8Array(2048);
  bigBytes.set(PNG_BYTES, 0);
  const bigForm = new FormData();
  bigForm.set('payload', JSON.stringify(validMaskedPayload()));
  bigForm.set('image', new Blob([bigBytes], { type: 'image/png' }), 'big.png');
  const rBig = await worker.fetch(new Request('https://fb.test/v1/feedback', { method: 'POST', body: bigForm }), env);
  assert.equal(rBig.status, 413);

  // Text mode attaching an image is rejected
  const textWithImg = new FormData();
  textWithImg.set(
    'payload',
    JSON.stringify({
      ...validMaskedPayload(),
      privacy_mode: 'text',
      image: null,
    }),
  );
  textWithImg.set('image', new Blob([PNG_BYTES], { type: 'image/png' }), 'x.png');
  const rText = await worker.fetch(new Request('https://fb.test/v1/feedback', { method: 'POST', body: textWithImg }), env);
  assert.equal(rText.status, 400);

  // Rate limited
  const { env: limEnv } = makeEnv(false);
  const rLim = await worker.fetch(new Request('https://fb.test/v1/feedback', { method: 'POST', body: '{}' }), limEnv);
  assert.equal(rLim.status, 429);
});

test('validatePayload rejects malformed bbox and empty text-only feedback', () => {
  assert.equal(validatePayload({ ...validMaskedPayload(), schema: 'bad' }).ok, false);
  assert.equal(
    validatePayload({
      ...validMaskedPayload(),
      diffs: [{ kind: 'fn_missed', bbox: [0, 0, -10, 20] }],
    }).ok,
    false,
  );
  assert.equal(
    validatePayload({
      ...validMaskedPayload(),
      privacy_mode: 'text',
      image: null,
      tags: [],
      note: null,
      diffs: [],
    }).ok,
    false,
  );
  // Text mode must not leak diffs.
  assert.equal(
    validatePayload({
      ...validMaskedPayload(),
      privacy_mode: 'text',
      image: null,
    }).ok,
    false,
  );
  // Full mode must have empty masked_regions.
  assert.equal(
    validatePayload({
      ...validMaskedPayload(),
      privacy_mode: 'full',
    }).ok,
    false,
  );
  // Non-integer image dimensions rejected.
  assert.equal(
    validatePayload({
      ...validMaskedPayload(),
      image: { width: 1080.5, height: 2400, masked_regions: [] },
    }).ok,
    false,
  );
});

test('enforces bounded streaming body cap without Content-Length header', async () => {
  const { env } = makeEnv();
  // Stream 8 KiB JSON (> MAX_PAYLOAD_BYTES = 4096) without Content-Length.
  const bigJsonStream = new ReadableStream<Uint8Array>({
    start(controller) {
      controller.enqueue(new TextEncoder().encode('{"note":"'));
      controller.enqueue(new Uint8Array(5000).fill(0x61));
      controller.enqueue(new TextEncoder().encode('"}'));
      controller.close();
    },
  });
  const req = new Request('https://fb.test/v1/feedback', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: bigJsonStream,
    // @ts-expect-error Node fetch requires duplex for ReadableStream bodies
    duplex: 'half',
  });
  const res = await worker.fetch(req, env);
  assert.equal(res.status, 413);
});

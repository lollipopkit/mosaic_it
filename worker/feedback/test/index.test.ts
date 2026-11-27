import assert from 'node:assert/strict';
import test from 'node:test';
import worker, { detectImageFormat, validatePayload, verifyTurnstileToken, type Env } from '../src/index.ts';
import { FEEDBACK_COPY, FEEDBACK_LOCALES } from '../src/i18n.ts';

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

test('GET / and /feedback serve web feedback UI with strict CSP and no-referrer', async () => {
  const { env } = makeEnv();
  for (const path of ['/', '/index.html', '/feedback', '/feedback/', '/feedback/index.html']) {
    const res = await worker.fetch(new Request(`https://fb.test${path}`), env);
    assert.equal(res.status, 200, `GET ${path} should return 200`);
    assert.match(res.headers.get('Content-Type') ?? '', /^text\/html/);
    assert.equal(res.headers.get('Referrer-Policy'), 'no-referrer');
    const csp = res.headers.get('Content-Security-Policy') ?? '';
    assert.match(csp, /default-src 'none'/);
    assert.match(csp, /connect-src 'self'/);
    const html = await res.text();
    assert.match(html, /DecompressionStream\('deflate-raw'\)/);
    assert.match(html, /\/v1\/feedback/);
    const head = await worker.fetch(new Request(`https://fb.test${path}`, { method: 'HEAD' }), env);
    assert.equal(head.status, 200, `HEAD ${path} should return 200`);
    assert.equal(await head.text(), '');
  }
});

test('accepts standalone web platform text feedback', async () => {
  const { env, stored } = makeEnv();
  const res = await worker.fetch(
    new Request('https://fb.test/v1/feedback', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        schema: 'unseen.feedback.v1',
        app_version: 'web',
        platform: 'web',
        model_id: 'web',
        privacy_mode: 'text',
        tags: ['other'],
        note: 'Web submission',
        image: null,
        diffs: [],
        excluded_preference_count: 0,
      }),
    }),
    env,
  );
  assert.equal(res.status, 201);
  assert.equal(stored.size, 1);
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

test('Turnstile enabled: HTML includes widget script and CSP allows challenges.cloudflare.com', async () => {
  const { env } = makeEnv();
  env.TURNSTILE_SITE_KEY = '0x4AAAAAATestSiteKey';
  env.TURNSTILE_SECRET_KEY = '0x4AAAAAATestSecret';

  const res = await worker.fetch(new Request('https://fb.test/feedback'), env);
  assert.equal(res.status, 200);
  assert.equal(res.headers.get('Referrer-Policy'), 'strict-origin-when-cross-origin');
  const csp = res.headers.get('Content-Security-Policy') ?? '';
  assert.match(csp, /script-src 'unsafe-inline' https:\/\/challenges\.cloudflare\.com/);
  assert.match(csp, /frame-src https:\/\/challenges\.cloudflare\.com/);
  const html = await res.text();
  assert.match(html, /https:\/\/challenges\.cloudflare\.com\/turnstile\/v0\/api\.js\?render=explicit&onload=onTurnstileLoad/);
  assert.match(html, /const TURNSTILE_SITE_KEY = "0x4AAAAAATestSiteKey"/);
  assert.match(html, /id="turnstileSlot"/);
});

test('Turnstile enforces valid token, hostname check, fail-closed config, and upstream errors', async () => {
  const makeJsonReq = (token?: string) =>
    new Request('https://fb.test/v1/feedback', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'CF-Connecting-IP': '203.0.113.9',
        ...(token !== undefined ? { 'X-Turnstile-Token': token } : {}),
      },
      body: JSON.stringify({
        schema: 'unseen.feedback.v1',
        app_version: 'web',
        platform: 'web',
        model_id: 'web',
        privacy_mode: 'text',
        tags: ['other'],
        note: 'Turnstile test',
        image: null,
        diffs: [],
        excluded_preference_count: 0,
      }),
    });

  // Misconfigured (site key without secret key) fails closed with 500
  const { env: badCfg } = makeEnv();
  badCfg.TURNSTILE_SITE_KEY = '0x4AAAAAATestSiteKey';
  const rMis = await worker.fetch(makeJsonReq('tok'), badCfg);
  assert.equal(rMis.status, 500);

  // Missing token -> 403 without calling siteverify or touching R2
  let verifyCalls = 0;
  const { env, stored } = makeEnv();
  env.TURNSTILE_SITE_KEY = '0x4AAAAAATestSiteKey';
  env.TURNSTILE_SECRET_KEY = '0x4AAAAAATestSecret';
  env.TURNSTILE_ALLOWED_HOSTNAMES = 'mosaic.lollipopkit.com,unseen-feedback.lollipopkit.workers.dev';
  env.TURNSTILE_FETCH = (async (_url, init) => {
    verifyCalls++;
    const body = new URLSearchParams(String(init?.body ?? ''));
    const tok = body.get('response');
    assert.equal(body.get('secret'), '0x4AAAAAATestSecret');
    assert.equal(body.get('remoteip'), '203.0.113.9');
    if (tok === 'good-token') {
      return new Response(JSON.stringify({ success: true, hostname: 'mosaic.lollipopkit.com' }), { status: 200 });
    }
    if (tok === 'wrong-host') {
      return new Response(JSON.stringify({ success: true, hostname: 'evil.example.com' }), { status: 200 });
    }
    if (tok === 'upstream-500') {
      return new Response('err', { status: 500 });
    }
    return new Response(JSON.stringify({ success: false, 'error-codes': ['invalid-input-response'] }), { status: 200 });
  }) as typeof fetch;

  const rMissing = await worker.fetch(makeJsonReq(), env);
  assert.equal(rMissing.status, 403);
  assert.equal(verifyCalls, 0);
  assert.equal(stored.size, 0);

  // Invalid token -> 403
  const rBad = await worker.fetch(makeJsonReq('bad-token'), env);
  assert.equal(rBad.status, 403);
  assert.equal(verifyCalls, 1);
  assert.equal(stored.size, 0);

  // Hostname mismatch -> 403
  const rHost = await worker.fetch(makeJsonReq('wrong-host'), env);
  assert.equal(rHost.status, 403);
  assert.equal(stored.size, 0);

  // Upstream failure -> 502 fail-closed
  const rDown = await worker.fetch(makeJsonReq('upstream-500'), env);
  assert.equal(rDown.status, 502);
  assert.equal(stored.size, 0);

  // Valid token + allowed hostname -> 201 and stored in R2
  const rOk = await worker.fetch(makeJsonReq('good-token'), env);
  assert.equal(rOk.status, 201);
  assert.equal(stored.size, 1);
});

test('Turnstile edge cases: malformed tokens, upstream null/throw, default hostname, XSS sitekey, rate-limit order, multipart', async () => {
  const makeJsonReq = (token?: string) =>
    new Request('https://fb.test/v1/feedback', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token !== undefined ? { 'X-Turnstile-Token': token } : {}),
      },
      body: JSON.stringify({
        schema: 'unseen.feedback.v1',
        app_version: 'web',
        platform: 'web',
        model_id: 'web',
        privacy_mode: 'text',
        tags: ['other'],
        note: 'Edge test',
        image: null,
        diffs: [],
        excluded_preference_count: 0,
      }),
    });

  // Malformed sitekey does not relax CSP/Referrer-Policy on GET and fails closed (500) on POST
  const { env: xssEnv } = makeEnv();
  xssEnv.TURNSTILE_SITE_KEY = '"><script>alert(1)</script>';
  xssEnv.TURNSTILE_SECRET_KEY = '0x4AAAAAATestSecret';
  const rGetBadKey = await worker.fetch(new Request('https://fb.test/feedback'), xssEnv);
  assert.equal(rGetBadKey.status, 200);
  assert.equal(rGetBadKey.headers.get('Referrer-Policy'), 'no-referrer');
  assert.doesNotMatch(rGetBadKey.headers.get('Content-Security-Policy') ?? '', /challenges\.cloudflare\.com/);
  assert.doesNotMatch(await rGetBadKey.text(), /alert\(1\)/);
  const rPostBadKey = await worker.fetch(makeJsonReq('tok'), xssEnv);
  assert.equal(rPostBadKey.status, 500);

  // Rate limit runs before Turnstile verification
  let verifyCalls = 0;
  const { env: limEnv } = makeEnv(false);
  limEnv.TURNSTILE_SECRET_KEY = '0x4AAAAAATestSecret';
  limEnv.TURNSTILE_FETCH = (async () => {
    verifyCalls++;
    return new Response(JSON.stringify({ success: true, hostname: 'fb.test' }), { status: 200 });
  }) as typeof fetch;
  assert.equal((await worker.fetch(makeJsonReq('tok'), limEnv)).status, 429);
  assert.equal(verifyCalls, 0);

  // Secret-only config enforces Turnstile and defaults allowed hostname to request hostname (case-insensitive)
  const { env, stored } = makeEnv();
  env.TURNSTILE_SECRET_KEY = '0x4AAAAAATestSecret';
  env.TURNSTILE_FETCH = (async (_url, init) => {
    verifyCalls++;
    const tok = new URLSearchParams(String(init?.body ?? '')).get('response');
    if (tok === 'throw') throw new Error('network down');
    if (tok === 'non-json') return new Response('<html>err</html>', { status: 200 });
    if (tok === 'json-null') return new Response('null', { status: 200 });
    if (tok === 'no-host') return new Response(JSON.stringify({ success: true }), { status: 200 });
    if (tok === 'upper-host') return new Response(JSON.stringify({ success: true, hostname: 'FB.TEST' }), { status: 200 });
    return new Response(JSON.stringify({ success: true, hostname: 'fb.test' }), { status: 200 });
  }) as typeof fetch;

  // Whitespace, oversized (>2048), and control chars rejected locally without calling siteverify
  assert.equal((await worker.fetch(makeJsonReq('   '), env)).status, 403);
  assert.equal((await worker.fetch(makeJsonReq('a'.repeat(2049)), env)).status, 403);
  const ctrlRes = await verifyTurnstileToken({
    token: 'tok\r\nbad',
    secret: '0x4AAAAAATestSecret',
    remoteIp: null,
    allowedHostnames: ['fb.test'],
    fetchFn: env.TURNSTILE_FETCH,
  });
  assert.deepEqual(ctrlRes, { ok: false, status: 403, error: 'invalid turnstile token' });
  const nulRes = await verifyTurnstileToken({
    token: 'tok\0bad',
    secret: '0x4AAAAAATestSecret',
    remoteIp: null,
    allowedHostnames: ['fb.test'],
    fetchFn: env.TURNSTILE_FETCH,
  });
  assert.deepEqual(nulRes, { ok: false, status: 403, error: 'invalid turnstile token' });
  assert.equal(verifyCalls, 0);

  // Upstream throw / non-JSON / JSON null -> 502 fail-closed
  assert.equal((await worker.fetch(makeJsonReq('throw'), env)).status, 502);
  assert.equal((await worker.fetch(makeJsonReq('non-json'), env)).status, 502);
  assert.equal((await worker.fetch(makeJsonReq('json-null'), env)).status, 502);

  // Missing hostname fails default hostname check -> 403
  assert.equal((await worker.fetch(makeJsonReq('no-host'), env)).status, 403);

  // Case-insensitive default hostname match succeeds -> 201
  assert.equal((await worker.fetch(makeJsonReq('upper-host'), env)).status, 201);

  // Multipart upload with X-Turnstile-Token succeeds -> 201
  const form = new FormData();
  form.set('payload', JSON.stringify(validMaskedPayload()));
  form.set('image', new Blob([PNG_BYTES], { type: 'image/png' }), 'shot.png');
  const rMulti = await worker.fetch(
    new Request('https://fb.test/v1/feedback', {
      method: 'POST',
      headers: { 'X-Turnstile-Token': 'ok-multipart' },
      body: form,
    }),
    env,
  );
  assert.equal(rMulti.status, 201);
  assert.equal(stored.size, 3);
});

test('Feedback UI supports all 17 ServerBox locales without English placeholders', async () => {
  const expectedCodes = [
    'en', 'zh-CN', 'zh-TW', 'ja', 'ko', 'de', 'es', 'fr', 'it', 'nl', 'pt', 'ru', 'uk', 'tr', 'id', 'fa', 'az',
  ];
  assert.deepEqual(FEEDBACK_LOCALES.map((l) => l.code), expectedCodes);

  const enCopy = FEEDBACK_COPY.en;
  for (const meta of FEEDBACK_LOCALES) {
    const copy = FEEDBACK_COPY[meta.code];
    assert.ok(copy, `missing copy for ${meta.code}`);
    if (meta.code === 'fa') assert.equal(meta.dir, 'rtl');
    else assert.equal(meta.dir, 'ltr');

    // Every flat string field must be non-empty and (for non-en) not copy English placeholders
    for (const [k, v] of Object.entries(enCopy)) {
      if (typeof v !== 'string') continue;
      const got = (copy as Record<string, unknown>)[k];
      assert.equal(typeof got, 'string', `${meta.code}.${k} must be string`);
      assert.ok((got as string).trim().length > 0, `${meta.code}.${k} must be non-empty`);
      if (meta.code !== 'en' && v.length > 8) {
        assert.notEqual(got, v, `${meta.code}.${k} must not use English placeholder`);
      }
    }
    for (const group of ['tags', 'legend', 'modeNames'] as const) {
      for (const [k, v] of Object.entries(enCopy[group])) {
        const got = (copy[group] as Record<string, string>)[k];
        assert.ok(typeof got === 'string' && got.trim().length > 0, `${meta.code}.${group}.${k} missing`);
        if (group === 'legend') assert.ok(got.includes('{n}'), `${meta.code}.legend.${k} missing {n}`);
      }
    }
  }

  const { env } = makeEnv();
  const res = await worker.fetch(new Request('https://fb.test/feedback'), env);
  const html = await res.text();
  assert.match(html, /<html lang="en">/);
  assert.match(html, /<select class="lang-sel" id="langSel"/);
  for (const meta of FEEDBACK_LOCALES) {
    assert.ok(html.includes(`<option value="${meta.code}">${meta.label}</option>`), `missing option ${meta.code}`);
  }
  assert.match(html, /Object\.prototype\.hasOwnProperty\.call\(LOCALE_META, base\)/);
  assert.doesNotMatch(html, /LOCALE_META\[base\]/);
});

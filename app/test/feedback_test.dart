import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/src/boxes.dart';
import 'package:unseen/src/feedback.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);
}

void main() {
  late Directory tempDir;
  late File png;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('unseen_fb');
    png = File('${tempDir.path}/shot.png')
      ..writeAsBytesSync(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4//8/AAX+Av6nNYGEAAAAAElFTkSuQmCC',
        ),
      );
  });

  tearDown(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  Shot sampleShot() {
    // Kept TP model box
    final tp = EditBox(
      rect: const Rect.fromLTWH(20, 40, 200, 60),
      className: 'phone',
      score: 0.92,
      selected: true,
      source: BoxSource.detector,
    );
    // Unchecked model box (preference by default, not FP until confirmed)
    final uncheckedA = EditBox(
      rect: const Rect.fromLTWH(20, 120, 160, 40),
      className: 'avatar',
      score: 0.75,
      selected: true,
      source: BoxSource.detector,
    )..selected = false;
    final uncheckedB = EditBox(
      rect: const Rect.fromLTWH(20, 180, 180, 40),
      className: 'finance',
      score: 0.61,
      selected: true,
      source: BoxSource.detector,
    )..selected = false;
    // Manually drawn missed box (FN)
    final drawn = EditBox(
      rect: const Rect.fromLTWH(100, 300, 300, 80),
      className: 'person_name',
      selected: true,
      source: BoxSource.drawn,
    );
    return Shot(png, const Size(1000, 2000), [
      tp,
      uncheckedA,
      uncheckedB,
      drawn,
    ]);
  }

  test('FeedbackDraft separates personal preference from confirmed FP and scales bboxes', () {
    final shot = sampleShot();
    final draft = FeedbackDraft(shot: shot);

    expect(draft.mode, FeedbackPrivacyMode.masked);
    expect(draft.keptModelBoxes.length, 1);
    expect(draft.uncheckedModelBoxes.length, 2);
    expect(draft.missedBoxes.length, 1);
    expect(draft.rawDiffCount, 3);
    expect(draft.tags, contains(FeedbackTag.missed));
    expect(draft.excludedPreferenceCount, 2);

    // Confirm only the second unchecked box as false positive.
    draft.toggleConfirmedFp(draft.uncheckedModelBoxes[1]);
    expect(draft.excludedPreferenceCount, 1);
    expect(draft.tags, contains(FeedbackTag.falsePositive));

    // User masks the missed box for extra privacy -> goes into masked_regions
    // AND sets masked_by_user: true.
    draft.toggleUserMaskedFn(draft.missedBoxes.single);
    expect(draft.maskedRegionsForUpload().length, 2);

    // Scale from 1000x2000 to 640x1280 (0.64x).
    final payload = draft.buildPayload(
      modelId: 'screenshots@abc123',
      platform: 'ios',
      uploadedSize: const Size(640, 1280),
    );

    expect(payload['schema'], 'unseen.feedback.v1');
    expect(payload['privacy_mode'], 'masked');
    expect(payload['excluded_preference_count'], 1);

    final image = payload['image'] as Map<String, dynamic>;
    expect(image['width'], 640);
    expect(image['height'], 1280);
    final masked = image['masked_regions'] as List;
    expect(masked.length, 2);
    expect(masked[0], [12.8, 25.6, 128.0, 38.4]);
    expect(masked[1], [64.0, 192.0, 192.0, 51.2]);

    final diffs = payload['diffs'] as List;
    expect(diffs.length, 2);
    expect(diffs[0]['kind'], 'fn_missed');
    expect(diffs[0]['masked_by_user'], isTrue);
    expect(diffs[0]['bbox'], [64.0, 192.0, 192.0, 51.2]);
    expect(diffs[1]['kind'], 'fp_confirmed');
    expect(diffs[1]['initial_class'], 'finance');
    expect(diffs[1]['score'], 0.61);
  });

  test('auto-masks adaptive-promoted review boxes and exportCheck boxes in masked mode', () {
    // Adaptive-promoted review box: initialSelected=false, shownSelected=true, selected=true
    final promoted =
        EditBox(
            rect: const Rect.fromLTWH(10, 20, 100, 40),
            className: 'person_name',
            score: 0.48,
            selected: false,
            review: true,
            source: BoxSource.detector,
          )
          ..selected = true
          ..shownSelected = true;

    // exportCheck box added during export check
    final checkBox = EditBox(
      rect: const Rect.fromLTWH(10, 80, 120, 40),
      className: 'phone',
      score: 0.85,
      selected: true,
      source: BoxSource.exportCheck,
    );

    final shot = Shot(png, const Size(500, 500), [promoted, checkBox]);
    final draft = FeedbackDraft(shot: shot);

    expect(draft.keptModelBoxes, [checkBox]);
    expect(draft.missedBoxes, [promoted]);
    expect(draft.userMaskedFn, contains(promoted));
    expect(draft.maskedRegionsForUpload().length, 2);

    final payload = draft.buildPayload(modelId: 'm', platform: 'ios');
    final image = payload['image'] as Map<String, dynamic>;
    expect((image['masked_regions'] as List).length, 2);
    final diffs = payload['diffs'] as List;
    expect(diffs.single['masked_by_user'], isTrue);
  });

  test('FeedbackSnapshot is immutable against subsequent draft mutations', () {
    final shot = sampleShot();
    final draft = FeedbackDraft(shot: shot);
    final snap = draft.snapshot();

    // Mutate draft after snapshot (simulating mid-flight user tap).
    draft.mode = FeedbackPrivacyMode.text;
    draft.toggleUserMaskedFn(draft.missedBoxes.single);
    draft.setShot(null);

    final payload = snap.buildPayload(modelId: 'm', platform: 'ios');
    expect(payload['privacy_mode'], 'masked');
    expect(payload['image'], isNotNull);
    expect(((payload['image'] as Map)['masked_regions'] as List).length, 1);
  });

  test('text mode omits image, diffs, and excluded_preference_count', () {
    final shot = sampleShot();
    final draft = FeedbackDraft(shot: shot, mode: FeedbackPrivacyMode.text);
    expect(draft.canSubmit, isTrue); // has default 'missed' tag

    final payload = draft.buildPayload(modelId: 'm', platform: 'macos');
    expect(payload['image'], isNull);
    expect(payload['diffs'], isEmpty);
    expect(payload['excluded_preference_count'], 0);

    final empty = FeedbackDraft();
    expect(empty.canSubmit, isFalse);
    empty.note = '  Missed QQ number  ';
    expect(empty.canSubmit, isTrue);
    expect(
      empty.buildPayload(modelId: 'none', platform: 'macos')['note'],
      'Missed QQ number',
    );
  });

  test(
    'FeedbackClient posts multipart/JSON and wraps non-JSON errors cleanly',
    () async {
      late String capturedContentType;
      late dynamic capturedData;
      final dio = Dio()
        ..httpClientAdapter = _StubAdapter((opts) async {
          capturedContentType = opts.contentType ?? '';
          capturedData = opts.data;
          if (opts.path.endsWith('/html-error')) {
            return ResponseBody.fromString(
              '<html>502 Bad Gateway</html>',
              502,
              headers: {
                Headers.contentTypeHeader: ['text/html'],
              },
            );
          }
          return ResponseBody.fromString(
            jsonEncode({
              'id': 'FB-20261126-abcdef123456',
              'received_at': '2026-11-26T04:00:00Z',
            }),
            201,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

      final client = FeedbackClient(
        dio: dio,
        endpoint: 'https://example.test/v1/feedback',
      );

      final draft = FeedbackDraft(shot: sampleShot());
      final r1 = await client.submit(
        payload: draft.buildPayload(modelId: 'test', platform: 'ios'),
        imageFile: png,
      );
      expect(r1.id, 'FB-20261126-abcdef123456');
      expect(capturedData, isA<FormData>());

      final textDraft = FeedbackDraft(note: 'Test');
      final r2 = await client.submit(
        payload: textDraft.buildPayload(modelId: 'none', platform: 'ios'),
      );
      expect(r2.id, 'FB-20261126-abcdef123456');
      expect(capturedContentType, contains('application/json'));

      final badClient = FeedbackClient(
        dio: dio,
        endpoint: 'https://example.test/html-error',
      );
      await expectLater(
        badClient.submit(
          payload: textDraft.buildPayload(modelId: 'none', platform: 'ios'),
        ),
        throwsA(isA<FeedbackException>()),
      );
    },
  );
}

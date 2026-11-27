import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/src/boxes.dart';
import 'package:unseen/src/feedback.dart';

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

  test('buildFeedbackWebUri encodes deflate-raw payload and optional JPEG into URL fragment', () {
    final draft = FeedbackDraft(shot: sampleShot())..note = 'Missed address';
    final payload = draft.buildPayload(
      modelId: 'ui_screenshot@0150b2fb',
      platform: 'ios',
      uploadedSize: const Size(640, 1280),
    );
    final jpeg = Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3, 4]);

    final uri = buildFeedbackWebUri(
      payload: payload,
      imageBytes: jpeg,
      baseUrl: 'https://example.test/',
    );
    expect(uri.scheme, 'https');
    expect(uri.host, 'example.test');
    expect(uri.query, isEmpty);
    expect(uri.fragment, contains('v=1&d='));
    expect(uri.fragment, contains('&i='));
    expect(uri.fragment, isNot(contains('=' * 2)));

    final decoded = decodeFeedbackWebPayload(uri);
    expect(decoded, equals(payload));

    final params = Uri.splitQueryString(uri.fragment);
    final decodedImg = base64Url.decode(base64Url.normalize(params['i']!));
    expect(decodedImg, equals(jpeg));

    // Deferred image mode omits i= and sets m=1 while preserving full payload.
    final deferred = buildFeedbackWebUri(
      payload: payload,
      imageDeferred: true,
      baseUrl: 'https://example.test/',
    );
    final dParams = Uri.splitQueryString(deferred.fragment);
    expect(dParams.containsKey('i'), isFalse);
    expect(dParams['m'], '1');
    expect(decodeFeedbackWebPayload(deferred), equals(payload));
  });
}

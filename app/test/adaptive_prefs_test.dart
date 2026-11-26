import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/src/adaptive_prefs.dart';
import 'package:unseen/src/boxes.dart';
import 'package:unseen/src/rust/api.dart';

void main() {
  final dummy = File('/tmp/dummy.png');

  EditBox det(
    String cls,
    double score, {
    required bool selected,
    bool suggested = false,
  }) => EditBox(
    rect: const Rect.fromLTWH(10, 10, 40, 20),
    className: cls,
    score: score,
    selected: selected,
    review: !selected && !suggested,
    suggested: suggested,
    source: BoxSource.detector,
  );

  test('unchecking raises threshold and unselects borderline boxes', () async {
    var stored = '{}';
    final prefs = AdaptivePrefs(
      read: () => stored,
      write: (v) async => stored = v,
    );

    // Uncheck 3 times on high-confidence boxes -> delta = +0.06.
    for (var i = 0; i < 3; i++) {
      final box = det('avatar', 0.65, selected: true);
      final shot = Shot(dummy, const Size(400, 400), [box]);
      prefs.apply(
        shot,
        enabled: true,
        offClasses: const {},
        baseThresholds: const {'avatar': 0.50},
      );
      expect(box.shownSelected, isTrue);
      box.selected = false;
      expect(
        await prefs.recordExport(shot, enabled: true, offClasses: const {}),
        isTrue,
      );
    }

    expect(prefs.offsets['avatar'], closeTo(0.06, 1e-4));
    expect(prefs.learnedCount, 1);

    // Reload from persisted JSON and apply to a new shot.
    final reloaded = AdaptivePrefs(read: () => stored);
    final borderline = det('avatar', 0.54, selected: true);
    final strong = det('avatar', 0.72, selected: true);
    final nextShot = Shot(dummy, const Size(400, 400), [borderline, strong]);

    reloaded.apply(
      nextShot,
      enabled: true,
      offClasses: const {},
      baseThresholds: const {'avatar': 0.50},
    );

    // Effective threshold = 0.50 + 0.06 = 0.56.
    expect(borderline.selected, isFalse);
    expect(borderline.shownSelected, isFalse);
    expect(borderline.initialSelected, isTrue);
    expect(strong.selected, isTrue);
    expect(strong.shownSelected, isTrue);
  });

  test('selecting review boxes lowers threshold and keeping does not decay negative offset', () async {
    var stored = '{}';
    final prefs = AdaptivePrefs(
      read: () => stored,
      write: (v) async => stored = v,
    );

    // Select review box twice -> delta = -0.04.
    for (var i = 0; i < 2; i++) {
      final box = det('person_name', 0.45, selected: false);
      final shot = Shot(dummy, const Size(400, 400), [box]);
      prefs.apply(
        shot,
        enabled: true,
        offClasses: const {},
        baseThresholds: const {'person_name': 0.50},
      );
      box.selected = true;
      await prefs.recordExport(shot, enabled: true, offClasses: const {});
    }

    expect(prefs.offsets['person_name'], closeTo(-0.04, 1e-4));

    final candidate = det('person_name', 0.47, selected: false);
    final tooLow = det('person_name', 0.42, selected: false);
    final shot = Shot(dummy, const Size(400, 400), [candidate, tooLow]);
    prefs.apply(
      shot,
      enabled: true,
      offClasses: const {},
      baseThresholds: const {'person_name': 0.50},
    );

    // Effective threshold = 0.50 - 0.04 = 0.46.
    expect(candidate.selected, isTrue);
    expect(candidate.shownSelected, isTrue);
    expect(candidate.initialSelected, isFalse);
    expect(tooLow.selected, isFalse);

    // Keeping the promoted box must NOT decay the negative offset toward 0.
    expect(
      await prefs.recordExport(shot, enabled: true, offClasses: const {}),
      isFalse,
    );
    expect(prefs.offsets['person_name'], closeTo(-0.04, 1e-4));
  });

  test('aggregates per initialClass per export and ignores reclass mutation', () async {
    final prefs = AdaptivePrefs();
    // 10 unchecked avatars in one screenshot -> at most 1 step (+0.02),
    // even if one box was reclassed to 'manual'.
    final boxes = [
      for (var i = 0; i < 10; i++)
        det('avatar', 0.80, selected: true)
          ..selected = false
          ..className = i == 0 ? 'manual' : 'avatar',
    ];
    await prefs.recordExport(
      Shot(dummy, const Size(400, 400), boxes),
      enabled: true,
      offClasses: const {},
    );
    expect(prefs.offsets.keys, ['avatar']);
    expect(prefs.offsets['avatar'], closeTo(AdaptivePrefs.stepUncheck, 1e-4));
  });

  test('respects offClasses, disabled flag, clamping, positive decay, and reset', () async {
    var stored = '{}';
    final prefs = AdaptivePrefs(
      read: () => stored,
      write: (v) async => stored = v,
    );

    // offClasses are never updated.
    final face = det('face', 0.80, selected: false, suggested: true);
    face.selected = true;
    final offShot = Shot(dummy, const Size(400, 400), [face]);
    expect(
      await prefs.recordExport(
        offShot,
        enabled: true,
        offClasses: const {'face'},
      ),
      isFalse,
    );
    expect(prefs.offsets, isEmpty);

    // Clamp at maxDelta (+0.20).
    for (var i = 0; i < 20; i++) {
      final b = det('phone', 0.55, selected: true)..selected = false;
      await prefs.recordExport(
        Shot(dummy, const Size(400, 400), [b]),
        enabled: true,
        offClasses: const {},
      );
    }
    expect(prefs.offsets['phone'], closeTo(AdaptivePrefs.maxDelta, 1e-4));

    // Keeping pre-selected boxes decays positive offset once per export.
    final kept = [
      det('phone', 0.90, selected: true),
      det('phone', 0.92, selected: true),
      det('phone', 0.95, selected: true),
    ];
    await prefs.recordExport(
      Shot(dummy, const Size(400, 400), kept),
      enabled: true,
      offClasses: const {},
    );
    expect(
      prefs.offsets['phone'],
      closeTo(AdaptivePrefs.maxDelta * AdaptivePrefs.keepDecay, 1e-4),
    );

    // When disabled, apply restores raw model selection.
    final b = det('phone', 0.55, selected: true);
    prefs.apply(
      Shot(dummy, const Size(400, 400), [b]),
      enabled: false,
      offClasses: const {},
      baseThresholds: const {'phone': 0.50},
    );
    expect(b.selected, isTrue);

    // Reset clears everything.
    await prefs.reset();
    expect(prefs.offsets, isEmpty);
    expect(stored, '{}');
  });

  test('scales base threshold by ThresholdPreset including built-in face=0.70', () {
    final prefs = AdaptivePrefs(read: () => '{"phone": 0.10, "face": 0.08}');
    // High preset: phone 0.50 * 4/3 = 0.6667; + 0.10 = 0.7667.
    final phone = det('phone', 0.72, selected: true);
    // Medium preset with face=0.70 from ModelInfo.selectThresholds: 0.70 + 0.08 = 0.78.
    final face = det('face', 0.75, selected: true);

    prefs.apply(
      Shot(dummy, const Size(400, 400), [phone]),
      enabled: true,
      offClasses: const {},
      preset: ThresholdPreset.high,
      baseThresholds: const {'phone': 0.50, 'face': 0.70},
    );
    expect(phone.selected, isFalse);

    prefs.apply(
      Shot(dummy, const Size(400, 400), [face]),
      enabled: true,
      offClasses: const {},
      preset: ThresholdPreset.medium,
      baseThresholds: const {'phone': 0.50, 'face': 0.70},
    );
    expect(face.selected, isFalse);
  });
}

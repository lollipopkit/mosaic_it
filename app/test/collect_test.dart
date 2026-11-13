import 'dart:io';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unseen/src/boxes.dart';
import 'package:unseen/src/collect.dart';
import 'package:unseen/src/rust/api.dart';

void main() {
  test('sample records boxes with origin, initial and final state', () {
    final detected = EditBox.fromRegion(
      const Region(
        className: 'phone',
        score: 0.4,
        state: RegionState.review,
        rect: PixelRect(left: 10, top: 20, right: 110, bottom: 40),
      ),
    );
    final rejected = EditBox.fromRegion(
      const Region(
        className: 'person_name',
        score: 0.9,
        state: RegionState.selected,
        rect: PixelRect(left: 0, top: 0, right: 50, bottom: 10),
      ),
    );
    final drawn = EditBox(
      rect: const Rect.fromLTWH(5, 60, 30, 10),
      className: manualClass,
      selected: true,
      source: BoxSource.drawn,
    )..group = 3;
    final shot = Shot(File('/x/IMG_1.png'), const Size(200, 100), [
      detected,
      rejected,
      drawn,
    ]);
    detected.selected = true;
    detected.className = 'email';
    rejected.selected = false;

    final j = Collector.sampleJson(
      shot,
      id: 'ab12',
      imageFile: 'images/ab12.png',
      export: ExportContext(
        model: const ModelInfo(
          classes: ['person_name', 'phone', 'email'],
          backend: 'cpu',
          verified: false,
        ),
        hashes: const ModelHashes(model: 'aa', sidecar: 'bb'),
        fill: Fill(style: FillStyle.solid, color: 0, seed: BigInt.zero),
        forced: true,
        outcome: ExportOutcome(
          written: true,
          surviving: const [],
          correlated: Uint32List.fromList([1]),
        ),
      ),
    );

    expect(j['id'], 'ab12');
    expect(j['mode'], 'export');
    expect(j['image'], {
      'file': 'images/ab12.png',
      'width': 200.0,
      'height': 100.0,
      'camera_photo': false,
    });
    expect((j['model'] as Map)['blake3'], 'aa');
    expect((j['model'] as Map)['sidecar_blake3'], 'bb');
    expect(j['export'], {
      'fill': 'solid',
      'forced': true,
      'surviving': <Object>[],
      'correlated': [1],
    });
    final boxes = (j['boxes'] as List).cast<Map<String, dynamic>>();
    expect(boxes[0], {
      'bbox': [10.0, 20.0, 100.0, 20.0],
      'class': 'email',
      'initial_class': 'phone',
      'initial_bbox': [10.0, 20.0, 100.0, 20.0],
      'score': 0.4,
      'review': true,
      'source': 'detector',
      'initial_selected': false,
      'selected': true,
    });
    expect(boxes[1]['initial_selected'], isTrue);
    expect(boxes[1]['selected'], isFalse);
    expect(boxes[2]['source'], 'drawn');
    expect(boxes[2]['group'], 3);
    expect(boxes[0].containsKey('group'), isFalse);
    expect(boxes[2]['score'], isNull);
  });

  test('annotation records hold the drawn boxes and no model', () {
    final shot = Shot(File('/x/a.jpg'), const Size(10, 10), [
      EditBox(
        rect: const Rect.fromLTWH(1, 2, 3, 4),
        className: 'address',
        selected: true,
        source: BoxSource.drawn,
      ),
    ]);
    final j = Collector.sampleJson(shot, id: 'cd', imageFile: 'images/cd.jpg');
    expect(j['mode'], 'annotate');
    expect(j.containsKey('model'), isFalse);
    expect(j.containsKey('export'), isFalse);
    expect((j['boxes'] as List).single, containsPair('class', 'address'));
  });

  group('stored samples', () {
    late Directory d;
    setUp(() {
      d = Directory.systemTemp.createTempSync('collected');
      Collector.testDir = d;
      Directory('${d.path}/images').createSync();
      for (final id in ['a', 'b']) {
        File('${d.path}/images/$id.png').writeAsStringSync(id);
      }
      String rec(String id, String mode, String status) =>
          '{"id":"$id","mode":"$mode","status":"$status",'
          '"image":{"file":"images/$id.png"},"boxes":[]}';
      File('${d.path}/samples.jsonl').writeAsStringSync(
        [
          rec('a', 'annotate', 'skipped'),
          rec('b', 'export', 'labeled'),
          '{"id":"cut',
          rec('a', 'annotate', 'labeled'),
        ].join('\n'),
      );
    });
    tearDown(() {
      Collector.testDir = null;
      d.deleteSync(recursive: true);
    });

    test('the latest record per image wins; a cut line is skipped', () async {
      final s = await Collector.samples();
      expect([for (final r in s) r['id']], ['a', 'b']);
      expect(s.first['status'], 'labeled');
      expect((await Collector.stats()).$1, 2);
    });

    test('removeWhere drops every record and the image of a match', () async {
      await Collector.removeWhere((r) => r['mode'] == 'annotate');
      expect([for (final r in await Collector.samples()) r['id']], ['b']);
      expect(File('${d.path}/images/a.png').existsSync(), isFalse);
      expect(File('${d.path}/images/b.png').existsSync(), isTrue);
    });
  });
}

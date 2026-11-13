import 'dart:convert';
import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unseen/src/label_set.dart';

Map<String, dynamic> coco() => {
  'info': {'description': 'unseen pseudo-labels'},
  'categories': [
    {'id': 0, 'name': 'person_name'},
    {'id': 2, 'name': 'phone'},
  ],
  'images': [
    {
      'id': 0,
      'file_name': 'a.png',
      'width': 100,
      'height': 200,
      'review': true,
    },
    {
      'id': 1,
      'file_name': 'b.png',
      'width': 100,
      'height': 200,
      'review': true,
    },
  ],
  'annotations': [
    {
      'id': 0,
      'image_id': 0,
      'category_id': 2,
      'bbox': [0, 0, 50, 10],
      'source': 'yolo',
      'score': 0.9,
    },
    {
      'id': 1,
      'image_id': 0,
      'category_id': 0,
      'bbox': [0, 20, 50, 10],
      'source': 'vlm',
      'review': 'detector_missed',
    },
    {
      'id': 2,
      'image_id': 1,
      'category_id': 2,
      'bbox': [0, 0, 50, 10],
      'source': 'yolo',
      'review': 'vlm_missed',
    },
  ],
};

void main() {
  final file = File('/labels/coco.json');

  test('reads shots, classes and review flags', () {
    final set = LabelSet.fromJson(file, coco());
    expect(set.classes, ['person_name', 'phone']);
    expect(set.shots.map((s) => s.image.path), [
      '/labels/a.png',
      '/labels/b.png',
    ]);
    final [ok, flagged] = set.shots[0].boxes;
    expect((ok.selected, ok.review, ok.score), (true, false, 0.9));
    expect((flagged.selected, flagged.review), (false, true));
    expect(set.needsReview(set.shots[0]), isTrue);
    // b.png has no flagged boxes but nobody checked it yet.
    expect(set.needsReview(set.shots[1]), isTrue);
  });

  test('untouched round trip keeps annotations and pending reviews', () {
    final json = LabelSet.fromJson(file, coco()).toJson();
    expect(jsonEncode(json['annotations']), jsonEncode(coco()['annotations']));
    expect([for (final im in json['images']) im['review']], [true, true]);
  });

  test('verified image keeps selected boxes, edits become human', () {
    final set = LabelSet.fromJson(file, coco());
    final shot = set.shots[0];
    final [ok, flagged] = shot.boxes;
    ok.rect = const Rect.fromLTWH(1, 0, 50, 10);
    flagged
      ..selected = true
      ..className = 'phone';
    set.shots[1].boxes.single.selected = true;
    set.verify(shot);
    final json = set.toJson();
    final anns = json['annotations'] as List;
    expect(anns, hasLength(3));
    expect(anns[0], {
      'id': 0,
      'image_id': 0,
      'category_id': 2,
      'bbox': [1.0, 0.0, 50.0, 10.0],
      'area': 500.0,
      'iscrowd': 0,
      'source': 'human',
    });
    expect((anns[1]['source'], anns[1]['category_id']), ('human', 2));
    // Accepted on an unverified image: keeps its source, loses the flag.
    expect((anns[2]['source'], anns[2].containsKey('review')), ('yolo', false));
    final images = json['images'] as List;
    expect((images[0]['verified'], images[0]['review']), (true, false));
    expect((images[1]['verified'], images[1]['review']), (null, false));
  });

  test('deselected boxes are dropped once verified', () {
    final set = LabelSet.fromJson(file, coco());
    set.shots[0].boxes[0].selected = false;
    set.verify(set.shots[0]);
    final anns = set.toJson()['annotations'] as List;
    expect([for (final a in anns) a['image_id']], [1]);
    expect(set.needsReview(set.shots[0]), isFalse);
  });

  test('save writes atomically', () async {
    final dir = await Directory.systemTemp.createTemp('labels');
    addTearDown(() => dir.delete(recursive: true));
    final f = File('${dir.path}/coco.json')
      ..writeAsStringSync(jsonEncode(coco()));
    final set = await LabelSet.open(f);
    set.verify(set.shots[1]);
    await set.save();
    expect(File('${f.path}.tmp').existsSync(), isFalse);
    final again = await LabelSet.open(f);
    expect(again.verified(again.shots[1]), isTrue);
    expect(again.shots[1].boxes, isEmpty);
  });
}

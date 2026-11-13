import 'dart:convert';
import 'dart:io';

import 'package:flutter/painting.dart';

import 'boxes.dart';

/// A COCO file of pseudo-labels under human
/// review. Selected boxes are kept; boxes flagged `review` start unselected.
///
/// Saving keeps each untouched annotation as read (its `source`), writes
/// moved, re-classed or drawn boxes with `source: "human"`, and drops
/// deselected boxes. A verified image keeps only selected boxes and gets
/// `verified: true`; other images keep their pending review boxes.
class LabelSet {
  LabelSet._(this.file, this._json, this._ids, this.shots, this._images);

  final File file;
  final Map<String, dynamic> _json;

  /// Category ids by name.
  final Map<String, int> _ids;
  List<String> get classes => _ids.keys.toList();
  final List<Shot> shots;
  final Map<Shot, Map<String, dynamic>> _images;

  static Future<LabelSet> open(File file) async =>
      fromJson(file, jsonDecode(await file.readAsString()));

  static LabelSet fromJson(File file, Map<String, dynamic> json) {
    final cats = {
      for (final c in json['categories'] as List)
        c['id'] as int: c['name'] as String,
    };
    final byImage = <int, List<Map<String, dynamic>>>{};
    for (final a
        in (json['annotations'] as List).cast<Map<String, dynamic>>()) {
      byImage.putIfAbsent(a['image_id'] as int, () => []).add(a);
    }
    final shots = <Shot>[];
    final images = <Shot, Map<String, dynamic>>{};
    for (final im in (json['images'] as List).cast<Map<String, dynamic>>()) {
      final shot = Shot(
        File('${file.parent.path}/${im['file_name']}'),
        Size((im['width'] as num).toDouble(), (im['height'] as num).toDouble()),
        [
          for (final a in byImage[im['id']] ?? const <Map<String, dynamic>>[])
            EditBox(
              rect: _rect(a['bbox'] as List),
              className: cats[a['category_id']]!,
              score: (a['score'] as num?)?.toDouble(),
              selected: a['review'] == null,
              review: a['review'] != null,
              source: BoxSource.label,
              origin: a,
            ),
        ],
      );
      shots.add(shot);
      images[shot] = im;
    }
    return LabelSet._(
      file,
      json,
      {for (final MapEntry(:key, :value) in cats.entries) value: key},
      shots,
      images,
    );
  }

  static Rect _rect(List b) {
    final [x, y, w, h] = [for (final v in b) (v as num).toDouble()];
    return Rect.fromLTWH(x, y, w, h);
  }

  bool verified(Shot s) => _images[s]!['verified'] == true;

  /// Not yet checked by a person. Every image needs a pass, not only those
  /// with flagged boxes: pseudo-labels can miss regions without flagging
  /// anything.
  bool needsReview(Shot s) => !verified(s);

  void verify(Shot s) => _images[s]!['verified'] = true;

  Map<String, dynamic> toJson() {
    final anns = <Map<String, dynamic>>[];
    for (final shot in shots) {
      final im = _images[shot]!;
      final done = verified(shot);
      var pending = false;
      for (final b in shot.boxes) {
        // A deselected box is rejected, except a pending review box on an
        // image nobody verified yet.
        if (!b.selected && !(b.review && !done)) continue;
        final o = b.origin;
        final untouched =
            o != null &&
            _rect(o['bbox'] as List) == b.rect &&
            o['category_id'] == _ids[b.className];
        final a = untouched
            ? (Map.of(o)..remove('id'))
            : <String, dynamic>{
                'image_id': im['id'],
                'category_id': _ids[b.className],
                'bbox': [b.rect.left, b.rect.top, b.rect.width, b.rect.height],
                'area': b.rect.width * b.rect.height,
                'iscrowd': 0,
                'source': 'human',
              };
        if (b.selected) a.remove('review');
        pending |= a['review'] != null;
        anns.add({'id': anns.length, ...a});
      }
      im['review'] = pending;
    }
    return {..._json, 'annotations': anns};
  }

  /// Writes atomically, so an interrupted save leaves the old file.
  Future<void> save() async {
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode(toJson()));
    await tmp.rename(file.path);
  }
}

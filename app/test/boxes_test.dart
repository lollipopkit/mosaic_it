import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unseen/src/boxes.dart';

void main() {
  test('mergeFound selects covered boxes and adds the rest', () {
    final covered = EditBox(
      rect: const Rect.fromLTRB(0, 0, 100, 20),
      className: 'phone',
      score: 0.2,
      selected: false,
      source: BoxSource.detector,
    );
    final boxes = [covered];
    final added = mergeFound(boxes, const [
      Rect.fromLTRB(2, 1, 101, 21),
      Rect.fromLTRB(0, 200, 100, 220),
    ], 'phone');
    expect(added, 1);
    expect(covered.selected, isTrue);
    expect(boxes, hasLength(2));
    expect(boxes.last.manual, isTrue);
    expect(boxes.last.source, BoxSource.found);
    expect(covered.initialSelected, isFalse);
    expect(boxes.last.className, 'phone');
  });

  test('iou', () {
    expect(
      iou(const Rect.fromLTRB(0, 0, 10, 10), const Rect.fromLTRB(0, 0, 10, 10)),
      1,
    );
    expect(
      iou(
        const Rect.fromLTRB(0, 0, 10, 10),
        const Rect.fromLTRB(20, 20, 30, 30),
      ),
      0,
    );
    expect(
      iou(const Rect.fromLTRB(0, 0, 10, 10), const Rect.fromLTRB(5, 0, 15, 10)),
      closeTo(1 / 3, 1e-9),
    );
  });
}

import 'package:material_ui/material_ui.dart';

import 'boxes.dart';

/// A batch of opened images under edit: which one is shown, the box being
/// edited, and undo / redo of every change to boxes.
///
/// Callers mutate boxes between [record] and [changed]: [record] saves the
/// shot's boxes as they were, so [undo] can put them back.
class EditSession extends ChangeNotifier {
  EditSession(this.shots);

  final List<Shot> shots;
  int _index = 0;
  EditBox? _active;
  final _undo = <_Snapshot>[];
  final _redo = <_Snapshot>[];

  /// Snapshots kept per direction; older ones are dropped.
  static const historyLimit = 100;

  int get index => _index;
  Shot get shot => shots[_index];

  set index(int i) {
    if (i == _index) return;
    _index = i;
    _active = null;
    notifyListeners();
  }

  /// The box being moved, resized or re-classed; drawn with handles.
  EditBox? get active => _active;
  set active(EditBox? b) {
    if (b == _active) return;
    _active = b;
    notifyListeners();
  }

  /// Boxes changed: redraw everything that shows them.
  void changed() => notifyListeners();

  bool get canUndo => _undo.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;

  /// Saves [shot]'s boxes (defaults to the current one) before a change.
  void record([Shot? shot]) {
    _undo.add(_Snapshot.of(shot ?? this.shot));
    if (_undo.length > historyLimit) _undo.removeAt(0);
    _redo.clear();
  }

  void undo() => _swap(_undo, _redo);
  void redo() => _swap(_redo, _undo);

  void _swap(List<_Snapshot> from, List<_Snapshot> to) {
    if (from.isEmpty) return;
    final s = from.removeLast();
    to.add(_Snapshot.of(s.shot));
    s.restore();
    _index = shots.indexOf(s.shot);
    if (!s.shot.boxes.contains(_active)) _active = null;
    notifyListeners();
  }

  /// [b] and the boxes of the same value (its group) in the shown shot.
  List<EditBox> groupOf(EditBox b) => b.group == null
      ? [b]
      : [
          for (final x in shot.boxes)
            if (x.group == b.group) x,
        ];

  /// Makes [b] (and its group) part of [a]'s value: one group, [a]'s class,
  /// all selected. Recorded for undo.
  void merge(EditBox a, EditBox b) {
    if (groupOf(a).contains(b)) return;
    record();
    final id =
        a.group ??
        b.group ??
        shot.boxes.fold<int>(
          0,
          (m, x) => x.group != null && x.group! >= m ? x.group! + 1 : m,
        );
    for (final x in [...groupOf(a), ...groupOf(b)]) {
      x
        ..group = id
        ..className = a.className
        ..selected = true;
    }
    changed();
  }

  /// Gives [b]'s value class [c] and selects it. Recorded for undo.
  void reclass(EditBox b, String c) {
    final parts = groupOf(b);
    if (parts.every((x) => x.className == c && x.selected)) return;
    record();
    for (final x in parts) {
      x
        ..className = c
        ..selected = true;
    }
    changed();
  }

  /// Deletes [b]'s value (every line of it). Recorded for undo.
  void remove(EditBox b) {
    record();
    final parts = groupOf(b);
    shot.boxes.removeWhere(parts.contains);
    if (parts.contains(_active)) _active = null;
    changed();
  }

  /// Makes every box of [b]'s value a value of its own. Recorded for undo.
  void split(EditBox b) {
    if (b.group == null) return;
    record();
    for (final x in groupOf(b)) {
      x.group = null;
    }
    changed();
  }

  /// Selected boxes across the batch.
  int get selectedCount =>
      shots.fold(0, (n, s) => n + s.boxes.where((b) => b.selected).length);
}

/// One shot's boxes and their mutable state at one moment.
class _Snapshot {
  _Snapshot.of(this.shot)
    : _boxes = [
        for (final b in shot.boxes)
          (b, b.rect, b.className, b.selected, b.group),
      ];

  final Shot shot;
  final List<(EditBox, Rect, String, bool, int?)> _boxes;

  void restore() {
    shot.boxes = [
      for (final (b, rect, cls, sel, group) in _boxes)
        b
          ..rect = rect
          ..className = cls
          ..selected = sel
          ..group = group,
    ];
  }
}

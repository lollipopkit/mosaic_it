import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/l10n/app_localizations.dart';
import 'package:unseen/src/boxes.dart';
import 'package:unseen/src/edit_session.dart';
import 'package:unseen/src/editor.dart';

void main() {
  // A 1x1 PNG; the editor scales it to the declared image size, which equals
  // the 400x400 viewport, so image and screen coordinates coincide.
  final png =
      File('${Directory.systemTemp.createTempSync('unseen').path}/blank.png')
        ..writeAsBytesSync(
          base64Decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4//8/AAX+Av6nNYGEAAAAAElFTkSuQmCC',
          ),
        );

  EditBox box(Rect r, {bool selected = true, String cls = 'phone'}) => EditBox(
    rect: r,
    className: cls,
    score: 0.5,
    selected: selected,
    source: BoxSource.detector,
  );

  Future<EditSession> pump(
    WidgetTester t,
    List<EditBox> boxes, {
    EditorKind kind = EditorKind.redact,
    bool drawing = false,
    List<EditBox> hidden = const [],
  }) async {
    final s = EditSession([
      Shot(png, const Size(400, 400), boxes, hidden: hidden),
    ]);
    await t.binding.setSurfaceSize(const Size(400, 400));
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SizedBox(
          width: 400,
          height: 400,
          child: BoxEditor(session: s, kind: kind, drawing: drawing),
        ),
      ),
    );
    return s;
  }

  testWidgets('tap toggles the smallest box under the pointer', (t) async {
    final outer = box(const Rect.fromLTRB(0, 0, 300, 300));
    final inner = box(const Rect.fromLTRB(100, 100, 150, 150), selected: false);
    final s = await pump(t, [outer, inner]);
    await t.tapAt(const Offset(120, 120));
    expect(inner.selected, isTrue);
    expect(outer.selected, isTrue);
    await t.tapAt(const Offset(250, 250));
    expect(outer.selected, isFalse);
    s.undo();
    expect(outer.selected, isTrue);
    s.redo();
    expect(outer.selected, isFalse);
  });

  testWidgets(
    'tapping a hidden detection adds it selected, also in draw mode',
    (t) async {
      final low = box(const Rect.fromLTRB(100, 100, 200, 140), selected: false);
      final s = await pump(t, [], hidden: [low], drawing: true);
      await t.tapAt(const Offset(300, 300));
      expect(s.shot.boxes, isEmpty);
      await t.tapAt(const Offset(150, 120));
      final added = s.shot.boxes.single;
      expect(added.selected, isTrue);
      expect(added.rect, low.rect);
      expect(added.source, BoxSource.tapped);
      // A second tap takes it away; undo and a new tap bring it back.
      await t.tapAt(const Offset(150, 120));
      expect(s.shot.boxes, isEmpty);
      s.undo();
      expect(s.shot.boxes.single.selected, isTrue);
      s.undo();
      expect(s.shot.boxes, isEmpty);
      await t.tapAt(const Offset(150, 120));
      expect(s.shot.boxes.single.selected, isTrue);
      expect(low.selected, isFalse);
    },
  );

  testWidgets('drawing adds a selected drawn box', (t) async {
    final s = await pump(t, [], drawing: true);
    await t.dragFrom(const Offset(50, 50), const Offset(100, 60));
    await t.pump();
    final b = s.shot.boxes.single;
    expect(b.source, BoxSource.drawn);
    expect(b.selected, isTrue);
    expect(b.rect.width, greaterThan(50));
    s.undo();
    expect(s.shot.boxes, isEmpty);
  });

  testWidgets('the active box moves with a drag and resizes by a corner', (
    t,
  ) async {
    final b = box(const Rect.fromLTRB(100, 100, 200, 140));
    final s = await pump(t, [b]);
    s.active = b;
    await t.pump();
    await t.dragFrom(const Offset(150, 120), const Offset(40, 20));
    await t.pump();
    expect(b.rect.left, closeTo(140, 1));
    expect(b.rect.top, closeTo(120, 1));
    expect(b.rect.size, const Size(100, 40));
    expect(b.initialRect, const Rect.fromLTRB(100, 100, 200, 140));

    // Bottom-right corner (240, 160) pulled out: the top-left stays.
    await t.dragFrom(const Offset(240, 160), const Offset(60, 30));
    await t.pump();
    expect(b.rect.topLeft, const Offset(140, 120));
    expect(b.rect.right, closeTo(300, 1));
    expect(b.rect.bottom, closeTo(190, 1));

    s.undo();
    s.undo();
    expect(b.rect, const Rect.fromLTRB(100, 100, 200, 140));
  });

  testWidgets(
    'annotating: tapping a suggestion accepts it and makes it active',
    (t) async {
      final suggestion = box(
        const Rect.fromLTRB(20, 20, 120, 60),
        selected: false,
        cls: 'address',
      );
      final s = await pump(t, [suggestion], kind: EditorKind.annotate);
      await t.tapAt(const Offset(60, 40));
      expect(suggestion.selected, isTrue);
      expect(s.active, same(suggestion));
    },
  );

  testWidgets('one finger on empty space pans the view', (t) async {
    final b = box(const Rect.fromLTRB(100, 100, 150, 150), selected: false);
    await pump(t, [b]);
    await t.dragFrom(const Offset(300, 300), const Offset(-50, -50));
    await t.pump();
    expect(b.rect, const Rect.fromLTRB(100, 100, 150, 150));
    // The box now shows 50 px up and left.
    await t.tapAt(const Offset(75, 75));
    expect(b.selected, isTrue);
  });

  test('merge makes one value; class, delete and split act on all of it', () {
    final a = box(const Rect.fromLTRB(0, 0, 40, 10), cls: 'person_name');
    final b = box(const Rect.fromLTRB(0, 12, 20, 22), selected: false);
    final c = box(const Rect.fromLTRB(0, 24, 30, 34));
    final s = EditSession([
      Shot(png, const Size(100, 100), [a, b, c]),
    ]);
    s.merge(a, b);
    s.merge(b, c);
    expect(s.groupOf(c), [a, b, c]);
    expect(
      {
        for (final x in [a, b, c]) x.className,
      },
      {'person_name'},
    );
    expect(b.selected, isTrue);

    s.reclass(c, 'address');
    expect(
      {
        for (final x in [a, b, c]) x.className,
      },
      {'address'},
    );

    s.split(a);
    expect([a.group, b.group, c.group], [null, null, null]);
    s.undo();
    expect(s.groupOf(a), [a, b, c]);

    s.remove(b);
    expect(s.shot.boxes, isEmpty);
    s.undo();
    expect(s.shot.boxes, [a, b, c]);
    s.undo();
    s.undo();
    s.undo();
    expect([a.group, b.group, c.group], [null, null, null]);
    expect(a.className, 'person_name');
  });

  testWidgets('tapping one line of a merged value toggles every line', (
    t,
  ) async {
    final a = box(const Rect.fromLTRB(100, 100, 200, 120));
    final b = box(const Rect.fromLTRB(100, 130, 160, 150));
    final s = await pump(t, [a, b]);
    s.merge(a, b);
    await t.tapAt(const Offset(120, 140));
    expect([a.selected, b.selected], [false, false]);
  });

  testWidgets('picking a merge target taps through to the callback', (t) async {
    final a = box(const Rect.fromLTRB(100, 100, 200, 120));
    final b = box(const Rect.fromLTRB(100, 130, 160, 150));
    final s = EditSession([
      Shot(png, const Size(400, 400), [a, b]),
    ]);
    final picked = <EditBox?>[];
    await t.binding.setSurfaceSize(const Size(400, 400));
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SizedBox(
          width: 400,
          height: 400,
          child: BoxEditor(
            session: s,
            kind: EditorKind.annotate,
            merging: true,
            mergeFrom: a,
            onMergePick: picked.add,
          ),
        ),
      ),
    );
    await t.tapAt(const Offset(120, 140));
    await t.tapAt(const Offset(350, 350));
    expect(picked, [b, null]);
    // Picking does not select or activate.
    expect(s.active, isNull);
  });

  test('history is capped and redo clears on a new change', () {
    final b = box(Rect.zero);
    final s = EditSession([
      Shot(png, const Size(10, 10), [b]),
    ]);
    for (var i = 0; i < EditSession.historyLimit + 5; i++) {
      s.record();
      b.selected = !b.selected;
    }
    var undone = 0;
    while (s.canUndo) {
      s.undo();
      undone++;
    }
    expect(undone, EditSession.historyLimit);
    expect(s.canRedo, isTrue);
    s.record();
    expect(s.canRedo, isFalse);
  });
}

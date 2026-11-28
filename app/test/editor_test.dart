import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart' show ScreenEdge, SystemBars;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/l10n/app_localizations.dart';
import 'package:unseen/src/boxes.dart';
import 'package:unseen/src/edit_session.dart';
import 'package:unseen/src/editor.dart';
import 'package:unseen/src/editor_page.dart';
import 'package:unseen/src/rust/api.dart';
import 'package:unseen/src/settings.dart';

class _FakeSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  tearDown(() => SystemBars.debugBars = const {});

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
          child: BoxEditor(session: s, drawing: drawing),
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

  testWidgets('a resized viewport refits the image', (t) async {
    final b = box(const Rect.fromLTRB(0, 0, 50, 50), selected: false);
    final s = EditSession([
      Shot(png, const Size(400, 400), [b]),
    ]);
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.binding.setSurfaceSize(const Size(400, 400));
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BoxEditor(session: s, drawing: false),
      ),
    );
    // Unfolded or rotated: the image is centred in the wider screen.
    await t.binding.setSurfaceSize(const Size(800, 400));
    await t.pump();
    await t.tapAt(const Offset(25, 25));
    expect(b.selected, isFalse);
    await t.tapAt(const Offset(225, 25));
    expect(b.selected, isTrue);
  });

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

  Future<void> pumpWide(
    WidgetTester t,
    EdgeInsets padding, {
    Size size = const Size(900, 420),
  }) async {
    const info = ModelInfo(
      classes: ['phone'],
      backend: 'CPU',
      selectThresholds: {'phone': 0.5},
      verified: false,
    );
    await t.binding.setSurfaceSize(size);
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: size, padding: padding),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EditorPage(
            shots: [
              for (var i = 0; i < 3; i++)
                Shot(png, const Size(400, 800), [
                  box(const Rect.fromLTRB(10, 10, 100, 60)),
                ]),
            ],
            settings: AppSettings(fillStyle: FillStyle.solid, fillColor: 0),
            model: _FakeSession(),
            info: info,
          ),
        ),
      ),
    );
    await t.pump();
    expect(t.takeException(), isNull);
  }

  testWidgets(
    'a view wider than tall puts the bars and strip beside the image',
    (t) async {
      await pumpWide(t, const EdgeInsets.symmetric(horizontal: 40));
      final add = t.getCenter(find.byIcon(Icons.add_photo_alternate_outlined));
      final export = t.getCenter(find.byIcon(Icons.ios_share));
      final draw = t.getCenter(find.byIcon(Icons.highlight_alt));
      final feedback = t.getCenter(find.byIcon(Icons.flag_outlined));
      final strip = t.getRect(find.byType(BatchStrip));
      // Actions run down the left edge, tools down the right one, both clear
      // of the insets.
      expect(add.dx, inInclusiveRange(40, 100));
      expect(add.dy, lessThan(100));
      expect(export.dx, add.dx);
      expect(export.dy, greaterThan(210));
      expect(draw.dx, inInclusiveRange(800, 860));
      expect(feedback.dx, draw.dx);
      expect(feedback.dy, greaterThan(draw.dy));
      // The batch strip stands next to the actions.
      expect(strip.left, greaterThanOrEqualTo(100));
      expect(strip.height, greaterThan(strip.width));
    },
  );

  testWidgets('a status bar column on one side takes the actions', (t) async {
    SystemBars.debugBars = const {
      ScreenEdge.left: Rect.fromLTRB(18, 12, 62, 408),
      ScreenEdge.right: Rect.fromLTRB(833, 60, 877, 360),
      ScreenEdge.top: Rect.fromLTRB(12, 8, 798, 52),
      ScreenEdge.bottom: Rect.fromLTRB(8, 364, 802, 408),
    };
    await pumpWide(t, const EdgeInsets.only(right: 90));
    final add = t.getCenter(find.byIcon(Icons.add_photo_alternate_outlined));
    final export = t.getCenter(find.byIcon(Icons.ios_share));
    final draw = t.getCenter(find.byIcon(Icons.highlight_alt));
    final strip = t.getRect(find.byType(BatchStrip));
    // Inside the column, in its middle, clear of what sits at its ends.
    expect(add.dx, greaterThan(810));
    expect((add.dy + export.dy) / 2, moreOrLessEquals(210, epsilon: 2));
    expect(export.dx, add.dx);
    expect(draw.dx, lessThan(90));
    // The strip stands just inside the actions.
    expect(strip.right, lessThanOrEqualTo(add.dx - 22));
  });

  testWidgets('upright, the actions run down a status bar column', (t) async {
    SystemBars.debugBars = const {
      ScreenEdge.left: Rect.fromLTRB(18, 12, 62, 666),
      ScreenEdge.right: Rect.fromLTRB(399, 60, 443, 618),
      ScreenEdge.top: Rect.fromLTRB(12, 8, 364, 52),
      ScreenEdge.bottom: Rect.fromLTRB(8, 622, 368, 666),
    };
    await pumpWide(
      t,
      const EdgeInsets.only(right: 90),
      size: const Size(466, 678),
    );
    final add = t.getCenter(find.byIcon(Icons.add_photo_alternate_outlined));
    final export = t.getCenter(find.byIcon(Icons.ios_share));
    final draw = t.getCenter(find.byIcon(Icons.highlight_alt));
    final regions = t.getCenter(find.byIcon(Icons.tune));
    expect(add.dx, greaterThan(376));
    expect(export.dx, add.dx);
    expect(export.dy, greaterThan(add.dy));
    // The tools and the strip along the bottom stay out of the column.
    expect(find.byType(BatchStrip), findsOneWidget);
    expect(t.getRect(find.byType(BatchStrip)).right, lessThanOrEqualTo(376));
    expect(draw.dx, lessThan(376));
    expect(regions.dx, lessThan(376));
  });

  testWidgets(
    'uneven side insets without SystemBars do not enter a status bar column',
    (t) async {
      // Android 3-button nav bar on the right in landscape: no SystemBars.
      await pumpWide(t, const EdgeInsets.only(right: 60));
      final add = t.getCenter(find.byIcon(Icons.add_photo_alternate_outlined));
      final draw = t.getCenter(find.byIcon(Icons.highlight_alt));
      expect(add.dx, lessThan(100));
      expect(draw.dx, lessThan(900 - 60));

      // Portrait with uneven side inset also keeps actions horizontal at top.
      await pumpWide(
        t,
        const EdgeInsets.only(right: 60),
        size: const Size(466, 678),
      );
      final addP = t.getCenter(find.byIcon(Icons.add_photo_alternate_outlined));
      final exportP = t.getCenter(find.byIcon(Icons.ios_share));
      expect(addP.dy, moreOrLessEquals(exportP.dy, epsilon: 2));
      expect(exportP.dx, lessThan(466 - 60));
    },
  );

  testWidgets('wide toolbar fits a short 900x340 viewport without overflow', (
    t,
  ) async {
    await pumpWide(
      t,
      const EdgeInsets.fromLTRB(40, 0, 40, 21),
      size: const Size(900, 340),
    );
    final fill = t.getRect(find.byTooltip('Fill style'));
    final draw = t.getRect(find.byIcon(Icons.highlight_alt));
    final feedback = t.getRect(find.byIcon(Icons.flag_outlined));
    final regions = t.getRect(find.byIcon(Icons.tune));
    expect(fill.top, greaterThanOrEqualTo(0));
    expect(draw.top, greaterThanOrEqualTo(fill.bottom));
    expect(feedback.top, greaterThan(draw.bottom));
    expect(regions.bottom, lessThanOrEqualTo(340));
  });

  testWidgets(
    'stale SystemBars on rotation transition and tiny viewports do not throw',
    (t) async {
      // Stale portrait Duo bars arriving on a landscape frame must be ignored.
      SystemBars.debugBars = const {
        ScreenEdge.right: Rect.fromLTRB(399, 60, 443, 618),
        ScreenEdge.bottom: Rect.fromLTRB(8, 622, 368, 666),
      };
      await pumpWide(
        t,
        const EdgeInsets.only(right: 90),
        size: const Size(678, 466),
      );
      // Tiny viewport with large insets must not produce negative dimensions.
      SystemBars.debugBars = const {};
      await pumpWide(t, const EdgeInsets.all(60), size: const Size(80, 80));
    },
  );

  testWidgets('ToolButton scales cleanly under 1.5x text scale', (t) async {
    const info = ModelInfo(
      classes: ['phone'],
      backend: 'CPU',
      selectThresholds: {'phone': 0.5},
      verified: false,
    );
    await t.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 640),
          textScaler: TextScaler.linear(1.5),
        ),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EditorPage(
            shots: [
              Shot(png, const Size(400, 400), [
                box(const Rect.fromLTRB(10, 10, 100, 60)),
              ]),
            ],
            settings: AppSettings(fillStyle: FillStyle.solid, fillColor: 0),
            model: _FakeSession(),
            info: info,
          ),
        ),
      ),
    );
    await t.pump();
    expect(t.takeException(), isNull);
  });

  testWidgets('fill sheet fits a short landscape viewport without overflow', (
    t,
  ) async {
    await t.binding.setSurfaceSize(const Size(678, 466));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(678, 466),
          padding: EdgeInsets.only(right: 90),
        ),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EditorPage(
            shots: const [],
            settings: AppSettings(fillStyle: FillStyle.solid, fillColor: 0),
            model: _FakeSession(),
          ),
        ),
      ),
    );
    await t.pump();
    await t.tap(find.byTooltip('Fill style'));
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(find.text('Noise'), findsOneWidget);
  });

  testWidgets(
    'EditorPage top bar fits 360dp width at 1.3x text scale and toggles peek',
    (t) async {
      final boxes = [
        box(const Rect.fromLTRB(10, 10, 100, 60)),
        box(const Rect.fromLTRB(120, 10, 200, 60), selected: false),
      ];
      final shot = Shot(png, const Size(400, 400), boxes);
      const info = ModelInfo(
        classes: ['phone', 'email'],
        backend: 'CPU',
        selectThresholds: {'phone': 0.5, 'email': 0.5},
        verified: false,
      );
      await t.binding.setSurfaceSize(const Size(360, 640));
      addTearDown(() => t.binding.setSurfaceSize(null));
      await t.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 640),
            textScaler: TextScaler.linear(1.3),
          ),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: EditorPage(
              shots: [shot],
              settings: AppSettings(
                fillStyle: FillStyle.solid,
                fillColor: 0x000000,
              ),
              model: _FakeSession(),
              info: info,
            ),
          ),
        ),
      );
      await t.pump();
      expect(t.takeException(), isNull);

      // Hold-to-peek swaps the icon, carries the selected-mask Badge, and releases cleanly.
      final peekFinder = find.byIcon(Icons.visibility_outlined);
      expect(peekFinder, findsOneWidget);
      final peekBadge = find.ancestor(
        of: peekFinder,
        matching: find.byType(Badge),
      );
      expect(peekBadge, findsOneWidget);
      expect(
        find.descendant(of: peekBadge, matching: find.text('1')),
        findsOneWidget,
      );
      final gesture = await t.startGesture(t.getCenter(peekFinder));
      await t.pump();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await gesture.up();
      await t.pump();
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add_photo_alternate_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    },
  );

  testWidgets(
    'EditorPage renders empty state with direct media picker button',
    (t) async {
      const info = ModelInfo(
        classes: ['phone', 'email'],
        backend: 'CPU',
        selectThresholds: {'phone': 0.5, 'email': 0.5},
        verified: false,
      );
      await t.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EditorPage(
            shots: const [],
            settings: AppSettings(
              fillStyle: FillStyle.solid,
              fillColor: 0x000000,
            ),
            model: _FakeSession(),
            info: info,
          ),
        ),
      );
      await t.pump();
      expect(t.takeException(), isNull);
      // Unified editor chrome is visible immediately, with the picker button on the canvas.
      expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add_photo_alternate_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
    },
  );
}

import 'dart:async';
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'boxes.dart';
import 'edit_session.dart';
import 'l10n.dart';
import 'rust/api.dart';

/// [patches] as images where they go, in image pixels.
Future<List<(Rect, ui.Image)>> decodePatches(List<PreviewPatch> patches) =>
    Future.wait(
      patches.map((p) async {
        final done = Completer<ui.Image>();
        ui.decodeImageFromPixels(
          p.rgba,
          p.width,
          p.height,
          ui.PixelFormat.rgba8888,
          done.complete,
        );
        return (
          Rect.fromLTWH(
            p.left.toDouble(),
            p.top.toDouble(),
            p.width.toDouble(),
            p.height.toDouble(),
          ),
          await done.future,
        );
      }),
    );

/// A dashed rectangle with [width] screen-pixel strokes; [px] is one screen
/// pixel in canvas units.
void drawDashedRect(
  Canvas canvas,
  Rect r,
  Color color,
  double px,
  double width,
) {
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width * px
    ..color = color;
  final dash = 5 * px;
  final gap = 3.5 * px;
  void line(Offset a, Offset b) {
    final len = (b - a).distance;
    if (len == 0) return;
    final dir = (b - a) / len;
    for (var t = 0.0; t < len; t += dash + gap) {
      final e = t + dash < len ? t + dash : len;
      canvas.drawLine(a + dir * t, a + dir * e, paint);
    }
  }

  line(r.topLeft, r.topRight);
  line(r.topRight, r.bottomRight);
  line(r.bottomRight, r.bottomLeft);
  line(r.bottomLeft, r.topLeft);
}

/// What the editor is for: redacting (detections, shown as they will be
/// hidden) or annotating (labelled boxes, shown in their class colours).
enum EditorKind { redact, annotate }

/// The shown image of [session] with its boxes.
///
/// - Tap: redact toggles a box; annotate makes it the active box (accepting
///   it when it is an unselected suggestion).
/// - Long press: makes the box active and calls [onLongPress] (its menu).
/// - Drag on the active box moves it, drag on a corner handle resizes it.
/// - With [drawing], a one-finger drag draws a box of [drawClass].
/// - Two fingers always zoom and pan.
class BoxEditor extends StatefulWidget {
  const BoxEditor({
    super.key,
    required this.session,
    required this.kind,
    this.drawing = false,
    this.drawClass = manualClass,
    this.fill,
    this.onLongPress,
    this.textLines = const [],
    this.onLineTap,
    this.merging = false,
    this.mergeFrom,
    this.onMergePick,
    this.fitPadding = EdgeInsets.zero,
  });

  /// Kept clear when the image is fitted: what floats over the editor. The
  /// image still pans under it.
  final EdgeInsets fitPadding;

  final EditSession session;
  final EditorKind kind;
  final bool drawing;

  /// Class of boxes drawn with [drawing].
  final String drawClass;

  /// How selected boxes will be hidden (redact); the editor shows exactly that.
  final Fill? fill;

  /// Called with the box and its rectangle on screen, for a menu beside it.
  final void Function(EditBox box, Rect onScreen)? onLongPress;

  /// Text lines found on the image (annotate): tapping one that no box covers
  /// calls [onLineTap] with its rectangle.
  final List<Rect> textLines;
  final ValueChanged<Rect>? onLineTap;

  /// The user picks boxes to merge: a tap on a box calls [onMergePick] with
  /// it instead of selecting it, a tap elsewhere with null (merging ends).
  final bool merging;

  /// The box the merge starts from, highlighted.
  final EditBox? mergeFrom;
  final ValueChanged<EditBox?>? onMergePick;

  @override
  State<BoxEditor> createState() => _BoxEditorState();
}

/// What a one-finger drag is doing.
sealed class _Grab {}

class _Move extends _Grab {
  _Move(this.box, this.start, this.from);
  final EditBox box;
  final Offset start;
  final Rect from;
}

class _Resize extends _Grab {
  _Resize(this.box, this.anchor);
  final EditBox box;

  /// The corner that stays put.
  final Offset anchor;
}

class _Draw extends _Grab {
  _Draw(this.start);
  final Offset start;
  Rect? rect;
}

class _BoxEditorState extends State<BoxEditor> {
  final _view = TransformationController();
  Size? _fittedFor;
  double _fitScale = 1;

  _Grab? _grab;
  bool _recorded = false;
  final _pointers = <int>{};

  /// Two or more fingers down: the view zooms and pans.
  bool get _multi => _pointers.length > 1;

  /// Redaction previews of the selected boxes, and what they were made for.
  List<(Rect, ui.Image)> _previews = [];
  String? _previewKey;
  Timer? _previewTimer;

  EditSession get _s => widget.session;
  Shot get _shot => _s.shot;
  Size get _size => _shot.size;

  /// Screen pixels around a handle that still grab it.
  static const _handleReach = 22.0;

  @override
  void initState() {
    super.initState();
    _s.addListener(_changed);
  }

  @override
  void didUpdateWidget(BoxEditor old) {
    super.didUpdateWidget(old);
    if (old.session != widget.session) {
      old.session.removeListener(_changed);
      widget.session.addListener(_changed);
    }
  }

  @override
  void dispose() {
    _s.removeListener(_changed);
    _view.dispose();
    _previewTimer?.cancel();
    for (final (_, im) in _previews) {
      im.dispose();
    }
    super.dispose();
  }

  void _changed() {
    if (_fittedFor != _size) _fittedFor = null;
    setState(() {});
  }

  double get _zoom => _view.value.getMaxScaleOnAxis();

  // --- previews -----------------------------------------------------------

  /// Schedules new previews when the selection or the fill changed. The old
  /// ones stay on screen until the new ones are decoded.
  void _refreshPreviews() {
    final f = widget.kind == EditorKind.redact ? widget.fill : null;
    final rects = [
      for (final b in _shot.boxes)
        if (b.selected) b.rect,
    ];
    final path = _shot.image.path;
    final key = f == null
        ? null
        : '$path ${f.style} ${f.color} ${f.seed} ${rects.join(';')}';
    if (key == _previewKey) return;
    _previewKey = key;
    _previewTimer?.cancel();
    if (f == null || rects.isEmpty) {
      _setPreviews([]);
      return;
    }
    _previewTimer = Timer(const Duration(milliseconds: 80), () async {
      final patches = await redactionPreview(
        imagePath: path,
        rects: [
          for (final r in rects)
            PixelRect(
              left: r.left,
              top: r.top,
              right: r.right,
              bottom: r.bottom,
            ),
        ],
        fill: f,
      );
      final next = await decodePatches(patches);
      if (!mounted || key != _previewKey) {
        for (final (_, im) in next) {
          im.dispose();
        }
        return;
      }
      _setPreviews(next);
    });
  }

  void _setPreviews(List<(Rect, ui.Image)> next) {
    final old = _previews;
    setState(() => _previews = next);
    for (final (_, im) in old) {
      im.dispose();
    }
  }

  // --- geometry -----------------------------------------------------------

  void _fit(Size viewport) {
    if (_fittedFor == _size) return;
    _fittedFor = _size;
    final pad = widget.fitPadding;
    final area = pad.deflateSize(viewport);
    final s = (area.width / _size.width).clamp(0.0, area.height / _size.height);
    final dx = pad.left + (area.width - _size.width * s) / 2;
    final dy = pad.top + (area.height - _size.height * s) / 2;
    _fitScale = s;
    _view.value = Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(s, s, s, 1);
  }

  static double _area(Rect r) => r.width * r.height;

  /// Smallest box under [p]: nested boxes stay reachable.
  /// The below-threshold detections to offer: not where a box already is
  /// (a weaker duplicate of it, or one a tap has added).
  List<EditBox> get _hiddenShown => [
    for (final h in _shot.hidden)
      if (!_covered(h.rect)) h,
  ];

  EditBox? _hit(Offset p, {List<EditBox>? among}) {
    EditBox? best;
    for (final b in among ?? _shot.boxes) {
      if (b.rect.contains(p) &&
          (best == null || _area(b.rect) < _area(best.rect))) {
        best = b;
      }
    }
    return best;
  }

  /// The corner of the active box near [p], as the opposite (fixed) corner.
  Offset? _handleAnchor(EditBox b, Offset p) {
    final reach = _handleReach / _zoom;
    final r = b.rect;
    for (final (c, anchor) in [
      (r.topLeft, r.bottomRight),
      (r.topRight, r.bottomLeft),
      (r.bottomLeft, r.topRight),
      (r.bottomRight, r.topLeft),
    ]) {
      if ((c - p).distance <= reach) return anchor;
    }
    return null;
  }

  Rect _clamp(Rect r) => r.intersect(Offset.zero & _size);

  // --- pointers -----------------------------------------------------------

  void _down(PointerDownEvent e) {
    _pointers.add(e.pointer);
    if (_multi) {
      // A second finger: zoom and pan instead of drawing or moving.
      _end(cancel: true);
      setState(() {});
      return;
    }
    final p = e.localPosition;
    final a = _s.active;
    _Grab? g;
    if (a != null) {
      final anchor = _handleAnchor(a, p);
      if (anchor != null) {
        g = _Resize(a, anchor);
      } else if (a.rect.contains(p)) {
        g = _Move(a, p, a.rect);
      }
    }
    if (g == null && widget.drawing) g = _Draw(p);
    if (g != null) {
      _recorded = false;
      setState(() => _grab = g);
    }
  }

  void _move(PointerMoveEvent e) {
    final g = _grab;
    if (_multi) return;
    if (g == null) {
      // One finger on nothing to grab moves the view. Done here, not by the
      // viewer, so a drag that starts on a box never pans first.
      if (!widget.drawing) {
        _view.value = Matrix4.translationValues(e.delta.dx, e.delta.dy, 0)
          ..multiply(_view.value);
      }
      return;
    }
    final p = e.localPosition;
    // Only a real change goes into the history; a tap does not.
    if (!_recorded && g is! _Draw) {
      _s.record();
      _recorded = true;
    }
    setState(() {
      switch (g) {
        case _Move(:final box, :final start, :final from):
          final r = from.shift(p - start);
          // Kept whole inside the image.
          final dx = r.left < 0
              ? -r.left
              : (r.right > _size.width ? _size.width - r.right : 0.0);
          final dy = r.top < 0
              ? -r.top
              : (r.bottom > _size.height ? _size.height - r.bottom : 0.0);
          box.rect = r.shift(Offset(dx, dy));
        case _Resize(:final box, :final anchor):
          box.rect = _clamp(Rect.fromPoints(anchor, p));
        case _Draw():
          g.rect = _clamp(Rect.fromPoints(g.start, p));
      }
    });
  }

  void _up(PointerEvent e) {
    final wasMulti = _multi;
    _pointers.remove(e.pointer);
    _end(cancel: e is PointerCancelEvent);
    if (wasMulti != _multi) setState(() {});
  }

  void _end({required bool cancel}) {
    final g = _grab;
    if (g == null) return;
    setState(() => _grab = null);
    if (g is _Draw) {
      final r = g.rect;
      final min = 3 / _fitScale;
      if (cancel || r == null || r.width < min || r.height < min) return;
      _s.record();
      final b = EditBox(
        rect: r,
        className: widget.drawClass,
        selected: true,
        source: BoxSource.drawn,
      );
      _shot.boxes.add(b);
      // Annotating: the new box is ready to adjust or re-class.
      if (widget.kind == EditorKind.annotate) _s.active = b;
      _s.changed();
    } else if (_recorded) {
      _s.changed();
    }
  }

  // --- taps ---------------------------------------------------------------

  void _tap(TapUpDetails d) {
    final p = d.localPosition;
    final shown = _hit(p);
    if (widget.merging) {
      widget.onMergePick?.call(shown);
      return;
    }
    if (widget.kind == EditorKind.redact) {
      if (shown == null) {
        _s.active = null;
        final low = _hit(p, among: _hiddenShown);
        if (low == null) return;
        _s.record();
        _shot.boxes.add(
          EditBox(
            rect: low.rect,
            className: low.className,
            score: low.score,
            selected: true,
            source: BoxSource.tapped,
          ),
        );
        _s.changed();
        return;
      }
      final b = shown;
      _s.record();
      if (b.source == BoxSource.tapped) {
        // Added by a tap, so a tap takes it away again.
        _shot.boxes.remove(b);
        _s.active = null;
        _s.changed();
        return;
      }
      // A value over several lines is redacted whole.
      final on = !b.selected;
      for (final x in _s.groupOf(b)) {
        x.selected = on;
      }
      _s.active = null;
      _s.changed();
      return;
    }
    final b = shown;
    if (b != null) {
      if (!b.selected) {
        // A model suggestion: tapping accepts it (with its other lines).
        _s.record();
        for (final x in _s.groupOf(b)) {
          x.selected = true;
        }
      }
      _s.active = b;
      _s.changed();
      return;
    }
    for (final line in widget.textLines) {
      if (line.contains(p) && !_covered(line)) {
        widget.onLineTap?.call(line);
        return;
      }
    }
    _s.active = null;
  }

  /// A box of the shot already covers most of [line].
  bool _covered(Rect line) => _shot.boxes.any((b) {
    final i = b.rect.intersect(line);
    return i.width > 0 && i.height > 0 && _area(i) > 0.6 * _area(line);
  });

  void _longPress(LongPressStartDetails d) {
    final b = _hit(d.localPosition);
    if (b == null) return;
    _s.active = b;
    final onScreen = MatrixUtils.transformRect(_view.value, b.rect);
    widget.onLongPress?.call(b, onScreen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _refreshPreviews();
    });
    return LayoutBuilder(
      builder: (context, c) {
        _fit(c.biggest);
        return InteractiveViewer(
          transformationController: _view,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.05,
          maxScale: 16,
          // The viewer pans only with two fingers; one-finger panning is
          // in [_move].
          panEnabled: _multi,
          child: Listener(
            onPointerDown: _down,
            onPointerMove: _move,
            onPointerUp: _up,
            onPointerCancel: _up,
            child: GestureDetector(
              onTapUp: _tap,
              onLongPressStart: _longPress,
              child: SizedBox.fromSize(
                size: _size,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Rounded by a constant amount on screen.
                    ListenableBuilder(
                      listenable: _view,
                      builder: (context, image) => ClipRRect(
                        borderRadius: BorderRadius.circular(13 / _zoom),
                        child: image,
                      ),
                      child: Image.file(
                        _shot.image,
                        key: ValueKey(_shot.image.path),
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                    ListenableBuilder(
                      listenable: _view,
                      builder: (context, _) => CustomPaint(
                        painter: _BoxPainter(
                          kind: widget.kind,
                          boxes: _shot.boxes,
                          hidden: _hiddenShown,
                          active: _s.active,
                          mergeFrom: widget.mergeFrom,
                          drawing: switch (_grab) {
                            _Draw(:final rect) => rect,
                            _ => null,
                          },
                          lines: widget.kind == EditorKind.annotate
                              ? [
                                  for (final l in widget.textLines)
                                    if (!_covered(l)) l,
                                ]
                              : const [],
                          zoom: _zoom,
                          fitScale: _fitScale,
                          label: (c) => classLabel(l10n, c),
                          previews: _previews,
                          accent: scheme.primary,
                          score: (s) => s.toStringAsFixed(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BoxPainter extends CustomPainter {
  _BoxPainter({
    required this.kind,
    required this.boxes,
    required this.hidden,
    required this.active,
    required this.mergeFrom,
    required this.drawing,
    required this.lines,
    required this.zoom,
    required this.fitScale,
    required this.label,
    required this.previews,
    required this.accent,
    required this.score,
  });

  final EditorKind kind;
  final List<EditBox> boxes;

  /// Detections below the review threshold (redact): outlined like other
  /// unselected boxes.
  final List<EditBox> hidden;
  final EditBox? active;

  /// The box a merge starts from; highlighted until the second is picked.
  final EditBox? mergeFrom;
  final Rect? drawing;

  /// Text lines that can be tapped into a box (annotate).
  final List<Rect> lines;
  final double zoom;

  /// [zoom] at which the image fits the viewport.
  final double fitScale;

  /// Display name of a class.
  final String Function(String) label;

  /// Redaction previews of the selected boxes (redact).
  final List<(Rect, ui.Image)> previews;
  final Color accent;
  final String Function(double) score;

  @override
  void paint(Canvas canvas, Size size) {
    // Constant on-screen widths whatever the zoom.
    final px = 1 / zoom;
    for (final l in lines) {
      drawDashedRect(
        canvas,
        l.inflate(2 * px),
        accent.withValues(alpha: .7),
        px,
        1.2,
      );
    }
    if (kind == EditorKind.redact) {
      for (final (r, im) in previews) {
        canvas.drawImageRect(
          im,
          Offset.zero & Size(im.width.toDouble(), im.height.toDouble()),
          r,
          Paint()..filterQuality = FilterQuality.none,
        );
      }
      // Selected: the fill and the class colour around it. Not selected: a
      // dashed suggestion, fainter below the review threshold.
      for (final b in boxes) {
        final c = classColor(b.className);
        if (b.selected) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              b.rect.inflate(px),
              Radius.circular(3 * px),
            ),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5 * px
              ..color = c,
          );
        } else {
          drawDashedRect(canvas, b.rect, c, px, 1.5);
        }
      }
      for (final b in hidden) {
        drawDashedRect(
          canvas,
          b.rect,
          classColor(b.className).withValues(alpha: .55),
          px,
          1.2,
        );
      }
    } else {
      // Labels grow with the zoom (up to 3x) so they stay readable.
      final labelSize = 11 * px * (zoom / fitScale).clamp(1.0, 3.0);
      // One label per value: on the first line of a group, which is joined
      // to its other lines.
      final groups = <int, List<EditBox>>{};
      for (final b in boxes) {
        if (b.group case final g?) groups.putIfAbsent(g, () => []).add(b);
      }
      for (final parts in groups.values) {
        parts.sort((a, b) => a.rect.top.compareTo(b.rect.top));
        for (var i = 1; i < parts.length; i++) {
          final c = classColor(parts[i].className);
          _dashedLine(
            canvas,
            parts[i - 1].rect.bottomLeft,
            parts[i].rect.topLeft,
            c,
            px,
          );
        }
      }
      for (final b in boxes) {
        final c = classColor(b.className);
        if (!b.selected) {
          // A suggestion not yet accepted.
          drawDashedRect(canvas, b.rect, c, px, 1.5);
          continue;
        }
        canvas
          ..drawRect(b.rect, Paint()..color = c.withValues(alpha: .14))
          ..drawRect(
            b.rect,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2 * px
              ..color = c,
          );
        if (b.group case final g? when groups[g]!.first != b) continue;
        final tp = TextPainter(
          text: TextSpan(
            text: ' ${label(b.className)} ',
            style: TextStyle(
              fontSize: labelSize,
              color: Colors.white,
              backgroundColor: c,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, b.rect.topLeft - Offset(0, tp.height));
      }
    }
    if (active case final a?) {
      // Redact: in the class colour, labelled with class and score.
      final c = kind == EditorKind.redact ? classColor(a.className) : accent;
      canvas.drawRect(
        a.rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * px
          ..color = c,
      );
      if (kind == EditorKind.redact) {
        final tp = TextPainter(
          text: TextSpan(
            text: [
              label(a.className),
              if (a.score case final s?) score(s),
            ].join(' '),
            style: TextStyle(
              fontSize: 12 * px,
              fontWeight: FontWeight.w500,
              color: c.computeLuminance() > .4 ? Colors.black : Colors.white,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final chip = Rect.fromLTWH(
          a.rect.left,
          a.rect.top - tp.height - 4 * px,
          tp.width + 10 * px,
          tp.height + 2 * px,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(chip, Radius.circular(4 * px)),
          Paint()..color = c,
        );
        tp.paint(canvas, chip.topLeft + Offset(5 * px, px));
      }
      for (final h in [
        a.rect.topLeft,
        a.rect.topRight,
        a.rect.bottomLeft,
        a.rect.bottomRight,
      ]) {
        canvas
          ..drawCircle(h, 6 * px, Paint()..color = Colors.white)
          ..drawCircle(
            h,
            6 * px,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2 * px
              ..color = c,
          );
      }
    }
    if (mergeFrom case final m?) {
      canvas.drawRect(
        m.rect.inflate(3 * px),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * px
          ..color = accent,
      );
    }
    if (drawing case final d?) drawDashedRect(canvas, d, accent, px, 2);
  }

  static void _dashedLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Color c,
    double px,
  ) {
    final paint = Paint()
      ..strokeWidth = 1.5 * px
      ..color = c;
    final len = (b - a).distance;
    if (len == 0) return;
    final dir = (b - a) / len;
    for (var t = 0.0; t < len; t += 7 * px) {
      final e = t + 4 * px < len ? t + 4 * px : len;
      canvas.drawLine(a + dir * t, a + dir * e, paint);
    }
  }

  @override
  bool shouldRepaint(_BoxPainter old) => true;
}

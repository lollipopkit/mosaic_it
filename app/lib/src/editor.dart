import 'dart:async';
import 'dart:math' as math;
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

/// The shown image of [session] with its boxes.
///
/// - Tap toggles a box (or adds a tapped hidden detection).
/// - Long press makes the box active and calls [onLongPress] (its menu).
/// - Drag on the active box moves it, drag on a corner handle resizes it.
/// - With [drawing], a one-finger drag draws a box of [drawClass].
/// - Two fingers always zoom and pan.
class BoxEditor extends StatefulWidget {
  const BoxEditor({
    super.key,
    required this.session,
    this.drawing = false,
    this.drawClass = manualClass,
    this.fill,
    this.onLongPress,
    this.merging = false,
    this.mergeFrom,
    this.onMergePick,
    this.fitPadding = EdgeInsets.zero,
    this.peekOriginal = false,
  });

  /// Kept clear when the image is fitted: what floats over the editor. The
  /// image still pans under it.
  final EdgeInsets fitPadding;

  /// Temporarily hides redaction fill patches so the user can inspect the
  /// underlying pixels while keeping box outlines visible.
  final bool peekOriginal;

  final EditSession session;
  final bool drawing;

  /// Class of boxes drawn with [drawing].
  final String drawClass;

  /// How selected boxes will be hidden; the editor shows exactly that.
  final Fill? fill;

  /// Called with the box and its rectangle on screen, for a menu beside it.
  final void Function(EditBox box, Rect onScreen)? onLongPress;

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

  /// Image size, viewport and padding the view was last fitted for.
  (Size, Size, EdgeInsets)? _fittedFor;
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
  static const _minScale = 0.05, _maxScale = 16.0;

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
    if (_fittedFor?.$1 != _size) _fittedFor = null;
    setState(() {});
  }

  double get _zoom => _view.value.getMaxScaleOnAxis();

  // --- previews -----------------------------------------------------------

  /// Schedules new previews when the selection or the fill changed. The old
  /// ones stay on screen until the new ones are decoded.
  void _refreshPreviews() {
    final f = widget.fill;
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

  /// Fits the image into [viewport]. When only the viewport or padding
  /// changed (rotation, fold, a bar appearing), the zoom relative to the fit
  /// and the image point at the centre are kept.
  void _fit(Size viewport) {
    final pad = widget.fitPadding;
    final key = (_size, viewport, pad);
    if (_fittedFor == key) return;
    Size deflate(Size v, EdgeInsets p) => Size(
      math.max(0.0, v.width - p.horizontal),
      math.max(0.0, v.height - p.vertical),
    );
    Offset centre(Size v, EdgeInsets p) =>
        Offset(p.left, p.top) + deflate(v, p).center(Offset.zero);
    final area = deflate(viewport, pad);
    final fit = math.min(area.width / _size.width, area.height / _size.height);
    if (!fit.isFinite || fit <= 0) return;
    final clampedFit = fit.clamp(_minScale, _maxScale);
    final old = _fittedFor;
    _fittedFor = key;
    var zoom = clampedFit;
    var focus = _size.center(Offset.zero);
    if (old != null && old.$1 == _size) {
      zoom = (_zoom / _fitScale * clampedFit).clamp(_minScale, _maxScale);
      focus = MatrixUtils.transformPoint(
        Matrix4.inverted(_view.value),
        centre(old.$2, old.$3),
      );
    }
    _fitScale = clampedFit;
    final t = centre(viewport, pad) - focus * zoom;
    _view.value = Matrix4.identity()
      ..translateByDouble(t.dx, t.dy, 0, 1)
      ..scaleByDouble(zoom, zoom, zoom, 1);
  }

  static double _area(Rect r) => r.width * r.height;

  /// The below-threshold detections a tap on an empty spot adds (not drawn:
  /// most are noise): not where a box already is (a weaker duplicate of it,
  /// or one a tap has added).
  List<EditBox> get _offered => [
    for (final h in _shot.hidden)
      if (!_covered(h.rect)) h,
  ];

  /// Smallest box under [p]: nested boxes stay reachable.

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
    if (shown == null) {
      _s.active = null;
      final low = _hit(p, among: _offered);
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
          minScale: _minScale,
          maxScale: _maxScale,
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
                          boxes: _shot.boxes,
                          active: _s.active,
                          mergeFrom: widget.mergeFrom,
                          drawing: switch (_grab) {
                            _Draw(:final rect) => rect,
                            _ => null,
                          },
                          zoom: _zoom,
                          label: (c) => classLabel(l10n, c),
                          previews: widget.peekOriginal ? const [] : _previews,
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
    required this.boxes,
    required this.active,
    required this.mergeFrom,
    required this.drawing,
    required this.zoom,
    required this.label,
    required this.previews,
    required this.accent,
    required this.score,
  });

  final List<EditBox> boxes;

  final EditBox? active;

  /// The box a merge starts from; highlighted until the second is picked.
  final EditBox? mergeFrom;
  final Rect? drawing;
  final double zoom;

  /// Display name of a class.
  final String Function(String) label;

  /// Redaction previews of the selected boxes.
  final List<(Rect, ui.Image)> previews;
  final Color accent;
  final String Function(double) score;

  @override
  void paint(Canvas canvas, Size size) {
    // Constant on-screen widths whatever the zoom.
    final px = 1 / zoom;
    for (final (r, im) in previews) {
      canvas.drawImageRect(
        im,
        Offset.zero & Size(im.width.toDouble(), im.height.toDouble()),
        r,
        Paint()..filterQuality = FilterQuality.none,
      );
    }
    // Selected: the fill and the class colour around it. Not selected: a
    // dashed suggestion.
    for (final b in boxes) {
      final c = classColor(b.className);
      if (b.selected) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(b.rect.inflate(px), Radius.circular(3 * px)),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5 * px
            ..color = c,
        );
      } else {
        drawDashedRect(canvas, b.rect, c, px, 1.5);
      }
    }
    if (active case final a?) {
      final c = classColor(a.className);
      canvas.drawRect(
        a.rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * px
          ..color = c,
      );
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

  @override
  bool shouldRepaint(_BoxPainter old) => true;
}

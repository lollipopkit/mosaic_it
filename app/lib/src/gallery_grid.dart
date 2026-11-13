import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../l10n/app_localizations.dart';
import 'store.dart';

/// The photo library as a grid of square cells, like the iOS Photos library:
/// pinch to change the cell size, and optionally show each image whole.
class GalleryGrid extends StatefulWidget {
  const GalleryGrid({
    super.key,
    required this.assets,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    required this.onNearEnd,
  });

  final List<AssetEntity> assets;

  /// In selection order; a cell shows its 1-based position.
  final List<AssetEntity> selected;

  final ValueChanged<AssetEntity> onTap;
  final ValueChanged<AssetEntity> onLongPress;

  /// Scrolled close to the last loaded asset.
  final VoidCallback onNearEnd;

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  /// Cell widths in logical pixels, by zoom level: 3, 5 and 7 columns on a
  /// phone, more on a wider window.
  static const _extents = [130.0, 80.0, 56.0];

  /// Thumbnail short sides in pixels, by zoom level.
  static const _pixels = [384, 256, 192];

  static const _gap = 2.0;

  var _scroll = ScrollController();

  /// Touches on the grid by pointer, for the pinch.
  final _touches = <int, Offset>{};

  /// Finger distance (or trackpad scale) at the last zoom step.
  double _stepSpan = 1;

  double _width = 0;

  /// Zoom steps so far: each one builds a new grid at its scroll offset.
  int _generation = 0;

  /// Two fingers were down in the current touch: its taps select nothing.
  bool _pinched = false;

  DateTime _wheelStep = DateTime(0);

  SettingStore get _store => SettingStore.instance;

  int get _zoom => _store.gridZoom.get().clamp(0, _extents.length - 1);

  int get _columns => max(2, (_width / _extents[_zoom]).round());

  bool get _pinching => _touches.length > 1;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Moves [by] zoom levels, keeping the same images in view.
  void _step(int by) {
    final next = (_zoom + by).clamp(0, _extents.length - 1);
    // Not attached: the grid of the previous step has not been laid out yet.
    if (next == _zoom || !_scroll.hasClients) return;
    HapticFeedback.selectionClick();
    final before = _columns, old = _scroll;
    _store.gridZoom.set(next);
    // Rows and their height both scale with the column count. The rebuilt
    // grid starts at the new offset, so no frame shows the old one.
    final after = _columns;
    setState(() {
      _generation++;
      _scroll = ScrollController(
        initialScrollOffset: old.offset * before * before / (after * after),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
  }

  /// [span] grew or shrank enough since the last step to zoom one level.
  void _pinch(double span) {
    final ratio = span / _stepSpan;
    if (ratio < 1.25 && ratio > 0.8) return;
    _stepSpan = span;
    _step(ratio > 1 ? -1 : 1);
  }

  double get _touchSpan {
    final [a, b, ...] = _touches.values.toList();
    return max((a - b).distance, 1);
  }

  void _touch(PointerEvent e, {required bool down}) {
    if (e.kind == PointerDeviceKind.trackpad) return;
    final was = _pinching;
    if (down && _touches.isEmpty) _pinched = false;
    down ? _touches[e.pointer] = e.position : _touches.remove(e.pointer);
    if (_pinching) {
      _pinched = true;
      _stepSpan = _touchSpan;
    }
    // Scrolling stops while two fingers are down.
    if (was != _pinching) setState(() {});
  }

  void _nearEnd(ScrollMetrics m) {
    if (m.extentAfter < 800) widget.onNearEnd();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      _width = box.maxWidth;
      // The pinch reads the pointers itself: a gesture recognizer loses the
      // first finger to a scroll that has already started.
      return Listener(
        onPointerDown: (e) => _touch(e, down: true),
        onPointerUp: (e) => _touch(e, down: false),
        onPointerCancel: (e) => _touch(e, down: false),
        onPointerMove: (e) {
          if (!_touches.containsKey(e.pointer)) return;
          _touches[e.pointer] = e.position;
          if (_pinching) _pinch(_touchSpan);
        },
        onPointerPanZoomStart: (_) => _stepSpan = 1,
        onPointerPanZoomUpdate: (e) => _pinch(e.scale),
        onPointerSignal: (e) {
          final keys = HardwareKeyboard.instance;
          if (e is! PointerScrollEvent ||
              !(keys.isControlPressed || keys.isMetaPressed)) {
            return;
          }
          // One wheel gesture sends many events; it moves one level.
          final now = DateTime.now();
          if (now.difference(_wheelStep).inMilliseconds < 300) return;
          _wheelStep = now;
          _step(e.scrollDelta.dy.sign.toInt());
        },
        // Metrics too: a page that does not fill the window never scrolls.
        child: NotificationListener<ScrollMetricsNotification>(
          onNotification: (n) {
            _nearEnd(n.metrics);
            return false;
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              _nearEnd(n.metrics);
              return false;
            },
            child: ListenableBuilder(
              listenable: Listenable.merge([
                _store.gridZoom.listenable(),
                _store.gridAspect.listenable(),
              ]),
              builder: (context, _) {
                final whole = _store.gridAspect.get(), columns = _columns;
                return GridView.builder(
                  key: ValueKey(_generation),
                  controller: _scroll,
                  physics: _pinching
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: _gap,
                    crossAxisSpacing: _gap,
                  ),
                  itemCount: widget.assets.length,
                  itemBuilder: (context, i) {
                    final a = widget.assets[i];
                    return _Cell(
                      key: ValueKey(a.id),
                      asset: a,
                      order: widget.selected.indexOf(a) + 1,
                      selecting: widget.selected.isNotEmpty,
                      pixels: _pixels[_zoom],
                      whole: whole,
                      onTap: () {
                        if (!_pinched) widget.onTap(a);
                      },
                      onLongPress: () {
                        if (!_pinched) widget.onLongPress(a);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class _Cell extends StatelessWidget {
  const _Cell({
    super.key,
    required this.asset,
    required this.order,
    required this.selecting,
    required this.pixels,
    required this.whole,
    required this.onTap,
    required this.onLongPress,
  });

  final AssetEntity asset;

  /// 1-based position in the selection, 0 when not selected.
  final int order;

  /// Some cell is selected: the others show where a tap selects them.
  final bool selecting;

  /// Thumbnail short side in pixels.
  final int pixels;

  /// Show the whole image instead of cropping it to the square.
  final bool whole;

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  /// A thumbnail whose short side fills the cell; the long side is capped
  /// for panoramas and very long screenshots.
  ThumbnailSize get _thumbnail {
    final w = asset.orientatedWidth, h = asset.orientatedHeight;
    if (w <= 0 || h <= 0) return ThumbnailSize.square(pixels);
    // Whole: the long side fits the cell. Cropped: the short side fills it.
    final scale = pixels / (whole ? max(w, h) : min(w, h));
    int side(int v) => min((v * scale).round(), pixels * 8);
    return ThumbnailSize(side(w), side(h));
  }

  static String _duration(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    final mark = MarksStore.instance.of(asset.id);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: scheme.surfaceContainerHighest),
          AssetEntityImage(
            asset,
            isOriginal: false,
            thumbnailSize: _thumbnail,
            fit: whole ? BoxFit.contain : BoxFit.cover,
            gaplessPlayback: true,
          ),
          if (order > 0) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: .3),
                border: Border.all(color: scheme.primary, width: 3),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: scheme.primary,
                child: Text(
                  '$order',
                  style: TextStyle(fontSize: 10, color: scheme.onPrimary),
                ),
              ),
            ),
          ],
          if (order == 0 && selecting)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  color: Colors.black.withValues(alpha: .15),
                ),
              ),
            ),
          if (mark != null)
            Positioned(
              left: 4,
              bottom: 4,
              child: _Tag(
                mark == MarksStore.redacted
                    ? t.badgeRedacted
                    : t.badgeAnnotated,
              ),
            ),
          if (asset.type == AssetType.video)
            Positioned(
              right: 4,
              bottom: 4,
              child: _Tag(_duration(asset.videoDuration)),
            ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .5),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9)),
  );
}

import 'dart:io';

import 'package:material_ui/material_ui.dart';

import 'rust/api.dart';

/// Where a box came from.
enum BoxSource {
  /// The detector's pre-selection or review band.
  detector,

  /// Below the review threshold, added by a tap on its place.
  tapped,

  /// Drawn by the user.
  drawn,

  /// Added by find-all from a box the user picked.
  found,

  /// Reported by the export check as still readable.
  exportCheck,

  /// Read from a COCO file under label review.
  label,
}

/// A box in the editor: a detection or one the user drew.
class EditBox {
  EditBox({
    required this.rect,
    required this.className,
    required this.selected,
    required this.source,
    this.score,
    this.review = false,
    this.suggested = false,
    this.origin,
  }) : initialSelected = selected,
       initialClass = className,
       initialRect = rect;

  factory EditBox.fromRegion(
    Region r, {
    BoxSource source = BoxSource.detector,
  }) => EditBox(
    rect: Rect.fromLTRB(r.rect.left, r.rect.top, r.rect.right, r.rect.bottom),
    className: r.className,
    score: r.score,
    selected: r.state == RegionState.selected,
    review: r.state == RegionState.review,
    suggested: r.state == RegionState.suggested,
    source: source,
  );

  /// Image pixels.
  Rect rect;
  String className;

  /// Null for boxes the user added (drawn or found by find-all).
  final double? score;

  /// Below the calibrated threshold: shown unselected and highlighted.
  final bool review;

  /// Of a class off by default: shown unselected, not highlighted.
  final bool suggested;
  bool selected;

  /// Boxes with the same group are one value printed over several lines (one
  /// box per line, as the synthetic labels' `part`); null: a value of its own.
  int? group;

  final BoxSource source;

  /// State when the box appeared, before the user touched it.
  final bool initialSelected;
  final String initialClass;
  final Rect initialRect;

  /// The COCO annotation this box was read from (label review only).
  final Map<String, dynamic>? origin;

  /// Null score: drawn, found, or a label without one.
  bool get manual => score == null;
}

const manualClass = 'manual';

/// Stable colour per class.
Color classColor(String name) {
  const palette = [
    Color(0xFFE5484D),
    Color(0xFF30A46C),
    Color(0xFF3E63DD),
    Color(0xFFF76B15),
    Color(0xFF8E4EC6),
    Color(0xFF12A594),
    Color(0xFFD6409F),
    Color(0xFF978365),
    Color(0xFF0090FF),
    Color(0xFFAB4ABA),
    Color(0xFF5BB98B),
  ];
  if (name == manualClass) return const Color(0xFF8B8D98);
  final h = name.codeUnits.fold<int>(0, (a, c) => (a * 31 + c) & 0x7fffffff);
  return palette[h % palette.length];
}

/// One opened image and its boxes.
class Shot {
  Shot(
    this.image,
    this.size,
    this.boxes, {
    this.hidden = const [],
    this.cameraPhoto = false,
    this.assetId,
  });

  /// [image] with what the model found on it.
  factory Shot.detected(File image, Detected d, {String? assetId}) => Shot(
    image,
    Size(d.width.toDouble(), d.height.toDouble()),
    d.regions.map(EditBox.fromRegion).toList(),
    hidden: d.hidden.map(EditBox.fromRegion).toList(),
    cameraPhoto: d.cameraPhoto,
    assetId: assetId,
  );

  /// Detections below the review threshold: outlined in the redact editor,
  /// where a tap on one adds a selected [BoxSource.tapped] copy to [boxes].
  /// Never changed themselves.
  final List<EditBox> hidden;

  /// The photo-library item it was opened from, for the gallery's badges.
  final String? assetId;

  final File image;

  /// A camera photo, outside the screenshot domain the model is calibrated on.
  final bool cameraPhoto;

  /// Pixels; box coordinates use it.
  final Size size;
  List<EditBox> boxes;

  String get name => image.uri.pathSegments.last;
}

double iou(Rect a, Rect b) {
  final i = a.intersect(b);
  if (i.width <= 0 || i.height <= 0) return 0;
  final inter = i.width * i.height;
  return inter / (a.width * a.height + b.width * b.height - inter);
}

/// Selects boxes already covering a found region and adds the rest as
/// selected boxes of [className]. Returns how many were added.
int mergeFound(List<EditBox> boxes, Iterable<Rect> found, String className) {
  var added = 0;
  for (final r in found) {
    final existing = boxes.where((b) => iou(b.rect, r) > 0.5).toList();
    if (existing.isNotEmpty) {
      for (final b in existing) {
        b.selected = true;
      }
    } else {
      boxes.add(
        EditBox(
          rect: r,
          className: className,
          selected: true,
          source: BoxSource.found,
        ),
      );
      added++;
    }
  }
  return added;
}

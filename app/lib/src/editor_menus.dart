import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:fl_lib/fl_lib.dart'
    show
        CardX,
        ContextMenuAction,
        ContextMenuButton,
        SegmentedTab,
        SegmentedTabs,
        SheetChoiceTile,
        SheetScaffold,
        SwitchX,
        showResizableSheet,
        showRowsSheet;
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'boxes.dart';
import 'edit_session.dart';
import 'editor.dart';
import 'l10n.dart';
import 'settings.dart';

/// The first entry of a box's menu: its class (and score), to change it.
ContextMenuAction classAction(
  AppLocalizations l,
  EditBox b,
  VoidCallback onTap,
) => ContextMenuAction(
  text: classLabel(l, b.className),
  icon: Icons.label_outline,
  note: switch (b.score) {
    final s? => l.scoreValue(s.toStringAsFixed(2)),
    null => null,
  },
  onTap: onTap,
);

/// Shown while picking boxes to merge: what to do, and how to stop.
class MergeHint extends StatelessWidget {
  const MergeHint({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.inverseSurface,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l.mergeHint,
                style: TextStyle(color: scheme.onInverseSurface),
              ),
            ),
            TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: scheme.inversePrimary,
              ),
              child: Text(l.cancel),
            ),
          ],
        ),
      ),
    );
  }
}

/// A class's colour, as a dot.
class ClassDot extends StatelessWidget {
  const ClassDot(this.className, {super.key});

  final String className;

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: classColor(className),
      shape: BoxShape.circle,
    ),
  );
}

/// Picks one of [classes], showing [current] as chosen.
Future<String?> showClassSheet(
  BuildContext context,
  List<String> classes,
  String current,
) {
  final l = AppLocalizations.of(context);
  return showRowsSheet<String>(
    context,
    title: l.pickClass,
    rows: (context) => [
      for (final c in classes)
        SheetChoiceTile(
          leading: ClassDot(c),
          title: classLabel(l, c),
          selected: c == current,
          onTap: () => Navigator.pop(context, c),
        ),
    ],
  );
}

/// Regions of the shown image (or the batch) by class: how many are
/// selected, and a switch per class.
Future<void> showRegionSheet(BuildContext context, EditSession s) =>
    showResizableSheet<void>(
      context,
      builder: (context) => _RegionSheet(session: s),
    );

class _RegionSheet extends StatefulWidget {
  const _RegionSheet({required this.session});

  final EditSession session;

  @override
  State<_RegionSheet> createState() => _RegionSheetState();
}

class _RegionSheetState extends State<_RegionSheet> {
  bool _all = false;

  EditSession get _s => widget.session;

  void _set(Iterable<(Shot, EditBox)> boxes, bool on) {
    for (final shot in {for (final e in boxes) e.$1}) {
      _s.record(shot);
    }
    for (final (_, b) in boxes) {
      b.selected = on;
    }
    _s.changed();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final boxes = [
      for (final shot in _all ? _s.shots : [_s.shot])
        for (final b in shot.boxes) (shot, b),
    ];
    final byClass = <String, List<(Shot, EditBox)>>{};
    for (final e in boxes) {
      byClass.putIfAbsent(e.$2.className, () => []).add(e);
    }
    final selected = boxes.where((e) => e.$2.selected).length;
    return SheetScaffold.rows(
      title: Text('${l.regionsTooltip}  $selected / ${boxes.length}'),
      header: _s.shots.length > 1
          ? SegmentedTabs<bool>(
              expand: true,
              segments: [
                SegmentedTab(value: false, label: l.thisImage),
                SegmentedTab(
                  value: true,
                  label: l.allImagesCount(_s.shots.length),
                ),
              ],
              selected: _all,
              onSelected: (v) => setState(() => _all = v),
            )
          : null,
      actions: [
        TextButton(
          onPressed: selected == boxes.length ? null : () => _set(boxes, true),
          child: Text(l.selectAll),
        ),
        TextButton(
          onPressed: selected == 0 ? null : () => _set(boxes, false),
          child: Text(l.selectNone),
        ),
      ],
      rows: [
        for (final MapEntry(key: c, value: of) in byClass.entries)
          Builder(
            builder: (context) {
              final on = of.where((e) => e.$2.selected).length;
              return ListTile(
                leading: ClassDot(c),
                title: Text(classLabel(l, c)),
                subtitle: Text(
                  on == 0
                      ? '$on / ${of.length} · ${l.suggested}'
                      : '$on / ${of.length}',
                ),
                trailing: SwitchX(
                  value: on == of.length,
                  onChanged: (v) => _set(of, v),
                ),
                onTap: () => _set(of, on != of.length),
              );
            },
          ),
      ],
    );
  }
}

/// Where the export sheet sends the redacted images.
enum ExportTarget { share, photos, photosDeleteOriginals, files }

/// Where to export to, the format and size, and whether to keep training
/// data. Settings are saved as they change; the chosen target is returned.
Future<ExportTarget?> showExportSheet(
  BuildContext context, {
  required AppSettings settings,
  required int images,
  required int regions,
  required bool fromLibrary,
}) => showResizableSheet<ExportTarget>(
  context,
  builder: (context) => StatefulBuilder(
    builder: (context, setSheet) {
      final l = AppLocalizations.of(context);
      final mobile = Platform.isIOS || Platform.isAndroid;
      void set(void Function(AppSettings) f) {
        setSheet(() => f(settings));
        settings.save();
      }

      Widget target(ExportTarget t, String title, IconData icon, [String? s]) =>
          ListTile(
            leading: Icon(icon),
            title: Text(title),
            subtitle: s == null ? null : Text(s),
            onTap: () => Navigator.pop(context, t),
          );
      final side = exportSides.contains(settings.exportMaxSide)
          ? settings.exportMaxSide
          : 0;
      String sideLabel(int px) => px == 0 ? l.sizeOriginal : l.sizePixels(px);
      return SheetScaffold.rows(
        title: Text(l.exportSummary(images, regions)),
        rows: [
          if (mobile) ...[
            target(ExportTarget.share, l.share, Icons.ios_share),
            target(ExportTarget.photos, l.saveToPhotos, Icons.download),
            if (fromLibrary)
              target(
                ExportTarget.photosDeleteOriginals,
                l.saveAndDeleteOriginals,
                Icons.delete_outline,
                Platform.isIOS
                    ? l.originalsToRecentlyDeleted
                    : l.originalsToTrash,
              ),
          ] else
            target(ExportTarget.files, l.saveAs, Icons.download),
          const Divider(),
          ListTile(
            title: Text(l.exportFormat),
            trailing: ContextMenuButton(
              actions: () => [
                for (final f in ExportFormat.values)
                  ContextMenuAction(
                    text: f.name.toUpperCase(),
                    checked: f == settings.exportFormat,
                    onTap: () => set((s) => s.exportFormat = f),
                  ),
              ],
              child: ContextMenuButton.value(
                Text(settings.exportFormat.name.toUpperCase()),
              ),
            ),
          ),
          ListTile(
            title: Text(l.exportSize),
            trailing: ContextMenuButton(
              actions: () => [
                for (final px in exportSides)
                  ContextMenuAction(
                    text: sideLabel(px),
                    checked: px == side,
                    onTap: () => set((s) => s.exportMaxSide = px),
                  ),
              ],
              child: ContextMenuButton.value(Text(sideLabel(side))),
            ),
          ),
          ListTile(
            title: Text(l.collectTitle),
            trailing: SwitchX(
              value: settings.collect,
              onChanged: (v) => set((s) => s.collect = v),
            ),
          ),
        ],
      );
    },
  ),
);

/// Why the export check flagged an area.
enum CheckReason { notSelected, boxTooSmall, fillShowsThrough }

/// An area the export check found readable in the output.
typedef CheckArea = ({Rect rect, String className, CheckReason reason});

/// What the user does about readable areas.
enum CheckAction { add, show, force }

/// The export check's findings for one image, each area as it would be
/// written, and what to do about them.
Future<CheckAction?> showCheckSheet(
  BuildContext context, {
  required List<CheckArea> areas,
  required ui.Image image,
  required List<(Rect, ui.Image)> patches,
  required int? index,
  required bool canAdd,
}) => showResizableSheet<CheckAction>(
  context,
  builder: (context) {
    final l = AppLocalizations.of(context);
    String reason(CheckReason r) => switch (r) {
      CheckReason.notSelected => l.reasonNotSelected,
      CheckReason.boxTooSmall => l.reasonBoxTooSmall,
      CheckReason.fillShowsThrough => l.reasonFillShowsThrough,
    };
    return SheetScaffold(
      title: Text(l.exportCheckTitle(areas.length)),
      header: Text(
        index == null ? l.exportCheckBody : l.exportCheckBodyOf(index),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, CheckAction.force),
          child: Text(l.exportAnyway),
        ),
        if (canAdd) ...[
          OutlinedButton(
            onPressed: () => Navigator.pop(context, CheckAction.show),
            child: Text(l.showThem),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, CheckAction.add),
            child: Text(l.redactThemAndExport),
          ),
        ],
      ],
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final a in areas)
            SizedBox(
              width: 160,
              child: CardX(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 72,
                      child: CustomPaint(
                        painter: _CropPainter(image, patches, a),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ClassDot(a.className),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${classLabel(l, a.className)} · ${reason(a.reason)}',
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  },
);

/// [area] and some of its surroundings as export would write them.
class _CropPainter extends CustomPainter {
  _CropPainter(this.image, this.patches, this.area);

  final ui.Image image;
  final List<(Rect, ui.Image)> patches;
  final CheckArea area;

  @override
  void paint(Canvas canvas, Size size) {
    final r = area.rect;
    // The area with a margin, widened to the card's aspect ratio.
    var src = r.inflate(math.max(6, r.shortestSide * .3));
    final aspect = size.width / size.height;
    src = src.width / src.height < aspect
        ? Rect.fromCenter(
            center: src.center,
            width: src.height * aspect,
            height: src.height,
          )
        : Rect.fromCenter(
            center: src.center,
            width: src.width,
            height: src.width / aspect,
          );
    final k = size.width / src.width;
    canvas
      ..clipRect(Offset.zero & size)
      ..scale(k)
      ..translate(-src.left, -src.top)
      ..drawImageRect(
        image,
        src,
        src,
        Paint()..filterQuality = FilterQuality.medium,
      );
    for (final (p, im) in patches) {
      if (!p.overlaps(src)) continue;
      canvas.drawImageRect(
        im,
        Offset.zero & Size(im.width.toDouble(), im.height.toDouble()),
        p,
        Paint()..filterQuality = FilterQuality.none,
      );
    }
    drawDashedRect(
      canvas,
      r.inflate(2 / k),
      classColor(area.className),
      1 / k,
      1.5,
    );
  }

  @override
  bool shouldRepaint(_CropPainter old) =>
      old.image != image || old.patches != patches || old.area != area;
}

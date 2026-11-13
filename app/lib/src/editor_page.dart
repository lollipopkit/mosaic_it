import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:fl_lib/fl_lib.dart'
    show ContextMenuAction, Frosted, showContextMenu;
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import 'boxes.dart';
import 'collect.dart';
import 'edit_session.dart';
import 'editor.dart';
import 'editor_menus.dart';
import 'rust/api.dart';
import 'settings.dart';
import 'store.dart';

/// Redacting a batch of opened images: a top bar (back, undo, count,
/// export), the editor, the batch strip, and the tools (fill, draw, similar,
/// merge, regions).
class EditorPage extends StatefulWidget {
  const EditorPage({
    super.key,
    required this.shots,
    required this.settings,
    required this.model,
    required this.info,
  });

  final List<Shot> shots;
  final AppSettings settings;
  final Session model;
  final ModelInfo info;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final _s = EditSession(widget.shots)..addListener(_changed);

  /// Library originals can go to Recently Deleted (iOS) or the trash
  /// (Android 11+).
  static final Future<bool> _canTrash = Platform.isIOS
      ? Future.value(true)
      : Platform.isAndroid
      ? PhotoManager.systemVersion().then((v) => (int.tryParse(v) ?? 0) >= 30)
      : Future.value(false);

  /// On from the start: a missed value is one drag away; two fingers move
  /// the view.
  bool _drawing = true;
  String? _busy;

  /// Taps on boxes merge them into [_mergeFrom] (the first one tapped when
  /// merging started without an active box).
  bool _merging = false;
  EditBox? _mergeFrom;

  /// The editor's area, to place a box's menu under the box.
  final _viewKey = GlobalKey();

  AppLocalizations get _l => AppLocalizations.of(context);
  static final _mobile = Platform.isIOS || Platform.isAndroid;

  @override
  void dispose() {
    _s.dispose();
    super.dispose();
  }

  void _changed() => setState(() {
    // A merge starts from a box of the shown shot (gone after a shot
    // switch, delete or undo).
    if (_mergeFrom case final m? when !_s.shot.boxes.contains(m)) {
      _mergeFrom = null;
    }
  });

  void _toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _run(String label, Future<void> Function() f) async {
    setState(() => _busy = label);
    try {
      await f();
    } catch (e) {
      if (mounted) _toast('$e');
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  List<String> get _classes => [...widget.info.classes, manualClass];

  // --- boxes --------------------------------------------------------------

  Future<void> _pickClass(EditBox b) async {
    final c = await showClassSheet(context, _classes, b.className);
    if (c != null) _s.reclass(b, c);
  }

  void _startMerge(EditBox? from) => setState(() {
    _merging = true;
    _mergeFrom = from;
  });

  void _mergePick(EditBox? b) => setState(() {
    if (b == null) {
      _merging = false;
      _mergeFrom = null;
    } else if (_mergeFrom case final from?) {
      _s.merge(from, b);
    } else {
      _mergeFrom = b;
      _s.active = b;
    }
  });

  /// Selects or adds every region in the batch that looks like [f] (same
  /// render scale assumed, as for screenshots from one device).
  Future<void> _findSimilar(EditBox f) async {
    final src = _s.shot;
    await _run(_l.findingSimilar, () async {
      final rect = PixelRect(
        left: f.rect.left,
        top: f.rect.top,
        right: f.rect.right,
        bottom: f.rect.bottom,
      );
      var found = 0, added = 0;
      for (final shot in _s.shots) {
        final hits = await findSimilarRegions(
          imagePath: src.image.path,
          rect: rect,
          targetPath: shot.image.path,
        );
        if (hits.isEmpty) continue;
        found += hits.length;
        _s.record(shot);
        added += mergeFound(shot.boxes, [
          for (final m in hits) Rect.fromLTRB(m.left, m.top, m.right, m.bottom),
        ], f.className);
      }
      _s.changed();
      if (mounted) {
        _toast(
          _s.shots.length > 1
              ? _l.similarSelectedAcross(found, added, _s.shots.length)
              : _l.similarSelected(found, added),
        );
      }
    });
  }

  // --- menus --------------------------------------------------------------

  /// The menu of [b], under its place [r] in the editor.
  void _boxMenu(EditBox b, Rect r) {
    final view = _viewKey.currentContext?.findRenderObject() as RenderBox?;
    showContextMenu(context, at: view?.localToGlobal(r.bottomCenter), [
      classAction(_l, b, () => _pickClass(b)),
      ContextMenuAction(
        text: _l.similar,
        icon: Icons.filter_none,
        enabled: _busy == null,
        onTap: () => _findSimilar(b),
      ),
      ContextMenuAction(
        text: _l.merge,
        icon: Icons.join_inner,
        onTap: () => _startMerge(b),
      ),
      if (b.group != null)
        ContextMenuAction(
          text: _l.split,
          icon: Icons.call_split,
          onTap: () => _s.split(b),
        ),
      ContextMenuAction(
        text: _l.delete,
        icon: Icons.delete_outline,
        destructive: true,
        onTap: () => _s.remove(b),
      ),
    ]);
  }

  Future<void> _openExport() async {
    final canTrash = await _canTrash;
    if (!mounted) return;
    final target = await showExportSheet(
      context,
      settings: widget.settings,
      images: _s.shots.length,
      regions: _s.selectedCount,
      fromLibrary: canTrash && _s.shots.any((s) => s.assetId != null),
    );
    if (target == null) return;
    try {
      await _export(target);
    } catch (e) {
      if (mounted) _toast('$e');
    }
  }

  // --- export -------------------------------------------------------------

  static String _stem(Shot s) => s.name.replaceAll(RegExp(r'\.[^.]+$'), '');

  Future<void> _export(ExportTarget target) async {
    final shots = _s.shots;
    final ext = widget.settings.exportFormat.extension;
    String name(Shot s) => '${_stem(s)}-redacted.$ext';
    // Where each shot is written: a temp dir on phones, a chosen file or
    // folder on desktops.
    final Map<Shot, String> targets;
    if (_mobile) {
      final dir = await getTemporaryDirectory();
      targets = {for (final shot in shots) shot: '${dir.path}/${name(shot)}'};
    } else if (shots.length == 1) {
      final shot = shots.single;
      final loc = await getSaveLocation(
        suggestedName: name(shot),
        acceptedTypeGroups: [
          for (final f in ExportFormat.values)
            XTypeGroup(label: f.name.toUpperCase(), extensions: [f.extension]),
        ],
      );
      if (loc == null) return;
      targets = {shot: loc.path};
    } else {
      final dir = await getDirectoryPath(confirmButtonText: _l.exportHere);
      if (dir == null) return;
      targets = {for (final shot in shots) shot: '$dir/${name(shot)}'};
    }
    final written = <Shot, String>{};
    for (final MapEntry(key: shot, value: out) in targets.entries) {
      if (!await _write(shot, out)) {
        if (mounted && shots.length > 1) _toast(_l.exportStoppedAt(shot.name));
        return;
      }
      written[shot] = out;
    }
    if (!mounted) return;
    switch (target) {
      case ExportTarget.share:
        await SharePlus.instance.share(
          ShareParams(files: [for (final p in written.values) XFile(p)]),
        );
      case ExportTarget.photos || ExportTarget.photosDeleteOriginals:
        var saved = false;
        await _run(_l.saving, () async {
          for (final p in written.values) {
            await PhotoManager.editor.saveImageWithPath(
              p,
              title: p.split('/').last,
            );
          }
          saved = true;
          if (mounted) _toast(_l.savedToPhotos(written.length));
        });
        // Originals go only once every redacted copy is in the library.
        if (saved && target == ExportTarget.photosDeleteOriginals && mounted) {
          await _deleteOriginals(written.keys);
        }
      case ExportTarget.files:
        _toast(
          written.length == 1
              ? _l.exportedTo(written.values.single)
              : _l.exportedImages(written.length),
        );
    }
  }

  /// Moves the library originals of [shots] to Recently Deleted (iOS) or
  /// the trash (Android), then leaves the editor. The user can decline the
  /// system prompt; the editor then stays.
  Future<void> _deleteOriginals(Iterable<Shot> shots) async {
    final ids = [for (final s in shots) ?s.assetId];
    if (ids.isEmpty) return;
    final List<String> deleted;
    try {
      if (Platform.isAndroid) {
        final assets = await Future.wait(ids.map(AssetEntity.fromId));
        deleted = await PhotoManager.editor.android.moveToTrash([
          for (final a in assets) ?a,
        ]);
      } else {
        deleted = await PhotoManager.editor.deleteWithIds(ids);
      }
    } catch (e) {
      if (mounted) _toast(_l.originalsNotDeleted('$e'));
      return;
    }
    if (deleted.isNotEmpty && mounted) Navigator.of(context).maybePop();
  }

  /// Redacts [shot] into [out] after the self-check. When the check finds
  /// readable areas the user redacts them too, looks at them, or overrides;
  /// returns whether the file was written.
  Future<bool> _write(Shot shot, String out, {bool force = false}) async {
    final chosen = shot.boxes.where((b) => b.selected).toList();
    final rects = [
      for (final b in chosen)
        PixelRect(
          left: b.rect.left,
          top: b.rect.top,
          right: b.rect.right,
          bottom: b.rect.bottom,
        ),
    ];
    final maxSide = widget.settings.exportMaxSide;
    ExportOutcome? r;
    await _run(
      _s.shots.length > 1
          ? _l.checkingImage(shot.name)
          : _l.checkingAndExporting,
      () async {
        r = await widget.model.redactAndExport(
          imagePath: shot.image.path,
          outPath: out,
          rects: rects,
          fill: widget.settings.fill,
          force: force,
          maxSide: maxSide == 0 ? null : maxSide,
        );
      },
    );
    final res = r;
    if (res == null || !mounted) return false;
    if (res.written) {
      await _collect(shot, res, forced: force);
      if (shot.assetId case final id?) {
        MarksStore.instance.mark(id, MarksStore.redacted);
      }
      return true;
    }
    _s.index = _s.shots.indexOf(shot);
    final action = await _showCheck(shot, chosen, rects, res);
    if (!mounted) return false;
    switch (action) {
      case CheckAction.add || CheckAction.show:
        // An unselected box already there is selected (add) or left as a
        // suggestion (show); the rest are added, selected or as suggestions
        // to tap. A selected box the area still shows around is too small,
        // so the area is added as a box of its own.
        final add = action == CheckAction.add;
        _s.record(shot);
        for (final r in res.surviving) {
          final b = EditBox.fromRegion(r, source: BoxSource.exportCheck);
          final same = shot.boxes
              .where((x) => !x.selected && iou(x.rect, b.rect) > .5)
              .toList();
          if (same.isEmpty) {
            shot.boxes.add(b..selected = add);
          } else if (add) {
            for (final x in same) {
              x.selected = true;
            }
          }
        }
        _s.changed();
        return add && await _write(shot, out);
      case CheckAction.force:
        return _write(shot, out, force: true);
      case null:
        return false;
    }
  }

  /// The export check's findings on [shot], each area shown as it would be
  /// written.
  Future<CheckAction?> _showCheck(
    Shot shot,
    List<EditBox> chosen,
    List<PixelRect> rects,
    ExportOutcome res,
  ) async {
    final areas = <CheckArea>[
      for (final r in res.surviving)
        () {
          final rect = Rect.fromLTRB(
            r.rect.left,
            r.rect.top,
            r.rect.right,
            r.rect.bottom,
          );
          return (
            rect: rect,
            className: r.className,
            reason: chosen.any((b) => b.rect.overlaps(rect))
                ? CheckReason.boxTooSmall
                : CheckReason.notSelected,
          );
        }(),
      for (final i in res.correlated)
        (
          rect: chosen[i].rect,
          className: chosen[i].className,
          reason: CheckReason.fillShowsThrough,
        ),
    ];
    final preview = await redactionPreview(
      imagePath: shot.image.path,
      rects: rects,
      fill: widget.settings.fill,
    );
    final codec = await ui.instantiateImageCodec(
      await shot.image.readAsBytes(),
    );
    final ui.Image image;
    try {
      image = (await codec.getNextFrame()).image;
    } finally {
      codec.dispose();
    }
    final patches = await decodePatches(preview);
    try {
      if (!mounted) return null;
      return await showCheckSheet(
        context,
        areas: areas,
        image: image,
        patches: patches,
        index: _s.shots.length > 1 ? _s.shots.indexOf(shot) + 1 : null,
        canAdd: res.surviving.isNotEmpty,
      );
    } finally {
      image.dispose();
      for (final (_, im) in patches) {
        im.dispose();
      }
    }
  }

  /// Keeps [shot] and the box choices as training data when the user opted
  /// in. A failure is reported and never blocks the export.
  Future<void> _collect(
    Shot shot,
    ExportOutcome res, {
    required bool forced,
  }) async {
    if (!widget.settings.collect) return;
    try {
      await Collector.record(
        shot,
        export: ExportContext(
          model: widget.info,
          hashes: await widget.model.hashes(),
          fill: widget.settings.fill,
          forced: forced,
          outcome: res,
        ),
      );
    } catch (e) {
      if (mounted) _toast(_l.collectFailed('$e'));
    }
  }

  // --- layout -------------------------------------------------------------

  /// Heights of what floats over the image, without the safe area.
  static const _topBar = 64.0, _toolBar = 68.0, _strip = BatchStrip.height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inset = MediaQuery.paddingOf(context);
    final shot = _s.shot;
    final active = _s.active;
    final selected = shot.boxes.where((b) => b.selected).length;
    final idle = _busy == null;
    final batch = _s.shots.length > 1;
    Widget round(Widget button) => Frosted(
      shape: const CircleBorder(),
      child: SizedBox.square(dimension: 48, child: Center(child: button)),
    );
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: Stack(
        key: _viewKey,
        children: [
          Positioned.fill(
            child: BoxEditor(
              key: ValueKey(shot),
              session: _s,
              kind: EditorKind.redact,
              drawing: _drawing && !_merging,
              fill: widget.settings.fill,
              onLongPress: _boxMenu,
              merging: _merging,
              mergeFrom: _mergeFrom,
              onMergePick: _mergePick,
              fitPadding: EdgeInsets.fromLTRB(
                12,
                inset.top + _topBar,
                12,
                inset.bottom + _toolBar + (batch ? _strip : 0) + 8,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Row(
                      children: [
                        round(
                          IconButton(
                            tooltip: MaterialLocalizations.of(context)
                                .backButtonTooltip,
                            onPressed: () => Navigator.of(context).maybePop(),
                            // The glyphs are drawn off their boxes' centres.
                            icon: Transform.translate(
                              offset: const Offset(-2, 0),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Frosted(
                          child: Row(
                            children: [
                              IconButton(
                                tooltip: _l.undo,
                                icon: const Icon(Icons.undo),
                                onPressed: _s.canUndo ? _s.undo : null,
                              ),
                              IconButton(
                                tooltip: _l.redo,
                                icon: const Icon(Icons.redo),
                                onPressed: _s.canRedo ? _s.redo : null,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Frosted(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            child: Text(
                              _l.selectedOf(selected, shot.boxes.length),
                              style: const TextStyle(
                                fontFeatures: [ui.FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          style: const ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(Size.square(48)),
                          ),
                          tooltip: _l.export,
                          onPressed: idle ? _openExport : null,
                          icon: Transform.translate(
                            offset: const Offset(0, -2),
                            child: const Icon(Icons.ios_share, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!idle) const LinearProgressIndicator(minHeight: 2),
                  if (shot.cameraPhoto)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Frosted(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(_l.cameraPhoto),
                        ),
                      ),
                    ),
                  if (_merging)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: MergeHint(onCancel: () => _mergePick(null)),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  if (batch)
                    BatchStrip(
                      shots: _s.shots,
                      index: _s.index,
                      onSelect: (i) => _s.index = i,
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Row(
                      children: [
                        Frosted(
                          shape: const CircleBorder(),
                          child: SizedBox.square(
                            dimension: 52,
                            child: IconButton(
                              tooltip: _l.fillStyle,
                              onPressed: () => showFillSheet(
                                context,
                                widget.settings,
                                () => setState(() {}),
                              ),
                              icon: FillSwatch(
                                style: widget.settings.fillStyle,
                                color: widget.settings.fillColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Frosted(
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  ToolButton(
                                    icon: Icons.highlight_alt,
                                    label: _l.modeDraw,
                                    selected: _drawing && !_merging,
                                    onTap: () => setState(() {
                                      _drawing = _merging || !_drawing;
                                      _merging = false;
                                      _mergeFrom = null;
                                    }),
                                  ),
                                  ToolButton(
                                    icon: Icons.filter_none,
                                    label: _l.similar,
                                    onTap: active == null || !idle
                                        ? null
                                        : () => _findSimilar(active),
                                  ),
                                  ToolButton(
                                    icon: Icons.join_inner,
                                    label: _l.merge,
                                    selected: _merging,
                                    onTap: () => _merging
                                        ? _mergePick(null)
                                        : _startMerge(active),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Badge.count(
                          count: selected,
                          // Inside the button's top right, on its circle.
                          offset: const Offset(-10, 6),
                          backgroundColor: scheme.primary,
                          textColor: scheme.onPrimary,
                          child: Frosted(
                            shape: const CircleBorder(),
                            child: SizedBox.square(
                              dimension: 52,
                              child: IconButton(
                                tooltip: _l.regionsTooltip,
                                onPressed: () => showRegionSheet(context, _s),
                                icon: const Icon(Icons.tune),
                              ),
                            ),
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
  }
}

/// A tool in the bottom bar: icon over a short label; [selected] while its
/// mode is on.
class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = onTap == null
        ? scheme.onSurface.withValues(alpha: .38)
        : (selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant);
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? scheme.secondaryContainer : Colors.transparent,
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected && onTap != null ? scheme.primary : color,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Thumbnails of the batch, each with how many boxes it will redact.
class BatchStrip extends StatelessWidget {
  const BatchStrip({
    super.key,
    required this.shots,
    required this.index,
    required this.onSelect,
  });

  final List<Shot> shots;
  final int index;
  final ValueChanged<int> onSelect;

  static const _height = 68.0;

  /// Its height in the layout.
  static const height = _height + 16;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    double thumb(Shot s) =>
        ((_height - 10) * s.size.width / s.size.height).clamp(24.0, 96.0);
    // Thumbnail, its frame and the room for its badge.
    double extent(Shot s) => thumb(s) + 25;
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, c) {
          final total = shots.fold(0.0, (w, s) => w + extent(s));
          // Centred while they fit; built as they scroll into view.
          final side = math.max(16.0, (c.maxWidth - total) / 2);
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: side),
            itemCount: shots.length,
            itemExtentBuilder: (i, _) => extent(shots[i]),
            itemBuilder: (context, i) {
              final shot = shots[i];
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 4, 10, 4),
                child: Semantics(
                  selected: i == index,
                  label: shot.name,
                  child: GestureDetector(
                    onTap: () => onSelect(i),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: i == index
                                  ? scheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              shot.image,
                              height: _height - 10,
                              width: thumb(shot),
                              cacheHeight: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -6,
                          bottom: -6,
                          child: Badge.count(
                            count: shot.boxes.where((b) => b.selected).length,
                            backgroundColor: i == index
                                ? scheme.primary
                                : scheme.surfaceContainerHighest,
                            textColor: i == index
                                ? scheme.onPrimary
                                : scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

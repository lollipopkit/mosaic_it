import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import 'boxes.dart';
import 'collect.dart';
import 'edit_session.dart';
import 'editor.dart';
import 'l10n.dart';
import 'rust/api.dart';
import 'settings.dart';
import 'store.dart';

/// Redacting a batch of opened images: the editor, the batch strip, and a
/// bottom toolbar (undo, draw, find similar, regions, export).
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

  /// On from the start: a missed value is one drag away; two fingers move
  /// the view.
  bool _drawing = true;
  String? _busy;

  /// The long-pressed box and where it is on screen, for its menu.
  (EditBox, Rect)? _menu;

  AppLocalizations get _l => AppLocalizations.of(context);
  static final _mobile = Platform.isIOS || Platform.isAndroid;

  @override
  void dispose() {
    _s.dispose();
    super.dispose();
  }

  void _changed() {
    // The menu belongs to one box in one state; any change closes it.
    if (_menu case (final b, _) when _s.active != b) _menu = null;
    setState(() {});
  }

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

  // --- box menu -----------------------------------------------------------

  Future<void> _pickClass(EditBox b) async {
    final c = await showClassSheet(context, _classes, b.className);
    if (c != null) _s.reclass(b, c);
  }

  /// The box merges start from, while the user picks the others.
  EditBox? _mergeFrom;

  void _mergePick(EditBox? b) => setState(() {
    if (b == null) {
      _mergeFrom = null;
    } else {
      _s.merge(_mergeFrom!, b);
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

  // --- export -------------------------------------------------------------

  static String _stem(Shot s) => s.name.replaceAll(RegExp(r'\.[^.]+$'), '');

  Future<void> _export() async {
    final shots = _s.shots;
    // Where each shot goes: a temp dir to share on phones, a chosen file or
    // folder on desktops.
    final Map<Shot, String> targets;
    if (_mobile) {
      final dir = await getTemporaryDirectory();
      targets = {
        for (final shot in shots)
          shot: '${dir.path}/${_stem(shot)}-redacted.png',
      };
    } else if (shots.length == 1) {
      final shot = shots.single;
      final loc = await getSaveLocation(
        suggestedName: '${_stem(shot)}-redacted.png',
        acceptedTypeGroups: const [
          XTypeGroup(label: 'PNG', extensions: ['png']),
          XTypeGroup(label: 'JPEG', extensions: ['jpg', 'jpeg']),
        ],
      );
      if (loc == null) return;
      targets = {shot: loc.path};
    } else {
      final dir = await getDirectoryPath(confirmButtonText: _l.exportHere);
      if (dir == null) return;
      targets = {
        for (final shot in shots) shot: '$dir/${_stem(shot)}-redacted.png',
      };
    }
    final written = <String>[];
    for (final MapEntry(key: shot, value: out) in targets.entries) {
      if (!await _write(shot, out)) {
        if (mounted && shots.length > 1) _toast(_l.exportStoppedAt(shot.name));
        return;
      }
      written.add(out);
    }
    if (!mounted) return;
    if (_mobile) {
      await SharePlus.instance.share(
        ShareParams(files: [for (final p in written) XFile(p)]),
      );
    } else {
      _toast(
        written.length == 1
            ? _l.exportedTo(written.single)
            : _l.exportedImages(written.length),
      );
    }
  }

  /// Redacts [shot] into [out] after the self-check. When the check finds
  /// readable areas the user redacts them too, looks at them, or overrides;
  /// returns whether the file was written.
  Future<bool> _write(Shot shot, String out, {bool force = false}) async {
    final chosen = shot.boxes.where((b) => b.selected).toList();
    ExportOutcome? r;
    await _run(
      _s.shots.length > 1
          ? _l.checkingImage(shot.name)
          : _l.checkingAndExporting,
      () async {
        r = await widget.model.redactAndExport(
          imagePath: shot.image.path,
          outPath: out,
          rects: [
            for (final b in chosen)
              PixelRect(
                left: b.rect.left,
                top: b.rect.top,
                right: b.rect.right,
                bottom: b.rect.bottom,
              ),
          ],
          fill: widget.settings.fill,
          force: force,
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
    final readable = res.surviving.length + res.correlated.length;
    final action = await showModalBottomSheet<_CheckAction>(
      context: context,
      showDragHandle: true,
      builder: (context) =>
          _CheckSheet(count: readable, canAdd: res.surviving.isNotEmpty),
    );
    switch (action) {
      case _CheckAction.add:
        _s.record(shot);
        shot.boxes.addAll(
          res.surviving.map(
            (r) =>
                EditBox.fromRegion(r, source: BoxSource.exportCheck)
                  ..selected = true,
          ),
        );
        _s.changed();
        return _write(shot, out);
      case _CheckAction.show:
        // Shown as suggestions: tap one to redact it.
        _s.record(shot);
        shot.boxes.addAll(
          res.surviving.map(
            (r) =>
                EditBox.fromRegion(r, source: BoxSource.exportCheck)
                  ..selected = false,
          ),
        );
        _s.changed();
        return false;
      case _CheckAction.force:
        return _write(shot, out, force: true);
      case null:
        return false;
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

  // --- sheets -------------------------------------------------------------

  Future<void> _regions() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _RegionSheet(
      session: _s,
      settings: widget.settings,
      onFillChanged: () {
        widget.settings.save();
        setState(() {});
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shot = _s.shot;
    final active = _s.active;
    return Scaffold(
      // No top bar: the image gets the height, and back sits with the tools.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_busy != null) const LinearProgressIndicator(),
            if (shot.cameraPhoto)
              MaterialBanner(
                content: Text(_l.cameraPhoto),
                actions: const [SizedBox.shrink()],
              ),
            Expanded(
              child: ColoredBox(
                color: scheme.surfaceContainerHighest,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Listener(
                        // Touching the image closes the box menu.
                        onPointerDown: (_) {
                          if (_menu != null) setState(() => _menu = null);
                        },
                        child: BoxEditor(
                          key: ValueKey(shot),
                          session: _s,
                          kind: EditorKind.redact,
                          drawing: _drawing,
                          fill: widget.settings.fill,
                          onLongPress: (b, r) => setState(() => _menu = (b, r)),
                          mergeFrom: _mergeFrom,
                          onMergePick: _mergePick,
                        ),
                      ),
                    ),
                    if (_menu case (final b, final r))
                      BoxMenu(
                        at: r,
                        actions: [
                          (
                            '${classLabel(_l, b.className)} ▾',
                            () => _pickClass(b),
                          ),
                          (
                            _l.merge,
                            () => setState(() {
                              _menu = null;
                              _mergeFrom = b;
                            }),
                          ),
                          if (b.group != null) (_l.split, () => _s.split(b)),
                          (_l.similar, () => _findSimilar(b)),
                          (_l.delete, () => _s.remove(b)),
                        ],
                      ),
                    if (_mergeFrom != null)
                      MergeHint(onCancel: () => _mergePick(null)),
                  ],
                ),
              ),
            ),
            if (_s.shots.length > 1)
              BatchStrip(
                shots: _s.shots,
                index: _s.index,
                onSelect: (i) => _s.index = i,
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
          child: Row(
            children: [
              ToolButton(
                icon: Icons.arrow_back,
                label: MaterialLocalizations.of(context).backButtonTooltip,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              ToolButton(
                icon: Icons.undo,
                label: _l.undo,
                onTap: _s.canUndo ? _s.undo : null,
                onLongPress: _s.canRedo ? _s.redo : null,
              ),
              ToolButton(
                icon: Icons.crop_square,
                label: _l.modeDraw,
                selected: _drawing,
                onTap: () => setState(() => _drawing = !_drawing),
              ),
              ToolButton(
                icon: Icons.content_copy,
                label: _l.similar,
                onTap: active == null || _busy != null
                    ? null
                    : () => _findSimilar(active),
              ),
              ToolButton(
                icon: Icons.tune,
                label: _l.regionsTooltip,
                onTap: _regions,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _busy == null ? _export : null,
                  child: Text(_l.export),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _CheckAction { add, show, force }

class _CheckSheet extends StatelessWidget {
  const _CheckSheet({required this.count, required this.canAdd});

  final int count;

  /// Surviving detections that can be redacted as boxes.
  final bool canAdd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.exportCheckTitle(count),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(l.exportCheckBody),
            const SizedBox(height: 16),
            if (canAdd) ...[
              FilledButton(
                onPressed: () => Navigator.pop(context, _CheckAction.add),
                child: Text(l.redactThemAndExport),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, _CheckAction.show),
                child: Text(l.showThem),
              ),
            ],
            TextButton(
              onPressed: () => Navigator.pop(context, _CheckAction.force),
              child: Text(l.exportAnyway),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown while picking boxes to merge: what to do, and how to stop.
class MergeHint extends StatelessWidget {
  const MergeHint({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Positioned(
      left: 10,
      right: 10,
      top: 8,
      child: Material(
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
      ),
    );
  }
}

/// A menu over a box on screen: one text button per action.
class BoxMenu extends StatelessWidget {
  const BoxMenu({super.key, required this.at, required this.actions});

  /// The box on screen.
  final Rect at;
  final List<(String, VoidCallback)> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, c) {
        const height = 44.0;
        // Above the box, or below it when there is no room above.
        final top = at.top - height - 10 >= 0
            ? at.top - height - 10
            : (at.bottom + 10).clamp(0.0, c.maxHeight - height);
        return Stack(
          children: [
            Positioned(
              top: top,
              left: 12,
              right: 12,
              child: Align(
                alignment: Alignment(
                  ((at.center.dx / c.maxWidth) * 2 - 1).clamp(-1.0, 1.0),
                  0,
                ),
                child: Material(
                  color: scheme.inverseSurface,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final (text, onTap) in actions)
                          TextButton(
                            onPressed: onTap,
                            style: TextButton.styleFrom(
                              foregroundColor: scheme.onInverseSurface,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(text),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Picks one of [classes], showing [current] as chosen.
Future<String?> showClassSheet(
  BuildContext context,
  List<String> classes,
  String current,
) {
  final l = AppLocalizations.of(context);
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              l.pickClass,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final c in classes)
            ListTile(
              leading: CircleAvatar(radius: 6, backgroundColor: classColor(c)),
              title: Text(classLabel(l, c)),
              trailing: c == current ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, c),
            ),
        ],
      ),
    ),
  );
}

/// Classes of the shown image (or the batch) with how many are redacted, a
/// switch per class, and the fill style.
class _RegionSheet extends StatefulWidget {
  const _RegionSheet({
    required this.session,
    required this.settings,
    required this.onFillChanged,
  });

  final EditSession session;
  final AppSettings settings;
  final VoidCallback onFillChanged;

  @override
  State<_RegionSheet> createState() => _RegionSheetState();
}

class _RegionSheetState extends State<_RegionSheet> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = widget.session;
    final shots = _all ? s.shots : [s.shot];
    final byClass = <String, List<(Shot, EditBox)>>{};
    for (final shot in shots) {
      for (final b in shot.boxes) {
        byClass.putIfAbsent(b.className, () => []).add((shot, b));
      }
    }
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (s.shots.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(value: false, label: Text(l.thisImage)),
                    ButtonSegment(
                      value: true,
                      label: Text(l.allImagesCount(s.shots.length)),
                    ),
                  ],
                  selected: {_all},
                  onSelectionChanged: (v) => setState(() => _all = v.single),
                ),
              ),
            for (final MapEntry(key: c, value: boxes) in byClass.entries)
              SwitchListTile(
                secondary: CircleAvatar(
                  radius: 6,
                  backgroundColor: classColor(c),
                ),
                title: Text(classLabel(l, c)),
                subtitle: Text(
                  '${boxes.where((e) => e.$2.selected).length} / ${boxes.length}',
                ),
                value: boxes.every((e) => e.$2.selected),
                onChanged: (v) {
                  for (final shot in {for (final e in boxes) e.$1}) {
                    s.record(shot);
                  }
                  for (final (_, b) in boxes) {
                    b.selected = v;
                  }
                  s.changed();
                  setState(() {});
                },
              ),
            const Divider(),
            ListTile(title: Text(l.fillLabel)),
            FillPicker(
              settings: widget.settings,
              onChanged: () {
                widget.onFillChanged();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A toolbar action: icon over a short label.
class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = onTap == null
        ? scheme.onSurface.withValues(alpha: .38)
        : (selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant);
    return Expanded(
      child: Material(
        color: selected ? scheme.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Thumbnails of the batch with how many boxes each will redact, or [badge].
class BatchStrip extends StatelessWidget {
  const BatchStrip({
    super.key,
    required this.shots,
    required this.index,
    required this.onSelect,
    this.badge,
  });

  final List<Shot> shots;
  final int index;
  final ValueChanged<int> onSelect;

  /// Replaces the selected-box count.
  final String Function(Shot)? badge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: shots.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final text =
              badge?.call(shots[i]) ??
              '${shots[i].boxes.where((b) => b.selected).length}';
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: i == index ? scheme.primary : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      shots[i].image,
                      height: 64,
                      cacheHeight: 128,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (text.isNotEmpty)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

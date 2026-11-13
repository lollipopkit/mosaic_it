import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'boxes.dart';
import 'collect.dart';
import 'edit_session.dart';
import 'editor.dart';
import 'editor_page.dart';
import 'l10n.dart';
import 'label_set.dart';
import 'rust/api.dart';
import 'store.dart';

/// Where annotations go: new labels into the collected data, or a COCO
/// file of pseudo-labels under review (debug builds on desktop).
sealed class _Target {
  List<String> get classes;

  /// Already decided, so the queue starts after it.
  bool done(Shot s);
  Future<void> save(Shot s, AnnotateStatus status);
}

class _Collected extends _Target {
  final _done = <Shot>{};

  @override
  List<String> get classes => labelClasses();

  @override
  bool done(Shot s) => _done.contains(s);

  @override
  Future<void> save(Shot s, AnnotateStatus status) async {
    await Collector.record(s, status: status);
    _done.add(s);
  }
}

class _Review extends _Target {
  _Review(this.set);
  final LabelSet set;

  @override
  List<String> get classes => set.classes;

  @override
  bool done(Shot s) => set.verified(s);

  @override
  Future<void> save(Shot s, AnnotateStatus status) async {
    // A skipped image stays to review; the others are verified as they are.
    if (status == AnnotateStatus.skipped) return;
    set.verify(s);
    await set.save();
  }
}

/// Labelling a queue of images: every box drawn by hand (or accepted from
/// model suggestions), each image saved when the user moves on.
class AnnotatePage extends StatefulWidget {
  /// New labels for [images], saved with the collected training data.
  AnnotatePage.fresh(
    List<(File, String?)> this._images, {
    super.key,
    this.model,
  }) : _shots = null,
       _target = _Collected(),
       _set = null;

  /// Saved annotations opened again; saving replaces their records.
  AnnotatePage.edit(List<Shot> this._shots, {super.key, this.model})
    : _images = null,
      _target = _Collected(),
      _set = null;

  /// Reviewing [set]'s pseudo-labels.
  AnnotatePage.review(LabelSet set, {super.key})
    : _images = null,
      _shots = null,
      _target = _Review(set),
      _set = set,
      model = null;

  /// Image files and their photo-library asset ids.
  final List<(File, String?)>? _images;
  final List<Shot>? _shots;
  final _Target _target;
  final LabelSet? _set;

  /// Runs suggestions when the user turns them on; null hides the switch.
  final Session? model;

  @override
  State<AnnotatePage> createState() => _AnnotatePageState();
}

class _AnnotatePageState extends State<AnnotatePage> {
  EditSession? _s;
  late String _class = widget._target.classes.first;
  bool _suggest = false;
  final _suggested = <Shot>{};
  String? _busy;
  (EditBox, Rect)? _menu;

  /// Text lines per shot, found on first view.
  final _lines = <Shot, List<Rect>>{};

  AppLocalizations get _l => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _s?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final shots = <Shot>[];
    if (widget._set case final set?) {
      shots.addAll(set.shots);
    } else if (widget._shots case final given?) {
      shots.addAll(given);
    } else {
      for (final (f, assetId) in widget._images!) {
        final d = await openImage(imagePath: f.path);
        shots.add(
          Shot(
            f,
            Size(d.width.toDouble(), d.height.toDouble()),
            [],
            cameraPhoto: d.cameraPhoto,
            assetId: assetId,
          ),
        );
      }
    }
    if (!mounted) return;
    final s = EditSession(shots)..addListener(_changed);
    final first = shots.indexWhere((x) => !widget._target.done(x));
    s.index = first < 0 ? 0 : first;
    setState(() => _s = s);
    _prepare();
  }

  void _changed() {
    if (_menu case (final b, _) when _s?.active != b) _menu = null;
    setState(() {});
  }

  void _toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  /// Text lines and, when on, suggestions for the shown image.
  Future<void> _prepare() async {
    final s = _s!;
    final shot = s.shot;
    if (!_lines.containsKey(shot)) {
      try {
        final lines = await textLines(imagePath: shot.image.path);
        _lines[shot] = [
          for (final r in lines)
            Rect.fromLTRB(r.left, r.top, r.right, r.bottom),
        ];
      } catch (_) {
        // No text recognition on this platform: drawing still works.
        _lines[shot] = const [];
      }
      if (mounted) setState(() {});
    }
    await _suggestFor(shot);
  }

  Future<void> _suggestFor(Shot shot) async {
    final m = widget.model;
    if (!_suggest || m == null || _suggested.contains(shot)) return;
    _suggested.add(shot);
    setState(() => _busy = _l.detecting);
    try {
      final d = await m.detect(imagePath: shot.image.path);
      // Suggestions start unselected: a tap accepts one.
      shot.boxes.addAll(
        d.regions.map((r) => EditBox.fromRegion(r)..selected = false),
      );
      _s!.changed();
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  /// Sets the class for new boxes, and re-classes the active box.
  void _pickClass(String c) {
    final s = _s!;
    setState(() => _class = c);
    if (s.active case final a?) s.reclass(a, c);
  }

  void _addLine(Rect line) {
    final s = _s!;
    s.record();
    final b = EditBox(
      rect: line,
      className: _class,
      selected: true,
      source: BoxSource.drawn,
    );
    s.shot.boxes.add(b);
    s.active = b;
    s.changed();
  }

  /// The box merges start from, while the user picks the others.
  EditBox? _mergeFrom;

  void _mergePick(EditBox? b) => setState(() {
    if (b == null) {
      _mergeFrom = null;
    } else {
      _s!.merge(_mergeFrom!, b);
    }
  });

  Future<void> _boxClass(EditBox b) async {
    final c = await showClassSheet(
      context,
      widget._target.classes,
      b.className,
    );
    if (c != null) _pickClass(c);
  }

  /// Saves the shown image as [status] and moves to the next one not done.
  Future<void> _finish(AnnotateStatus status) async {
    final s = _s!;
    final shot = s.shot;
    setState(() => _busy = _l.saving);
    try {
      if (status == AnnotateStatus.empty) {
        // Nothing private: no box is a label.
        for (final b in shot.boxes) {
          b.selected = false;
        }
      }
      await widget._target.save(shot, status);
      if (shot.assetId case final id? when status != AnnotateStatus.skipped) {
        MarksStore.instance.mark(id, MarksStore.annotated);
      }
    } catch (e) {
      if (mounted) _toast(_l.collectFailed('$e'));
      return;
    } finally {
      if (mounted) setState(() => _busy = null);
    }
    if (!mounted) return;
    final n = s.shots.length;
    for (var k = 1; k <= n; k++) {
      final i = (s.index + k) % n;
      if (!widget._target.done(s.shots[i]) && i != s.index) {
        s.index = i;
        _prepare();
        return;
      }
    }
    // Everything decided (skipped images count for this pass).
    _toast(_l.labelsSaved(n));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    if (s == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    final shot = s.shot;
    final done = s.shots.where(widget._target.done).length;
    final review = widget._set != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(_l.annotateOf(s.index + 1, s.shots.length)),
        actions: [
          IconButton(
            tooltip: _l.undo,
            icon: const Icon(Icons.undo),
            onPressed: s.canUndo ? s.undo : null,
          ),
          IconButton(
            tooltip: _l.redo,
            icon: const Icon(Icons.redo),
            onPressed: s.canRedo ? s.redo : null,
          ),
          if (widget.model != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_l.suggestions),
                selected: _suggest,
                onSelected: (v) {
                  setState(() => _suggest = v);
                  _suggestFor(shot);
                },
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: _busy != null ? null : done / s.shots.length,
            minHeight: 3,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Listener(
                      onPointerDown: (_) {
                        if (_menu != null) setState(() => _menu = null);
                      },
                      child: BoxEditor(
                        key: ValueKey(shot),
                        session: s,
                        kind: EditorKind.annotate,
                        // One finger draws (or moves the active box); two
                        // fingers zoom and pan. Not while picking merges.
                        drawing: _mergeFrom == null,
                        drawClass: _class,
                        textLines: _lines[shot] ?? const [],
                        onLineTap: _addLine,
                        onLongPress: (b, r) => setState(() => _menu = (b, r)),
                        mergeFrom: _mergeFrom,
                        onMergePick: _mergePick,
                      ),
                    ),
                  ),
                  if (shot.boxes.isEmpty && (_lines[shot]?.isNotEmpty ?? false))
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 12,
                      child: Center(child: Chip(label: Text(_l.annotateHint))),
                    ),
                  if (_menu case (final b, final r))
                    BoxMenu(
                      at: r,
                      actions: [
                        (
                          '${classLabel(_l, b.className)} ▾',
                          () => _boxClass(b),
                        ),
                        (
                          _l.merge,
                          () => setState(() {
                            _menu = null;
                            _mergeFrom = b;
                          }),
                        ),
                        if (b.group != null) (_l.split, () => s.split(b)),
                        (_l.delete, () => s.remove(b)),
                      ],
                    ),
                  if (_mergeFrom != null)
                    MergeHint(onCancel: () => _mergePick(null)),
                ],
              ),
            ),
          ),
          _ClassBar(
            classes: widget._target.classes,
            selected: _class,
            onSelect: _pickClass,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _busy == null
                      ? () => _finish(AnnotateStatus.skipped)
                      : null,
                  child: Text(_l.skip),
                ),
              ),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: _busy == null
                      ? () => _finish(AnnotateStatus.empty)
                      : null,
                  child: Text(_l.nothingPrivate),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _busy == null
                      ? () => _finish(AnnotateStatus.labeled)
                      : null,
                  child: Text(review ? _l.verifyNext : _l.next),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The classes as chips; the chosen one labels new boxes.
class _ClassBar extends StatelessWidget {
  const _ClassBar({
    required this.classes,
    required this.selected,
    required this.onSelect,
  });

  final List<String> classes;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: classes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final c = classes[i];
          return ChoiceChip(
            avatar: CircleAvatar(radius: 5, backgroundColor: classColor(c)),
            label: Text(classLabel(l, c)),
            selected: c == selected,
            onSelected: (_) => onSelect(c),
          );
        },
      ),
    );
  }
}

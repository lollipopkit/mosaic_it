import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import 'annotate_page.dart';
import 'boxes.dart';
import 'collect.dart';
import 'l10n.dart';
import 'rust/api.dart';

/// What has been annotated on this device: counts by status and class, each
/// image with its status (tap to edit again), export as one zip, delete.
class AnnotationDataPage extends StatefulWidget {
  const AnnotationDataPage({super.key, this.model});

  /// Offered for suggestions when an image is opened again.
  final Session? model;

  @override
  State<AnnotationDataPage> createState() => _AnnotationDataPageState();
}

class _AnnotationDataPageState extends State<AnnotationDataPage> {
  List<Map<String, dynamic>>? _records;
  Directory? _dir;
  bool _busy = false;

  AppLocalizations get _l => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final dir = await Collector.dir();
    final all = await Collector.samples();
    if (!mounted) return;
    setState(() {
      _dir = dir;
      // Newest first.
      _records = [
        for (final r in all.reversed)
          if (r['mode'] == 'annotate') r,
      ];
    });
  }

  static AnnotateStatus _status(Map<String, dynamic> r) =>
      AnnotateStatus.values.asNameMap()[r['status']] ?? AnnotateStatus.labeled;

  static List<Map<String, dynamic>> _selected(Map<String, dynamic> r) => [
    for (final b in (r['boxes'] as List).cast<Map<String, dynamic>>())
      if (b['selected'] == true) b,
  ];

  Shot _shot(Map<String, dynamic> r) {
    final im = r['image'] as Map<String, dynamic>;
    Rect rect(List v) {
      final [x, y, w, h] = [for (final n in v) (n as num).toDouble()];
      return Rect.fromLTWH(x, y, w, h);
    }

    return Shot(
      File('${_dir!.path}/${im['file']}'),
      Size((im['width'] as num).toDouble(), (im['height'] as num).toDouble()),
      [
        for (final b in (r['boxes'] as List).cast<Map<String, dynamic>>())
          EditBox(
            rect: rect(b['bbox'] as List),
            className: b['class'] as String,
            selected: b['selected'] as bool,
            score: (b['score'] as num?)?.toDouble(),
            source:
                BoxSource.values.asNameMap()[b['source']] ?? BoxSource.drawn,
          )..group = b['group'] as int?,
      ],
      cameraPhoto: im['camera_photo'] == true,
    );
  }

  Future<void> _edit(Map<String, dynamic> r) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnnotatePage.edit([_shot(r)], model: widget.model),
      ),
    );
    await _load();
  }

  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      final zip = await Collector.package();
      await SharePlus.instance.share(ShareParams(files: [XFile(zip.path)]));
      await zip.delete();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(_l.annotateDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_l.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await Collector.removeWhere((r) => r['mode'] == 'annotate');
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final records = _records;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_l.annotationData),
        actions: [
          IconButton(
            tooltip: _l.exportAll,
            icon: const Icon(Icons.ios_share),
            onPressed: _busy || (records?.isEmpty ?? true) ? null : _export,
          ),
          PopupMenuButton<void>(
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: records?.isNotEmpty ?? false,
                onTap: _deleteAll,
                child: Text(_l.deleteAll),
              ),
            ],
          ),
        ],
      ),
      body: switch (records) {
        null => const Center(child: CircularProgressIndicator()),
        [] => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_l.noAnnotations, textAlign: TextAlign.center),
          ),
        ),
        final rs => _body(rs, scheme),
      },
    );
  }

  Widget _body(List<Map<String, dynamic>> rs, ColorScheme scheme) {
    final byStatus = {
      for (final s in AnnotateStatus.values)
        s: rs.where((r) => _status(r) == s).length,
    };
    final perClass = <String, int>{};
    for (final r in rs) {
      if (_status(r) != AnnotateStatus.labeled) continue;
      for (final b in _selected(r)) {
        perClass.update(b['class'] as String, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    final classes = perClass.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    Widget stat(int n, String label) => Expanded(
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$n', style: Theme.of(context).textTheme.headlineSmall),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              stat(byStatus[AnnotateStatus.labeled]!, _l.statLabeled),
              stat(byStatus[AnnotateStatus.empty]!, _l.statEmpty),
              stat(byStatus[AnnotateStatus.skipped]!, _l.statSkipped),
            ],
          ),
        ),
        if (classes.isNotEmpty) ...[
          _Header(_l.boxesPerClass),
          for (final MapEntry(key: c, value: n) in classes)
            ListTile(
              dense: true,
              leading: CircleAvatar(radius: 6, backgroundColor: classColor(c)),
              title: Text(classLabel(_l, c)),
              trailing: Text('$n'),
            ),
        ],
        _Header(_l.imagesHeader),
        for (final r in rs)
          ListTile(
            onTap: () => _edit(r),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                File('${_dir!.path}/${r['image']['file']}'),
                width: 40,
                height: 56,
                cacheWidth: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              MaterialLocalizations.of(
                context,
              ).formatMediumDate(DateTime.parse(r['time'] as String).toLocal()),
            ),
            trailing: _Badge(
              switch (_status(r)) {
                AnnotateStatus.labeled => _l.boxCount(_selected(r).length),
                AnnotateStatus.empty => _l.statEmpty,
                AnnotateStatus.skipped => _l.statSkipped,
              },
              switch (_status(r)) {
                AnnotateStatus.labeled => scheme.primaryContainer,
                AnnotateStatus.empty => scheme.surfaceContainerHighest,
                AnnotateStatus.skipped => scheme.tertiaryContainer,
              },
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.labelLarge),
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(text, style: Theme.of(context).textTheme.labelSmall),
  );
}

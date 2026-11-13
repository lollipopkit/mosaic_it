import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import 'boxes.dart';
import 'edit_session.dart';
import 'editor.dart';
import 'l10n.dart';
import 'rust/api.dart';
import 'video_tracks.dart';

/// Analyses a video, lets the user choose which tracks to redact while
/// scrubbing through it, and exports the result.
class VideoPage extends StatefulWidget {
  const VideoPage({
    super.key,
    required this.session,
    required this.video,
    required this.fill,
    this.tempDir = getTemporaryDirectory,
  });

  final Session session;
  final File video;

  /// How tracks are hidden (app settings).
  final Fill fill;

  /// Where keyframe previews and exports on phones go (replaced in tests,
  /// which have no path_provider).
  final Future<Directory> Function() tempDir;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  static final _mobile = Platform.isIOS || Platform.isAndroid;

  late final Directory _cache;
  VideoProject? _project;
  VideoSummary? _summary;

  /// Track indices to redact.
  final Set<int> _on = {};
  int _frame = 0;

  /// One-finger drags draw a region the detector missed.
  bool _drawing = false;

  /// The shown frame as an editor session, rebuilt when the frame or the
  /// tracks change; its boxes map back to tracks.
  EditSession? _frameSession;
  Map<EditBox, int> _byBox = {};

  /// Sound can be as private as pixels, so it is dropped unless asked for.
  bool _keepAudio = false;

  /// Frames processed by the running analysis or export, and its label.
  AppLocalizations get _l => AppLocalizations.of(context);

  (String, int)? _busy;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  @override
  void dispose() {
    _frameSession?.dispose();
    _project?.dispose();
    // Keyframe images of a private video do not outlive the page.
    if (_project != null) _cache.delete(recursive: true).ignore();
    super.dispose();
  }

  Future<void> _analyze() async {
    try {
      final tmp = await widget.tempDir();
      _cache = await tmp.createTemp('video-');
      final p = VideoProject(
        videoPath: widget.video.path,
        cacheDir: _cache.path,
      );
      _project = p;
      await for (final n in p.analyze(session: widget.session)) {
        if (mounted) setState(() => _busy = (_l.analysing, n));
      }
      final s = p.summary();
      if (!mounted) return;
      setState(() {
        _summary = s;
        _busy = null;
        for (final (i, t) in s.tracks.indexed) {
          if (t.state == RegionState.selected) _on.add(i);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = null;
          _error = '$e';
        });
      }
    }
  }

  List<(int, EditBox)> _boxes(VideoProject p, VideoSummary s) => [
    for (final b in p.boxesAt(frame: _frame))
      (
        b.track,
        EditBox(
          rect: Rect.fromLTRB(
            b.rect.left,
            b.rect.top,
            b.rect.right,
            b.rect.bottom,
          ),
          className: s.tracks[b.track].className,
          selected: _on.contains(b.track),
          review: s.tracks[b.track].state == RegionState.review,
          suggested: s.tracks[b.track].state == RegionState.suggested,
          // Video boxes are not collected; tracks keep their own origin.
          source: BoxSource.detector,
        ),
      ),
  ];

  Future<void> _addManual(Rect r) async {
    final p = _project;
    if (p == null) return;
    setState(() => _busy = (_l.followingRegion, 0));
    try {
      final i = await p.addManual(
        frame: _frame,
        rect: PixelRect(
          left: r.left,
          top: r.top,
          right: r.right,
          bottom: r.bottom,
        ),
      );
      final s = p.summary();
      if (!mounted) return;
      setState(() {
        _summary = s;
        _on.add(i);
        _drawing = false;
      });
      final (start, end) = trackSpan(s.tracks[i], s.keyframes, s.frames);
      _toast(_l.redactingSpan(clock(s.times[start]), clock(s.times[end - 1])));
    } catch (e) {
      if (mounted) _toast('$e');
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  void _toggle(int track, bool on) =>
      setState(() => on ? _on.add(track) : _on.remove(track));

  Future<void> _export({bool force = false}) async {
    final p = _project, s = _summary;
    if (p == null || s == null) return;
    final stem = widget.video.uri.pathSegments.last.replaceAll(
      RegExp(r'\.[^.]+$'),
      '',
    );
    final String out;
    if (_mobile) {
      out = '${_cache.path}/$stem-redacted.mp4';
    } else {
      final loc = await getSaveLocation(
        suggestedName: '$stem-redacted.mp4',
        acceptedTypeGroups: const [
          XTypeGroup(label: 'MP4', extensions: ['mp4']),
        ],
      );
      if (loc == null) return;
      out = loc.path;
    }
    ExportResult? result;
    try {
      await for (final e in p.export_(
        session: widget.session,
        outPath: out,
        opts: VideoExportOptions(
          tracks: Uint32List.fromList(_on.toList()..sort()),
          fill: widget.fill,
          keepAudio: _keepAudio,
          force: force,
        ),
      )) {
        if (mounted) setState(() => _busy = (_l.exporting, e.frames));
        result = e.result ?? result;
      }
    } catch (e) {
      if (mounted) _toast('$e');
      return;
    } finally {
      if (mounted) setState(() => _busy = null);
    }
    final r = result;
    if (r == null || !mounted) return;
    if (r.written) {
      if (_mobile) {
        await SharePlus.instance.share(ShareParams(files: [XFile(out)]));
      } else {
        _toast(_keepAudio ? _l.exportedTo(out) : _l.exportedToNoAudio(out));
      }
      return;
    }
    final f = r.failed!;
    final action = await showDialog<_Failed>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_l.exportCheckFailedAt(clock(s.times[f.frame]))),
        content: Text(
          _l.videoRegionsVisible(
            f.surviving.length,
            f.surviving
                .map((r) => classLabel(_l, r.className))
                .toSet()
                .join(', '),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _Failed.force),
            child: Text(_l.exportAnyway),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, _Failed.show),
            child: Text(_l.showFrame),
          ),
        ],
      ),
    );
    switch (action) {
      case _Failed.show:
        setState(() => _frame = f.frame);
      case _Failed.force:
        await _export(force: true);
      case null:
    }
  }

  void _toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final p = _project, s = _summary, busy = _busy;
    final narrow = MediaQuery.sizeOf(context).width < 700;
    final tracks = s == null
        ? null
        : _TrackList(
            summary: s,
            keepAudio: _keepAudio,
            onKeepAudio: (v) => setState(() => _keepAudio = v),
            on: _on,
            onToggle: _toggle,
            onJump: (f) => setState(() => _frame = f),
          );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.uri.pathSegments.last),
        actions: [
          if (s != null)
            IconButton(
              tooltip: _l.drawMissedRegion,
              isSelected: _drawing,
              icon: const Icon(Icons.crop_square),
              onPressed: () => setState(() => _drawing = !_drawing),
            ),
          if (s != null)
            IconButton(
              tooltip: _l.export,
              icon: const Icon(Icons.ios_share),
              onPressed: busy == null ? _export : null,
            ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: narrow && tracks != null
          ? Drawer(width: 300, child: SafeArea(child: tracks))
          : null,
      body: Column(
        children: [
          if (busy != null)
            LinearProgressIndicator(
              value: s == null || s.frames == 0 ? null : busy.$2 / s.frames,
            ),
          if (busy != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_l.busyFrames(busy.$1, busy.$2)),
            ),
          if (_error case final e?) Expanded(child: Center(child: Text(e))),
          if (p != null && s != null) ...[
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _preview(p, s)),
                  if (!narrow && tracks != null)
                    SizedBox(width: 300, child: tracks),
                ],
              ),
            ),
            _Scrubber(
              summary: s,
              frame: _frame,
              onFrame: (f) => setState(() => _frame = f),
            ),
          ],
        ],
      ),
    );
  }

  Widget _preview(VideoProject p, VideoSummary s) {
    final boxes = _boxes(p, s);
    _byBox = {for (final (t, b) in boxes) b: t};
    final shot = Shot(
      File(p.previewPath(frame: _frame)),
      Size(s.width.toDouble(), s.height.toDouble()),
      [for (final (_, b) in boxes) b],
    );
    // Disposed after the editor has moved to the new session.
    final old = _frameSession;
    WidgetsBinding.instance.addPostFrameCallback((_) => old?.dispose());
    final handled = <EditBox>{};
    final session = _frameSession = EditSession([shot])
      ..addListener(() => _frameChanged(shot, handled));
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: BoxEditor(
        // One view (fit, zoom) for the whole video.
        key: ValueKey(widget.video.path),
        session: session,
        kind: EditorKind.redact,
        drawing: _drawing,
        fill: widget.fill,
      ),
    );
  }

  /// A tapped box toggles its track; a drawn box becomes a manual track.
  void _frameChanged(Shot shot, Set<EditBox> handled) {
    for (final b in shot.boxes) {
      final t = _byBox[b];
      if (t == null) {
        if (handled.add(b)) _addManual(b.rect);
      } else if (b.selected != _on.contains(t)) {
        _toggle(t, b.selected);
      }
    }
  }
}

enum _Failed { show, force }

class _Scrubber extends StatelessWidget {
  const _Scrubber({
    required this.summary,
    required this.frame,
    required this.onFrame,
  });

  final VideoSummary summary;
  final int frame;
  final ValueChanged<int> onFrame;

  @override
  Widget build(BuildContext context) {
    final last = summary.frames - 1;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Text(clock(summary.times[frame])),
            Expanded(
              child: Slider(
                value: frame.toDouble(),
                max: last.toDouble().clamp(1, double.infinity),
                onChanged: last == 0 ? null : (v) => onFrame(v.round()),
              ),
            ),
            Text(clock(summary.times[last])),
          ],
        ),
      ),
    );
  }
}

/// Tracks with a redact switch and where they appear in the video.
class _TrackList extends StatelessWidget {
  const _TrackList({
    required this.summary,
    required this.keepAudio,
    required this.onKeepAudio,
    required this.on,
    required this.onToggle,
    required this.onJump,
  });

  final VideoSummary summary;
  final bool keepAudio;
  final ValueChanged<bool> onKeepAudio;
  final Set<int> on;
  final void Function(int track, bool on) onToggle;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    final scheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    return Material(
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              l.tracksSummary(on.length, s.tracks.length, s.keyframes.length),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (s.hasAudio)
            SwitchListTile(
              dense: true,
              value: keepAudio,
              onChanged: onKeepAudio,
              title: Text(l.keepAudio),
              subtitle: Text(l.keepAudioHint),
            ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: s.tracks.length,
              itemBuilder: (context, i) {
                final t = s.tracks[i];
                final (start, end) = trackSpan(t, s.keyframes, s.frames);
                final c = classColor(t.className);
                return CheckboxListTile(
                  dense: true,
                  value: on.contains(i),
                  onChanged: (v) => onToggle(i, v ?? false),
                  secondary: IconButton(
                    tooltip: l.goToFirstAppearance,
                    icon: const Icon(Icons.my_location, size: 18),
                    onPressed: () => onJump(start),
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(radius: 5, backgroundColor: c),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          classLabel(l, t.className),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (t.state == RegionState.review) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.help_outline, size: 14, color: scheme.error),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${clock(s.times[start])} – '
                        '${clock(end < s.frames ? s.times[end] : s.times.last)}',
                      ),
                      const SizedBox(height: 4),
                      _Span(start: start, end: end, frames: s.frames, color: c),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Where a track is on screen, along the whole video.
class _Span extends StatelessWidget {
  const _Span({
    required this.start,
    required this.end,
    required this.frames,
    required this.color,
  });

  final int start, end, frames;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 4,
    child: LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth / frames;
        return Stack(
          children: [
            Container(color: color.withValues(alpha: 0.15)),
            Positioned(
              left: start * w,
              width: ((end - start) * w).clamp(2, c.maxWidth),
              top: 0,
              bottom: 0,
              child: Container(color: color),
            ),
          ],
        );
      },
    ),
  );
}

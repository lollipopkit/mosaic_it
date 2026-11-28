import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:fl_lib/fl_lib.dart'
    show ContextMenuAction, Frosted, ScreenEdge, SystemBars, showContextMenu;
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import 'adaptive_prefs.dart';
import 'boxes.dart';
import 'edit_session.dart';
import 'editor.dart';
import 'editor_menus.dart';
import 'feedback.dart';
import 'feedback_sheet.dart';
import 'intro_page.dart';
import 'model_store.dart';
import 'platform_bridge.dart';
import 'rust/api.dart';
import 'settings.dart';

/// Main workspace: opens directly into the redaction editor, lets the user pick
/// photos via the OS picker (zero photo-library read permission), and accepts
/// image files shared or dropped from the OS.
class EditorPage extends StatefulWidget {
  const EditorPage({
    super.key,
    this.shots,
    this.settings,
    this.model,
    this.info,
  });

  /// Pre-loaded shots (optional; used by widget tests).
  final List<Shot>? shots;
  final AppSettings? settings;
  final Session? model;
  final ModelInfo? info;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  static final _mobile = Platform.isIOS || Platform.isAndroid;
  static const _videoExts = {
    'mp4',
    'mov',
    'm4v',
    'mkv',
    'webm',
    'avi',
    '3gp',
    '3g2',
    'mpg',
    'mpeg',
    'ts',
  };
  static const _imageExts = {
    'png',
    'jpg',
    'jpeg',
    'webp',
    'heic',
    'heif',
    'bmp',
    'tif',
    'tiff',
    'gif',
  };
  static const _screenshots = bool.fromEnvironment('SCREENSHOTS');

  Session? _model;
  ModelInfo? _info;
  late AppSettings _settings;
  bool _hasCustomModel = false;
  EditSession? _editSession;

  /// On from the start: a missed value is one drag away; two fingers move
  /// the view.
  bool _drawing = true;
  bool _peeking = false;
  final _peekPointers = <int>{};
  late final AppLifecycleListener _lifecycle;

  /// Where the system puts bars of our controls along each edge.
  final _systemBars = SystemBars.watch({
    for (final e in ScreenEdge.values) e: _control,
  });
  String? _busy;
  bool _picking = false;
  bool _exporting = false;

  /// Taps on boxes merge them into [_mergeFrom] (the first one tapped when
  /// merging started without an active box).
  bool _merging = false;
  EditBox? _mergeFrom;

  /// The editor's area, to place a box's menu under the box.
  final _viewKey = GlobalKey();

  /// Shots already fed into [AdaptivePrefs.recordExport] during this editor
  /// session so repeated exports (e.g. Save then Share) do not double-count.
  final _learnedShots = <Shot>{};

  /// External file batches received before the model finished loading or while
  /// another batch or export is in flight.
  final _pendingIncoming = <String>[];
  final _incomingQueue = <List<String>>[];
  bool _drainingIncoming = false;
  bool _coldDrained = false;
  StreamSubscription<List<String>>? _incomingSub;

  AppLocalizations get _l => AppLocalizations.of(context);
  bool get _standalone => widget.shots == null;

  @override
  void initState() {
    super.initState();
    _settings =
        widget.settings ??
        AppSettings(fillStyle: FillStyle.solid, fillColor: 0x000000);
    _model = widget.model;
    _info = widget.info;
    if (widget.shots case final initial? when initial.isNotEmpty) {
      _editSession = EditSession(initial)..addListener(_changed);
    }
    _systemBars.addListener(_barsChanged);
    _lifecycle = AppLifecycleListener(
      onInactive: _stopPeeking,
      onHide: _stopPeeking,
    );
    if (_standalone) {
      _incomingSub = PlatformBridge.incomingFiles.listen(_handleIncomingPaths);
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAndDrain());
    }
  }

  Future<void> _loadAndDrain() async {
    await _loadModel();
    if (!mounted || _model == null || _info == null || _coldDrained) return;
    _coldDrained = true;
    final cold = await PlatformBridge.drainIncomingFiles();
    final launch = _screenshots ? await _launchFiles() : const <String>[];
    if (!mounted) return;
    final initial = <String>[..._pendingIncoming, ...cold, ...launch];
    _pendingIncoming.clear();
    if (initial.isNotEmpty) {
      _enqueueIncoming(initial);
    }
  }

  /// Builds with `--dart-define=SCREENSHOTS=true` open the images in
  /// `tmp/launch_files` at start, for scripted store screenshots
  /// (tool/appstore/shoot.sh).
  static Future<List<String>> _launchFiles() async {
    final dir = Directory('${Directory.systemTemp.path}/launch_files');
    if (!await dir.exists()) return const [];
    return [
      await for (final f in dir.list())
        if (f is File &&
            _imageExts.contains(PlatformBridge.extensionOf(f.path)))
          f.path,
    ]..sort();
  }

  void _barsChanged() => setState(() {});

  void _stopPeeking() {
    _peekPointers.clear();
    if (_peeking && mounted) setState(() => _peeking = false);
  }

  @override
  void deactivate() {
    _peekPointers.clear();
    _peeking = false;
    super.deactivate();
  }

  @override
  void dispose() {
    _incomingSub?.cancel();
    _systemBars.removeListener(_barsChanged);
    _lifecycle.dispose();
    _editSession?.removeListener(_changed);
    _editSession?.dispose();
    super.dispose();
  }

  void _changed() => setState(() {
    final s = _editSession;
    if (s == null) return;
    // A merge starts from a box of the shown shot (gone after a shot
    // switch, delete or undo).
    if (_mergeFrom case final m? when !s.shot.boxes.contains(m)) {
      _mergeFrom = null;
    }
  });

  void _toast(String text, {SnackBarAction? action}) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text), action: action));

  Future<void> _run(String label, Future<void> Function() f) async {
    setState(() => _busy = label);
    try {
      await f();
    } catch (e) {
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) _toast(_message(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  String _message(Object e) => switch (e) {
    ModelPickError(sidecarFor: final m?) => _l.pickSidecar(m),
    ModelPickError() => _l.pickOneModel(modelExtensions.join(' / ')),
    _ => '$e',
  };

  List<String> get _classes => [...?_info?.classes, manualClass];

  // --- model & settings ----------------------------------------------------

  Future<void> _loadModel() => _run(_l.loadingModel, () async {
    final settings = await AppSettings.load();
    final hasCustom = await ModelStore.hasCustomModel();
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _hasCustomModel = hasCustom;
    });
    Session? s;
    try {
      s = await ModelStore.takePreloadedOrLoad();
    } catch (e) {
      if (hasCustom) {
        await ModelStore.clearCustom();
        if (mounted) setState(() => _hasCustomModel = false);
        s = await ModelStore.load();
      } else {
        throw StateError(_l.savedModelFailed('$e'));
      }
    }
    if (mounted) _setSession(s);
  });

  void _setSession(Session? s) => setState(() {
    if (s != null) _settings.applyTo(s);
    _model = s;
    _info = s?.info();
  });

  Future<bool> _chooseModel() async {
    final files = await openFiles(
      acceptedTypeGroups: [
        Platform.isIOS
            ? XTypeGroup(
                label: _l.modelFileType,
                uniformTypeIdentifiers: const ['public.data'],
              )
            : Platform.isAndroid
            ? XTypeGroup(label: _l.modelFileType, mimeTypes: const ['*/*'])
            : XTypeGroup(
                label: _l.modelFileType,
                extensions: [
                  for (final e in modelExtensions) e.substring(1),
                  'json',
                ],
              ),
      ],
      confirmButtonText: _l.useModel,
    );
    if (files.isEmpty) return false;
    var ok = false;
    await _run(_l.loadingModel, () async {
      final s = await ModelStore.importAndOpen([for (final x in files) x.path]);
      if (!mounted) return;
      setState(() => _hasCustomModel = true);
      _setSession(s);
      ok = true;
    });
    return ok;
  }

  Future<void> _resetBundledModel() => _run(_l.loadingModel, () async {
    await ModelStore.clearCustom();
    final s = await ModelStore.load();
    if (!mounted) return;
    setState(() => _hasCustomModel = false);
    _setSession(s);
  });

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsPage(
          settings: _settings,
          classes: _info?.classes ?? const [],
          info: _info,
          model: _model,
          hasCustomModel: _hasCustomModel,
          onChooseModel: _chooseModel,
          onResetModel: _resetBundledModel,
        ),
      ),
    );
    if (!mounted) return;
    if (_model case final s?) _settings.applyTo(s);
    setState(() {});
    _maybeDrainIncoming();
  }

  // --- picking & incoming files --------------------------------------------

  void _handleIncomingPaths(List<String> paths) {
    if (!mounted || paths.isEmpty) return;
    if (_model == null || _info == null) {
      _pendingIncoming.addAll(paths);
      return;
    }
    _enqueueIncoming(paths);
  }

  void _enqueueIncoming(List<String> paths) {
    _incomingQueue.add(paths);
    _maybeDrainIncoming();
  }

  void _maybeDrainIncoming() {
    if (_drainingIncoming || _exporting || _busy != null) return;
    if (_incomingQueue.isEmpty || !mounted) return;
    unawaited(_drainIncomingQueue());
  }

  Future<void> _drainIncomingQueue() async {
    _drainingIncoming = true;
    try {
      while (_incomingQueue.isNotEmpty && mounted) {
        if (_exporting || _busy != null) break;
        final batch = _incomingQueue.removeAt(0);
        final openedVideo = await _openPaths(batch);
        // Stop draining after pushing VideoPage so queued batches do not
        // immediately dismiss it; any newer incoming event will re-trigger.
        if (openedVideo) break;
      }
    } finally {
      _drainingIncoming = false;
    }
  }

  static bool _isVideoPath(String path) =>
      _videoExts.contains(PlatformBridge.extensionOf(path));

  Shot _prepareShot(File image, Detected detected) {
    final shot = Shot.detected(image, detected);
    AdaptivePrefs.instance.apply(
      shot,
      enabled: _settings.adaptivePreselect,
      offClasses: _settings.offClasses,
      preset: _settings.threshold,
      baseThresholds: _info?.selectThresholds ?? const {},
    );
    return shot;
  }

  /// Opens the native zero-permission media picker (PHPicker on iOS, Photo
  /// Picker on Android, file dialog on desktop).
  Future<void> _pickMedia() async {
    if (_picking || _busy != null || _exporting) return;
    if (_model == null || _info == null) {
      _toast(_l.chooseModelFirst);
      return;
    }
    _picking = true;
    final List<String> paths;
    try {
      if (_mobile) {
        if (!await confirmFirstPickerIfRestricted(context) || !mounted) return;
        // TODO: re-enable allowVideo once native video model I/O is supported.
        paths = await PlatformBridge.pickMedia(
          multiple: true,
          allowVideo: false,
        );
      } else {
        final picked = await openFiles(
          acceptedTypeGroups: [
            XTypeGroup(
              label: _l.imagesFileType,
              extensions: _imageExts.toList(),
            ),
          ],
        );
        paths = [for (final x in picked) x.path];
      }
    } catch (e) {
      if (mounted) _toast('$e');
      return;
    } finally {
      _picking = false;
    }
    if (paths.isEmpty || !mounted) return;
    _enqueueIncoming(paths);
  }

  /// Opens image [paths] in the editor. Video files are ignored until native
  /// video model I/O is supported.
  Future<bool> _openPaths(List<String> paths) async {
    final s = _model, info = _info;
    if (s == null || info == null || !mounted) return false;
    final files = [
      for (final p in paths)
        if (File(p).existsSync()) File(p),
    ];
    if (files.isEmpty) return false;
    Navigator.of(context).popUntil((r) => r.isFirst);
    if (!mounted) return false;

    // TODO: route video files to VideoPage once native video model I/O lands.
    final images = [
      for (final f in files)
        if (!_isVideoPath(f.path)) f,
    ];
    if (images.isEmpty) return false;

    final shots = <Shot>[];
    Object? firstError;
    await _run(_l.detecting, () async {
      for (final (i, image) in images.indexed) {
        if (!mounted) return;
        if (images.length > 1) {
          setState(() => _busy = _l.detectingProgress(i + 1, images.length));
        }
        try {
          final preparedPath = await PlatformBridge.prepareImage(image.path);
          final prepared = File(preparedPath);
          final d = await s.detect(imagePath: prepared.path);
          shots.add(_prepareShot(prepared, d));
        } catch (e) {
          firstError ??= e;
        }
      }
      if (shots.isEmpty && firstError != null) {
        throw firstError!;
      }
    });
    if (shots.isEmpty || !mounted) return false;
    if (firstError != null) {
      _toast(_message(firstError!));
    }
    final next = EditSession(shots)..addListener(_changed);
    final prev = _editSession;
    setState(() {
      _editSession = next;
      _merging = false;
      _mergeFrom = null;
      _peekPointers.clear();
      _peeking = false;
      _learnedShots.clear();
    });
    prev?.removeListener(_changed);
    prev?.dispose();
    return false;
  }

  // --- boxes --------------------------------------------------------------

  Future<void> _pickClass(EditBox b) async {
    final s = _editSession;
    if (s == null) return;
    final c = await showClassSheet(context, _classes, b.className);
    if (c != null) s.reclass(b, c);
  }

  void _startMerge(EditBox? from) => setState(() {
    _merging = true;
    _mergeFrom = from;
  });

  void _mergePick(EditBox? b) {
    final s = _editSession;
    if (s == null) return;
    setState(() {
      if (b == null) {
        _merging = false;
        _mergeFrom = null;
      } else if (_mergeFrom case final from?) {
        s.merge(from, b);
      } else {
        _mergeFrom = b;
        s.active = b;
      }
    });
  }

  /// Selects or adds every region in the batch that looks like [f] (same
  /// render scale assumed, as for screenshots from one device).
  Future<void> _findSimilar(EditBox f) async {
    final s = _editSession;
    if (s == null) return;
    final src = s.shot;
    await _run(_l.findingSimilar, () async {
      final rect = PixelRect(
        left: f.rect.left,
        top: f.rect.top,
        right: f.rect.right,
        bottom: f.rect.bottom,
      );
      var found = 0, added = 0;
      for (final shot in s.shots) {
        final hits = await findSimilarRegions(
          imagePath: src.image.path,
          rect: rect,
          targetPath: shot.image.path,
        );
        if (hits.isEmpty) continue;
        found += hits.length;
        s.record(shot);
        added += mergeFound(shot.boxes, [
          for (final m in hits) Rect.fromLTRB(m.left, m.top, m.right, m.bottom),
        ], f.className);
      }
      s.changed();
      if (mounted) {
        _toast(
          s.shots.length > 1
              ? _l.similarSelectedAcross(found, added, s.shots.length)
              : _l.similarSelected(found, added),
        );
      }
    });
    _maybeDrainIncoming();
  }

  // --- menus --------------------------------------------------------------

  /// The menu of [b], under its place [r] in the editor.
  void _boxMenu(EditBox b, Rect r) {
    final s = _editSession;
    if (s == null) return;
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
          onTap: () => s.split(b),
        ),
      ContextMenuAction(
        text: _l.delete,
        icon: Icons.delete_outline,
        destructive: true,
        onTap: () => s.remove(b),
      ),
    ]);
  }

  Future<void> _openFeedback([Shot? shot]) {
    if (!mounted) return Future.value();
    return showFeedbackSheet(
      context,
      shot: shot ?? _editSession?.shot,
      model: _model,
      info: _info,
    );
  }

  Future<void> _openExport() async {
    final s = _editSession;
    if (s == null || _exporting) return;
    _exporting = true;
    try {
      final target = await showExportSheet(
        context,
        settings: _settings,
        images: s.shots.length,
        regions: s.selectedCount,
        feedbackDiffCount: FeedbackDraft(shot: s.shot).rawDiffCount,
      );
      if (target == null || !mounted) return;
      if (target == ExportTarget.feedback) {
        await _openFeedback();
        return;
      }
      try {
        await _export(target);
      } catch (e) {
        if (mounted) _toast('$e');
      }
    } finally {
      _exporting = false;
      _maybeDrainIncoming();
    }
  }

  // --- export -------------------------------------------------------------

  static String _stem(Shot s) => s.name.replaceAll(RegExp(r'\.[^.]+$'), '');

  /// Generates unique filenames within a single batch so identically stemmed
  /// files (e.g. `IMG_001.jpg` and `IMG_001.png`) never overwrite each other.
  static Map<Shot, String> _uniqueTargets(
    List<Shot> shots,
    String dir,
    String ext,
  ) {
    final used = <String, int>{};
    final out = <Shot, String>{};
    for (final shot in shots) {
      final base = '${_stem(shot)}-redacted';
      final n = (used[base] ?? 0) + 1;
      used[base] = n;
      final fileName = n == 1 ? '$base.$ext' : '$base-$n.$ext';
      out[shot] = '$dir/$fileName';
    }
    return out;
  }

  static Future<void> _deleteTempFiles(Iterable<String> paths) async {
    for (final p in paths) {
      try {
        await File(p).delete();
      } catch (_) {}
    }
  }

  Future<void> _export(ExportTarget target) async {
    final s = _editSession;
    if (s == null) return;
    final shots = s.shots;
    final ext = _settings.exportFormat.extension;
    final usesTempDir = _mobile || target == ExportTarget.copy;
    final Map<Shot, String> targets;
    if (usesTempDir) {
      final dir = await getTemporaryDirectory();
      targets = _uniqueTargets(shots, dir.path, ext);
    } else if (shots.length == 1) {
      final shot = shots.single;
      final loc = await getSaveLocation(
        suggestedName: '${_stem(shot)}-redacted.$ext',
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
      targets = _uniqueTargets(shots, dir, ext);
    }
    final written = <Shot, String>{};
    for (final MapEntry(key: shot, value: out) in targets.entries) {
      if (!await _write(shot, out)) {
        if (usesTempDir) await _deleteTempFiles(written.values);
        if (mounted && shots.length > 1) _toast(_l.exportStoppedAt(shot.name));
        return;
      }
      written[shot] = out;
    }
    if (!mounted) {
      if (usesTempDir) await _deleteTempFiles(written.values);
      return;
    }
    final editedShot = written.keys
        .where((shot) => FeedbackDraft(shot: shot).rawDiffCount > 0)
        .firstOrNull;
    final feedbackAction = editedShot == null
        ? null
        : SnackBarAction(
            label: _l.feedbackAction,
            onPressed: () {
              if (mounted) _openFeedback(editedShot);
            },
          );
    switch (target) {
      case ExportTarget.copy:
        final outPath = written.values.first;
        var ok = false;
        try {
          ok = await PlatformBridge.copyImageToClipboard(outPath);
        } finally {
          await _deleteTempFiles(written.values);
        }
        if (mounted) {
          _toast(
            ok ? _l.copiedToClipboard : _l.copyFailed,
            action: ok ? feedbackAction : null,
          );
        }
      case ExportTarget.share:
        await SharePlus.instance.share(
          ShareParams(files: [for (final p in written.values) XFile(p)]),
        );
      case ExportTarget.photos:
        await _run(_l.saving, () async {
          var savedCount = 0;
          try {
            for (final p in written.values) {
              final ok = await PlatformBridge.saveImageToPhotos(p);
              if (!ok) break;
              savedCount++;
            }
          } finally {
            await _deleteTempFiles(written.values);
          }
          if (mounted) {
            if (savedCount == written.length) {
              _toast(_l.savedToPhotos(savedCount), action: feedbackAction);
            } else if (savedCount > 0) {
              _toast('${_l.savedToPhotos(savedCount)} · ${_l.saveFailed}');
            } else {
              _toast(_l.saveFailed);
            }
          }
        });
      case ExportTarget.files:
        _toast(
          written.length == 1
              ? _l.exportedTo(written.values.single)
              : _l.exportedImages(written.length),
          action: feedbackAction,
        );
      case ExportTarget.feedback:
        break;
    }
  }

  /// Redacts [shot] into [out] after the self-check. When the check finds
  /// readable areas the user redacts them too, looks at them, or overrides;
  /// returns whether the file was written.
  Future<bool> _write(Shot shot, String out, {bool force = false}) async {
    final s = _editSession;
    final model = _model;
    if (s == null || model == null) return false;
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
    final maxSide = _settings.exportMaxSide;
    ExportOutcome? r;
    await _run(
      s.shots.length > 1
          ? _l.checkingImage(shot.name)
          : _l.checkingAndExporting,
      () async {
        r = await model.redactAndExport(
          imagePath: shot.image.path,
          outPath: out,
          rects: rects,
          fill: _settings.fill,
          force: force,
          maxSide: maxSide == 0 ? null : maxSide,
        );
      },
    );
    final res = r;
    if (res == null || !mounted) return false;
    if (res.written) {
      if (_learnedShots.add(shot)) {
        await AdaptivePrefs.instance.recordExport(
          shot,
          enabled: _settings.adaptivePreselect,
          offClasses: _settings.offClasses,
        );
      }
      return true;
    }
    s.index = s.shots.indexOf(shot);
    final action = await _showCheck(shot, chosen, rects, res);
    if (!mounted) return false;
    switch (action) {
      case CheckAction.add || CheckAction.show:
        final add = action == CheckAction.add;
        s.record(shot);
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
        s.changed();
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
    final s = _editSession;
    if (s == null) return null;
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
      fill: _settings.fill,
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
        index: s.shots.length > 1 ? s.shots.indexOf(shot) + 1 : null,
        canAdd: res.surviving.isNotEmpty,
      );
    } finally {
      image.dispose();
      for (final (_, im) in patches) {
        im.dispose();
      }
    }
  }

  // --- layout -------------------------------------------------------------

  /// Thickness of the bars over the image. They sit above and below it, or
  /// beside it when the view is wider than tall, centred on the line the
  /// system lays bars of [_control]-sized buttons on.
  static const _actionBar = 60.0, _toolBar = 68.0, _toolRail = 78.0;
  static const _control = 44.0;
  static const _strip = BatchStrip.height;

  /// Tools stay within thumb reach on large screens.
  static const _toolBarMaxExtent = 520.0;

  @override
  Widget build(BuildContext context) {
    final s = _editSession;
    final scheme = Theme.of(context).colorScheme;
    final inset = MediaQuery.paddingOf(context);
    final size = MediaQuery.sizeOf(context);
    final wide = size.width > size.height;
    final batch = s != null && s.shots.length > 1;
    final axis = wide ? Axis.vertical : Axis.horizontal;
    final system = _validSystemBars(size);
    // Side insets this uneven on a device reporting system bars are a column
    // (iPhone Duo) that is empty but for a camera and the status bar: the
    // actions run down it, clear of them, and when wide the tools take the
    // other side. Even insets hold a camera cutout in their middle.
    final inStatus = system.isNotEmpty && (inset.left - inset.right).abs() > 32;
    final railAxis = wide || inStatus ? Axis.vertical : Axis.horizontal;
    final actionsRight = inStatus && inset.right > inset.left;
    final bar = _bars(size, inset, system);
    final actionsBar = bar[actionsRight ? ScreenEdge.right : ScreenEdge.left]!;
    final toolsBar = bar[actionsRight ? ScreenEdge.left : ScreenEdge.right]!;
    final topBar = bar[ScreenEdge.top]!, bottomBar = bar[ScreenEdge.bottom]!;
    final shot = s?.shot;
    final active = s?.active;
    final selected = shot == null
        ? 0
        : shot.boxes.where((b) => b.selected).length;
    final idle = _busy == null;
    final ready = idle && _model != null;
    final failed = idle && _model == null && _standalone;
    Widget gap(double v) => SizedBox(width: v, height: v);
    Widget round(Widget button) => Frosted(
      shape: const CircleBorder(),
      child: SizedBox.square(dimension: 44, child: Center(child: button)),
    );

    final undoRedo = Frosted(
      child: Flex(
        direction: railAxis,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (tip, icon, enabled, onPressed) in [
            (_l.undo, Icons.undo, s?.canUndo ?? false, s?.undo),
            (_l.redo, Icons.redo, s?.canRedo ?? false, s?.redo),
          ])
            IconButton(
              constraints: BoxConstraints.tight(
                railAxis == Axis.vertical
                    ? const Size(44, 40)
                    : const Size(40, 44),
              ),
              padding: EdgeInsets.zero,
              tooltip: tip,
              icon: Icon(icon, size: 20),
              onPressed: enabled ? onPressed : null,
            ),
        ],
      ),
    );

    final peek = () {
      final enabled = shot != null;
      final button = Semantics(
        button: true,
        enabled: enabled,
        label: shot == null
            ? _l.peekOriginal
            : '${_l.peekOriginal}, ${_l.selectedOf(selected, shot.boxes.length)}',
        child: IgnorePointer(
          ignoring: !enabled,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (e) {
              _peekPointers.add(e.pointer);
              if (!_peeking) setState(() => _peeking = true);
            },
            onPointerUp: (e) => _peekUp(e.pointer),
            onPointerCancel: (e) => _peekUp(e.pointer),
            child: SizedBox.square(
              dimension: 44,
              child: Center(
                child: Icon(
                  _peeking ? Icons.visibility : Icons.visibility_outlined,
                  size: 20,
                  color: !enabled
                      ? scheme.onSurface.withValues(alpha: .38)
                      : _peeking
                      ? scheme.primary
                      : null,
                ),
              ),
            ),
          ),
        ),
      );
      return Badge.count(
        count: selected,
        isLabelVisible: enabled,
        offset: const Offset(-6, 4),
        backgroundColor: scheme.primary,
        textColor: scheme.onPrimary,
        child: Frosted(
          shape: const CircleBorder(),
          child: _mobile
              ? button
              : Tooltip(message: _l.peekOriginal, child: button),
        ),
      );
    }();

    Widget buildActionsFlex({required bool compact}) => Flex(
      direction: railAxis,
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        round(
          IconButton(
            padding: EdgeInsets.zero,
            tooltip: _l.selectMedia,
            onPressed: ready ? _pickMedia : null,
            icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
          ),
        ),
        gap(4),
        undoRedo,
        if (compact) gap(12) else const Spacer(),
        peek,
        gap(4),
        round(
          IconButton(
            padding: EdgeInsets.zero,
            tooltip: _l.settings,
            onPressed: idle ? _openSettings : null,
            icon: const Icon(Icons.settings_outlined, size: 20),
          ),
        ),
        gap(4),
        IconButton.filled(
          style: const ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size.square(44)),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          tooltip: _l.export,
          onPressed: idle && s != null ? _openExport : null,
          icon: Transform.translate(
            offset: const Offset(0, -1),
            child: const Icon(Icons.ios_share, size: 19),
          ),
        ),
      ],
    );
    // In a column or a short rail, centred and scaled down so it never overflows.
    final actions = inStatus
        ? Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: buildActionsFlex(compact: true),
            ),
          )
        : wide
        ? LayoutBuilder(
            builder: (context, c) => c.maxHeight < 280
                ? Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: buildActionsFlex(compact: true),
                    ),
                  )
                : buildActionsFlex(compact: false),
          )
        : buildActionsFlex(compact: false);

    final toolButtons = [
      ToolButton(
        icon: Icons.highlight_alt,
        label: _l.modeDraw,
        selected: s != null && _drawing && !_merging,
        onTap: s == null
            ? null
            : () => setState(() {
                _drawing = _merging || !_drawing;
                _merging = false;
                _mergeFrom = null;
              }),
      ),
      ToolButton(
        icon: Icons.filter_none,
        label: _l.similar,
        onTap: s == null || active == null || !idle
            ? null
            : () => _findSimilar(active),
      ),
      ToolButton(
        icon: Icons.join_inner,
        label: _l.merge,
        selected: s != null && _merging,
        onTap: s == null
            ? null
            : () => _merging ? _mergePick(null) : _startMerge(active),
      ),
      ToolButton(
        icon: Icons.flag_outlined,
        label: _l.feedbackShort,
        onTap: idle ? _openFeedback : null,
      ),
    ];
    final tools = Frosted(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: wide
            ? SizedBox(
                width: 56,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final t in toolButtons)
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 56),
                          child: SizedBox(height: 56, child: t),
                        ),
                      ),
                  ],
                ),
              )
            : SizedBox(
                height: 46,
                child: Row(
                  children: [for (final t in toolButtons) Expanded(child: t)],
                ),
              ),
      ),
    );
    final toolBar = Container(
      constraints: wide
          ? null
          : const BoxConstraints(maxWidth: _toolBarMaxExtent),
      padding: const EdgeInsets.all(8),
      child: Flex(
        direction: axis,
        mainAxisAlignment: wide
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Frosted(
            shape: const CircleBorder(),
            child: SizedBox.square(
              dimension: 52,
              child: IconButton(
                tooltip: _l.fillStyle,
                onPressed: () =>
                    showFillSheet(context, _settings, () => setState(() {})),
                icon: FillSwatch(
                  style: _settings.fillStyle,
                  color: _settings.fillColor,
                  size: 24,
                ),
              ),
            ),
          ),
          if (wide)
            Flexible(child: tools)
          else ...[
            gap(8),
            Expanded(child: tools),
            gap(8),
          ],
          Badge.count(
            count: selected,
            isLabelVisible: s != null,
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
                  onPressed: s == null
                      ? null
                      : () => showRegionSheet(context, s),
                  icon: const Icon(Icons.tune),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final strip = batch
        ? BatchStrip(
            shots: s.shots,
            index: s.index,
            onSelect: (i) => s.index = i,
            axis: axis,
          )
        : null;

    final notices = [
      if (!idle) const LinearProgressIndicator(minHeight: 2),
      if (shot != null && shot.cameraPhoto)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
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
      if (_merging && s != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: MergeHint(onCancel: () => _mergePick(null)),
        ),
    ];

    // Rails are centred on the line their edge's bar sits on, clamped inside the viewport.
    Rect rail(Rect bar, double width) {
      final w = math.min(width, size.width);
      final left = (bar.center.dx - w / 2).clamp(0.0, size.width - w);
      final top = (bar.top + 8).clamp(0.0, size.height);
      final bottom = math.max(top, (bar.bottom - 8).clamp(0.0, size.height));
      return Rect.fromLTRB(left, top, left + w, bottom);
    }

    final actionsRail = rail(actionsBar, _actionBar);
    final toolsRail = rail(toolsBar, _toolRail);
    // Upright, the strip stays above the tools.
    final stripTop = inset.top.clamp(0.0, size.height);
    final stripBottom = math.max(
      stripTop,
      (size.height - inset.bottom).clamp(0.0, size.height),
    );
    final stripRect = !batch || !wide
        ? null
        : actionsRight
        ? Rect.fromLTRB(
            math.max(0.0, actionsRail.left - _strip),
            stripTop,
            actionsRail.left,
            stripBottom,
          )
        : Rect.fromLTRB(
            actionsRail.right,
            stripTop,
            math.min(size.width, actionsRail.right + _strip),
            stripBottom,
          );
    // Around the image: the rails beside it, else the bars above and below.
    final inner = Rect.fromLTRB(
      actionsRight ? toolsRail.right : (stripRect ?? actionsRail).right,
      wide || inStatus ? inset.top + 12 : topBar.center.dy + 30,
      actionsRight ? (stripRect ?? actionsRail).left : toolsRail.left,
      wide
          ? size.height - inset.bottom - 12
          : bottomBar.center.dy - _toolBar / 2 - (batch ? _strip : 0) - 8,
    );
    // Upright, the image shares the tools' middle.
    final mid = bottomBar.center.dx;
    final half = [
      mid - inset.left - 12,
      size.width - inset.right - 12 - mid,
      if (inStatus)
        (actionsRight ? actionsRail.left - mid : mid - actionsRail.right),
    ].reduce(math.min);
    final fitPadding = _clampPadding(
      EdgeInsets.fromLTRB(
        wide ? inner.left : mid - half,
        inner.top,
        wide ? size.width - inner.right : size.width - mid - half,
        size.height - inner.bottom,
      ),
      size,
    );

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: Stack(
        key: _viewKey,
        children: [
          Positioned.fill(
            child: s != null && shot != null
                ? BoxEditor(
                    key: ValueKey(shot),
                    session: s,
                    drawing: _drawing && !_merging,
                    fill: _settings.fill,
                    onLongPress: _boxMenu,
                    merging: _merging,
                    mergeFrom: _mergeFrom,
                    onMergePick: _mergePick,
                    peekOriginal: _peeking,
                    fitPadding: fitPadding,
                  )
                : Center(
                    child: Padding(
                      padding: fitPadding,
                      child: failed
                          ? FilledButton.icon(
                              onPressed: _loadAndDrain,
                              icon: const Icon(Icons.refresh),
                              label: Text(_l.retry),
                            )
                          : FilledButton.icon(
                              onPressed: ready ? _pickMedia : null,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: Text(_l.selectMedia),
                            ),
                    ),
                  ),
          ),
          if (wide || inStatus) ...[
            Positioned.fromRect(rect: actionsRail, child: actions),
            if (stripRect != null)
              Positioned.fromRect(rect: stripRect, child: strip!),
            Positioned(
              left: fitPadding.left,
              right: fitPadding.right,
              top: 0,
              child: SafeArea(
                left: false,
                right: false,
                bottom: false,
                child: Column(children: notices),
              ),
            ),
          ] else
            Positioned(
              left: topBar.left,
              width: topBar.width,
              top: topBar.center.dy - _actionBar / 2,
              child: Column(
                children: [
                  SizedBox(
                    height: _actionBar,
                    child: Center(
                      child: SizedBox(height: _control, child: actions),
                    ),
                  ),
                  ...notices,
                ],
              ),
            ),
          if (wide)
            Positioned.fromRect(rect: toolsRail, child: toolBar)
          else
            Positioned(
              left: math.max(0.0, bottomBar.left - 8),
              width: math.min(
                size.width - math.max(0.0, bottomBar.left - 8),
                bottomBar.width + 16,
              ),
              bottom: math.max(
                0.0,
                size.height - bottomBar.center.dy - _toolBar / 2,
              ),
              child: Column(
                children: [
                  ?strip,
                  Center(child: toolBar),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Drops stale system bar coordinates during a rotation or fold transition
  /// frame where [MediaQuery.sizeOf] updated ahead of the platform channel.
  Map<ScreenEdge, Rect> _validSystemBars(Size size) {
    final system = _systemBars.value;
    if (system.isEmpty) return const {};
    for (final r in system.values) {
      if (r.left < -1 ||
          r.top < -1 ||
          r.right > size.width + 1 ||
          r.bottom > size.height + 1) {
        return const {};
      }
    }
    return system;
  }

  static EdgeInsets _clampPadding(EdgeInsets p, Size size) {
    var left = math.max(0.0, p.left);
    var right = math.max(0.0, p.right);
    var top = math.max(0.0, p.top);
    var bottom = math.max(0.0, p.bottom);
    if (left + right > size.width) {
      final s = size.width / (left + right);
      left *= s;
      right *= s;
    }
    if (top + bottom > size.height) {
      final s = size.height / (top + bottom);
      top *= s;
      bottom *= s;
    }
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  /// Where a bar along each edge sits: as the system lays one out (clear of
  /// corners, cameras and the status bar, centred on their line), else just
  /// inside the safe area.
  Map<ScreenEdge, Rect> _bars(
    Size size,
    EdgeInsets inset,
    Map<ScreenEdge, Rect> system,
  ) {
    final w = size.width, h = size.height;
    Rect side(double left) {
      final top = (inset.top + 4).clamp(0.0, h);
      final bottom = math.max(top, (h - inset.bottom - 4).clamp(0.0, h));
      final barW = math.min(_control, w);
      final l = left.clamp(0.0, w - barW);
      return Rect.fromLTRB(l, top, l + barW, bottom);
    }

    final topW = math.max(0.0, w - inset.horizontal - 24);
    final bottomW = math.max(0.0, w - inset.horizontal - 16);
    return {
      ScreenEdge.left: system[ScreenEdge.left] ?? side(inset.left + 18),
      ScreenEdge.right:
          system[ScreenEdge.right] ?? side(w - inset.right - 18 - _control),
      ScreenEdge.top:
          system[ScreenEdge.top] ??
          Rect.fromLTWH(
            (inset.left + 12).clamp(0.0, w),
            (inset.top + 8).clamp(0.0, h),
            math.min(topW, w),
            math.min(_control, h),
          ),
      ScreenEdge.bottom:
          system[ScreenEdge.bottom] ??
          Rect.fromLTWH(
            (inset.left + 8).clamp(0.0, w),
            (h - inset.bottom - _toolBar / 2 - _control / 2).clamp(0.0, h),
            math.min(bottomW, w),
            math.min(_control, h),
          ),
    };
  }

  void _peekUp(int pointer) {
    _peekPointers.remove(pointer);
    if (_peekPointers.isEmpty && _peeking) setState(() => _peeking = false);
  }
}

/// A tool in the tool bar: icon over a short label; [selected] while its
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
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.secondaryContainer : Colors.transparent,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                    style: TextStyle(fontSize: 12, color: color),
                  ),
                ],
              ),
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
    this.axis = Axis.horizontal,
  });

  final List<Shot> shots;
  final int index;
  final ValueChanged<int> onSelect;

  /// The direction the thumbnails run in.
  final Axis axis;

  static const _cross = 68.0;

  /// Its thickness in the layout, across [axis].
  static const height = _cross + 16;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final horizontal = axis == Axis.horizontal;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    const side = _cross - 10;
    // Thumbnail size along [axis]; [side] across it.
    double thumb(Shot s) => horizontal
        ? (side * s.size.width / s.size.height).clamp(24.0, 96.0)
        : (side * s.size.height / s.size.width).clamp(24.0, 128.0);
    // Thumbnail, its frame and the room for its badge.
    double extent(Shot s) => thumb(s) + 25;
    return SizedBox(
      width: horizontal ? null : height,
      height: horizontal ? height : null,
      child: LayoutBuilder(
        builder: (context, c) {
          final total = shots.fold(0.0, (w, s) => w + extent(s));
          final room = horizontal ? c.maxWidth : c.maxHeight;
          // Centred while they fit; built as they scroll into view.
          final edge = math.max(16.0, (room - total) / 2);
          return ListView.builder(
            scrollDirection: axis,
            padding: horizontal
                ? EdgeInsets.symmetric(horizontal: edge)
                : EdgeInsets.symmetric(vertical: edge),
            itemCount: shots.length,
            itemExtentBuilder: (i, _) => extent(shots[i]),
            itemBuilder: (context, i) {
              final shot = shots[i];
              return Padding(
                padding: horizontal
                    ? const EdgeInsets.fromLTRB(5, 2, 10, 10)
                    : const EdgeInsets.fromLTRB(2, 5, 10, 10),
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
                              width: horizontal ? thumb(shot) : side,
                              height: horizontal ? side : thumb(shot),
                              cacheHeight:
                                  ((horizontal ? side : thumb(shot)) * dpr)
                                      .round(),
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

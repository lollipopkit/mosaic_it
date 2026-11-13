import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../l10n/app_localizations.dart';
import 'annotate_page.dart';
import 'annotation_data_page.dart';
import 'boxes.dart';
import 'editor_page.dart';
import 'gallery_grid.dart';
import 'label_set.dart';
import 'model_store.dart';
import 'review_resume.dart';
import 'rust/api.dart';
import 'settings.dart';
import 'store.dart';
import 'video_page.dart';

/// Which part of the photo library the gallery shows.
enum _Filter { screenshots, all, videos, album }

/// The home page is the photo library: pick screenshots (or a video), then
/// redact or annotate them.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Session? _session;
  ModelInfo? _info;
  AppSettings _settings = AppSettings(
    fillStyle: FillStyle.solid,
    fillColor: 0x000000,
  );
  String? _busy;

  /// Share of the model download done, while one runs.
  double? _progress;

  /// The first model could not be downloaded; the gallery offers a retry.
  bool _modelMissing = false;

  PermissionState? _permission;
  _Filter _filter = _Filter.screenshots;
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _album;
  final _assets = <AssetEntity>[];
  int _page = 0;
  bool _hasMore = true;
  bool _loading = false;

  /// In the order they were tapped.
  final _selected = <AssetEntity>[];

  static const _pageSize = 120;
  static final _mobile = Platform.isIOS || Platform.isAndroid;

  AppLocalizations get _l => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadModel();
      _openLibrary();
    });
  }

  @override
  void dispose() {
    PhotoManager.removeChangeCallback(_libraryChanged);
    PhotoManager.stopChangeNotify();
    super.dispose();
  }

  // --- model ----------------------------------------------------------------

  Future<void> _loadModel() => _run(_l.loadingModel, () async {
    final settings = await AppSettings.load();
    setState(() => _settings = settings);
    try {
      var s = await _openModel();
      if (s == null) {
        // First launch: the app ships without a model.
        await _downloadModel();
        s = await _openModel();
      } else if (settings.autoUpdateModel) {
        // Staged for the next launch; this one keeps the model it opened.
        unawaited(ModelStore.update().then((_) {}, onError: (_) {}));
      }
      _setSession(s);
    } finally {
      // Label review (debug builds) continues where it was left.
      if (kDebugMode) {
        if (await ReviewResume.load() case final dir?) {
          await _reviewLabelsAt(dir);
        }
      }
    }
  });

  Future<Session?> _openModel() async {
    try {
      return await ModelStore.load();
    } catch (e) {
      // A model saved by an older version may no longer load; a newer
      // release may.
      try {
        if (await ModelStore.update()) return await ModelStore.load();
      } catch (_) {}
      throw StateError(_l.savedModelFailed('$e'));
    }
  }

  Future<void> _downloadModel() async {
    setState(() => _modelMissing = false);
    try {
      final found = await ModelStore.update(
        onProgress: (v) {
          // Whole percents: the download reports every chunk.
          if ((v * 100).floor() != ((_progress ?? 0) * 100).floor()) {
            setState(() => _progress = v);
          }
        },
      );
      // No release this version of the app can run.
      if (!found) setState(() => _modelMissing = true);
    } catch (_) {
      // Offline, or the download did not match the manifest.
      setState(() => _modelMissing = true);
    } finally {
      setState(() => _progress = null);
    }
  }

  void _setSession(Session? s) => setState(() {
    if (s != null) _settings.applyTo(s);
    _session = s;
    _info = s?.info();
  });

  void _toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  /// Runs [f] with a busy indicator and shows any error.
  Future<void> _run(String label, Future<void> Function() f) async {
    setState(() => _busy = label);
    try {
      await f();
    } catch (e) {
      // At startup the window can still be zero-sized; a SnackBar shown
      // before the first real layout trips the Scaffold layout assertion.
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) _toast(_message(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  String _message(Object e) => switch (e) {
    ModelPickError(sidecarFor: final m?) => _l.pickSidecar(m),
    ModelPickError() => _l.pickOneModel,
    _ => '$e',
  };

  Future<void> _chooseModel() async {
    // iOS filters by UTI only, and .onnx has none registered.
    final files = await openFiles(
      acceptedTypeGroups: [
        Platform.isIOS
            ? XTypeGroup(
                label: _l.modelFileType,
                uniformTypeIdentifiers: const ['public.data'],
              )
            : XTypeGroup(
                label: _l.modelFileType,
                extensions: const ['onnx', 'json'],
              ),
      ],
      confirmButtonText: _l.useModel,
    );
    if (files.isEmpty) return;
    await _run(_l.loadingModel, () async {
      final f = await ModelStore.import([for (final x in files) x.path]);
      _setSession(await ModelStore.open(f));
    });
  }

  // --- library --------------------------------------------------------------

  Future<void> _openLibrary() async {
    final p = await PhotoManager.requestPermissionExtend();
    if (!mounted) return;
    setState(() => _permission = p);
    if (!p.hasAccess) return;
    // Changes made in Photos (or to the limited selection) show up here.
    PhotoManager.addChangeCallback(_libraryChanged);
    PhotoManager.startChangeNotify();
    await _reload();
  }

  void _libraryChanged(MethodCall _) => _reload(keepPlace: true);

  RequestType get _type =>
      _filter == _Filter.videos ? RequestType.video : RequestType.image;

  /// Counts [_reload] calls: a newer one supersedes those still loading.
  int _reloads = 0;

  /// Loads the current filter's assets. With [keepPlace] (the library
  /// changed) the same number of assets is fetched and swapped in at once, so
  /// the grid stays where it is; otherwise it starts again from the top.
  Future<void> _reload({bool keepPlace = false}) async {
    final reload = ++_reloads;
    final paths = await PhotoManager.getAssetPathList(
      type: _filter == _Filter.album ? RequestType.common : _type,
    );
    final path = switch (_filter) {
      _Filter.screenshots => paths.where(_isScreenshots).firstOrNull,
      _Filter.all || _Filter.videos => paths.where((p) => p.isAll).firstOrNull,
      _Filter.album => _album,
    };
    final count = keepPlace ? max(_assets.length, _pageSize) : _pageSize;
    final assets =
        await path?.getAssetListRange(start: 0, end: count) ??
        const <AssetEntity>[];
    if (!mounted || reload != _reloads) return;
    setState(() {
      _albums = paths;
      _album = path;
      _assets
        ..clear()
        ..addAll(assets);
      // Whole pages only, so the next page continues where these end.
      _page = assets.length ~/ _pageSize;
      _hasMore = assets.length == count && count % _pageSize == 0;
      // What was deleted from the library cannot stay selected.
      if (keepPlace) _selected.retainWhere(assets.contains);
    });
  }

  static bool _isScreenshots(AssetPathEntity p) =>
      p.albumTypeEx?.darwin?.subtype ==
          PMDarwinAssetCollectionSubtype.smartAlbumScreenshots ||
      // Android keeps them in a folder of that name.
      p.name.toLowerCase().contains('screenshot');

  Future<void> _more() async {
    final path = _album;
    if (path == null || _loading || !_hasMore) return;
    _loading = true;
    final reload = _reloads;
    try {
      final page = await path.getAssetListPaged(page: _page, size: _pageSize);
      // A reload since then already holds these assets, or others.
      if (!mounted || reload != _reloads) return;
      setState(() {
        _assets.addAll(page);
        _page++;
        _hasMore = page.length == _pageSize;
      });
    } finally {
      _loading = false;
    }
  }

  Future<void> _setFilter(_Filter f) async {
    if (f == _Filter.album) {
      final a = await showModalBottomSheet<AssetPathEntity>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final p in _albums)
                ListTile(
                  title: Text(p.name),
                  trailing: p == _album ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.pop(context, p),
                ),
            ],
          ),
        ),
      );
      if (a == null) return;
      _album = a;
    }
    setState(() {
      _filter = f;
      _selected.clear();
    });
    await _reload();
  }

  void _toggle(AssetEntity a) => setState(() {
    if (!_selected.remove(a)) {
      // A video is redacted on its own.
      if (_isVideo(a) || _selected.any(_isVideo)) _selected.clear();
      _selected.add(a);
    }
  });

  static bool _isVideo(AssetEntity a) => a.type == AssetType.video;

  /// The selected items as files: images re-encoded where the decoder needs
  /// it (HEIC becomes JPEG), screenshots as they are.
  Future<List<(File, String)>> _files() async => [
    for (final a in _selected)
      if (await a.file case final f?) (f, a.id),
  ];

  // --- actions --------------------------------------------------------------

  Future<void> _redact() async {
    final s = _session, info = _info;
    if (s == null || info == null) {
      _toast(_l.chooseModelFirst);
      return;
    }
    if (_selected.any(_isVideo)) return _openVideo(_selected.single);
    final shots = <Shot>[];
    await _run(_l.detecting, () async {
      final files = await _files();
      for (final (i, (image, id)) in files.indexed) {
        if (files.length > 1) {
          setState(() => _busy = _l.detectingProgress(i + 1, files.length));
        }
        final d = await s.detect(imagePath: image.path);
        shots.add(Shot.detected(image, d, assetId: id));
      }
    });
    if (shots.isEmpty || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            EditorPage(shots: shots, settings: _settings, model: s, info: info),
      ),
    );
    setState(_selected.clear);
  }

  Future<void> _annotate() async {
    List<(File, String?)> files = [];
    await _run(_l.loading, () async => files = await _files());
    if (files.isEmpty || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnnotatePage.fresh(files, model: _session),
      ),
    );
    setState(_selected.clear);
  }

  Future<void> _openVideo(AssetEntity a) async {
    final s = _session;
    final f = await a.file;
    if (s == null || f == null || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VideoPage(session: s, video: f, fill: _settings.fill),
      ),
    );
    setState(_selected.clear);
  }

  /// Desktops without a photo library open image files directly.
  Future<void> _openFiles() async {
    final s = _session, info = _info;
    if (s == null || info == null) return;
    final files = await openFiles(
      acceptedTypeGroups: [
        XTypeGroup(
          label: _l.imagesFileType,
          extensions: const ['png', 'jpg', 'jpeg', 'webp'],
        ),
      ],
    );
    if (files.isEmpty) return;
    final shots = <Shot>[];
    await _run(_l.detecting, () async {
      for (final f in files) {
        final d = await s.detect(imagePath: f.path);
        shots.add(Shot.detected(File(f.path), d));
      }
    });
    if (shots.isEmpty || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            EditorPage(shots: shots, settings: _settings, model: s, info: info),
      ),
    );
  }

  /// Opens a folder holding `coco.json` and its images (pseudo-label
  /// review, debug builds on desktop).
  Future<void> _reviewLabels() async {
    final dir = await getDirectoryPath(confirmButtonText: _l.reviewButton);
    if (dir == null) return;
    await _run(_l.openingLabels, () => _reviewLabelsAt(dir));
  }

  Future<void> _reviewLabelsAt(String dir) async {
    final file = File('$dir/coco.json');
    final name = Directory(dir).uri.pathSegments
        .where((s) => s.isNotEmpty)
        .last;
    if (!await file.exists()) throw StateError(_l.noLabelsIn(name));
    final set = await LabelSet.open(file);
    if (set.shots.isEmpty) throw StateError(_l.noImagesIn(name));
    await ReviewResume.save(dir);
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => AnnotatePage.review(set)));
    await ReviewResume.clear();
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsPage(
          settings: _settings,
          classes: _info?.classes ?? const [],
          info: _info,
          onChooseModel: _chooseModel,
        ),
      ),
    );
    if (_session case final s?) _settings.applyTo(s);
    setState(() {});
  }

  // --- view -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final selecting = _selected.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: selecting
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(_selected.clear),
              )
            : null,
        title: Text(
          selecting ? _l.selectedImages(_selected.length) : _l.appTitle,
        ),
        actions: [
          PopupMenuButton<VoidCallback>(
            onSelected: (f) => f(),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AnnotationDataPage(model: _session),
                  ),
                ),
                child: Text(_l.annotationData),
              ),
              CheckedPopupMenuItem(
                checked: SettingStore.instance.gridAspect.get(),
                value: () {
                  final aspect = SettingStore.instance.gridAspect;
                  aspect.set(!aspect.get());
                },
                child: Text(_l.aspectRatioGrid),
              ),
              if (!_mobile)
                PopupMenuItem(value: _openFiles, child: Text(_l.openFiles)),
              if (kDebugMode && !_mobile)
                PopupMenuItem(
                  value: _reviewLabels,
                  child: Text(_l.reviewPseudoLabels),
                ),
            ],
          ),
          IconButton(
            tooltip: _l.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
        ],
        bottom: _busy == null
            ? null
            : PreferredSize(
                preferredSize: Size.fromHeight(3),
                child: LinearProgressIndicator(minHeight: 3, value: _progress),
              ),
      ),
      body: _body(),
      bottomNavigationBar: selecting
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    if (!_selected.any(_isVideo)) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy == null ? _annotate : null,
                          child: Text(_l.annotate),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: _busy == null ? _redact : null,
                        child: Text(_l.redactImages(_selected.length)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _body() {
    final p = _permission;
    if (p == null) return const Center(child: CircularProgressIndicator());
    if (!p.hasAccess) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_l.photosDenied, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: PhotoManager.openSetting,
                child: Text(_l.openSettings),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Row(
            children: [
              for (final (f, label) in [
                (_Filter.screenshots, _l.filterScreenshots),
                (_Filter.all, _l.filterAll),
                (_Filter.videos, _l.filterVideos),
                (
                  _Filter.album,
                  _filter == _Filter.album && _album != null
                      ? '${_album!.name} ▾'
                      : '${_l.albums} ▾',
                ),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: _filter == f,
                    onSelected: (_) => _setFilter(f),
                  ),
                ),
            ],
          ),
        ),
        if (_modelMissing)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Card.filled(
              margin: EdgeInsets.zero,
              child: ListTile(
                dense: true,
                title: Text(_l.modelDownloadFailed),
                trailing: TextButton(
                  onPressed: _busy == null ? _loadModel : null,
                  child: Text(_l.retry),
                ),
              ),
            ),
          ),
        if (p == PermissionState.limited)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Card.filled(
              margin: EdgeInsets.zero,
              child: ListTile(
                dense: true,
                title: Text(_l.limitedAccess),
                trailing: TextButton(
                  onPressed: () => PhotoManager.presentLimited(),
                  child: Text(_l.manage),
                ),
              ),
            ),
          ),
        Expanded(
          child: _assets.isEmpty
              ? Center(child: Text(_hasMore ? _l.loading : _l.noPhotos))
              : GalleryGrid(
                  assets: _assets,
                  selected: _selected,
                  onTap: _toggle,
                  onLongPress: _preview,
                  onNearEnd: _more,
                ),
        ),
      ],
    );
  }

  Future<void> _preview(AssetEntity a) => showDialog<void>(
    context: context,
    builder: (context) => GestureDetector(
      onTap: () => Navigator.pop(context),
      child: InteractiveViewer(
        child: AssetEntityImage(a, isOriginal: true, fit: BoxFit.contain),
      ),
    ),
  );
}

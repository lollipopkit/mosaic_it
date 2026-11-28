import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'rust/api.dart';

/// Model file extensions this platform runs: LiteRT's `.tflite` on
/// Android, ONNX elsewhere.
final modelExtensions = [Platform.isAndroid ? '.tflite' : '.onnx'];

/// Fallback version label when `bundled.stamp` is absent (e.g. unit tests).
const defaultBundledModelVersion = '0.6.0';

bool _isModel(String path) => modelExtensions.any(path.endsWith);

/// Keeps the active detector model (a [modelExtensions] file plus its `.json`
/// sidecar) completely offline: either the bundled model shipped inside the
/// app package, or a local model manually imported by the user.
class ModelStore {
  static const _androidChannel = MethodChannel(
    'com.lollipopkit.unseen/bundled_model',
  );

  static String? _cachedBundledVersion;
  static Future<File?>? _bundledInFlight;
  static Future<Session?>? _preloaded;
  static int _preloadGen = 0;

  /// Version string read from `bundled.stamp` next to the bundled model
  /// (falling back to [defaultBundledModelVersion] before extraction or in tests).
  static String get bundledModelVersion =>
      _cachedBundledVersion ?? defaultBundledModelVersion;

  static Future<Directory> _dir() async {
    final d = Directory(
      '${(await getApplicationSupportDirectory()).path}/models',
    );
    return d.create(recursive: true);
  }

  static File? _modelIn(Directory d) {
    if (!d.existsSync()) return null;
    for (final f in d.listSync().whereType<File>()) {
      if (_isModel(f.path) && File('${f.path}.json').existsSync()) return f;
    }
    return null;
  }

  static void _readStampNear(File model) {
    final stamp = File('${model.parent.path}/bundled.stamp');
    if (!stamp.existsSync()) return;
    try {
      final firstLine = stamp.readAsLinesSync().firstOrNull?.trim();
      if (firstLine != null && firstLine.isNotEmpty) {
        _cachedBundledVersion = firstLine;
      }
    } catch (_) {}
  }

  /// A custom model imported manually by the user (overrides [bundled]).
  static Future<File?> custom() async => _modelIn(await _dir());

  /// Whether a user-imported custom model is currently active.
  static Future<bool> hasCustomModel() async => await custom() != null;

  /// Invalidates any in-flight or completed preloaded session, waiting for
  /// active file reads to finish and disposing the native session to avoid leaks.
  static Future<void> _invalidatePreload() async {
    _preloadGen++;
    final pending = _preloaded;
    _preloaded = null;
    if (pending != null) {
      try {
        (await pending)?.dispose();
      } catch (_) {}
    }
  }

  /// Removes any user-imported custom model so [load] falls back to [bundled].
  static Future<void> clearCustom() async {
    await _invalidatePreload();
    final d = await _dir();
    for (final f in d.listSync().whereType<File>()) {
      await f.delete();
    }
  }

  /// Resolves the model bundled inside the app package (zero networking).
  ///
  /// - iOS / macOS: opened directly from the read-only app bundle.
  /// - Android: streamed once from APK `assets/models/` into app support.
  static Future<File?> bundled() {
    return _bundledInFlight ??= () async {
      try {
        return await _resolveBundled();
      } finally {
        _bundledInFlight = null;
      }
    }();
  }

  static Future<File?> _resolveBundled() async {
    if (Platform.isAndroid) {
      final dest = '${(await _dir()).path}/bundled';
      final path = await _androidChannel.invokeMethod<String>('extract', {
        'dir': dest,
      });
      if (path == null) return null;
      final f = File(path);
      if (f.existsSync() && File('${f.path}.json').existsSync()) {
        _readStampNear(f);
        return f;
      }
      return null;
    }
    final exeDir = File(Platform.resolvedExecutable).parent;
    final candidates = <Directory>[
      if (Platform.isMacOS) Directory('${exeDir.parent.path}/Resources/models'),
      if (Platform.isIOS) Directory('${exeDir.path}/models'),
      Directory('${exeDir.path}/data/flutter_assets/models'),
      Directory('${exeDir.path}/models'),
    ];
    for (final dir in candidates) {
      if (_modelIn(dir) case final found?) {
        _readStampNear(found);
        return found;
      }
    }
    return null;
  }

  /// Reads the bundled version label from `bundled.stamp` when available.
  static Future<String> resolveBundledVersion() async {
    if (_cachedBundledVersion != null) return _cachedBundledVersion!;
    try {
      await bundled();
    } catch (_) {}
    return bundledModelVersion;
  }

  /// The active stored model (custom override first, otherwise bundled).
  static Future<File?> current() async => await custom() ?? await bundled();

  /// Starts loading the active model in the background (e.g. while the user
  /// reads the first-launch IntroPage) so [takePreloadedOrLoad] finishes immediately.
  static void preload() {
    if (_preloaded != null) return;
    final gen = _preloadGen;
    _preloaded = load().then((s) {
      if (gen != _preloadGen) {
        s?.dispose();
        return null;
      }
      return s;
    }, onError: (_) => null);
  }

  /// Returns an already-preloaded session if available, otherwise calls [load].
  static Future<Session?> takePreloadedOrLoad() async {
    final pending = _preloaded;
    _preloaded = null;
    if (pending != null) {
      final s = await pending;
      if (s != null) return s;
    }
    return load();
  }

  /// Copies a model and its sidecar, picked together by the user, validates
  /// that the runtime can open it, and only then replaces any previous custom
  /// model so a corrupt import never breaks the active installation.
  static Future<Session> importAndOpen(List<String> paths) async {
    await _invalidatePreload();
    final (model, sidecar) = pickModelFiles(paths);
    // Pickers may rename what they copy (Android's file_selector gives a
    // file without a registered MIME type another extension), so the format
    // comes from the content.
    final raf = await File(model).open();
    final ext = modelExtension(await raf.read(8));
    await raf.close();
    if (!modelExtensions.contains(ext)) {
      throw const ModelPickError.notOneModel();
    }
    final file = model.split(Platform.pathSeparator).last;
    final dot = file.indexOf('.');
    final name = '${dot > 0 ? file.substring(0, dot) : file}$ext';
    final d = await _dir();
    final stage = await Directory(
      '${d.path}/.import-${DateTime.now().microsecondsSinceEpoch}',
    ).create(recursive: true);
    try {
      final stagedModel = await File(model).copy('${stage.path}/$name');
      final stagedSidecar = await File(sidecar)
          .copy('${stagedModel.path}.json');
      // Validate before touching the active custom model directory.
      await open(stagedModel);
      for (final f in d.listSync().whereType<File>()) {
        await f.delete();
      }
      final dst = await stagedModel.rename('${d.path}/$name');
      await stagedSidecar.rename('${dst.path}.json');
      return await open(dst);
    } finally {
      if (stage.existsSync()) {
        await stage.delete(recursive: true);
      }
    }
  }

  /// Loads the active model (custom override, falling back to bundled).
  static Future<Session?> load() async {
    final customFile = await custom();
    if (customFile != null) {
      return open(customFile);
    }
    final bundledFile = await bundled();
    return bundledFile == null ? null : open(bundledFile);
  }

  /// Loads [model], keeping compiled hardware models in the app's cache
  /// directory so later loads skip compilation.
  static Future<Session> open(File model) async => Session.load(
    modelPath: model.path,
    cacheDir: (await getApplicationCacheDirectory()).path,
  );
}

/// Why picked files are not a model and its sidecar; the UI words it.
class ModelPickError implements Exception {
  const ModelPickError.notOneModel() : sidecarFor = null;
  const ModelPickError.noSidecar(String model) : sidecarFor = model;

  /// The model file name whose `.json` sidecar is missing; null when the
  /// pick did not hold exactly one model file.
  final String? sidecarFor;
}

/// The extension of a model file whose first bytes are [head]: `.tflite`
/// for a LiteRT flatbuffer (identifier `TFL3`), else `.onnx`.
String modelExtension(List<int> head) =>
    head.length >= 8 && String.fromCharCodes(head.sublist(4, 8)) == 'TFL3'
    ? '.tflite'
    : '.onnx';

/// The model and its sidecar among picked [paths]: exactly one file that is
/// not `.json` (its name may not tell the format: [modelExtension]), and
/// `<model>.json` or else the only `.json`.
(String, String) pickModelFiles(List<String> paths) {
  final models = paths.where((p) => !p.endsWith('.json')).toList();
  final json = paths.where((p) => p.endsWith('.json')).toList();
  if (models.length != 1) throw const ModelPickError.notOneModel();
  final model = models.single;
  final name = model.split(Platform.pathSeparator).last;
  final exact = json.where(
    (p) => p.split(Platform.pathSeparator).last == '$name.json',
  );
  if (exact.isNotEmpty) return (model, exact.first);
  if (json.length == 1) return (model, json.single);
  throw ModelPickError.noSidecar(name);
}

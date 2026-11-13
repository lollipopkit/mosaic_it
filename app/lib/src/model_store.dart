import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'rust/api.dart';

/// Keeps one detector model (`*.onnx` plus its `*.onnx.json` sidecar) in the
/// app's support directory: a release downloaded from [_manifest], or files
/// the user picked (copied in, as the sandbox only grants access to those).
class ModelStore {
  /// The signed list of releases (models/manifest.toml, models/publish.sh).
  static const _manifest =
      'https://pub.lolli.tech/models/unseen/manifest.signed';

  static Future<Directory> _dir() async {
    final d = Directory(
      '${(await getApplicationSupportDirectory()).path}/models',
    );
    return d.create(recursive: true);
  }

  /// A downloaded release waits in `staged/<version>/` until the next
  /// [load]: the files of a model in use are never replaced.
  static Future<Directory> _staged() async =>
      Directory('${(await _dir()).path}/staged').create();

  static File? _modelIn(Directory d) => d
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.onnx'))
      .firstOrNull;

  /// The staged release: its model is written last, so finding one means the
  /// release is complete.
  static Future<File?> _stagedModel() async => (await _staged())
      .listSync()
      .whereType<Directory>()
      .map(_modelIn)
      .nonNulls
      .firstOrNull;

  /// Raised by [import]: a download that started before it must not replace
  /// what the user picked.
  static int _imports = 0;

  /// The stored model, if any.
  static Future<File?> current() async => _modelIn(await _dir());

  /// Copies a model and its sidecar, picked together by the user, replacing
  /// the stored model. The sidecar is `<model>.onnx.json`, or the only
  /// `.json` picked. Picking files rather than a folder works on every
  /// platform (iOS has no folder picker) and under the macOS sandbox.
  static Future<File> import(List<String> paths) async {
    final (model, sidecar) = pickModelFiles(paths);
    final name = model.split(Platform.pathSeparator).last;
    final d = await _dir();
    _imports++;
    for (final f in d.listSync()) {
      await f.delete(recursive: true);
    }
    final dst = await File(model).copy('${d.path}/$name');
    await File(sidecar).copy('${dst.path}.json');
    return dst;
  }

  /// The stored model, after a staged release took its place; null when
  /// there is none yet ([update] downloads one).
  static Future<Session?> load() async {
    await _applyStaged();
    final f = await current();
    return f == null ? null : open(f);
  }

  /// Downloads the newest release into the staging directory when the stored
  /// model is an older release or there is none; [load] then uses it. False
  /// when nothing newer that this app can run is published. A model the user
  /// imported is not such a release and is left alone.
  static Future<bool> update({ValueChanged<double>? onProgress}) async {
    final staged = await _staged(), imports = _imports;
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        // Between chunks: a stalled download fails, a slow one goes on.
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    try {
      final manifest = await dio.get<List<int>>(
        _manifest,
        options: Options(responseType: ResponseType.bytes),
      );
      final u = await modelUpdate(
        manifest: manifest.data!,
        installed: (await _stagedModel() ?? await current())?.path,
      );
      if (u == null) return false;
      final dir = await Directory('${staged.path}/${u.version}').create();
      final model = File('${dir.path}/${u.file}');
      final sidecar = File('${model.path}.json');
      final part = File('${model.path}.part');
      await _download(dio, u.sidecarUrl, sidecar, u.sidecarBlake3);
      await _download(dio, u.modelUrl, part, u.blake3, onProgress);
      if (imports != _imports) {
        await dir.delete(recursive: true);
        return false;
      }
      // Renamed last: only then is the staged release complete.
      await part.rename(model.path);
      for (final other in staged.listSync()) {
        if (other.path != dir.path) await other.delete(recursive: true);
      }
      return true;
    } finally {
      dio.close();
    }
  }

  /// Saves [url] as [to] if its content has the expected BLAKE3.
  static Future<void> _download(
    Dio dio,
    String url,
    File to,
    String blake3, [
    ValueChanged<double>? onProgress,
  ]) async {
    await dio.download(
      url,
      to.path,
      onReceiveProgress: (got, total) {
        if (total > 0) onProgress?.call(got / total);
      },
    );
    if (await fileBlake3(path: to.path) != blake3) {
      await to.delete();
      throw HttpException(
        'content does not match the manifest',
        uri: Uri.parse(url),
      );
    }
  }

  /// Makes the staged release the stored model. Every step can be repeated,
  /// so an interrupted move finishes at the next launch.
  static Future<void> _applyStaged() async {
    final model = await _stagedModel();
    if (model == null) return;
    final d = await _dir();
    String name(File f) => f.path.split(Platform.pathSeparator).last;
    final sidecar = File('${model.path}.json');
    final keep = {name(model), name(sidecar)};
    for (final f in d.listSync().whereType<File>()) {
      if (!keep.contains(name(f))) await f.delete();
    }
    // Already moved if an earlier run was interrupted here.
    if (sidecar.existsSync()) {
      await sidecar.rename('${d.path}/${name(sidecar)}');
    }
    await model.rename('${d.path}/${name(model)}');
    await (await _staged()).delete(recursive: true);
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
  /// pick did not hold exactly one `.onnx`.
  final String? sidecarFor;
}

/// The model and its sidecar among picked [paths]: exactly one `.onnx`, and
/// `<model>.onnx.json` or else the only `.json`.
(String, String) pickModelFiles(List<String> paths) {
  final onnx = paths.where((p) => p.endsWith('.onnx')).toList();
  final json = paths.where((p) => p.endsWith('.json')).toList();
  if (onnx.length != 1) throw const ModelPickError.notOneModel();
  final model = onnx.single;
  final name = model.split(Platform.pathSeparator).last;
  final exact = json.where(
    (p) => p.split(Platform.pathSeparator).last == '$name.json',
  );
  if (exact.isNotEmpty) return (model, exact.first);
  if (json.length == 1) return (model, json.single);
  throw ModelPickError.noSidecar(name);
}

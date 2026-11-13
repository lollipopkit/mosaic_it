import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'boxes.dart';
import 'rust/api.dart';

/// What the user decided about an image in annotation mode.
enum AnnotateStatus {
  /// The selected boxes are its private regions.
  labeled,

  /// It holds nothing private (a negative example).
  empty,

  /// Not decided; the image is kept so it can be labelled later.
  skipped,
}

/// How an exported image's boxes came about: the model that proposed them
/// and what the export did.
class ExportContext {
  const ExportContext({
    required this.model,
    required this.hashes,
    required this.fill,
    required this.forced,
    required this.outcome,
  });

  final ModelInfo model;
  final ModelHashes hashes;
  final Fill fill;
  final bool forced;

  /// The export check of the written file.
  final ExportOutcome outcome;
}

/// Keeps images with every box and the user's choices as future training
/// data, on the device only: exports when the user opted in
/// (`AppSettings.collect`), and every save in annotation mode.
///
/// Layout under `Documents/collected` (visible in the Files app and Finder on
/// iOS): `images/<blake3>.<ext>`, the original as opened, and `samples.jsonl`,
/// one record per export or save, keyed by the image's BLAKE3. Saving an image
/// again, in this session or a later one, appends a newer record with the
/// same id; the last one wins. The directory is kept out of backups.
///
/// Record `mode`: `export` (boxes proposed by [ExportContext.model], then
/// chosen by the user) or `annotate` (drawn by the user, no model). Version 1
/// records have no `mode` and are exports.
class Collector {
  static const _version = 2;

  static Future<Directory> dir() async =>
      testDir ??
      Directory('${(await getApplicationDocumentsDirectory()).path}/collected');

  /// Replaces [dir] in tests, which have no documents directory.
  @visibleForTesting
  static Directory? testDir;

  /// Records [shot]: an export when [export] is given, else an annotation
  /// with [status].
  static Future<void> record(
    Shot shot, {
    ExportContext? export,
    AnnotateStatus status = AnnotateStatus.labeled,
  }) async {
    final d = await dir();
    if (!await d.exists()) {
      await d.create(recursive: true);
      // Unredacted originals: never into iCloud or device backups.
      await excludeFromBackup(path: d.path);
    }
    final images = await Directory('${d.path}/images').create();
    final id = await fileBlake3(path: shot.image.path);
    final ext = shot.name.contains('.') ? shot.name.split('.').last : 'img';
    final image = File('${images.path}/$id.$ext');
    if (!await image.exists()) {
      // Renamed into place, so an interrupted copy never looks complete.
      final tmp = await shot.image.copy('${image.path}.tmp');
      await tmp.rename(image.path);
    }
    final line = jsonEncode(
      sampleJson(
        shot,
        id: id,
        imageFile: 'images/$id.$ext',
        export: export,
        status: status,
      ),
    );
    await File('${d.path}/samples.jsonl')
        .writeAsString('$line\n', mode: FileMode.append, flush: true);
  }

  static Map<String, dynamic> sampleJson(
    Shot shot, {
    required String id,
    required String imageFile,
    ExportContext? export,
    AnnotateStatus status = AnnotateStatus.labeled,
  }) => {
    'v': _version,
    'id': id,
    'mode': export == null ? 'annotate' : 'export',
    if (export == null) 'status': status.name,
    'time': DateTime.now().toUtc().toIso8601String(),
    'image': {
      'file': imageFile,
      'width': shot.size.width,
      'height': shot.size.height,
      'camera_photo': shot.cameraPhoto,
    },
    if (export case final e?) ...{
      'model': {
        'blake3': e.hashes.model,
        'sidecar_blake3': e.hashes.sidecar,
        'backend': e.model.backend,
        'classes': e.model.classes,
        'domain': e.model.domain,
        'verified': e.model.verified,
      },
      'export': {
        'fill': e.fill.style.name,
        'forced': e.forced,
        // Detections the check still found readable after redaction.
        'surviving': [
          for (final r in e.outcome.surviving)
            {
              'bbox': _bbox(
                r.rect.left,
                r.rect.top,
                r.rect.right,
                r.rect.bottom,
              ),
              'class': r.className,
              'score': r.score,
            },
        ],
        // Indices into the selected boxes, in `boxes` order.
        'correlated': e.outcome.correlated.toList(),
      },
    },
    'boxes': [
      for (final b in shot.boxes)
        {
          'bbox': _bbox(b.rect.left, b.rect.top, b.rect.right, b.rect.bottom),
          'class': b.className,
          'initial_class': b.initialClass,
          'initial_bbox': _bbox(
            b.initialRect.left,
            b.initialRect.top,
            b.initialRect.right,
            b.initialRect.bottom,
          ),
          'score': b.score,
          'review': b.review,
          if (b.suggested) 'suggested': true,
          'source': b.source.name,
          // Boxes sharing a group are the lines of one value.
          if (b.group != null) 'group': b.group,
          'initial_selected': b.initialSelected,
          'selected': b.selected,
        },
    ],
  };

  static List<double> _bbox(double l, double t, double r, double b) => [
    l,
    t,
    r - l,
    b - t,
  ];

  /// The latest record of every image, in the order first recorded. A line
  /// cut short by a crash is skipped; the next save rewrites that record.
  static Future<List<Map<String, dynamic>>> samples() async {
    final f = File('${(await dir()).path}/samples.jsonl');
    if (!await f.exists()) return [];
    final latest = <String, Map<String, dynamic>>{};
    for (final l in await f.readAsLines()) {
      if (l.isEmpty) continue;
      try {
        final j = jsonDecode(l) as Map<String, dynamic>;
        latest[j['id'] as String] = j;
      } on FormatException {
        continue;
      }
    }
    return latest.values.toList();
  }

  /// Number of distinct images recorded, and bytes on disk.
  static Future<(int, int)> stats() async {
    final d = await dir();
    if (!await d.exists()) return (0, 0);
    var bytes = 0;
    await for (final f in d.list(recursive: true)) {
      if (f is File) bytes += await f.length();
    }
    return ((await samples()).length, bytes);
  }

  /// Deletes every record of the images whose latest record matches [test],
  /// and their image files.
  static Future<void> removeWhere(
    bool Function(Map<String, dynamic>) test,
  ) async {
    final d = await dir();
    final f = File('${d.path}/samples.jsonl');
    if (!await f.exists()) return;
    final gone = {
      for (final j in await samples())
        if (test(j)) j['id'] as String: j['image']['file'] as String,
    };
    if (gone.isEmpty) return;
    String? idOf(String l) {
      try {
        return (jsonDecode(l) as Map<String, dynamic>)['id'] as String;
      } on FormatException {
        return null;
      }
    }

    final kept = [
      for (final l in await f.readAsLines())
        if (idOf(l) case final id? when !gone.containsKey(id)) l,
    ];
    // Rewritten atomically, so an interruption leaves the old file.
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(kept.map((l) => '$l\n').join(), flush: true);
    await tmp.rename(f.path);
    for (final rel in gone.values) {
      final img = File('${d.path}/$rel');
      if (await img.exists()) await img.delete();
    }
  }

  /// The collected directory as one zip in the temporary directory, to hand
  /// to the share sheet; the caller deletes it afterwards.
  static Future<File> package() async {
    final d = await dir();
    final out = File(
      '${(await getTemporaryDirectory()).path}/unseen-data-'
      '${DateTime.now().toUtc().toIso8601String().replaceAll(':', '-')}.zip',
    );
    final zip = ZipFileEncoder()..create(out.path);
    await zip.addDirectory(d, includeDirName: false);
    await zip.close();
    return out;
  }

  static Future<void> clear() async {
    final d = await dir();
    if (await d.exists()) await d.delete(recursive: true);
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';

import 'boxes.dart';

/// App version included in feedback payloads (kept in sync with pubspec.yaml).
const feedbackAppVersion = '1.0.0+1';

/// Default Cloudflare Worker endpoint for anonymous detection feedback.
const defaultFeedbackEndpoint = String.fromEnvironment(
  'UNSEEN_FEEDBACK_URL',
  defaultValue: 'https://unseen-feedback.lollipopkit.workers.dev/v1/feedback',
);

/// Maximum longer side in pixels of feedback screenshots uploaded on-device.
const feedbackMaxImageSide = 1280;

/// Maximum note length accepted by the feedback worker.
const feedbackMaxNoteLength = 500;

/// Maximum boxes per array accepted by the feedback worker.
const feedbackMaxBoxes = 200;

/// Maximum `excluded_preference_count` accepted by the feedback worker.
const feedbackMaxExcludedPrefs = 500;

/// Maximum class name length accepted by the feedback worker.
const feedbackMaxClassLen = 64;

enum FeedbackPrivacyMode {
  masked('masked'),
  full('full'),
  text('text');

  const FeedbackPrivacyMode(this.wireValue);
  final String wireValue;
}

enum FeedbackTag {
  missed('missed'),
  falsePositive('false_positive'),
  boxDrift('box_drift'),
  wrongClass('wrong_class'),
  other('other');

  const FeedbackTag(this.wireValue);
  final String wireValue;
}

class FeedbackReceipt {
  const FeedbackReceipt({required this.id, required this.receivedAt});

  final String id;
  final String receivedAt;
}

class FeedbackException implements Exception {
  const FeedbackException(this.message);
  final String message;

  @override
  String toString() => message;
}

String currentFeedbackPlatform() {
  if (Platform.isIOS) return 'ios';
  if (Platform.isAndroid) return 'android';
  if (Platform.isMacOS) return 'macos';
  if (Platform.isLinux) return 'linux';
  if (Platform.isWindows) return 'windows';
  return 'linux';
}

String _capLen(String s, int maxLen) =>
    s.length > maxLen ? s.substring(0, maxLen) : s;

/// Immutable snapshot of a [FeedbackDraft] captured synchronously before async
/// image preparation and upload so mid-flight UI mutations cannot desynchronize
/// the redacted image from the JSON metadata.
class FeedbackSnapshot {
  const FeedbackSnapshot({
    required this.mode,
    required this.imageFile,
    required this.sourceSize,
    required this.maskedRegions,
    required this.missedEntries,
    required this.confirmedFpEntries,
    required this.excludedPreferenceCount,
    required this.tags,
    required this.note,
  });

  final FeedbackPrivacyMode mode;
  final File? imageFile;
  final Size? sourceSize;
  final List<Rect> maskedRegions;
  final List<({Rect rect, String className, double? score, bool maskedByUser})>
  missedEntries;
  final List<({Rect rect, String initialClass, double? score})>
  confirmedFpEntries;
  final int excludedPreferenceCount;
  final List<FeedbackTag> tags;
  final String? note;

  static List<double>? _bboxFor(Rect rect, Size srcSize, Size dstSize) {
    if (srcSize.width <= 0 ||
        srcSize.height <= 0 ||
        dstSize.width <= 0 ||
        dstSize.height <= 0) {
      return null;
    }
    final sx = dstSize.width / srcSize.width;
    final sy = dstSize.height / srcSize.height;
    final left = (rect.left * sx).clamp(0.0, dstSize.width);
    final top = (rect.top * sy).clamp(0.0, dstSize.height);
    final right = (rect.right * sx).clamp(0.0, dstSize.width);
    final bottom = (rect.bottom * sy).clamp(0.0, dstSize.height);
    final w = right - left;
    final h = bottom - top;
    if (w <= 0 || h <= 0) return null;
    double r1(double v) => double.parse(v.toStringAsFixed(1));
    final rw = math.max(0.1, r1(w));
    final rh = math.max(0.1, r1(h));
    return [r1(left), r1(top), rw, rh];
  }

  /// Builds the `unseen.feedback.v1` JSON payload matching the Worker schema.
  Map<String, dynamic> buildPayload({
    required String modelId,
    String? platform,
    String version = feedbackAppVersion,
    Size? uploadedSize,
  }) {
    final isText = mode == FeedbackPrivacyMode.text;
    final src = sourceSize;
    final dst = src == null ? null : (uploadedSize ?? src);
    final diffs = <Map<String, dynamic>>[];

    if (!isText && src != null && dst != null) {
      for (final e in missedEntries) {
        if (diffs.length >= feedbackMaxBoxes) break;
        final bbox = _bboxFor(e.rect, src, dst);
        if (bbox == null) continue;
        diffs.add({
          'kind': 'fn_missed',
          'bbox': bbox,
          'class': _capLen(e.className, feedbackMaxClassLen),
          if (e.score != null)
            'score': double.parse(e.score!.clamp(0.0, 1.0).toStringAsFixed(4)),
          if (mode == FeedbackPrivacyMode.masked && e.maskedByUser)
            'masked_by_user': true,
        });
      }
      for (final e in confirmedFpEntries) {
        if (diffs.length >= feedbackMaxBoxes) break;
        final bbox = _bboxFor(e.rect, src, dst);
        if (bbox == null) continue;
        diffs.add({
          'kind': 'fp_confirmed',
          'bbox': bbox,
          'initial_class': _capLen(e.initialClass, feedbackMaxClassLen),
          if (e.score != null)
            'score': double.parse(e.score!.clamp(0.0, 1.0).toStringAsFixed(4)),
        });
      }
    }

    Map<String, dynamic>? imageMeta;
    if (!isText && src != null && dst != null) {
      final masked = <List<double>>[];
      if (mode == FeedbackPrivacyMode.masked) {
        for (final r in maskedRegions) {
          if (masked.length >= feedbackMaxBoxes) break;
          final bbox = _bboxFor(r, src, dst);
          if (bbox != null) masked.add(bbox);
        }
      }
      imageMeta = {
        'width': dst.width.round().clamp(1, 16384),
        'height': dst.height.round().clamp(1, 16384),
        'masked_regions': masked,
      };
    }

    return {
      'schema': 'unseen.feedback.v1',
      'app_version': _capLen(version, 32),
      'platform': platform ?? currentFeedbackPlatform(),
      'model_id': _capLen(modelId, 128),
      'privacy_mode': mode.wireValue,
      'tags': [for (final t in tags) t.wireValue],
      'note': note,
      'image': imageMeta,
      'diffs': diffs,
      'excluded_preference_count': isText
          ? 0
          : excludedPreferenceCount.clamp(0, feedbackMaxExcludedPrefs),
    };
  }
}

/// Interactive feedback state derived from an optional edited [Shot].
///
/// Separates user preference (unchecked model boxes, neutral by default) from
/// confirmed model errors ([confirmedFp] and [missedBoxes]), and tracks which
/// boxes will be redacted before upload in [FeedbackPrivacyMode.masked].
class FeedbackDraft {
  FeedbackDraft({
    this.shot,
    FeedbackPrivacyMode? mode,
    Set<FeedbackTag>? tags,
    this.note = '',
  }) : mode =
           mode ??
           (shot == null
               ? FeedbackPrivacyMode.text
               : FeedbackPrivacyMode.masked),
       tags = tags ?? _defaultTags(shot) {
    _seedDefaultMasks();
  }

  Shot? shot;
  FeedbackPrivacyMode mode;
  final Set<FeedbackTag> tags;
  String note;

  /// Unchecked model boxes explicitly confirmed by the user as false positives.
  final Set<EditBox> confirmedFp = {};

  /// Missed boxes blacked out before uploading (telemetry only).
  final Set<EditBox> userMaskedFn = {};

  void _seedDefaultMasks() {
    userMaskedFn.clear();
    // Review boxes auto-selected by AdaptivePrefs were shown redacted in the
    // editor; mask them by default in masked mode to prevent unexpected leaks.
    for (final b in missedBoxes) {
      if (b.shownSelected && b.source == BoxSource.detector) {
        userMaskedFn.add(b);
      }
    }
  }

  static Set<FeedbackTag> _defaultTags(Shot? shot) {
    if (shot == null) return {};
    final out = <FeedbackTag>{};
    if (shot.boxes.any(_isMissedBox)) out.add(FeedbackTag.missed);
    return out;
  }

  /// Model-detected boxes that were kept selected (auto-redacted in masked
  /// mode), including `exportCheck` detections.
  static bool _isKeptModelBox(EditBox b) =>
      b.selected &&
      (b.source == BoxSource.exportCheck ||
          (b.source == BoxSource.detector &&
              (b.initialSelected || b.suggested)));

  /// Detector pre-selected boxes that the user unchecked (neutral preference
  /// until confirmed as false positive).
  static bool _isUncheckedModelBox(EditBox b) =>
      !b.selected && b.source == BoxSource.detector && b.initialSelected;

  /// Selected boxes the detector missed or scored below the select threshold.
  static bool _isMissedBox(EditBox b) =>
      b.selected &&
      (b.source == BoxSource.drawn ||
          b.source == BoxSource.found ||
          b.source == BoxSource.tapped ||
          (b.source == BoxSource.detector &&
              !b.initialSelected &&
              !b.suggested));

  List<EditBox> get keptModelBoxes =>
      shot == null ? const [] : shot!.boxes.where(_isKeptModelBox).toList();

  List<EditBox> get uncheckedModelBoxes => shot == null
      ? const []
      : shot!.boxes.where(_isUncheckedModelBox).toList();

  List<EditBox> get missedBoxes =>
      shot == null ? const [] : shot!.boxes.where(_isMissedBox).toList();

  /// Total edits relative to the raw detector output (used for entry badges).
  int get rawDiffCount => missedBoxes.length + uncheckedModelBoxes.length;

  /// Unchecked model boxes NOT confirmed as false positive (personal preference).
  int get excludedPreferenceCount {
    final unchecked = uncheckedModelBoxes;
    return unchecked.where((b) => !confirmedFp.contains(b)).length;
  }

  void setShot(Shot? next) {
    shot = next;
    confirmedFp.clear();
    _seedDefaultMasks();
    if (next == null) {
      mode = FeedbackPrivacyMode.text;
    } else if (mode == FeedbackPrivacyMode.text) {
      mode = FeedbackPrivacyMode.masked;
    }
    if (next != null && missedBoxes.isNotEmpty) {
      tags.add(FeedbackTag.missed);
    }
  }

  void toggleConfirmedFp(EditBox b) {
    if (!confirmedFp.remove(b)) {
      confirmedFp.add(b);
      tags.add(FeedbackTag.falsePositive);
    }
  }

  void toggleUserMaskedFn(EditBox b) {
    if (!userMaskedFn.remove(b)) {
      userMaskedFn.add(b);
    }
  }

  /// Rectangles in original shot pixel coordinates that must be blacked out
  /// before uploading the image.
  List<Rect> maskedRegionsForUpload() {
    if (shot == null || mode != FeedbackPrivacyMode.masked) return const [];
    final bounds = Offset.zero & shot!.size;
    final rects = <Rect>[];
    for (final b in [...keptModelBoxes, ...userMaskedFn]) {
      final clipped = b.rect.intersect(bounds);
      if (clipped.width > 0 && clipped.height > 0) rects.add(clipped);
    }
    return rects;
  }

  bool get canSubmit {
    final trimmed = note.trim();
    if (mode == FeedbackPrivacyMode.text) {
      return tags.isNotEmpty || trimmed.isNotEmpty;
    }
    return shot != null;
  }

  /// Captures an immutable submission snapshot synchronously.
  FeedbackSnapshot snapshot() {
    final s = shot;
    final rawNote = note.trim();
    final trimmedNote = rawNote.isEmpty
        ? null
        : _capLen(rawNote, feedbackMaxNoteLength);
    return FeedbackSnapshot(
      mode: mode,
      imageFile: s?.image,
      sourceSize: s?.size,
      maskedRegions: List.unmodifiable(maskedRegionsForUpload()),
      missedEntries: List.unmodifiable([
        for (final b in missedBoxes)
          (
            rect: b.rect,
            className: b.className,
            score: b.score,
            maskedByUser: userMaskedFn.contains(b),
          ),
      ]),
      confirmedFpEntries: List.unmodifiable([
        for (final b in uncheckedModelBoxes)
          if (confirmedFp.contains(b))
            (rect: b.rect, initialClass: b.initialClass, score: b.score),
      ]),
      excludedPreferenceCount: excludedPreferenceCount,
      tags: List.unmodifiable(tags),
      note: trimmedNote,
    );
  }

  /// Convenience wrapper for building a payload directly from current state.
  Map<String, dynamic> buildPayload({
    required String modelId,
    String? platform,
    String version = feedbackAppVersion,
    Size? uploadedSize,
  }) => snapshot().buildPayload(
    modelId: modelId,
    platform: platform,
    version: version,
    uploadedSize: uploadedSize,
  );
}

/// Uploads anonymous feedback payloads (and optional redacted screenshots) to
/// the Cloudflare Worker endpoint.
class FeedbackClient {
  FeedbackClient({Dio? dio, this.endpoint = defaultFeedbackEndpoint})
    : _ownsDio = dio == null,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 20),
            ),
          );

  final bool _ownsDio;
  final Dio _dio;
  final String endpoint;

  void close() {
    if (_ownsDio) _dio.close();
  }

  static Map<String, dynamic>? _tryDecodeMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return {for (final e in data.entries) e.key.toString(): e.value};
    }
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } on FormatException {
        return null;
      }
    }
    return null;
  }

  Future<FeedbackReceipt> submit({
    required Map<String, dynamic> payload,
    File? imageFile,
  }) async {
    try {
      final Response<dynamic> resp;
      if (imageFile != null) {
        final name = imageFile.uri.pathSegments.last;
        final form = FormData.fromMap({
          'payload': jsonEncode(payload),
          'image': await MultipartFile.fromFile(imageFile.path, filename: name),
        });
        resp = await _dio.post<dynamic>(endpoint, data: form);
      } else {
        resp = await _dio.post<dynamic>(
          endpoint,
          data: payload,
          options: Options(contentType: Headers.jsonContentType),
        );
      }

      final status = resp.statusCode ?? 0;
      final map = _tryDecodeMap(resp.data);

      if (status >= 200 && status < 300 && map != null && map['id'] is String) {
        return FeedbackReceipt(
          id: map['id'] as String,
          receivedAt: (map['received_at'] as String?) ?? '',
        );
      }
      final err = map?['error']?.toString() ?? 'HTTP $status';
      throw FeedbackException(err);
    } on DioException catch (e) {
      final map = _tryDecodeMap(e.response?.data);
      if (map?['error'] != null) {
        throw FeedbackException(map!['error'].toString());
      }
      throw FeedbackException(e.message ?? e.type.name);
    }
  }
}

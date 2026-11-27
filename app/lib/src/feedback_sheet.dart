import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:fl_lib/fl_lib.dart'
    show SegmentedTab, SegmentedTabs, SheetScaffold, showResizableSheet;
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/app_localizations.dart';
import 'boxes.dart';
import 'editor.dart';
import 'feedback.dart';
import 'intro_page.dart';
import 'platform_bridge.dart';
import 'rust/api.dart';

/// Opens the offline privacy-first feedback bottom sheet.
///
/// The app never sends network requests itself: once the user confirms what to
/// share, the sheet encodes the annotations (and, when under the URL budget,
/// the redacted JPEG) into the `#fragment` of the web feedback URL and hands
/// it off to the system browser.
Future<bool?> showFeedbackSheet(
  BuildContext context, {
  Shot? shot,
  Session? model,
  ModelInfo? info,
  Future<bool> Function(Uri uri)? launchUri,
}) => showResizableSheet<bool>(
  context,
  restLimit: SheetScaffold.restLimit,
  builder: (context) => _FeedbackSheet(
    initialShot: shot,
    model: model,
    info: info,
    launchUri: launchUri,
  ),
);

class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet({
    required this.initialShot,
    required this.model,
    required this.info,
    required this.launchUri,
  });

  final Shot? initialShot;
  final Session? model;
  final ModelInfo? info;
  final Future<bool> Function(Uri uri)? launchUri;

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  late final _draft = FeedbackDraft(
    shot: widget.model != null ? widget.initialShot : null,
    mode: widget.model == null || widget.initialShot == null
        ? FeedbackPrivacyMode.text
        : FeedbackPrivacyMode.masked,
  );
  late final _noteCtrl = TextEditingController();
  bool _preparing = false;
  bool _picking = false;
  String? _error;

  static final _mobile = Platform.isIOS || Platform.isAndroid;

  bool get _locked => _preparing || _picking;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickScreenshot() async {
    final model = widget.model;
    if (model == null || _locked) return;
    setState(() {
      _picking = true;
      _error = null;
    });
    try {
      String? path;
      if (_mobile) {
        final picked = await PlatformBridge.pickMedia(
          multiple: false,
          allowVideo: false,
        );
        path = picked.firstOrNull;
      } else {
        final picked = await openFile(
          acceptedTypeGroups: [
            XTypeGroup(
              label: AppLocalizations.of(context).imagesFileType,
              extensions: const [
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
              ],
            ),
          ],
        );
        path = picked?.path;
      }
      if (path == null || !mounted) return;
      final prepared = await PlatformBridge.prepareImage(path);
      final file = File(prepared);
      final detected = await model.detect(imagePath: file.path);
      if (!mounted) return;
      setState(() {
        _draft.setShot(Shot.detected(file, detected));
      });
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<Size> _readImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    try {
      final frame = await codec.getNextFrame();
      try {
        return Size(
          frame.image.width.toDouble(),
          frame.image.height.toDouble(),
        );
      } finally {
        frame.image.dispose();
      }
    } finally {
      codec.dispose();
    }
  }

  Future<String> _resolveModelId() async {
    final model = widget.model;
    if (model != null) {
      try {
        final hashes = await model.hashes();
        final shortHash = hashes.model.substring(
          0,
          math.min(16, hashes.model.length),
        );
        final domain = widget.info?.domain;
        return domain == null ? shortHash : '$domain@$shortHash';
      } catch (_) {
        return widget.info?.domain ?? 'unknown';
      }
    }
    return widget.info?.domain ?? 'none';
  }

  Future<(Uint8List, Size)> _renderFeedbackJpeg({
    required Session model,
    required File imgFile,
    required List<PixelRect> rects,
    required String outPath,
    required int maxSide,
    required int quality,
  }) async {
    final outcome = await model.redactAndExport(
      imagePath: imgFile.path,
      outPath: outPath,
      rects: rects,
      fill: Fill(style: FillStyle.solid, color: 0x000000, seed: BigInt.zero),
      force: true,
      maxSide: maxSide,
      jpegQuality: quality,
    );
    if (!outcome.written) {
      throw StateError('Failed to prepare redacted image');
    }
    final file = File(outPath);
    final bytes = await file.readAsBytes();
    final size = await _readImageSize(file);
    return (bytes, size);
  }

  Future<void> _openWebFeedback() async {
    if (_locked || !_draft.canSubmit) return;
    // Capture an immutable snapshot synchronously before the first await so
    // the prepared image and JSON metadata are guaranteed consistent.
    final snap = _draft.snapshot();
    setState(() {
      _preparing = true;
      _error = null;
    });
    File? tempFile;
    try {
      final modelId = await _resolveModelId();
      Size? uploadedSize;
      Uint8List? inlineImage;
      var imageDeferred = false;

      if (snap.mode != FeedbackPrivacyMode.text) {
        final imgFile = snap.imageFile;
        final model = widget.model;
        if (imgFile == null || model == null) {
          throw StateError('No model available to prepare image');
        }
        final dir = await getTemporaryDirectory();
        final outPath =
            '${dir.path}/unseen-fb-${DateTime.now().microsecondsSinceEpoch}.jpg';
        tempFile = File(outPath);
        final rects = [
          for (final r in snap.maskedRegions)
            PixelRect(
              left: r.left,
              top: r.top,
              right: r.right,
              bottom: r.bottom,
            ),
        ];
        // Windows ShellExecuteW caps URLs at ~32 KiB, so skip encoding an
        // inline JPEG there and hand off the pre-filled annotations + masks.
        final allowInline = !Platform.isWindows;
        if (!allowInline) {
          uploadedSize = snap.sourceSize;
          imageDeferred = true;
        } else {
          const attempts = [
            (feedbackMaxImageSide, 70),
            (feedbackMaxImageSide, 55),
            (960, 55),
          ];
          Size? lastSize;
          for (final (side, quality) in attempts) {
            final (bytes, size) = await _renderFeedbackJpeg(
              model: model,
              imgFile: imgFile,
              rects: rects,
              outPath: outPath,
              maxSide: side,
              quality: quality,
            );
            lastSize = size;
            if (bytes.length <= feedbackMaxInlineImageBytes) {
              inlineImage = bytes;
              break;
            }
          }
          uploadedSize = lastSize;
          if (inlineImage == null) {
            imageDeferred = true;
          }
        }
      }

      final payload = snap.buildPayload(
        modelId: modelId,
        uploadedSize: uploadedSize,
      );
      final uri = buildFeedbackWebUri(
        payload: payload,
        imageBytes: inlineImage,
        imageDeferred: imageDeferred,
      );
      final launcher =
          widget.launchUri ?? (Uri u) => openExternalUrl(u.toString());
      final launched = await launcher(uri);
      if (!mounted) return;
      if (!launched) {
        setState(() => _error = 'Could not open browser');
        return;
      }
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      if (mounted) setState(() => _preparing = false);
    }
  }

  String _tagLabel(AppLocalizations l, FeedbackTag tag) => switch (tag) {
    FeedbackTag.missed => l.feedbackTagMissed,
    FeedbackTag.falsePositive => l.feedbackTagFalsePositive,
    FeedbackTag.boxDrift => l.feedbackTagBoxDrift,
    FeedbackTag.wrongClass => l.feedbackTagWrongClass,
    FeedbackTag.other => l.feedbackTagOther,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final shot = _draft.shot;
    final canAttachImage = widget.model != null;

    return PopScope(
      canPop: !_preparing,
      child: SheetScaffold(
        title: Text(l.feedbackTitle),
        actions: [
          TextButton(
            onPressed: _preparing ? null : () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton.icon(
            onPressed: _locked || !_draft.canSubmit ? null : _openWebFeedback,
            icon: _preparing
                ? SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.open_in_new, size: 17),
            label: Text(l.feedbackOpenWeb),
          ),
        ],
        child: SingleChildScrollView(
          child: AbsorbPointer(
            absorbing: _locked,
            child: Opacity(
              opacity: _locked ? 0.6 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (shot != null && canAttachImage) ...[
                    SegmentedTabs<FeedbackPrivacyMode>(
                      expand: true,
                      segments: [
                        SegmentedTab(
                          value: FeedbackPrivacyMode.masked,
                          label: l.feedbackModeMasked,
                        ),
                        SegmentedTab(
                          value: FeedbackPrivacyMode.full,
                          label: l.feedbackModeFull,
                        ),
                        SegmentedTab(
                          value: FeedbackPrivacyMode.text,
                          label: l.feedbackModeText,
                        ),
                      ],
                      selected: _draft.mode,
                      onSelected: (v) {
                        if (!_locked) setState(() => _draft.mode = v);
                      },
                    ),
                    const SizedBox(height: 12),
                  ] else if (shot == null && canAttachImage) ...[
                    OutlinedButton.icon(
                      onPressed: _locked ? null : _pickScreenshot,
                      icon: _picking
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_photo_alternate_outlined),
                      label: Text(l.feedbackAttachScreenshot),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (shot != null &&
                      _draft.mode != FeedbackPrivacyMode.text) ...[
                    _FeedbackPreview(
                      shot: shot,
                      draft: _draft,
                      enabled: !_locked,
                      onChanged: () => setState(() {}),
                      onClear: widget.initialShot == null && !_locked
                          ? () => setState(() => _draft.setShot(null))
                          : null,
                    ),
                    const SizedBox(height: 8),
                    _PreviewLegend(draft: _draft),
                    const SizedBox(height: 12),
                  ],
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      for (final tag in FeedbackTag.values)
                        FilterChip(
                          label: Text(_tagLabel(l, tag)),
                          selected: _draft.tags.contains(tag),
                          onSelected: _locked
                              ? null
                              : (on) => setState(() {
                                  on
                                      ? _draft.tags.add(tag)
                                      : _draft.tags.remove(tag);
                                }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteCtrl,
                    enabled: !_locked,
                    maxLength: feedbackMaxNoteLength,
                    minLines: 2,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l.feedbackNoteHint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _draft.note = v),
                  ),
                  if (_error case final err?) ...[
                    const SizedBox(height: 6),
                    Text(
                      err,
                      style: textTheme.bodySmall?.copyWith(color: scheme.error),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewLegend extends StatelessWidget {
  const _PreviewLegend({required this.draft});

  final FeedbackDraft draft;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final maskedCount = draft.mode == FeedbackPrivacyMode.masked
        ? draft.keptModelBoxes.length + draft.userMaskedFn.length
        : 0;
    final fnCount = draft.missedBoxes.length;
    final fpCount = draft.confirmedFp.length;
    final prefCount = draft.excludedPreferenceCount;

    Widget pill(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        if (maskedCount > 0)
          pill(Colors.black, l.feedbackCountMasked(maskedCount)),
        if (fnCount > 0)
          pill(_FeedbackColors.missed, l.feedbackCountMissed(fnCount)),
        if (fpCount > 0)
          pill(_FeedbackColors.fpConfirmed, l.feedbackCountFp(fpCount)),
        if (prefCount > 0)
          pill(
            _FeedbackColors.preference,
            l.feedbackCountPreference(prefCount),
          ),
      ],
    );
  }
}

class _FeedbackColors {
  static const missed = Color(0xFFE5484D);
  static const fpConfirmed = Color(0xFFE08200);
  static const preference = Color(0xFF7A828E);
  static const keptFull = Color(0xFF30A46C);
}

/// Interactive preview of what will be uploaded.
///
/// Tapping an unchecked model box toggles between neutral preference and
/// confirmed false positive. In masked mode, tapping a missed box toggles
/// whether it is blacked out before upload.
class _FeedbackPreview extends StatelessWidget {
  const _FeedbackPreview({
    required this.shot,
    required this.draft,
    required this.enabled,
    required this.onChanged,
    this.onClear,
  });

  final Shot shot;
  final FeedbackDraft draft;
  final bool enabled;
  final VoidCallback onChanged;
  final VoidCallback? onClear;

  void _handleTap(Offset localPos, Size widgetSize) {
    if (!enabled) return;
    final img = shot.size;
    if (img.width <= 0 || img.height <= 0) return;
    final scale = math.min(
      widgetSize.width / img.width,
      widgetSize.height / img.height,
    );
    final dx = (widgetSize.width - img.width * scale) / 2;
    final dy = (widgetSize.height - img.height * scale) / 2;
    final p = Offset((localPos.dx - dx) / scale, (localPos.dy - dy) / scale);

    final candidates = <(EditBox, bool)>[
      for (final b in draft.uncheckedModelBoxes) (b, true),
      if (draft.mode == FeedbackPrivacyMode.masked)
        for (final b in draft.missedBoxes) (b, false),
    ];

    (EditBox, bool)? pick(double pad) {
      (EditBox, bool)? best;
      double bestArea = double.infinity;
      for (final entry in candidates) {
        final r = entry.$1.rect;
        if ((pad == 0 ? r : r.inflate(pad)).contains(p)) {
          final area = r.width * r.height;
          if (area < bestArea) {
            best = entry;
            bestArea = area;
          }
        }
      }
      return best;
    }

    final hit = pick(0) ?? pick(12 / scale);
    if (hit == null) return;
    final (box, isFpCandidate) = hit;
    if (isFpCandidate) {
      draft.toggleConfirmedFp(box);
    } else {
      draft.toggleUserMaskedFn(box);
    }
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textDirection = Directionality.of(context);
    final aspect = shot.size.width / math.max(1.0, shot.size.height);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: scheme.surfaceContainerHighest,
        constraints: const BoxConstraints(maxHeight: 280),
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: aspect.clamp(0.4, 2.5),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.biggest;
                    return GestureDetector(
                      onTapUp: enabled
                          ? (d) => _handleTap(d.localPosition, size)
                          : null,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            shot.image,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.medium,
                          ),
                          CustomPaint(
                            painter: _FeedbackOverlayPainter(
                              shot: shot,
                              draft: draft,
                              textDirection: textDirection,
                              labelMissed: l.feedbackBoxMissed,
                              labelMissedMasked: l.feedbackBoxMissedMasked,
                              labelFp: l.feedbackBoxFp,
                              labelPreference: l.feedbackBoxPreference,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            if (onClear case final clear?)
              Positioned(
                top: 6,
                right: 6,
                child: IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  onPressed: clear,
                  icon: const Icon(Icons.close, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackOverlayPainter extends CustomPainter {
  _FeedbackOverlayPainter({
    required this.shot,
    required this.draft,
    required this.textDirection,
    required this.labelMissed,
    required this.labelMissedMasked,
    required this.labelFp,
    required this.labelPreference,
  });

  final Shot shot;
  final FeedbackDraft draft;
  final TextDirection textDirection;
  final String labelMissed;
  final String labelMissedMasked;
  final String labelFp;
  final String labelPreference;

  void _drawPill(Canvas canvas, Rect box, String text, Color bg, double px) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 10 * px,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textDirection: textDirection,
    )..layout();
    final padX = 5 * px;
    final padY = 2 * px;
    final pillW = tp.width + padX * 2;
    final pillH = tp.height + padY * 2;
    final top = box.top - pillH - 2 * px >= 0
        ? box.top - pillH - 2 * px
        : box.top + 2 * px;
    final left = box.left
        .clamp(0.0, math.max(0.0, shot.size.width - pillW))
        .toDouble();
    final pill = Rect.fromLTWH(left, top, pillW, pillH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(pill, Radius.circular(4 * px)),
      Paint()..color = bg,
    );
    tp.paint(canvas, Offset(pill.left + padX, pill.top + padY));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final img = shot.size;
    if (img.width <= 0 || img.height <= 0) return;
    final scale = math.min(size.width / img.width, size.height / img.height);
    final dx = (size.width - img.width * scale) / 2;
    final dy = (size.height - img.height * scale) / 2;
    final px = 1 / scale;

    canvas
      ..save()
      ..translate(dx, dy)
      ..scale(scale);

    final maskedMode = draft.mode == FeedbackPrivacyMode.masked;

    // 1. Kept model boxes (TP): blacked out in masked mode, green outline in full.
    for (final b in draft.keptModelBoxes) {
      if (maskedMode) {
        canvas.drawRect(b.rect, Paint()..color = Colors.black);
      } else {
        canvas.drawRect(
          b.rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5 * px
            ..color = _FeedbackColors.keptFull,
        );
      }
    }

    // 2. Unchecked model boxes: slate dashed (preference) or amber solid (FP).
    for (final b in draft.uncheckedModelBoxes) {
      final isFp = draft.confirmedFp.contains(b);
      if (isFp) {
        canvas
          ..drawRect(
            b.rect,
            Paint()..color = _FeedbackColors.fpConfirmed.withValues(alpha: .16),
          )
          ..drawRect(
            b.rect,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2 * px
              ..color = _FeedbackColors.fpConfirmed,
          );
        _drawPill(canvas, b.rect, labelFp, _FeedbackColors.fpConfirmed, px);
      } else {
        drawDashedRect(canvas, b.rect, _FeedbackColors.preference, px, 1.5);
        _drawPill(
          canvas,
          b.rect,
          labelPreference,
          _FeedbackColors.preference,
          px,
        );
      }
    }

    // 3. Missed boxes (FN): rose solid, or blacked out when user-masked.
    for (final b in draft.missedBoxes) {
      final masked = maskedMode && draft.userMaskedFn.contains(b);
      if (masked) {
        canvas.drawRect(b.rect, Paint()..color = Colors.black);
        drawDashedRect(canvas, b.rect, _FeedbackColors.missed, px, 1.8);
        _drawPill(
          canvas,
          b.rect,
          labelMissedMasked,
          _FeedbackColors.missed,
          px,
        );
      } else {
        canvas
          ..drawRect(
            b.rect,
            Paint()..color = _FeedbackColors.missed.withValues(alpha: .14),
          )
          ..drawRect(
            b.rect,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2 * px
              ..color = _FeedbackColors.missed,
          );
        _drawPill(canvas, b.rect, labelMissed, _FeedbackColors.missed, px);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_FeedbackOverlayPainter old) => true;
}

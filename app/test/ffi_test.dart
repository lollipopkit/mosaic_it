// End-to-end through the generated bindings against a host build of
// crates/unseen-ffi:
//
//   cargo build --release -p unseen-ffi
//   UNSEEN_TEST_MODEL=path/to/model.onnx UNSEEN_TEST_IMAGE=path/to/img.png flutter test test/ffi_test.dart
//
// Skipped when the environment variables are not set; the video test also
// needs UNSEEN_TEST_VIDEO (a short screen recording with private data).

import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unseen/l10n/app_localizations.dart';
import 'package:unseen/src/rust/api.dart';
import 'package:unseen/src/rust/frb_generated.dart';
import 'package:unseen/src/editor.dart';
import 'package:unseen/src/video_page.dart';

void main() {
  final model = Platform.environment['UNSEEN_TEST_MODEL'];
  final image = Platform.environment['UNSEEN_TEST_IMAGE'];
  final video = Platform.environment['UNSEEN_TEST_VIDEO'];
  final skip = model == null || image == null
      ? 'set UNSEEN_TEST_MODEL and UNSEEN_TEST_IMAGE'
      : null;

  setUpAll(() async {
    if (skip != null) return;
    final ext = Platform.isMacOS ? 'dylib' : 'so';
    await RustLib.init(
      externalLibrary: ExternalLibrary.open(
        '../target/release/libunseen_ffi.$ext',
      ),
    );
  });

  test('load, detect, export', () async {
    final s = await Session.load(modelPath: model!);
    final info = s.info();
    expect(info.classes, isNotEmpty);

    final d = await s.detect(imagePath: image!);
    expect(d.width, greaterThan(0));
    expect(d.regions.every((r) => r.rect.right > r.rect.left), isTrue);

    final out = '${Directory.systemTemp.createTempSync('unseen').path}/out.png';
    final selected = d.regions
        .where((r) => r.state == RegionState.selected)
        .map((r) => r.rect)
        .toList();
    final forced = await s.redactAndExport(
      imagePath: image,
      outPath: out,
      rects: selected,
      fill: Fill(style: FillStyle.noise, color: 0, seed: BigInt.one),
      force: true,
    );
    expect(forced.written, isTrue);
    expect(File(out).existsSync(), isTrue);
    if (d.regions.isNotEmpty) {
      final q = d.regions.first.rect;
      final similar = await findSimilarRegions(imagePath: image, rect: q);
      expect(similar.every((m) => m.top != q.top || m.left != q.left), isTrue);
    }

    // Searching another image finds the query itself there.
    final copy =
        '${Directory.systemTemp.createTempSync('unseen').path}/copy.png';
    File(image).copySync(copy);
    // Any detected region is textured enough to match.
    expect(d.regions, isNotEmpty, reason: 'the test image needs detections');
    final q = d.regions.first.rect;
    final there = await findSimilarRegions(
      imagePath: image,
      rect: q,
      targetPath: copy,
    );
    expect(
      there.any(
        (m) => (m.left - q.left).abs() < 1 && (m.top - q.top).abs() < 1,
      ),
      isTrue,
      reason: 'query not found in a copy of its image',
    );

    // Nothing redacted: every pre-selected region survives, so the check
    // must refuse to write.
    File(out).deleteSync();
    final none = await s.redactAndExport(
      imagePath: image,
      outPath: out,
      rects: const [],
      fill: Fill(style: FillStyle.solid, color: 0, seed: BigInt.one),
      force: false,
    );
    if (selected.isNotEmpty) {
      expect(none.written, isFalse);
      expect(none.surviving, isNotEmpty);
      expect(File(out).existsSync(), isFalse);
    }
  }, skip: skip);

  test('video: analyze, preview, export', () async {
    final s = await Session.load(modelPath: model!);
    final tmp = Directory.systemTemp.createTempSync('unseen-video');
    final p = VideoProject(videoPath: video!, cacheDir: '${tmp.path}/cache');
    final seen = await p.analyze(session: s).toList();
    final sum = p.summary();
    expect(sum.frames, greaterThan(0));
    expect(seen.last, sum.frames);
    expect(sum.times, hasLength(sum.frames));
    expect(sum.keyframes.first, 0);
    expect(sum.tracks, isNotEmpty);

    // The preview of a frame between keyframes is the keyframe before it.
    final last = sum.frames - 1;
    final k = sum.keyframes.lastWhere((k) => k <= last);
    expect(
      p.previewPath(frame: last),
      endsWith('kf${'$k'.padLeft(6, '0')}.jpg'),
    );
    expect(File(p.previewPath(frame: last)).existsSync(), isTrue);
    final t0 = sum.tracks.indexWhere((t) => t.frames.isNotEmpty);
    expect(
      p.boxesAt(frame: sum.tracks[t0].frames.first).any((b) => b.track == t0),
      isTrue,
    );

    // A drawn region becomes a manual track, followed across keyframes.
    final first = sum.tracks.firstWhere((t) => t.frames.length > 1);
    final at = first.frames.first;
    final drawn = p
        .boxesAt(frame: at)
        .firstWhere((b) => sum.tracks[b.track] == first);
    final m = await p.addManual(frame: at, rect: drawn.rect);
    final withManual = p.summary();
    expect(m, sum.tracks.length);
    expect(withManual.tracks[m].className, 'manual');
    expect(withManual.tracks[m].frames.length, greaterThan(1));

    // Every track redacted: written (forced, since a model may flag
    // things it only finds once the rest is covered).
    final out = '${tmp.path}/out.mp4';
    final all = [for (var i = 0; i < withManual.tracks.length; i++) i];
    final done = await p
        .export_(
          session: s,
          outPath: out,
          opts: VideoExportOptions(
            tracks: Uint32List.fromList(all),
            fill: Fill(style: FillStyle.solid, color: 0, seed: BigInt.one),
            keepAudio: false,
            force: true,
          ),
        )
        .last;
    expect(done.result!.written, isTrue);
    expect(done.frames, sum.frames);
    expect(File(out).lengthSync(), greaterThan(0));

    // Nothing redacted: refused at the first keyframe with selected
    // detections, and no file left behind.
    File(out).deleteSync();
    final refused = await p
        .export_(
          session: s,
          outPath: out,
          opts: VideoExportOptions(
            tracks: Uint32List.fromList([]),
            fill: Fill(style: FillStyle.solid, color: 0, seed: BigInt.one),
            keepAudio: false,
            force: false,
          ),
        )
        .last;
    expect(refused.result!.written, isFalse);
    expect(refused.result!.failed!.surviving, isNotEmpty);
    expect(File(out).existsSync(), isFalse);
    expect(tmp.listSync().whereType<File>(), isEmpty);
  }, skip: skip ?? (video == null ? 'set UNSEEN_TEST_VIDEO' : null));

  testWidgets('video page: analyse, list tracks, toggle', (tester) async {
    final s = await tester.runAsync(() => Session.load(modelPath: model!));
    final tmp = Directory.systemTemp.createTempSync('unseen-page');
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VideoPage(
          session: s!,
          fill: Fill(style: FillStyle.solid, color: 0, seed: BigInt.one),
          video: File(video!),
          tempDir: () async => tmp,
        ),
      ),
    );
    // Analysis runs on Rust threads; give it real time.
    for (var i = 0; i < 600 && find.byType(Slider).evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    expect(find.byType(Slider), findsOneWidget);
    final boxes = find.byType(CheckboxListTile);
    expect(boxes, findsWidgets);
    final first = tester.widget<CheckboxListTile>(boxes.first);
    await tester.tap(boxes.first);
    await tester.pump();
    expect(
      tester.widget<CheckboxListTile>(boxes.first).value,
      isNot(first.value),
    );
    expect(find.textContaining('tracks redacted'), findsOneWidget);

    // Draw mode: a dragged box becomes a manual track.
    // The list is lazy, so count tracks from its header.
    int tracks() => int.parse(
      RegExp(r'of (\d+) tracks')
          .firstMatch(
            tester.widget<Text>(find.textContaining('tracks redacted')).data!,
          )!
          .group(1)!,
    );
    final before = tracks();
    await tester.tap(find.byIcon(Icons.crop_square));
    await tester.pump();
    final editor = tester.getRect(find.byType(BoxEditor));
    await tester.dragFrom(editor.center, const Offset(80, 30));
    for (
      var i = 0;
      i < 200 && find.byType(LinearProgressIndicator).evaluate().isNotEmpty ||
          i == 0;
      i++
    ) {
      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    expect(tracks(), before + 1);

    // Leaving the page deletes the keyframe images.
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 200)),
    );
    expect(tmp.listSync(), isEmpty);
  }, skip: skip != null || video == null);
}

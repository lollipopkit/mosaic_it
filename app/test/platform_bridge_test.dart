import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unseen/src/platform_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.lollipopkit.unseen/platform');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    PlatformBridge.resetForTest();
    messenger.setMockMethodCallHandler(channel, null);
  });

  tearDown(() {
    PlatformBridge.resetForTest();
    messenger.setMockMethodCallHandler(channel, null);
  });

  Future<void> simulateNativeIncoming(List<Object?> args) async {
    final data = const StandardMethodCodec().encodeMethodCall(
      MethodCall('onIncomingFiles', args),
    );
    await messenger.handlePlatformMessage(channel.name, data, (_) {});
  }

  test(
    'buffers incoming files until drained, then streams live events',
    () async {
      PlatformBridge.ensureInitialized();

      // Native pushes files before any Dart stream listener attaches.
      await simulateNativeIncoming(['/tmp/a.png', '', 123, '/tmp/b.jpg']);

      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getIncomingFiles') {
          return ['/tmp/cold.webp'];
        }
        return null;
      });

      final drained = await PlatformBridge.drainIncomingFiles();
      expect(drained, ['/tmp/a.png', '/tmp/b.jpg', '/tmp/cold.webp']);

      // Once a listener is attached, incoming events stream directly.
      final live = <List<String>>[];
      final sub = PlatformBridge.incomingFiles.listen(live.add);
      addTearDown(sub.cancel);

      await simulateNativeIncoming(['/tmp/live.png']);
      await Future<void>.delayed(Duration.zero);
      expect(live, [
        ['/tmp/live.png'],
      ]);
    },
  );

  test(
    'pickMedia, copyImage, saveImage, and prepareImage forward via channel',
    () async {
      final calls = <String, Object?>{};
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls[call.method] = call.arguments;
        return switch (call.method) {
          'pickMedia' => ['/tmp/picked.jpg', ''],
          'copyImage' => true,
          'saveImage' => true,
          'prepareImage' => '/tmp/converted.jpg',
          _ => null,
        };
      });

      expect(
        await PlatformBridge.pickMedia(multiple: false, allowVideo: false),
        ['/tmp/picked.jpg'],
      );
      expect(calls['pickMedia'], {'multiple': false, 'allowVideo': false});
      expect(await PlatformBridge.copyImageToClipboard('/tmp/out.png'), isTrue);
      expect(await PlatformBridge.saveImageToPhotos('/tmp/out.png'), isTrue);

      // Native formats pass through without calling native bridge.
      expect(
        await PlatformBridge.prepareImage('/tmp/native.png'),
        '/tmp/native.png',
      );
      expect(calls.containsKey('prepareImage'), isFalse);

      // Dotted directory with extensionless file must NOT look like ".png".
      expect(PlatformBridge.extensionOf('/tmp/dir.png/noext'), '');
      expect(
        await PlatformBridge.prepareImage('/tmp/dir.png/noext'),
        '/tmp/converted.jpg',
      );
      expect(
        await PlatformBridge.prepareImage('/tmp/photo.HEIC'),
        '/tmp/converted.jpg',
      );
    },
  );
}

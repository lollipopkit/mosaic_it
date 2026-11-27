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
    'copyImageToClipboard forwards path and returns platform result',
    () async {
      String? copiedPath;
      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'copyImage') {
          copiedPath = (call.arguments as Map)['path'] as String?;
          return true;
        }
        return null;
      });

      final ok = await PlatformBridge.copyImageToClipboard('/tmp/out.png');
      expect(ok, isTrue);
      expect(copiedPath, '/tmp/out.png');
    },
  );
}

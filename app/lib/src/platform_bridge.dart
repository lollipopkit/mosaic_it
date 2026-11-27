import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Native platform integrations that require zero third-party plugins:
/// - Copying a redacted image file to the system clipboard.
/// - Receiving images/videos shared or opened from the OS (Android Share,
///   iOS Open-In, macOS Open-With and window drag-and-drop).
class PlatformBridge {
  PlatformBridge._();

  static const _channel = MethodChannel('com.lollipopkit.unseen/platform');
  static final _incoming = StreamController<List<String>>.broadcast();
  static final _buffered = <String>[];
  static bool _initialized = false;

  /// Whether this OS has a native `copyImage` handler wired up.
  static bool get supportsCopyImage =>
      Platform.isIOS || Platform.isAndroid || Platform.isMacOS;

  static void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onIncomingFiles') {
        final paths = _parsePaths(call.arguments);
        if (paths.isEmpty) return;
        if (_incoming.hasListener) {
          _incoming.add(paths);
        } else {
          _buffered.addAll(paths);
        }
      }
    });
  }

  /// Stream of file paths delivered while the app is already running.
  static Stream<List<String>> get incomingFiles {
    ensureInitialized();
    return _incoming.stream;
  }

  /// Drains any file paths delivered at cold launch or before a listener attached.
  static Future<List<String>> drainIncomingFiles() async {
    ensureInitialized();
    final out = <String>[..._buffered];
    _buffered.clear();
    try {
      final raw = await _channel.invokeMethod<dynamic>('getIncomingFiles');
      out.addAll(_parsePaths(raw));
    } on MissingPluginException {
      // Unsupported in widget tests.
    } catch (_) {}
    return out;
  }

  /// Copies the image file at [path] onto the system clipboard.
  static Future<bool> copyImageToClipboard(String path) async {
    ensureInitialized();
    try {
      return await _channel.invokeMethod<bool>('copyImage', {'path': path}) ??
          false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static List<String> _parsePaths(dynamic raw) {
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is String && item.isNotEmpty) item,
    ];
  }

  @visibleForTesting
  static void resetForTest() {
    _buffered.clear();
    _initialized = false;
    _channel.setMethodCallHandler(null);
  }
}

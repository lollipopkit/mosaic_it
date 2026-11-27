import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Native platform integrations that require zero third-party plugins:
/// - Selecting images/videos via the OS photo picker (iOS `PHPickerViewController`,
///   Android `MediaStore.ACTION_PICK_IMAGES` / `ACTION_OPEN_DOCUMENT`) with zero
///   photo-library read or camera permissions.
/// - Copying a redacted image file to the system clipboard.
/// - Saving a redacted image to the system Photos / Gallery (write-only).
/// - Transcoding non-PNG/JPEG/WebP images (HEIC/TIFF/BMP/GIF) to upright JPEG.
/// - Receiving images/videos shared or opened from the OS (Android Share,
///   iOS Open-In, macOS Open-With and window drag-and-drop).
class PlatformBridge {
  PlatformBridge._();

  static const _channel = MethodChannel('com.lollipopkit.unseen/platform');
  static final _incoming = StreamController<List<String>>.broadcast();
  static final _buffered = <String>[];
  static bool _initialized = false;

  static const _nativeImageExts = {'png', 'jpg', 'jpeg', 'webp'};

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

  /// Opens the native zero-permission media picker on iOS (`PHPicker`) and
  /// Android (`ACTION_PICK_IMAGES` / `ACTION_OPEN_DOCUMENT`).
  static Future<List<String>> pickMedia({
    bool multiple = true,
    bool allowVideo = true,
  }) async {
    ensureInitialized();
    try {
      final raw = await _channel.invokeMethod<dynamic>('pickMedia', {
        'multiple': multiple,
        'allowVideo': allowVideo,
      });
      return _parsePaths(raw);
    } on MissingPluginException {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  /// On iOS, reports whether cellular/wireless data is currently restricted
  /// (true on China-mainland fresh installs before the system prompt is answered).
  static Future<bool> isWirelessDataRestricted() async {
    if (!Platform.isIOS) return false;
    ensureInitialized();
    try {
      return await _channel.invokeMethod<bool>('isWirelessDataRestricted') ??
          false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
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

  /// Saves the redacted image at [path] into the system Photos library using
  /// write-only access (iOS `PHPhotoLibrary .addOnly`, Android `MediaStore`).
  static Future<bool> saveImageToPhotos(String path) async {
    ensureInitialized();
    try {
      return await _channel.invokeMethod<bool>('saveImage', {'path': path}) ??
          false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Returns the lowercase extension of [path]'s basename, or empty if none.
  static String extensionOf(String path) {
    final slash = math.max(path.lastIndexOf('/'), path.lastIndexOf('\\'));
    final dot = path.lastIndexOf('.');
    if (dot <= slash + 1 || dot >= path.length - 1) return '';
    return path.substring(dot + 1).toLowerCase();
  }

  /// Ensures [path] is in a format Rust's `image` decoder supports (PNG, JPEG,
  /// or WebP) by transcoding HEIC/TIFF/BMP/GIF via the OS decoder when needed.
  static Future<String> prepareImage(String path) async {
    if (_nativeImageExts.contains(extensionOf(path))) {
      return path;
    }
    ensureInitialized();
    try {
      final out = await _channel.invokeMethod<String>('prepareImage', {
        'path': path,
      });
      if (out != null && out.isNotEmpty) return out;
    } on MissingPluginException {
      // Unsupported in widget tests.
    } catch (_) {}
    return path;
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

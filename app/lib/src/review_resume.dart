import 'dart:convert';
import 'dart:io';

import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path_provider/path_provider.dart';

/// Remembers the label folder under review so the next launch continues it.
/// The macOS sandbox forgets picked folders on quit, so there a
/// security-scoped bookmark is kept with the path.
class ReviewResume {
  static Future<File> _file() async =>
      File('${(await getApplicationSupportDirectory()).path}/review.json');

  static Future<void> save(String dir) async {
    final bookmark = Platform.isMacOS
        ? await SecureBookmarks().bookmark(Directory(dir))
        : null;
    await (await _file()).writeAsString(
      jsonEncode({'path': dir, 'bookmark': ?bookmark}),
    );
  }

  static Future<void> clear() async {
    final f = await _file();
    if (await f.exists()) await f.delete();
  }

  /// The folder last under review, made accessible again; null when there
  /// is none or it can no longer be reached.
  static Future<String?> load() async {
    final f = await _file();
    if (!await f.exists()) return null;
    try {
      final j = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      final path = j['path'] as String;
      if (j['bookmark'] case final String b) {
        final dir = await SecureBookmarks().resolveBookmark(
          b,
          isDirectory: true,
        );
        await SecureBookmarks().startAccessingSecurityScopedResource(dir);
        return dir.path;
      }
      return path;
    } on Exception {
      // A moved or deleted folder: forget it rather than fail every launch.
      await clear();
      return null;
    }
  }
}

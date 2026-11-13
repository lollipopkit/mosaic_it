import 'dart:io';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'app_icon.dart';

/// The launcher icon shown by the platform: iOS alternate icons, Android
/// launcher aliases.
abstract final class LauncherIcon {
  static const _channel = MethodChannel('com.lollipopkit.unseen/app_icon');

  static bool get supported => Platform.isIOS || Platform.isAndroid;

  static Future<AppIcon> current() async =>
      AppIcon.values.asNameMap()[await _channel.invokeMethod<String>('get')] ??
      AppIcon.fallback;

  static Future<void> set(AppIcon icon) =>
      _channel.invokeMethod<void>('set', icon.name);
}

/// [icon] as the launcher draws it.
class AppIconPreview extends StatelessWidget {
  const AppIconPreview(this.icon, {super.key, required this.size});

  final AppIcon icon;
  final double size;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * 0.225),
    child: CustomPaint(size: Size.square(size), painter: _Mosaic(icon)),
  );
}

class _Mosaic extends CustomPainter {
  const _Mosaic(this.icon);

  final AppIcon icon;

  @override
  void paint(Canvas canvas, Size size) {
    const n = AppIcon.side;
    final tile = size.width / n, tiles = icon.tiles;
    // Not anti-aliased: neighbouring tiles would show a seam.
    final paint = Paint()..isAntiAlias = false;
    for (var i = 0; i < tiles.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i % n * tile, i ~/ n * tile, tile, tile),
        paint..color = Color(0xFF000000 | tiles[i]),
      );
    }
  }

  @override
  bool shouldRepaint(_Mosaic old) => old.icon != icon;
}

/// The built-in icons; pops with the tapped one.
class AppIconPicker extends StatelessWidget {
  const AppIconPicker({super.key, required this.current});

  final AppIcon current;

  @override
  Widget build(BuildContext context) {
    final ring = Theme.of(context).colorScheme.primary;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final icon in AppIcon.values)
              Semantics(
                button: true,
                selected: icon == current,
                label:
                    '${AppLocalizations.of(context).appIcon} ${icon.index + 1}',
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(icon),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: icon == current ? ring : Colors.transparent,
                      ),
                    ),
                    child: AppIconPreview(icon, size: 64),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

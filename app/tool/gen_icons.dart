// Draws every launcher icon asset from lib/src/app_icon.dart:
//
//   dart run tool/gen_icons.dart
//
// iOS: one 1024px app icon set per colourway. macOS: the default colourway
// at every size. Android: adaptive icons as vector drawables.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:image/image.dart';
import 'package:unseen/src/app_icon.dart';

const _n = AppIcon.side;

void main() {
  final ios = Directory('ios/Runner/Assets.xcassets');
  for (final icon in AppIcon.values) {
    final set = Directory('${ios.path}/${_iosName(icon)}.appiconset');
    if (set.existsSync()) set.deleteSync(recursive: true);
    set.createSync(recursive: true);
    File('${set.path}/icon.png').writeAsBytesSync(encodePng(_mosaic(icon)));
    _writeJson('${set.path}/Contents.json', {
      'images': [
        {
          'filename': 'icon.png',
          'idiom': 'universal',
          'platform': 'ios',
          'size': '1024x1024',
        },
      ],
      'info': {'author': 'xcode', 'version': 1},
    });
  }

  final mac = _macShape(_mosaic(AppIcon.fallback, channels: 4));
  for (final size in [16, 32, 64, 128, 256, 512, 1024]) {
    File('macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_$size.png')
        .writeAsBytesSync(
          encodePng(
            copyResize(mac, width: size, interpolation: Interpolation.average),
          ),
        );
  }

  _expect('ios/Runner.xcodeproj/project.pbxproj', _iosName);
  _expect(
    'android/app/src/main/AndroidManifest.xml',
    (icon) => 'android:name=".icon.${icon.name}"',
  );

  const res = 'android/app/src/main/res';
  Directory('$res/mipmap-anydpi').createSync(recursive: true);
  File('$res/drawable/ic_launcher_mono.xml').writeAsStringSync(
    _vector(AppIcon.fallback.tiles.map(_monochrome).toList()),
  );
  for (final icon in AppIcon.values) {
    File(
      '$res/drawable/ic_launcher_${icon.name}.xml',
    ).writeAsStringSync(_vector([for (final c in icon.tiles) '#${_hex(c)}']));
    File('$res/mipmap-anydpi/ic_launcher_${icon.name}.xml')
        .writeAsStringSync('''
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background>
        <color android:color="#${_hex(icon.base)}" />
    </background>
    <foreground android:drawable="@drawable/ic_launcher_${icon.name}" />
    <monochrome android:drawable="@drawable/ic_launcher_mono" />
</adaptive-icon>
''');
  }
}

String _iosName(AppIcon icon) => 'AppIcon-${icon.name}';

/// Exits unless [path] mentions every icon: those lists are kept by hand.
void _expect(String path, String Function(AppIcon) mention) {
  final text = File(path).readAsStringSync();
  final missing = [
    for (final icon in AppIcon.values)
      if (!text.contains(mention(icon))) mention(icon),
  ];
  if (missing.isEmpty) return;
  stderr.writeln('$path lacks ${missing.join(', ')}');
  exitCode = 1;
}

String _hex(int rgb) => rgb.toRadixString(16).padLeft(6, '0').toUpperCase();

void _writeJson(String path, Object json) => File(path)
    .writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(json)}\n');

/// The full-bleed 1024px mosaic.
Image _mosaic(AppIcon icon, {int channels = 3}) {
  const size = 1024, tile = size ~/ _n;
  final image = Image(width: size, height: size, numChannels: channels);
  final tiles = icon.tiles;
  for (var i = 0; i < tiles.length; i++) {
    final x = i % _n * tile, y = i ~/ _n * tile, c = tiles[i];
    fillRect(
      image,
      x1: x,
      y1: y,
      x2: x + tile - 1,
      y2: y + tile - 1,
      color: ColorRgb8(c >> 16, (c >> 8) & 0xFF, c & 0xFF),
    );
  }
  return image;
}

/// The macOS icon shape: an 824px rounded square centred in 1024px.
Image _macShape(Image mosaic) {
  const size = 1024, body = 824, radius = 185.0, half = body / 2;
  final scaled = copyResize(mosaic, width: body, height: body);
  final out = Image(width: size, height: size, numChannels: 4);
  for (final p in out) {
    // Signed distance to the rounded square, for a one pixel soft edge.
    final dx = (p.x + 0.5 - size / 2).abs() - (half - radius);
    final dy = (p.y + 0.5 - size / 2).abs() - (half - radius);
    final outside = sqrt(pow(max(dx, 0), 2) + pow(max(dy, 0), 2));
    final distance = outside + min(max(dx, dy), 0) - radius;
    final alpha = (0.5 - distance).clamp(0.0, 1.0);
    if (alpha == 0) continue;
    final src = scaled.getPixelClamped(
      p.x - (size - body) ~/ 2,
      p.y - (size - body) ~/ 2,
    );
    p.setRgba(src.r, src.g, src.b, (alpha * 255).round());
  }
  return out;
}

/// White at the tile's lightness: the launcher tints the monochrome layer by
/// its alpha.
String _monochrome(int rgb) {
  final luma =
      (0.299 * (rgb >> 16) + 0.587 * ((rgb >> 8) & 0xFF) + 0.114 * (rgb & 0xFF))
          .round();
  return '#${luma.toRadixString(16).padLeft(2, '0').toUpperCase()}FFFFFF';
}

/// A 108dp adaptive icon layer. The mosaic covers the 72dp safe zone; the
/// rim, which masks and motion effects may show, repeats the nearest tile.
String _vector(List<String> colors) {
  const tile = 18, rim = 1;
  final paths = StringBuffer();
  for (var row = -rim; row < _n + rim; row++) {
    for (var col = -rim; col < _n + rim; col++) {
      final color = colors[row.clamp(0, _n - 1) * _n + col.clamp(0, _n - 1)];
      final x = (col + rim) * tile, y = (row + rim) * tile;
      paths.writeln(
        '    <path android:fillColor="$color" '
        'android:pathData="M$x,${y}h${tile}v${tile}h-${tile}z" />',
      );
    }
  }
  return '''
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
$paths</vector>
''';
}

/// Built-in launcher icons: one mosaic in several colourways.
///
/// Pure Dart, so `tool/gen_icons.dart` draws the platform assets from the
/// same tiles the settings page previews. After changing this file run
/// `dart run tool/gen_icons.dart`; a new value also needs an `activity-alias`
/// in AndroidManifest.xml and an entry in the iOS build setting
/// `ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES`; the tool fails without them.
enum AppIcon {
  wine(0x730C37, 0xE5484D),
  blue(0x3E63DD, 0x8E4EC6),
  green(0x2B9A66, 0x0090FF),
  orange(0xF76B15, 0xE5484D),
  purple(0x8E4EC6, 0xD6409F),
  graphite(0x4A4D57, 0x8B8D98);

  const AppIcon(this.base, this.accent);

  /// 0xRRGGBB. [fallback]'s is also the default theme seed.
  final int base;

  /// 0xRRGGBB, mixed into the tiles towards the top right corner.
  final int accent;

  /// The icon the platform shows until another is chosen.
  static const fallback = wine;

  /// Tiles per side.
  static const side = 4;

  /// Row-major 0xRRGGBB tiles, [side] × [side].
  List<int> get tiles => [
    for (final (light, mix) in _tiles)
      _lerp(
        _lerp(base, accent, mix),
        light < 0 ? 0x000000 : 0xFFFFFF,
        light.abs(),
      ),
  ];
}

/// Per tile: lightness shift (negative darkens) and share of the accent.
const _tiles = [
  (0.22, 0.0), (0.0, 0.0), (0.05, 0.45), (0.25, 0.9), //
  (-0.3, 0.0), (0.5, 0.0), (-0.15, 0.35), (0.0, 0.75), //
  (0.12, 0.0), (-0.2, 0.0), (0.7, 0.1), (-0.3, 0.5), //
  (0.35, 0.0), (-0.05, 0.0), (-0.4, 0.0), (0.3, 0.2), //
];

int _lerp(int a, int b, double t) {
  int channel(int shift) {
    final x = (a >> shift) & 0xFF, y = (b >> shift) & 0xFF;
    return (x + (y - x) * t).round() << shift;
  }

  return channel(16) | channel(8) | channel(0);
}

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/theme.dart';

import 'app_icon.dart';

/// App settings in fl_lib's encrypted SQLite store (key in the platform
/// keychain), shared with fl_lib's theme code through [ThemeSettings].
class SettingStore extends SqliteStore with ThemeSettings {
  SettingStore() : super('setting');

  static final instance = SettingStore();

  /// Seeded from the default launcher icon instead of fl_lib's colour.
  @override
  SqlitePropDefault<int> get colorSeed => _colorSeed;
  late final _colorSeed = propertyDefault(
    'primaryColor',
    0xFF000000 | AppIcon.fallback.base,
  );

  /// `FillStyle` name: how selected boxes are hidden, in the editor and on
  /// export.
  late final fillStyle = propertyDefault('fillStyle', 'solid');

  /// 0xRRGGBB for the solid fill.
  late final fillColor = propertyDefault('fillColor', 0x000000);

  /// `ExportFormat` name of exported images.
  late final exportFormat = propertyDefault('exportFormat', 'png');

  /// Longest side of exported images in pixels; 0 keeps the original size.
  late final exportMaxSide = propertyDefault('exportMaxSide', 0);

  /// Gallery zoom level: 0 has the largest cells; 1 is five columns on a phone.
  late final gridZoom = propertyDefault('gridZoom', 1);

  /// Gallery cells show the whole image instead of a square crop.
  late final gridAspect = propertyDefault('gridAspect', false);

  /// Keep exported images and box choices on the device as training data.
  late final collect = propertyDefault('collect', false);

  /// Replace a released model with newer releases as they are published.
  late final autoUpdateModel = propertyDefault('autoUpdateModel', true);

  /// `ThresholdPreset` name: scales the model's thresholds.
  late final threshold = propertyDefault('threshold', 'medium');

  /// Classes detected but not pre-selected.
  late final offClasses = listProperty<String>(
    'offClasses',
    defaultValue: defaultOffClasses.toList(),
  );
}

/// Faces are left to the user: a photo's faces are often meant to be seen.
const defaultOffClasses = {'face'};

/// What was done to a photo-library item, by asset id, for the gallery's
/// badges: [redacted] or [annotated].
class MarksStore extends SqliteStore {
  MarksStore() : super('marks');

  static final instance = MarksStore();

  static const redacted = 'redacted';
  static const annotated = 'annotated';

  String? of(String assetId) => get<String>(assetId);

  void mark(String assetId, String what) => set(assetId, what);
}

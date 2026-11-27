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

  /// Whether the first-launch offline intro has been completed.
  late final introSeen = propertyDefault('introSeen', false);

  /// `ThresholdPreset` name: scales the model's thresholds.
  late final threshold = propertyDefault('threshold', 'medium');

  /// Classes detected but not pre-selected.
  late final offClasses = listProperty<String>(
    'offClasses',
    defaultValue: defaultOffClasses.toList(),
  );

  /// Adjust per-class pre-selection thresholds locally from user edits.
  late final adaptivePreselect = propertyDefault('adaptivePreselect', true);

  /// JSON map of per-class threshold offsets learned on this device.
  late final adaptiveOffsets = propertyDefault('adaptiveOffsets', '{}');
}

/// Faces are left to the user: a photo's faces are often meant to be seen.
const defaultOffClasses = {'face'};

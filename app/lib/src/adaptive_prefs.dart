import 'dart:convert';

import 'boxes.dart';
import 'rust/api.dart';
import 'store.dart';

/// Local-only per-class threshold adjustments learned from user edits on
/// export. Never uploaded or synced.
class AdaptivePrefs {
  AdaptivePrefs({this.read, this.write});

  static final instance = AdaptivePrefs(
    read: () => SettingStore.instance.adaptiveOffsets.get(),
    write: (v) => SettingStore.instance.adaptiveOffsets.set(v),
  );

  static const double minDelta = -0.15;
  static const double maxDelta = 0.20;
  static const double stepUncheck = 0.02;
  static const double stepSelect = -0.02;
  static const double keepDecay = 0.95;
  static const double pruneEps = 0.005;
  static const double uncalibratedSelect = 0.30;
  static const double minThreshold = 0.05;
  static const double maxThreshold = 0.95;

  final String Function()? read;
  final Future<void> Function(String)? write;

  final Map<String, double> _offsets = {};
  bool _loaded = false;

  Map<String, double> get offsets {
    _ensureLoaded();
    return Map.unmodifiable(_offsets);
  }

  int get learnedCount {
    _ensureLoaded();
    return _offsets.length;
  }

  void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    final raw = read?.call();
    if (raw != null && raw.isNotEmpty) {
      loadFromJson(raw);
    }
  }

  void loadFromJson(String raw) {
    _offsets.clear();
    _loaded = true;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;
      for (final MapEntry(:key, :value) in decoded.entries) {
        if (value is num && value.isFinite) {
          final v = value.toDouble().clamp(minDelta, maxDelta);
          if (v.abs() >= pruneEps) _offsets[key] = v;
        }
      }
    } on FormatException {
      // Corrupt store entry: fall back to empty offsets.
    }
  }

  String toJson() {
    _ensureLoaded();
    return jsonEncode({
      for (final MapEntry(:key, :value) in _offsets.entries)
        key: double.parse(value.toStringAsFixed(4)),
    });
  }

  static double _presetScale(ThresholdPreset preset) => switch (preset) {
    ThresholdPreset.low => 2.0 / 3.0,
    ThresholdPreset.medium => 1.0,
    ThresholdPreset.high => 4.0 / 3.0,
  };

  /// Applies learned per-class threshold offsets to [shot] before it enters
  /// the editor, updating [EditBox.shownSelected] while preserving
  /// [EditBox.initialSelected] for feedback diffs.
  void apply(
    Shot shot, {
    required bool enabled,
    required Set<String> offClasses,
    ThresholdPreset preset = ThresholdPreset.medium,
    Map<String, double> baseThresholds = const {},
  }) {
    _ensureLoaded();
    final scale = _presetScale(preset);
    for (final b in shot.boxes) {
      b.selected = b.initialSelected;
      final cls = b.initialClass;
      if (enabled &&
          b.source == BoxSource.detector &&
          !b.suggested &&
          !offClasses.contains(cls)) {
        final delta = _offsets[cls] ?? 0.0;
        final score = b.score;
        if (delta != 0.0 && score != null) {
          final rawBase = baseThresholds[cls] ?? uncalibratedSelect;
          final base = (rawBase * scale).clamp(minThreshold, maxThreshold);
          final effective = (base + delta).clamp(minThreshold, maxThreshold);
          // Monotonic adjustment: positive delta only unselects; negative
          // delta only promotes review boxes.
          if (delta > 0 && b.initialSelected && score < effective) {
            b.selected = false;
          } else if (delta < 0 && !b.initialSelected && score >= effective) {
            b.selected = true;
          }
        }
      }
      b.shownSelected = b.selected;
    }
  }

  /// Updates per-class offsets from the user's final selections on export,
  /// aggregated per class so a single dense screenshot moves any class by at
  /// most one step. Returns whether any stored offset changed.
  Future<bool> recordExport(
    Shot shot, {
    required bool enabled,
    required Set<String> offClasses,
  }) async {
    if (!enabled) return false;
    _ensureLoaded();

    final counts = <String, ({int unchecks, int selects, int keeps})>{};
    for (final b in shot.boxes) {
      final cls = b.initialClass;
      if (b.source != BoxSource.detector ||
          b.suggested ||
          offClasses.contains(cls)) {
        continue;
      }
      final c = counts[cls] ?? (unchecks: 0, selects: 0, keeps: 0);
      if (b.shownSelected && !b.selected) {
        counts[cls] = (
          unchecks: c.unchecks + 1,
          selects: c.selects,
          keeps: c.keeps,
        );
      } else if (!b.shownSelected && b.selected) {
        counts[cls] = (
          unchecks: c.unchecks,
          selects: c.selects + 1,
          keeps: c.keeps,
        );
      } else if (b.shownSelected && b.selected) {
        counts[cls] = (
          unchecks: c.unchecks,
          selects: c.selects,
          keeps: c.keeps + 1,
        );
      }
    }

    var changed = false;
    for (final MapEntry(key: cls, value: c) in counts.entries) {
      final prev = _offsets[cls] ?? 0.0;
      double next;
      if (c.unchecks > c.selects) {
        next = prev + stepUncheck;
      } else if (c.selects > c.unchecks) {
        next = prev + stepSelect;
      } else if (c.keeps > 0 && c.unchecks == 0 && c.selects == 0 && prev > 0) {
        // Only decay positive offsets when the user agrees with pre-selection;
        // keeping boxes under a negative offset confirms the lower threshold.
        next = prev * keepDecay;
      } else {
        continue;
      }
      next = next.clamp(minDelta, maxDelta);
      if (next.abs() < pruneEps) {
        if (_offsets.remove(cls) != null) changed = true;
      } else if ((next - prev).abs() >= 1e-6) {
        _offsets[cls] = next;
        changed = true;
      }
    }
    if (changed) {
      await _persist();
    }
    return changed;
  }

  Future<void> reset() async {
    _loaded = true;
    _offsets.clear();
    await _persist();
  }

  Future<void> _persist() async {
    final fn = write;
    if (fn != null) {
      await fn(toJson());
    }
  }
}

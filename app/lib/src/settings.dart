import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/app_localizations.dart';
import 'app_icon.dart';
import 'app_icon_picker.dart';
import 'collect.dart';
import 'l10n.dart';
import 'rust/api.dart';
import 'store.dart';

import 'package:fl_lib/theme.dart';

/// App-wide settings, backed by [SettingStore].
class AppSettings {
  AppSettings({
    required this.fillStyle,
    required this.fillColor,
    this.collect = false,
    this.autoUpdateModel = true,
    this.threshold = ThresholdPreset.medium,
    this.offClasses = defaultOffClasses,
  });

  /// How every selected box is hidden, in the editor and on export.
  FillStyle fillStyle;

  /// 0xRRGGBB for [FillStyle.solid].
  int fillColor;

  /// Keep exported images and box choices on the device as training data.
  bool collect;

  /// Download newer model releases; they take effect at the next launch.
  bool autoUpdateModel;

  /// Scales the model's thresholds: low pre-selects more, high less.
  ThresholdPreset threshold;

  /// Applies what the detector reads from the settings to [s].
  void applyTo(Session s) => s
    ..setOffClasses(classes: offClasses.toList())
    ..setThreshold(preset: threshold);

  /// Classes detected but not pre-selected; the export check skips them.
  Set<String> offClasses;

  /// One seed per launch: random fills look the same in the preview and the
  /// export, and a video's fill does not flicker.
  static final _seed = BigInt.from(Random.secure().nextInt(1 << 32));

  Fill get fill => Fill(style: fillStyle, color: fillColor, seed: _seed);

  static SettingStore get _store => SettingStore.instance;

  static Future<AppSettings> load() async {
    await _migrateJson();
    return AppSettings(
      fillStyle:
          FillStyle.values.asNameMap()[_store.fillStyle.get()] ??
          FillStyle.solid,
      fillColor: _store.fillColor.get(),
      collect: _store.collect.get(),
      autoUpdateModel: _store.autoUpdateModel.get(),
      threshold:
          ThresholdPreset.values.asNameMap()[_store.threshold.get()] ??
          ThresholdPreset.medium,
      offClasses: _store.offClasses.get().toSet(),
    );
  }

  Future<void> save() => Future.wait([
    _store.fillStyle.set(fillStyle.name),
    _store.fillColor.set(fillColor),
    _store.collect.set(collect),
    _store.autoUpdateModel.set(autoUpdateModel),
    _store.threshold.set(threshold.name),
    _store.offClasses.set(offClasses.toList()),
  ]);

  /// Moves settings.json (versions before the SQLite store) into the store.
  // TODO: remove once no install can still have settings.json.
  static Future<void> _migrateJson() async {
    final f = File(
      '${(await getApplicationSupportDirectory()).path}/settings.json',
    );
    if (!await f.exists()) return;
    try {
      final j = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      if (j['fillStyle'] case final String v) await _store.fillStyle.set(v);
      if (j['fillColor'] case final int v) await _store.fillColor.set(v);
      if (j['collect'] case final bool v) await _store.collect.set(v);
    } on FormatException {
      // Unreadable: the store's defaults stand.
    }
    await f.delete();
  }
}

/// Fill colours offered for solid redaction, 0xRRGGBB.
const fillSwatches = [
  0x000000,
  0xFFFFFF,
  0x8B8D98,
  0xFF4FA3,
  0xE5322D,
  0x1677FF,
];

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.settings,
    this.classes = const [],
    this.info,
    this.onChooseModel,
  });

  final AppSettings settings;

  /// The loaded model's classes, for [AppSettings.offClasses].
  final List<String> classes;

  /// The loaded model: its calibration and inference backend.
  final ModelInfo? info;

  /// Imports a model chosen by the user (advanced).
  final Future<void> Function()? onChooseModel;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Collected records and bytes; null until counted.
  (int, int)? _collected;

  /// The launcher icon; null until read, or where it cannot be changed.
  AppIcon? _icon;

  @override
  void initState() {
    super.initState();
    _countCollected();
    if (LauncherIcon.supported) _readIcon();
  }

  Future<void> _readIcon() async {
    final icon = await LauncherIcon.current();
    if (mounted) setState(() => _icon = icon);
  }

  Future<void> _pickIcon(AppIcon current) async {
    final icon = await showModalBottomSheet<AppIcon>(
      context: context,
      showDragHandle: true,
      builder: (_) => AppIconPicker(current: current),
    );
    if (icon == null || icon == current) return;
    try {
      await LauncherIcon.set(icon);
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
      return;
    }
    if (mounted) setState(() => _icon = icon);
  }

  Future<void> _countCollected() async {
    final c = await Collector.stats();
    if (mounted) setState(() => _collected = c);
  }

  void _set(void Function(AppSettings) f) {
    setState(() => f(widget.settings));
    widget.settings.save();
  }

  Future<void> _deleteCollected(AppLocalizations t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(t.collectDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await Collector.clear();
    await _countCollected();
  }

  static String _size(int bytes) => bytes < 1 << 20
      ? '${(bytes / 1024).toStringAsFixed(0)} KB'
      : '${(bytes / (1 << 20)).toStringAsFixed(1)} MB';

  String _styleName(AppLocalizations t) => switch (widget.settings.fillStyle) {
    FillStyle.solid => t.fillSolid,
    FillStyle.surround => t.fillSurround,
    FillStyle.blocks => t.fillBlocks,
    FillStyle.tinted => t.fillTinted,
    FillStyle.noise => t.fillNoise,
  };

  Future<void> _pickStyle() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheet) => SafeArea(
        child: SingleChildScrollView(
          child: FillPicker(
            settings: widget.settings,
            onChanged: () {
              _set((_) {});
              setSheet(() {});
            },
          ),
        ),
      ),
    ),
  );

  Future<void> _pickClasses() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheet) {
        final l = AppLocalizations.of(context);
        final off = widget.settings.offClasses;
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final c in widget.classes)
                CheckboxListTile(
                  title: Text(classLabel(l, c)),
                  value: !off.contains(c),
                  dense: true,
                  onChanged: (on) {
                    _set(
                      (s) => s.offClasses = on == true
                          ? ({...off}..remove(c))
                          : {...off, c},
                    );
                    setSheet(() {});
                  },
                ),
            ],
          ),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = widget.settings;
    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          header(t.appearance),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(t.theme),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const _AppearancePage()),
            ),
          ),
          if (_icon case final icon?)
            ListTile(
              leading: const Icon(Icons.apps),
              title: Text(t.appIcon),
              trailing: AppIconPreview(icon, size: 32),
              onTap: () => _pickIcon(icon),
            ),
          header(t.redaction),
          ListTile(
            leading: const Icon(Icons.blur_on),
            title: Text(t.style),
            trailing: Text(_styleName(t)),
            onTap: _pickStyle,
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(t.threshold),
            trailing: SegmentedButton(
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              segments: [
                for (final (v, label) in [
                  (ThresholdPreset.low, t.thresholdLow),
                  (ThresholdPreset.medium, t.thresholdMedium),
                  (ThresholdPreset.high, t.thresholdHigh),
                ])
                  ButtonSegment(value: v, label: Text(label)),
              ],
              selected: {s.threshold},
              onSelectionChanged: (v) => _set((s) => s.threshold = v.single),
            ),
          ),
          if (widget.classes.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.checklist),
              title: Text(t.selectedByDefault),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickClasses,
            ),
          header(t.dataPrivacy),
          SwitchListTile(
            secondary: const Icon(Icons.dataset_outlined),
            title: Text(t.collectTitle),
            subtitle: Text(t.collectSubtitle),
            value: s.collect,
            onChanged: (v) => _set((s) => s.collect = v),
          ),
          if (_collected case (final n, final bytes) when n > 0 || bytes > 0)
            ListTile(
              title: Text(t.collectStats(n, _size(bytes))),
              subtitle: Text(t.localOnly),
              trailing: TextButton(
                onPressed: () => _deleteCollected(t),
                child: Text(t.collectDelete),
              ),
            ),
          header(t.model),
          if (widget.info case final i?)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(switch ((i.domain, i.verified)) {
                (null, _) => t.notCalibrated,
                (final d?, false) => t.calibratedUnverified(d),
                (final d?, true) => t.calibratedFor(d),
              }),
              subtitle: Text(i.backend),
            ),
          SwitchListTile(
            secondary: const Icon(Icons.system_update_alt),
            title: Text(t.autoUpdateModel),
            value: s.autoUpdateModel,
            onChanged: (v) => _set((s) => s.autoUpdateModel = v),
          ),
          if (widget.onChooseModel case final choose?)
            ListTile(
              leading: const Icon(Icons.memory),
              title: Text(t.importModel),
              subtitle: Text(t.advanced),
              onTap: () async {
                await choose();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          header(t.about),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(t.licenses),
            onTap: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }
}

/// fl_lib's appearance settings: theme mode, colour, presets, fonts.
class _AppearancePage extends StatefulWidget {
  const _AppearancePage();

  @override
  State<_AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<_AppearancePage> {
  @override
  Widget build(BuildContext context) {
    final a = ThemeAppearance(context, (f) {
      if (mounted) setState(f);
    });
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).theme)),
      body: ListView(
        children: [
          for (final r in [...a.themeRows(), ...a.fontRows()]) r.build(),
        ],
      ),
    );
  }
}

/// Fill style radio list and, for a solid fill, the colour swatches.
class FillPicker extends StatelessWidget {
  const FillPicker({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final AppSettings settings;

  /// After [settings] changed; the caller saves and redraws.
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = settings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioGroup<FillStyle>(
          groupValue: s.fillStyle,
          onChanged: (v) {
            if (v == null) return;
            s.fillStyle = v;
            onChanged();
          },
          child: Column(
            children: [
              for (final (v, label) in [
                (FillStyle.solid, t.fillSolid),
                (FillStyle.surround, t.fillSurround),
                (FillStyle.blocks, t.fillBlocks),
                (FillStyle.tinted, t.fillTinted),
                (FillStyle.noise, t.fillNoise),
              ])
                RadioListTile(value: v, title: Text(label), dense: true),
            ],
          ),
        ),
        if (s.fillStyle == FillStyle.solid)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Wrap(
              spacing: 10,
              children: [
                for (final c in fillSwatches)
                  GestureDetector(
                    onTap: () {
                      s.fillColor = c;
                      onChanged();
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF000000 | c),
                      child: c == s.fillColor
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color:
                                  Color(0xFF000000 | c).computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

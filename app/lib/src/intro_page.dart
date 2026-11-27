import 'dart:io';

import 'package:fl_lib/fl_lib.dart' show IntroPage, IntroPageArgs;
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import 'model_store.dart';
import 'store.dart';

/// Public GitHub repository for MosaicIt (AGPL-3.0).
const mosaicRepoUrl = 'https://github.com/lollipopkit/mosaic_it';
const mosaicRepoDisplay = 'github.com/lollipopkit/mosaic_it';

/// Concise platform-specific zero-network fact shown in Intro and Settings.
String platformNoNetPermBody(AppLocalizations l) {
  if (Platform.isAndroid) return l.introNoNetPermBodyAndroid;
  if (Platform.isMacOS) return l.introNoNetPermBodyDesktop;
  return l.introNoNetPermBodyIos;
}

/// Opens [url] in the system browser only (`LaunchMode.externalApplication`),
/// never falling back to an in-app WebView (which would fail without network
/// permissions in release builds).
Future<bool> openExternalUrl(String url) async {
  try {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

/// Single-page onboarding flow built on `fl_lib`'s [IntroPage]:
/// states clearly that the app has no networking capability or network
/// permissions, bundles the detector model, and links to the GitHub source.
class MosaicIntroPage extends StatefulWidget {
  const MosaicIntroPage({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<MosaicIntroPage> createState() => _MosaicIntroPageState();
}

class _MosaicIntroPageState extends State<MosaicIntroPage> {
  String _modelVersion = ModelStore.bundledModelVersion;

  @override
  void initState() {
    super.initState();
    _readModelVersion();
  }

  Future<void> _readModelVersion() async {
    final v = await ModelStore.resolveBundledVersion();
    if (mounted && v != _modelVersion) setState(() => _modelVersion = v);
  }

  Future<void> _finish() async {
    await SettingStore.instance.introSeen.set(true);
    if (!mounted) return;
    widget.onDone();
  }

  Widget _offlinePage(BuildContext context, AppLocalizations l) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          color: scheme.onPrimaryContainer,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        l.introOfflineTitle,
                        style: text.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        l.introOfflineBody,
                        style: text.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Card.filled(
                  margin: const EdgeInsets.only(bottom: 12),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.shield_outlined,
                          color: scheme.primary,
                        ),
                        title: Text(l.introNoNetPermTitle),
                        subtitle: Text(platformNoNetPermBody(l)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.memory, color: scheme.primary),
                        title: Text(l.introBundledModelTitle),
                        subtitle: Text(l.introBundledModelBody(_modelVersion)),
                      ),
                    ],
                  ),
                ),
                Card.filled(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Icon(Icons.code, color: scheme.primary),
                    title: Text(l.openSource),
                    subtitle: Text(
                      mosaicRepoDisplay,
                      style: TextStyle(color: scheme.primary),
                    ),
                    trailing: const Icon(Icons.north_east, size: 18),
                    onTap: () => openExternalUrl(mosaicRepoUrl),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return IntroPage(
      args: IntroPageArgs(
        maxWidth: 520,
        pages: [_offlinePage(context, l)],
        onDone: (_) => _finish(),
      ),
    );
  }
}

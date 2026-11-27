import 'package:fl_lib/fl_lib.dart' show IntroPage, IntroPageArgs;
import 'package:material_ui/material_ui.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import 'model_store.dart';
import 'store.dart';

/// Public GitHub repository for MosaicIt (AGPL-3.0).
const mosaicRepoUrl = 'https://github.com/lollipopkit/mosaic_it';
const mosaicRepoDisplay = 'github.com/lollipopkit/mosaic_it';

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

/// Two-step onboarding flow built on `fl_lib`'s [IntroPage]:
/// 1. States clearly that the app has no networking capability or network
///    permissions, bundles the detector model, and links to the GitHub source.
/// 2. Guides photo library access with live permission status.
class MosaicIntroPage extends StatefulWidget {
  const MosaicIntroPage({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<MosaicIntroPage> createState() => _MosaicIntroPageState();
}

class _MosaicIntroPageState extends State<MosaicIntroPage> {
  PermissionState? _permission;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _readPermission();
    _lifecycle = AppLifecycleListener(onResume: _readPermission);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _readPermission() async {
    try {
      final p = await PhotoManager.getPermissionState(
        requestOption: const PermissionRequestOption(),
      );
      if (mounted) setState(() => _permission = p);
    } catch (_) {
      // Tests or platforms without a photo library leave permission null.
    }
  }

  Future<void> _requestPermission() async {
    try {
      final p = await PhotoManager.requestPermissionExtend();
      if (mounted) setState(() => _permission = p);
    } catch (_) {
      // Platforms without a photo library ignore permission requests.
    }
  }

  Future<void> _finish() async {
    await SettingStore.instance.introSeen.set(true);
    if (!mounted) return;
    widget.onDone();
  }

  Widget _pageColumn(BuildContext context, List<Widget> children) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _head(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
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
            child: Icon(icon, color: scheme.onPrimaryContainer, size: 22),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 9),
          Text(
            body,
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _offlinePage(BuildContext context, AppLocalizations l) {
    final scheme = Theme.of(context).colorScheme;
    return _pageColumn(context, [
      _head(
        context,
        icon: Icons.wifi_off_rounded,
        title: l.introOfflineTitle,
        body: l.introOfflineBody,
      ),
      Card.filled(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.shield_outlined, color: scheme.primary),
              title: Text(l.introNoNetPermTitle),
              subtitle: Text(l.introNoNetPermBody),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.memory, color: scheme.primary),
              title: Text(l.introBundledModelTitle),
              subtitle: Text(l.introBundledModelBody(bundledModelVersion)),
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
    ]);
  }

  Widget _photosPage(BuildContext context, AppLocalizations l) {
    final scheme = Theme.of(context).colorScheme;
    final p = _permission;

    Widget permCard;
    if (p == PermissionState.authorized) {
      permCard = Card.filled(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(Icons.check_circle_outline, color: scheme.primary),
          title: Text(l.introPhotosGranted),
        ),
      );
    } else if (p == PermissionState.limited) {
      permCard = Card.filled(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(Icons.check_circle_outline, color: scheme.primary),
          title: Text(l.limitedAccess),
          trailing: TextButton(
            onPressed: () => PhotoManager.presentLimited(),
            child: Text(l.manage),
          ),
        ),
      );
    } else if (p != null && p != PermissionState.notDetermined) {
      permCard = Card.filled(
        margin: const EdgeInsets.only(bottom: 12),
        color: scheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.photosOffTitle,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: scheme.onErrorContainer),
              ),
              const SizedBox(height: 4),
              Text(
                l.photosDenied,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: scheme.onErrorContainer),
              ),
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: PhotoManager.openSetting,
                child: Text(l.openSettings),
              ),
            ],
          ),
        ),
      );
    } else {
      permCard = Card.filled(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: _requestPermission,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l.allowPhotoAccess),
              ),
            ],
          ),
        ),
      );
    }

    return _pageColumn(context, [
      _head(
        context,
        icon: Icons.photo_library_outlined,
        title: l.introTitle,
        body: l.introBody,
      ),
      permCard,
      Card.filled(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: Icon(Icons.check_circle_outline, color: scheme.primary),
          title: Text(l.introBundledReady),
          subtitle: Text(l.introBundledModelBody(bundledModelVersion)),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return IntroPage(
      args: IntroPageArgs(
        maxWidth: 520,
        pages: [_offlinePage(context, l), _photosPage(context, l)],
        onDone: (_) => _finish(),
      ),
    );
  }
}

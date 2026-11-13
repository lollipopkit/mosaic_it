import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/generated/l10n/lib_l10n.dart';
import 'package:fl_lib/theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';

import 'l10n/app_localizations.dart';
import 'src/home_page.dart';
import 'src/rust/frb_generated.dart';
import 'src/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Only what the theme and the settings store need from fl_lib: no sync
  // clients (Inits.initFlLibMain would read their tokens from the keychain).
  await Paths.init(_appName, dirs: const {PathDir.cache, PathDir.font});
  await PrefStore.shared.init();
  // Library/Application Support: Documents is shown in the Files app.
  await SqliteStore.openDatabase(
    dir: (await getApplicationSupportDirectory()).path,
  );
  await Future.wait([FlRust.ensureInitialized(), RustLib.init()]);
  ThemeHost.init(
    ThemeHost(
      store: () => SettingStore.instance,
      appName: _appName,
      icons: ThemeIcons(),
    ),
  );
  runApp(const UnseenApp());
}

const _appName = 'Unseen';

class UnseenApp extends StatefulWidget {
  const UnseenApp({super.key});

  @override
  State<UnseenApp> createState() => _UnseenAppState();
}

class _UnseenAppState extends State<UnseenApp> {
  @override
  Widget build(BuildContext context) {
    final store = SettingStore.instance;
    return ListenableBuilder(
      // Theme settings and a previewed store theme both redraw the app.
      listenable: Listenable.merge([
        ThemePackages.preview,
        store.colorSeed.listenable(),
        store.themeMode.listenable(),
        store.appThemePackage.listenable(),
      ]),
      builder: (context, _) {
        final source = AppThemeSource.current();
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          localizationsDelegates: const [
            LibLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildAppTheme(source),
          darkTheme: buildAppTheme(source, brightness: Brightness.dark),
          themeMode: ThemeMode.values[store.themeMode.get().clamp(0, 2)],
          home: const _L10n(child: HomePage()),
        );
      },
    );
  }
}

/// Hands the current locale to fl_lib's own strings.
class _L10n extends StatefulWidget {
  const _L10n({required this.child});

  final Widget child;

  @override
  State<_L10n> createState() => _L10nState();
}

class _L10nState extends State<_L10n> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.setLibL10n();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

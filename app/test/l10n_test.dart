import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/l10n/app_localizations.dart';
import 'package:unseen/main.dart';

void main() {
  testWidgets('material_ui localizations resolve with PopupMenuButton', (
    tester,
  ) async {
    late MaterialLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<int>(
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 1, child: Text('Item')),
                ],
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              l10n = MaterialLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(l10n.moreButtonTooltip, isNotEmpty);
    expect(find.byType(PopupMenuButton<int>), findsOneWidget);
  });

  test('supportedLocales matches the 17 ServerBox locales and loads every locale', () async {
    final tags =
        AppLocalizations.supportedLocales.map((l) => l.toLanguageTag()).toList()
          ..sort();
    expect(tags, [
      'az',
      'de',
      'en',
      'es',
      'fa',
      'fr',
      'id',
      'it',
      'ja',
      'ko',
      'nl',
      'pt',
      'ru',
      'tr',
      'uk',
      'zh',
      'zh-Hant',
    ]);
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = await AppLocalizations.delegate.load(locale);
      expect(l10n.appTitle, isNotEmpty, reason: 'appTitle empty for $locale');
      expect(
        l10n.selectMedia,
        isNotEmpty,
        reason: 'selectMedia empty for $locale',
      );
      expect(
        l10n.feedbackTitle,
        isNotEmpty,
        reason: 'feedbackTitle empty for $locale',
      );
    }
    // Slavic CLDR `one` matches 21, 31, etc. — verify placeholder is preserved.
    final ru = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(ru.exportedImages(21), contains('21'));
    expect(ru.adaptiveLearnedCount(21), contains('21'));
    final uk = await AppLocalizations.delegate.load(const Locale('uk'));
    expect(uk.exportedImages(21), contains('21'));
    expect(uk.adaptiveLearnedCount(21), contains('21'));
  });
}

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
}

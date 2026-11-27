import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/l10n/app_localizations.dart';
import 'package:unseen/main.dart';
import 'package:unseen/src/intro_page.dart';

void main() {
  testWidgets(
    'MosaicIntroPage shows single-page offline notice and GitHub URL',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MosaicIntroPage(onDone: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('无联网功能'), findsOneWidget);
      expect(find.text(mosaicRepoDisplay), findsOneWidget);
      expect(find.byIcon(Icons.done), findsOneWidget);
    },
  );
}

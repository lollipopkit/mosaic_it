import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unseen/l10n/app_localizations.dart';
import 'package:unseen/main.dart';
import 'package:unseen/src/intro_page.dart';

void main() {
  testWidgets(
    'MosaicIntroPage shows offline notice, GitHub URL, and photo step',
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

      // Page 1: offline declaration + GitHub repository link.
      expect(find.text('无联网功能'), findsOneWidget);
      expect(find.text(mosaicRepoDisplay), findsOneWidget);
      expect(find.text('1/2', findRichText: true), findsOneWidget);

      // Advance to Page 2 via IntroPage's Next button.
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text('内置模型已就绪'), findsOneWidget);
      expect(find.byIcon(Icons.done), findsOneWidget);
    },
  );
}

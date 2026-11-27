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

  testWidgets(
    'showWirelessDataNoticeSheet opens bottom sheet and returns user choice',
    (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    result = await showWirelessDataNoticeSheet(context);
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('无线数据弹窗提示'), findsOneWidget);
      expect(find.text('继续'), findsOneWidget);

      await tester.tap(find.text('继续'));
      await tester.pumpAndSettle();
      expect(result, isTrue);

      // Cancel returns false.
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(result, isFalse);

      // Barrier dismissal maps null to false.
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    },
  );
}

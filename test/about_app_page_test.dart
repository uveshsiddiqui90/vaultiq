import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/core/config/app_config.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/about_app/about_app_page/about_app_page.dart';

/// Tests for the "About App" screen opened from the Profile tab.
///
/// The screen is presentation-only (no controller, no network), so the tests
/// pin down the copy the user actually sees and the details bottom sheet that
/// every capability row opens.
void main() {
  Widget buildPage() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => GetMaterialApp(home: const AboutAppPage()),
    );
  }

  /// Pumps the screen with a phone-sized viewport.
  ///
  /// The default 800x600 test window would give ScreenUtil a width scale factor
  /// of ~2.2, which inflates every `.w` sized widget far beyond its real size.
  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
  }

  group('AboutAppPage', () {
    testWidgets('renders the header, the identity block and the feature list', (
      tester,
    ) async {
      await pumpPage(tester);

      // Header copy.
      expect(find.text(TextConstant.aboutApp), findsOneWidget);
      expect(find.text(TextConstant.aboutAppSubtitle), findsOneWidget);
      expect(find.text(TextConstant.aboutAppTagline), findsOneWidget);

      // Identity block: the wordmark is split in two spans, so match the parts.
      expect(find.textContaining('Vault'), findsWidgets);
      expect(find.text(TextConstant.aboutAppNameTagline), findsOneWidget);

      // One row per capability plus the closing note.
      expect(find.text(TextConstant.aboutWhatYouCanDo), findsOneWidget);
      expect(find.text(TextConstant.aboutTrackExpenses), findsOneWidget);
      expect(find.text(TextConstant.aboutSetBudgets), findsOneWidget);
      expect(find.text(TextConstant.aboutGetInsights), findsOneWidget);
      expect(find.text(TextConstant.aboutDataPriority), findsOneWidget);
      expect(find.text(TextConstant.aboutFooterDesc), findsOneWidget);

      // Version pill is fed from AppConfig, never from a literal.
      expect(
        find.text('${TextConstant.aboutVersionPrefix} ${AppConfig.appVersion}'),
        findsOneWidget,
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping a feature opens its details sheet', (tester) async {
      await pumpPage(tester);

      // The sheet content must not be there yet.
      expect(find.text(TextConstant.aboutGetInsightsDetails), findsNothing);

      await tester.ensureVisible(find.text(TextConstant.aboutGetInsights));
      await tester.pumpAndSettle();
      await tester.tap(find.text(TextConstant.aboutGetInsights));
      await tester.pumpAndSettle();

      expect(find.text(TextConstant.aboutGetInsightsDetails), findsOneWidget);
      expect(
        find.text(TextConstant.aboutGetInsightsPoints.first),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      // Close the sheet again so nothing keeps animating after the test.
      Get.back();
      await tester.pumpAndSettle();
      expect(find.text(TextConstant.aboutGetInsightsDetails), findsNothing);
    });
  });
}

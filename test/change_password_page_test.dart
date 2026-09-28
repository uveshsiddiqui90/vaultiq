import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/change_password/change_password_page/change_password_page.dart';

/// Keeps the PKCE code verifier in memory so the test never touches
/// `shared_preferences` (its platform plugin does not exist in unit tests).
class _MemoryAsyncStorage extends GotrueAsyncStorage {
  final Map<String, String> _items = {};

  @override
  Future<String?> getItem({required String key}) async => _items[key];

  @override
  Future<void> setItem({required String key, required String value}) async {
    _items[key] = value;
  }

  @override
  Future<void> removeItem({required String key}) async {
    _items.remove(key);
  }
}

/// Regression tests for the "Change Password" screen that is opened from the
/// Profile tab.
///
/// Two of its widgets are `Obx` widgets whose content is derived from the text
/// the user types. GetX throws
/// "the improper use of a GetX has been detected" when an `Obx` builder reads
/// no observable at all, which is what happened while these values were read
/// straight from the plain `TextEditingController`s. These tests pin down that
/// both hints keep working.
void main() {
  setUpAll(() async {
    // The page creates a controller that reaches Supabase, so the client has to
    // exist before the widget is built. In-memory stores keep the test offline.
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'test-anon-key',
      authOptions: FlutterAuthClientOptions(
        localStorage: const EmptyLocalStorage(),
        pkceAsyncStorage: _MemoryAsyncStorage(),
        detectSessionInUri: false,
      ),
    );
  });

  Widget buildPage() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => GetMaterialApp(home: ChangePasswordPage()),
    );
  }

  group('ChangePasswordPage reactivity', () {
    testWidgets('builds without the GetX "improper use" error', (tester) async {
      await tester.pumpWidget(buildPage());

      // Without the Rx mirrors the Obx rendering the strength hint throws and
      // this exception is reported through FlutterError.onError.
      expect(
        tester.takeException(),
        isNull,
        reason: 'Every Obx on this page must read an observable',
      );

      // CustomTextField prints its label in upper case.
      expect(find.text('CURRENT PASSWORD'), findsOneWidget);
      expect(find.text('NEW PASSWORD'), findsOneWidget);
      expect(find.text('CONFIRM PASSWORD'), findsOneWidget);
    });

    testWidgets('strength and mismatch hints follow the typed text', (
      tester,
    ) async {
      await tester.pumpWidget(buildPage());

      // Field order on the page: current (0), new (1), confirm (2).
      final passwordField = find.byType(TextField).at(1);
      final confirmField = find.byType(TextField).at(2);

      // Too short
      await tester.enterText(passwordField, 'abc');
      await tester.pump();
      expect(find.text('Too short (min 6 chars)'), findsOneWidget);

      // Strong + no mismatch while both fields match
      await tester.enterText(passwordField, 'Str0ng!Passw0rd');
      await tester.enterText(confirmField, 'Str0ng!Passw0rd');
      await tester.pump();
      expect(find.text('Strong'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsNothing);

      // Mismatch shows up as soon as the confirmation differs
      await tester.enterText(confirmField, 'Different1!');
      await tester.pump();
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('an empty current password is rejected without any request', (
      tester,
    ) async {
      await tester.pumpWidget(buildPage());

      await tester.ensureVisible(find.text('Update Password'));
      await tester.tap(find.text('Update Password'));
      // Let the change flow reach its local validation and show the snackbar.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Please enter your current password.'), findsOneWidget);

      // Take the snackbar down again: this cancels its 3 s auto-close timer and
      // disposes its animation, so the test leaves nothing pending behind.
      Get.closeAllSnackbars();
      await tester.pumpAndSettle();
    });
  });
}

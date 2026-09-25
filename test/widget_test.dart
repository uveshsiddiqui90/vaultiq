import 'package:flutter_test/flutter_test.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/core/config/app_config.dart';

void main() {
  group('AppPages.routes', () {
    test('registers every route name exactly once', () {
      final names = AppPages.routes.map((r) => r.name).toList();
      expect(
        names.toSet().length,
        names.length,
        reason: 'Duplicate route names are registered in AppPages.routes',
      );
    });

    test('contains every declared route', () {
      final names = AppPages.routes.map((r) => r.name).toSet();
      expect(
        names,
        containsAll(<String>[
          AppRoutes.LOGIN,
          AppRoutes.SIGNUP,
          AppRoutes.ADDBUDGET,
          AppRoutes.DASHBOARD,
          AppRoutes.EDITPROFILE,
          AppRoutes.CHANGEPASSWORD,
          AppRoutes.PROFILEPICTURE,
          AppRoutes.TRANSACTIONS,
        ]),
      );
    });
  });

  group('AppConfig', () {
    test('has sane validation limits', () {
      expect(AppConfig.minBudgetAmount, lessThan(AppConfig.maxBudgetAmount));
      expect(AppConfig.minExpenseAmount, greaterThan(0));
      expect(AppConfig.minExpenseAmount, lessThan(AppConfig.maxExpenseAmount));
      expect(AppConfig.maxNoteLength, greaterThan(0));
    });

    test('has real Supabase credentials (no placeholders)', () {
      expect(AppConfig.supabaseUrl, startsWith('https://'));
      expect(AppConfig.supabaseAnonKey, isNotEmpty);
      expect(AppConfig.supabaseAnonKey, isNot(contains('your_key_here')));
    });

    test('uses a budget alert threshold between 0 and 1', () {
      expect(AppConfig.budgetAlertThreshold, greaterThan(0));
      expect(AppConfig.budgetAlertThreshold, lessThanOrEqualTo(1));
    });
  });
}

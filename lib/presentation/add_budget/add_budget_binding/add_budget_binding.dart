import 'package:get/get.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_controller/add_budget_controller.dart';

class AddBudgetBinding extends Bindings {
  @override
  void dependencies() {
    // `fenix: true` so the controller is recreated if the route is removed and
    // pushed again (back → forward through onboarding). Without it the second
    // visit fails with "controller not found" — the same bug that broke the
    // Sign Up and profile-photo screens.
    Get.lazyPut<AddBudgetController>(() => AddBudgetController(), fenix: true);
  }
}


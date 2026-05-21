import 'package:get/get.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_controller/add_budget_controller.dart';




class AddBudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBudgetController>( () => AddBudgetController(),);
  }
}

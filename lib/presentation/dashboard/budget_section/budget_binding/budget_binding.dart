import 'package:get/get.dart';
import 'package:vaultiq/presentation/dashboard/budget_section/budget_controller/budget_controller.dart';



class BudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetController>( () => BudgetController(),);
  }
}

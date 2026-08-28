import 'package:get/get.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/change_password/change_password_controller/change_password_controller.dart';


class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>( () => ChangePasswordController(),);
  }
}

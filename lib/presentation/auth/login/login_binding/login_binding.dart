import 'package:get/get.dart';
import 'package:vaultiq/presentation/auth/login/login_controller/login_controller.dart';



class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>( () => LoginController(),);
  }
}

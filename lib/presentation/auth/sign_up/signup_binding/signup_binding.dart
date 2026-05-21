import 'package:get/get.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_controller/signup_controller.dart';


class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>( () => SignupController(),);
  }
}

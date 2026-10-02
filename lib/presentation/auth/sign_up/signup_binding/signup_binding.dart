import 'package:get/get.dart';
import 'package:vaultiq/presentation/auth/sign_up/signup_controller/signup_controller.dart';


class SignupBinding extends Bindings {
  @override
  void dependencies() {
    // `fenix: true` — the controller is disposed when the signup route is
    // removed (which happens on every successful signup). Without it a second
    // visit to this screen could not build a fresh controller and
    // `Get.find<SignupController>()` inside the page would throw, so the
    // "Create Account" button appeared to stop working.
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
  }
}

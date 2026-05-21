import 'package:get/get.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_controller/home_controller.dart';



class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>( () => HomeController(),);
  }
}

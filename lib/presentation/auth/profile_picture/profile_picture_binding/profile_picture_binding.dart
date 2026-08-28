import 'package:get/get.dart';
import 'package:vaultiq/presentation/auth/profile_picture/profile_picture_controller/profile_picture_controller.dart';




class ProfilePictureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePictureController>( () => ProfilePictureController(),);
  }
}

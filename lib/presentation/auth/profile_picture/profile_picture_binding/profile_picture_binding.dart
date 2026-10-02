import 'package:get/get.dart';
import 'package:vaultiq/presentation/auth/profile_picture/profile_picture_controller/profile_picture_controller.dart';




class ProfilePictureBinding extends Bindings {
  @override
  void dependencies() {
    // Recreated on every visit — the picked file and the upload flag must not
    // survive into a later onboarding attempt.
    Get.lazyPut<ProfilePictureController>(
      () => ProfilePictureController(),
      fenix: true,
    );
  }
}

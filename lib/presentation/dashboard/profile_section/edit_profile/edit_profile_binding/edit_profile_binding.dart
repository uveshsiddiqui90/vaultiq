import 'package:get/get.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/edit_profile_controller/edit_profile_controller.dart';



class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>( () => EditProfileController(),);
  }
}

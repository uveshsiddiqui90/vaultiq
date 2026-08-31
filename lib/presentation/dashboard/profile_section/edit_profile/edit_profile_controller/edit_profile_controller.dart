import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/services/update_profile/update_profile.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final args = Get.arguments;
  final UpdateProfile _updateProfileService = UpdateProfile();
  final profileImageUrl = ''.obs;

  

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.text = args?["name"] ?? "";
    emailController.text = args?["email"] ?? "";
    profileImageUrl.value = args?["profileImageUrl"] ?? "";
    print("EditProfileController initialized with name: ${nameController.text}, email: ${emailController.text}, profileImageUrl: ${profileImageUrl.value}");
    loadUserData();
  }

  void loadUserData() async {
    isLoading.value = true;
    await getUserNameEmail();
    isLoading.value = false;
  }

  Future<void> getUserNameEmail() async {
    final user = Supabase.instance.client.auth.currentUser;
    nameController.text = user?.userMetadata?['name'] ?? '';
    emailController.text = user?.email ?? '';
  }
 Future<void> updateProfile() async {
  try {
    await UpdateProfile.updateProfile(
      name: nameController.text.trim(),
    );

    AppSnackbar.success(
      message: "Profile updated successfully",
    );

  } catch (e) {
    AppSnackbar.error(
      message: e.toString(),
    );
  }
}

}
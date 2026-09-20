import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/services/update_profile/update_profile.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final args = Get.arguments;

  final profileImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  final Rxn<File> selectedImage = Rxn<File>();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    nameController.text = args?["name"] ?? "";
    emailController.text = args?["email"] ?? "";
    profileImageUrl.value = args?["profileImageUrl"] ?? "";

    loadUserData();
  } 

  Future<void> loadUserData() async {
    isLoading.value = true;

    await getUserNameEmail();

    isLoading.value = false;
  }

  Future<void> getUserNameEmail() async {
    final user = Supabase.instance.client.auth.currentUser;

    nameController.text =
        user?.userMetadata?['name'] ?? '';

    emailController.text =
        user?.email ?? '';
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

  // ───────── CAMERA ─────────

  Future<void> pickFromCamera() async {
    try {
      PermissionStatus status =
          await Permission.camera.status;

      if (!status.isGranted) {
        status = await Permission.camera.request();
      }

      if (status.isPermanentlyDenied) {
        Get.snackbar(
          "Camera Permission",
          "Please enable camera permission from settings.",
        );

        await openAppSettings();
        return;
      }

      if (!status.isGranted) {
        Get.snackbar(
          "Camera Permission",
          "Camera permission is required.",
        );
        return;
      }

      final XFile? image =
          await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value =
            File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to open camera",
      );
    }
  }

  // ───────── GALLERY ─────────

  Future<void> pickFromGallery() async {
    try {
      final XFile? image =
          await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value =
            File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to select image",
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
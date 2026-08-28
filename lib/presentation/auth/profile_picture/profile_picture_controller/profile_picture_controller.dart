import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePictureController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  final Rxn<File> profileImage = Rxn<File>();

  Future<void> pickFromCamera() async {
    try {
      // Camera permission check
      PermissionStatus status = await Permission.camera.status;

      // Permission nahi hai toh request karo
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }

      // User ne permission deny kar di
      if (status.isDenied) {
        Get.snackbar(
          "Camera Permission",
          "Camera permission is required to take a profile picture.",
        );
        return;
      }

      // User ne permanently deny kar diya
      if (status.isPermanentlyDenied) {
        Get.snackbar(
          "Camera Permission",
          "Please enable camera permission from Settings.",
        );

        await openAppSettings();
        return;
      }

      // Permission mil gayi
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      debugPrint("Camera Error: $e");

      Get.snackbar(
        "Camera Error",
        "Unable to open camera.",
      );
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      debugPrint("Gallery Error: $e");

      Get.snackbar(
        "Gallery Error",
        "Unable to select image.",
      );
    }
  }

  void removeProfileImage() {
    profileImage.value = null;
  }


  Future<String?> uploadProfileImage() async {
  try {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      Get.snackbar("Error", "User not logged in");
      return null;
    }

    final image = profileImage.value;

    if (image == null) {
      Get.snackbar("Error", "Please select a profile picture");
      return null;
    }

    final userId = user.id;

    final filePath = '$userId/profile.jpg';

    await Supabase.instance.client.storage
        .from('avatars')
        .upload(
          filePath,
          image,
          fileOptions: const FileOptions(
            upsert: true,
          ),
        );

    final imageUrl = Supabase.instance.client.storage
        .from('avatars')
        .getPublicUrl(filePath);

    debugPrint("Profile Image URL: $imageUrl");

    return imageUrl;
  } catch (e) {
    debugPrint("Upload Error: $e");

    Get.snackbar(
      "Upload Error",
      "Unable to upload profile picture",
    );

    return null;
  }
}
}
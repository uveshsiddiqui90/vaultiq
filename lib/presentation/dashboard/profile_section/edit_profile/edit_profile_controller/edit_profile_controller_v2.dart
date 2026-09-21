/// EditProfileControllerV2 — edit name & upload profile picture with validation

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/repositories/auth_repository.dart';
import 'package:vaultiq/data/services/profile_image_service/profile_image_service.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';

class EditProfileControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORIES & SERVICES
  // ──────────────────────────────────────────────────────────
  final _authRepository = AuthRepository();
  final _profileImageService = ProfileImageService();

  // ──────────────────────────────────────────────────────────
  // FORM CONTROLLERS & STATE
  // ──────────────────────────────────────────────────────────
  TextEditingController nameController = TextEditingController();
  RxBool isLoading = false.obs;
  RxString selectedImagePath = ''.obs;

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  /// Initialize form with current user name
  void _initializeForm() {
    try {
      final currentName = _authRepository.getUserName();
      nameController.text = currentName;
      logDebug('Form initialized with name: $currentName');
    } catch (e, st) {
      logError('Failed to initialize form', error: e, st: st);
    }
  }

  // ──────────────────────────────────────────────────────────
  // NAME UPDATE
  // ──────────────────────────────────────────────────────────

  /// Update user name with validation
  Future<void> updateName() async {
    try {
      isLoading.value = true;
      final newName = nameController.text.trim();

      logInfo('Updating name to: $newName');

      // Validate
      ValidationService.validateName(newName);

      // Update via auth
      await _authRepository.updateUserProfile(name: newName);

      AppSnackbar.success(message: 'Name updated successfully!');
      logInfo('Name updated');

      Get.back();
    } on ValidationException catch (e) {
      logWarn('Name validation failed: ${e.message}');
      AppSnackbar.warning(message: e.message);
    } on AppException catch (e) {
      logError('Failed to update name', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error updating name', error: e, st: st);
      AppSnackbar.error(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ──────────────────────────────────────────────────────────
  // IMAGE PICKER
  // ──────────────────────────────────────────────────────────

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedImagePath.value = image.path;
        logInfo('Image picked from gallery: ${image.path}');
      } else {
        logDebug('User cancelled gallery picker');
      }
    } catch (e, st) {
      logError('Failed to pick image from gallery', error: e, st: st);
      AppSnackbar.error(message: 'Failed to pick image');
    }
  }

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        selectedImagePath.value = image.path;
        logInfo('Image captured from camera: ${image.path}');
      } else {
        logDebug('User cancelled camera picker');
      }
    } catch (e, st) {
      logError('Failed to take photo with camera', error: e, st: st);
      AppSnackbar.error(message: 'Failed to take photo');
    }
  }

  /// Upload selected image as profile picture to Supabase
  /// Validates image exists, uploads to storage, shows feedback
  Future<void> uploadProfilePicture() async {
    try {
      if (selectedImagePath.value.isEmpty) {
        AppSnackbar.warning(message: 'Please select an image first');
        return;
      }

      isLoading.value = true;
      logInfo('Uploading profile picture...');

      // Convert path to File and upload
      final imageFile = File(selectedImagePath.value);
      final imageUrl = await _profileImageService.uploadProfileImage(imageFile);

      AppSnackbar.success(message: 'Profile picture updated!');
      selectedImagePath.value = '';
      logInfo('Profile picture uploaded: $imageUrl');

      Get.back();
    } on AppException catch (e) {
      logError('Failed to upload profile picture', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error uploading picture', error: e, st: st);
      AppSnackbar.error(message: 'Failed to upload picture. Try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear selected image
  void clearSelectedImage() {
    selectedImagePath.value = '';
    logDebug('Selected image cleared');
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY
  // ──────────────────────────────────────────────────────────

  bool get hasSelectedImage => selectedImagePath.value.isNotEmpty;

  bool get isNameChanged {
    final current = _authRepository.getUserName();
    return nameController.text.trim() != current;
  }
}

void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

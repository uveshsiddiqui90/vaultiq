/// EditProfileControllerV2 — edit name & upload profile picture with validation
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/repositories/auth_repository.dart';
import 'package:vaultiq/data/services/profile_image_service/profile_image_service.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/profile_controller/profile_controller_v2.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';

class EditProfileControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORIES & SERVICES
  // ──────────────────────────────────────────────────────────
  final _authRepository = AuthRepository();

  /// [ProfileImageService] reads `Supabase.instance.client` inside its field
  /// initialiser, so it is created lazily — building it eagerly would throw in
  /// widget tests / previews where Supabase has not been initialised yet.
  ProfileImageService? _profileImageServiceInstance;
  ProfileImageService get _profileImageService =>
      _profileImageServiceInstance ??= ProfileImageService();

  // ──────────────────────────────────────────────────────────
  // FORM CONTROLLERS & STATE
  // ──────────────────────────────────────────────────────────
  /// Editable "Full Name" field.
  TextEditingController nameController = TextEditingController();

  /// Read-only "Email Address" field — mirrors the signed-in user's email.
  TextEditingController emailController = TextEditingController();

  /// Local path of the photo the user picked but has not uploaded yet.
  RxString selectedImagePath = ''.obs;

  /// URL of the avatar that is already stored for this user (may be empty).
  RxString existingImageUrl = ''.obs;

  /// `true` when the user removed the saved avatar and that deletion still has
  /// to be sent to Supabase — "Save Changes" applies it.
  RxBool isImageMarkedForRemoval = false.obs;

  /// Two separate busy flags so only the button that was tapped shows a
  /// spinner instead of both buttons spinning at the same time.
  RxBool isUploadingImage = false.obs;
  RxBool isSavingProfile = false.obs;

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadForm();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  /// Pre-fill the form with the values currently stored for this user.
  ///
  /// Public because the page re-syncs every time it opens: the controller is
  /// not bound to the route lifecycle, so it may still hold values from an
  /// earlier visit.
  void loadForm() {
    try {
      nameController.text = _authRepository.getUserName();
      emailController.text = _authRepository.getUserEmail();

      // The account metadata is the only source of truth for the avatar: an
      // empty value means "no picture". Nothing is guessed from storage any
      // more — guessing made a deleted photo reappear after a reload.
      existingImageUrl.value = _authRepository.getUserAvatarUrl() ?? '';

      // A fresh visit never starts with a pending pick, a pending deletion or a
      // stuck spinner.
      selectedImagePath.value = '';
      isImageMarkedForRemoval.value = false;
      isUploadingImage.value = false;
      isSavingProfile.value = false;

      logDebug('Form loaded with name: ${nameController.text}');
    } catch (e, st) {
      logError('Failed to load form', error: e, st: st);
    }
  }

  // ──────────────────────────────────────────────────────────
  // NAME UPDATE
  // ──────────────────────────────────────────────────────────

  /// Update user name with validation.
  ///
  /// [popOnSuccess] closes the screen after a successful save — the page keeps
  /// it `true` for "Save Changes" and `false` for internal/chained calls.
  Future<void> updateName({bool popOnSuccess = true}) async {
    // Guard against a double tap while a save is already running.
    if (isSavingProfile.value) return;

    try {
      isSavingProfile.value = true;
      final newName = nameController.text.trim();

      logInfo('Updating name to: $newName');

      // Validate
      ValidationService.validateName(newName);

      // Update via auth
      await _authRepository.updateUserProfile(name: newName);

      AppSnackbar.success(message: 'Name updated successfully!');
      logInfo('Name updated');

      if (popOnSuccess) Get.back();
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
      isSavingProfile.value = false;
    }
  }

  /// "Save Changes" — the single action of this screen: it uploads a freshly
  /// picked photo, deletes a photo the user removed and persists the name.
  ///
  /// Every step is guarded so a failed upload or deletion leaves the form
  /// exactly as it was instead of silently dropping a change.
  Future<void> saveChanges() async {
    // Guard against a double tap while a save is already running.
    if (isLoading) return;

    // Photo first: a successful upload refreshes the avatar in place without
    // leaving the screen.
    if (hasSelectedImage) {
      await uploadProfilePicture();
      if (hasSelectedImage) return;
    }

    // Then the deletion of a photo the user removed with the delete badge.
    if (isImageMarkedForRemoval.value) {
      final deleted = await _deleteStoredImage();
      if (!deleted) return;
    }

    if (isNameChanged) {
      await updateName();
    } else {
      // Nothing left to save — just return to the profile tab.
      Get.back();
    }
  }

  /// Remove the saved avatar from Supabase Storage and from the account.
  ///
  /// The storage delete is best-effort: when it fails (e.g. a storage policy
  /// blocks it) the avatar is still cleared from the account so it disappears
  /// from the app. Returns `false` only when nothing could be saved, in which
  /// case the form stays open.
  Future<bool> _deleteStoredImage() async {
    try {
      isSavingProfile.value = true;
      logInfo('Removing the saved profile picture...');

      try {
        await _profileImageService.deleteProfileImage();
      } catch (e, st) {
        logError(
          'Storage delete failed — the avatar is cleared anyway',
          error: e,
          st: st,
        );
      }

      // An empty URL means "this account has no avatar any more".
      await _authRepository.updateAvatarUrl('');
      existingImageUrl.value = '';
      isImageMarkedForRemoval.value = false;

      // The profile tab header drops the picture as well.
      _syncAvatarEverywhere();

      AppSnackbar.success(message: 'Profile picture removed');
      logInfo('Profile picture removed');
      return true;
    } on AppException catch (e) {
      logError('Failed to remove the profile picture', error: e);
      AppSnackbar.error(message: e.message);
      return false;
    } catch (e, st) {
      logError('Unexpected error removing the picture', error: e, st: st);
      AppSnackbar.error(message: 'Failed to remove picture. Try again.');
      return false;
    } finally {
      isSavingProfile.value = false;
    }
  }

  /// Keep the avatar in sync across the app.
  ///
  /// The dashboard's profile header renders
  /// [ProfileControllerV2.profileImageUrl], so it is told about the new or
  /// removed picture right away — otherwise it would keep showing the previous
  /// avatar until the tab is reloaded.
  void _syncAvatarEverywhere() {
    if (Get.isRegistered<ProfileControllerV2>()) {
      Get.find<ProfileControllerV2>().refreshProfileImage();
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
        // A new pick replaces whatever is on screen, so a pending deletion of
        // the saved photo is no longer wanted.
        isImageMarkedForRemoval.value = false;
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
        // Same as the gallery path: a new photo cancels a pending deletion.
        isImageMarkedForRemoval.value = false;
        logInfo('Image captured from camera: ${image.path}');
      } else {
        logDebug('User cancelled camera picker');
      }
    } catch (e, st) {
      logError('Failed to take photo with camera', error: e, st: st);
      AppSnackbar.error(message: 'Failed to take photo');
    }
  }

  /// Upload the picked photo to Supabase Storage.
  ///
  /// [popOnSuccess] stays `false` for the new design: the avatar on screen is
  /// refreshed with the uploaded URL instead of closing the page, so the user
  /// can still review the form and press "Save Changes".
  Future<void> uploadProfilePicture({bool popOnSuccess = false}) async {
    // Guard against a double tap while an upload is already running.
    if (isUploadingImage.value) return;

    if (selectedImagePath.value.isEmpty) {
      AppSnackbar.warning(message: 'Please select an image first');
      return;
    }

    try {
      isUploadingImage.value = true;
      logInfo('Uploading profile picture...');

      // Convert path to File and upload
      final imageFile = File(selectedImagePath.value);
      final imageUrl = await _profileImageService.uploadProfileImage(imageFile);

      // Show the uploaded photo straight away …
      existingImageUrl.value = imageUrl;
      // A fresh upload cancels any deletion that was still pending.
      isImageMarkedForRemoval.value = false;
      // … and clear the local pick so the preview switches to the stored copy.
      selectedImagePath.value = '';

      // Persist the URL on the account so the picture survives the next app
      // launch. A metadata failure must not hide the fact that the upload
      // itself worked, hence this separate try/catch.
      try {
        await _authRepository.updateAvatarUrl(imageUrl);
      } catch (e, st) {
        logError(
          'Avatar uploaded but its URL could not be saved',
          error: e,
          st: st,
        );
      }

      // The profile tab header follows the new picture immediately.
      _syncAvatarEverywhere();

      AppSnackbar.success(message: 'Profile picture updated!');
      logInfo('Profile picture uploaded: $imageUrl');

      if (popOnSuccess) Get.back();
    } on AppException catch (e) {
      logError('Failed to upload profile picture', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error uploading picture', error: e, st: st);
      AppSnackbar.error(message: 'Failed to upload picture. Try again.');
    } finally {
      isUploadingImage.value = false;
    }
  }

  /// Delete badge on the avatar.
  ///
  /// A photo that only exists locally is dropped straight away; a photo that is
  /// already saved is hidden immediately and marked so that "Save Changes"
  /// deletes it from Supabase Storage as well (leaving the screen without
  /// saving keeps it).
  void removeProfileImage() {
    // Picked but not uploaded yet → just drop the local file.
    if (hasSelectedImage) {
      selectedImagePath.value = '';
      logDebug('Pending profile photo cleared');
      return;
    }

    // Nothing is on screen, so there is nothing to remove.
    if (existingImageUrl.value.isEmpty) return;

    isImageMarkedForRemoval.value = true;
    existingImageUrl.value = '';
    logInfo('Saved profile picture marked for removal');
    AppSnackbar.warning(
      title: 'Photo removed',
      message: 'Tap Save Changes to apply this change.',
    );
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY
  // ──────────────────────────────────────────────────────────

  /// `true` while any network operation is running (used to block double taps).
  bool get isLoading => isUploadingImage.value || isSavingProfile.value;

  /// `true` when a photo was picked but has not been uploaded yet.
  bool get hasSelectedImage => selectedImagePath.value.isNotEmpty;

  /// `true` when the typed name differs from the stored one.
  bool get isNameChanged {
    try {
      return nameController.text.trim() != _authRepository.getUserName();
    } catch (e) {
      // Auth not ready → treat the form as unchanged.
      return false;
    }
  }
}

void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/data/repositories/auth_repository.dart';
import 'package:vaultiq/data/services/profile_image_service/profile_image_service.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_controller/home_controller_v2.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/profile_controller/profile_controller_v2.dart';

class ProfilePictureController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  final Rxn<File> profileImage = Rxn<File>();

  /// `true` while the photo is being pushed to Supabase Storage — drives the
  /// spinner inside the "Continue" button and blocks a second tap.
  final RxBool isUploading = false.obs;

  final _authRepository = AuthRepository();

  /// [ProfileImageService] reads `Supabase.instance.client` inside its field
  /// initialiser, so it is created lazily — building it eagerly would throw in
  /// widget tests / previews where Supabase has not been initialised yet.
  ProfileImageService? _profileImageServiceInstance;
  ProfileImageService get _profileImageService =>
      _profileImageServiceInstance ??= ProfileImageService();

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
        AppSnackbar.warning(
          title: "Camera Permission",
          message: "Camera permission is required to take a profile picture.",
        );
        return;
      }

      // User ne permanently deny kar diya
      if (status.isPermanentlyDenied) {
        AppSnackbar.warning(
          title: "Camera Permission",
          message: "Please enable camera permission from Settings.",
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
        logInfo('Profile picture captured: ${image.path}');
      }
    } catch (e, st) {
      logError('Could not open the camera', error: e, st: st);

      AppSnackbar.error(message: "Unable to open camera.");
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
        logInfo('Profile picture picked: ${image.path}');
      }
    } catch (e, st) {
      logError('Could not pick an image from the gallery', error: e, st: st);

      AppSnackbar.error(message: "Unable to select image.");
    }
  }

  void removeProfileImage() {
    profileImage.value = null;
  }

  // ──────────────────────────────────────────────────────────
  // UPLOAD
  // ──────────────────────────────────────────────────────────

  /// Upload the picked photo and store its URL on the account.
  ///
  /// Returns `true` when the onboarding can move on.
  ///
  /// The previous version only pushed the bytes: nothing was ever written to
  /// the user's metadata, so Home and the Profile tab — which both read the
  /// avatar from that metadata — kept showing the placeholder even though the
  /// file had reached Storage. It also hard-coded a `.jpg` name while
  /// [ProfileImageService] keeps the real extension and adds a version suffix,
  /// which is what makes a replaced picture actually refresh.
  Future<bool> uploadProfileImage() async {
    if (isUploading.value) return false;

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      // Reachable when "Confirm email" is on and no session was ever created —
      // say something useful instead of a bare "User not logged in".
      AppSnackbar.error(message: "Your session expired. Please login again.");
      return false;
    }

    final image = profileImage.value;

    if (image == null) {
      logDebug('Upload skipped — no profile picture selected');
      return false;
    }

    try {
      isUploading.value = true;

      final imageUrl = await _profileImageService.uploadProfileImage(image);

      // Persist the URL on the account. A metadata failure must not hide the
      // fact that the upload itself worked, hence this separate try/catch.
      try {
        await _authRepository.updateAvatarUrl(imageUrl);
      } catch (e, st) {
        logError(
          'Avatar uploaded but its URL could not be saved',
          error: e,
          st: st,
        );
      }

      _syncAvatarEverywhere();

      logInfo('Profile picture uploaded: $imageUrl');
      AppSnackbar.success(message: 'Profile picture updated!');

      return true;
    } on AppException catch (e) {
      logError('Failed to upload profile picture', error: e);
      AppSnackbar.error(message: e.message);
      return false;
    } catch (e, st) {
      logError('Unexpected error uploading picture', error: e, st: st);
      AppSnackbar.error(message: "Unable to upload profile picture");
      return false;
    } finally {
      isUploading.value = false;
    }
  }

  /// Keep the avatar in sync across the app.
  ///
  /// Onboarding normally finishes before the dashboard exists, in which case
  /// `onInit` of those controllers loads the freshly saved URL anyway — the
  /// guard covers the other order too.
  void _syncAvatarEverywhere() {
    if (Get.isRegistered<ProfileControllerV2>()) {
      Get.find<ProfileControllerV2>().refreshProfileImage();
    }
    if (Get.isRegistered<HomeControllerV2>()) {
      Get.find<HomeControllerV2>().refreshProfileImage();
    }
  }
}

// Both dashboard controllers exported above declare their own top-level
// `logInfo` / `logError` helpers, and `logger_service.dart` exports the same
// names — declaring them here too keeps those calls unambiguous (same pattern
// as `edit_profile_controller_v2.dart`).
void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);
/// ChangePasswordControllerV2 — secure password change with validation
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/repositories/auth_repository.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';

class ChangePasswordControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORIES
  // ──────────────────────────────────────────────────────────
  final _authRepository = AuthRepository();

  // ──────────────────────────────────────────────────────────
  // FORM CONTROLLERS
  // ──────────────────────────────────────────────────────────
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // ──────────────────────────────────────────────────────────
  // STATE
  // ──────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  /// One visibility flag per field so every eye button only reveals its own
  /// row instead of all of them at once.
  RxBool showCurrentPassword = false.obs;
  RxBool showPassword = false.obs; // new password
  RxBool showConfirmPassword = false.obs;

  /// Reactive mirrors of the three password fields.
  ///
  /// A [TextEditingController] is a plain `ValueListenable`; reading it inside
  /// an `Obx` registers nothing, so GetX tears the widget down with
  /// "the improper use of a GetX has been detected". The strength hint and the
  /// "passwords do not match" hint are built inside `Obx` widgets, hence the
  /// typed text is mirrored into Rx variables that the builders can read.
  final RxString currentPassword = ''.obs;
  final RxString newPassword = ''.obs;
  final RxString confirmPassword = ''.obs;

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Keep the Rx mirrors in sync with what the user types.
    currentPasswordController.addListener(_syncCurrentPassword);
    newPasswordController.addListener(_syncNewPassword);
    confirmPasswordController.addListener(_syncConfirmPassword);
  }

  void _syncCurrentPassword() =>
      currentPassword.value = currentPasswordController.text;

  void _syncNewPassword() => newPassword.value = newPasswordController.text;

  void _syncConfirmPassword() =>
      confirmPassword.value = confirmPasswordController.text;

  @override
  void onClose() {
    currentPasswordController.removeListener(_syncCurrentPassword);
    newPasswordController.removeListener(_syncNewPassword);
    confirmPasswordController.removeListener(_syncConfirmPassword);
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ──────────────────────────────────────────────────────────
  // PASSWORD VALIDATION & CHANGE
  // ──────────────────────────────────────────────────────────

  /// Change password with full validation
  /// Validates: password strength, confirmation match
  Future<void> changePassword() async {
    try {
      isLoading.value = true;
      final current = currentPasswordController.text;
      final pwd = newPasswordController.text;
      final confirmation = confirmPasswordController.text;

      logInfo('Attempting to change password...');

      // ─── Validate every field ───
      if (current.isEmpty) {
        throw ValidationException(
          message: 'Please enter your current password.',
        );
      }
      ValidationService.validatePassword(pwd);
      ValidationService.validatePasswordConfirmation(pwd, confirmation);

      // ─── The current password has to be right before anything changes ───
      final bool isCurrentPasswordCorrect = await _authRepository.verifyPassword(
        password: current,
      );
      if (!isCurrentPasswordCorrect) {
        throw ValidationException(
          message: 'Current password is incorrect. Please try again.',
        );
      }

      // ─── Update via auth ───
      await _authRepository.changePassword(newPassword: pwd);

      logInfo('Password changed successfully');
      AppSnackbar.success(message: 'Password changed successfully!');

      // ─── Clear form & go back ───
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      Get.back();
    } on ValidationException catch (e) {
      logWarn('Password validation failed: ${e.message}');
      AppSnackbar.warning(message: e.message);
    } on AppException catch (e) {
      logError('Failed to change password', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error changing password', error: e, st: st);
      AppSnackbar.error(message: 'Failed to change password. Try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle the visibility of the current password field.
  void toggleCurrentPasswordVisibility() {
    showCurrentPassword.value = !showCurrentPassword.value;
  }

  /// Toggle the visibility of the new password field.
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  /// Toggle the visibility of the confirmation field.
  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY
  // ──────────────────────────────────────────────────────────

  bool get isFormValid {
    return currentPassword.value.isNotEmpty &&
        newPassword.value.isNotEmpty &&
        confirmPassword.value.isNotEmpty;
  }

  bool get doPasswordsMatch {
    if (newPassword.value.isEmpty || confirmPassword.value.isEmpty) {
      return true; // Don't show mismatch until both filled
    }
    return newPassword.value == confirmPassword.value;
  }

  String get passwordStrengthMessage {
    final pwd = newPassword.value;
    if (pwd.isEmpty) return '';
    if (pwd.length < 6) return 'Too short (min 6 chars)';
    if (pwd.length < 10) return 'Weak';
    if (_hasSpecialChar(pwd)) return 'Strong';
    return 'Medium';
  }

  /// Number of filled segments for the strength bar (0 → 4). It is derived from
  /// [passwordStrengthMessage] so the bar and the label never disagree.
  int get passwordStrengthLevel {
    final msg = passwordStrengthMessage;
    if (msg.isEmpty) return 0;
    if (msg.startsWith('Too short')) return 1;
    if (msg == 'Weak') return 2;
    if (msg == 'Medium') return 3;
    return 4; // Strong
  }

  bool _hasSpecialChar(String str) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(str);
  }
}

void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

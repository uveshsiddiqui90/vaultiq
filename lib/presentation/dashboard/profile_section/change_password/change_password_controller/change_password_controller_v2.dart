/// ChangePasswordControllerV2 — secure password change with validation

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
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // ──────────────────────────────────────────────────────────
  // STATE
  // ──────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;
  RxBool showPassword = false.obs;

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onClose() {
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
      final newPassword = newPasswordController.text;
      final confirmPassword = confirmPasswordController.text;

      logInfo('Attempting to change password...');

      // ─── Validate both fields ───
      ValidationService.validatePassword(newPassword);
      ValidationService.validatePasswordConfirmation(newPassword, confirmPassword);

      // ─── Update via auth ───
      await _authRepository.changePassword(newPassword: newPassword);

      logInfo('Password changed successfully');
      AppSnackbar.success(message: 'Password changed successfully!');

      // ─── Clear form & go back ───
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

  /// Toggle password visibility
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY
  // ──────────────────────────────────────────────────────────

  bool get isFormValid {
    return newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool get doPasswordsMatch {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return true; // Don't show mismatch until both filled
    }
    return newPasswordController.text == confirmPasswordController.text;
  }

  String get passwordStrengthMessage {
    final pwd = newPasswordController.text;
    if (pwd.isEmpty) return '';
    if (pwd.length < 6) return 'Too short (min 6 chars)';
    if (pwd.length < 10) return 'Weak';
    if (_hasSpecialChar(pwd)) return 'Strong';
    return 'Medium';
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

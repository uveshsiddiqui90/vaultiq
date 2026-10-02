import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/core/errors/auth_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  /// `true` while the signup request is in flight.
  /// Drives the spinner inside the "Create Account" button and blocks a second
  /// tap, so the same account can never be submitted twice.
  final RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // ──────────────────────────────────────────────────────────
  // VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Returns a user-facing error message when the form is not ready to submit,
  /// otherwise `null`.
  ///
  /// Lives in the controller so the page stays free of validation logic — the
  /// earlier version returned silently when the two passwords did not match,
  /// which is exactly what made the button look "dead".
  String? validateForm() {
    if (nameController.text.trim().isEmpty) {
      return TextConstant.nameEmptyError;
    }
    if (emailController.text.trim().isEmpty) {
      return TextConstant.emailEmptyError;
    }
    if (passwordController.text.isEmpty) {
      return TextConstant.passwordEmptyError;
    }
    if (confirmPasswordController.text.isEmpty) {
      return TextConstant.confirmPasswordEmptyError;
    }
    if (passwordController.text != confirmPasswordController.text) {
      return TextConstant.passwordMismatchError;
    }
    if (passwordController.text.length < 6) {
      return TextConstant.passwordTooShortError;
    }
    return null;
  }

  // ──────────────────────────────────────────────────────────
  // SIGN UP
  // ──────────────────────────────────────────────────────────

  /// Create the account and move on to the profile-picture step.
  ///
  /// Supabase replies with a `user` in three very different situations and the
  /// old code treated all of them as success:
  ///  * a brand-new account **with** a session → continue onboarding,
  ///  * a brand-new account **without** a session → "Confirm email" is enabled,
  ///    the user must verify the address before they can log in,
  ///  * an **existing** email → Supabase hides that fact and returns a fake user
  ///    whose `identities` list is empty. Navigating on from here is what made
  ///    the second signup attempt fail (and the later avatar upload fail with
  ///    "User not logged in").
  Future<void> userSignUp() async {
    // Re-entrancy guard — a tap while the request is running is ignored.
    if (isLoading.value) return;

    final errorMessage = validateForm();
    if (errorMessage != null) {
      AppSnackbar.error(message: errorMessage);
      return;
    }

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      isLoading.value = true;

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;

      if (user == null) {
        AppSnackbar.error(message: TextConstant.signupFailed);
        return;
      }

      // Existing email → Supabase returns a user with no identities instead of
      // throwing, purely to avoid leaking which addresses are registered.
      final identities = user.identities;
      if (identities != null && identities.isEmpty) {
        logWarn('Signup attempted with an already registered email');
        AppSnackbar.error(message: TextConstant.accountAlreadyExists);
        Get.offAllNamed(AppRoutes.LOGIN);
        return;
      }

      // "Confirm email" is switched on for this project → no session yet.
      if (response.session == null) {
        logInfo('Signup successful, email confirmation required');
        AppSnackbar.success(message: TextConstant.signupVerifyEmail);
        Get.offAllNamed(AppRoutes.LOGIN);
        return;
      }

      logInfo('Signup successful for user: ${user.id}');
      Get.offAllNamed(AppRoutes.PROFILEPICTURE);
    } on AuthException catch (e, st) {
      logError('Signup failed', error: e, st: st);
      AppSnackbar.error(message: AuthErrorHandler.getMessage(e));
    } catch (e, st) {
      logError('Unexpected error during signup', error: e, st: st);
      AppSnackbar.error(message: TextConstant.somethingWentWrong);
    } finally {
      isLoading.value = false;
    }
  }
}


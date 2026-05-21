import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/core/errors/auth_exception.dart';
import 'package:vaultiq/data/services/auth_service/auth_service.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  final AuthService _authService = AuthService();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading.value = true;

      final response = await _authService.login(email, password);

      if (response.user != null) {
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        AppSnackbar.error(message: TextConstant.userNotFoundError);
      }
    } on AuthException catch (e) {
      final message = AuthErrorHandler.getMessage(e);

      AppSnackbar.error(message: message);
    } catch (e) {
      AppSnackbar.error(message: TextConstant.loginFailed);
    } finally {
      isLoading.value = false;
    }
  }
}

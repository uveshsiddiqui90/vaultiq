import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/app_routes/app_routes.dart';

class SignupController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;

  Rx<bool> isPasswordVisible = false.obs;
  Rx<bool> isConfirmPasswordVisible = false.obs;

  Future<void> userSignUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final supabase = Supabase.instance.client;
   
    if (password != confirmPassword) {
      return;
    }

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user != null) {
       // Get.toNamed(AppRoutes.DASHBOARD);
       Get.toNamed(AppRoutes.ADDBUDGET);
      } else {
        Get.snackbar('Error', 'Sign up failed');
      }
     

      
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during sign up');
    }
  }
}

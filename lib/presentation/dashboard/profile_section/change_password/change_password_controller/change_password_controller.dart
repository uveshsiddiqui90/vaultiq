import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/repository/profile_repository/profile_repository.dart';

class ChangePasswordController extends GetxController {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
   final ProfileRepository _repository = ProfileRepository();

  RxBool isCurrentPasswordVisible = false.obs;
  RxBool isNewPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  
  }

Future<void> changePassword() async {
  try {
    if (newPasswordController.text !=
        confirmPasswordController.text) {
      AppSnackbar.error(
        message: "Passwords do not match",
      );
      return;
    }

    await _repository.changePassword(
      newPassword: newPasswordController.text.trim(),
    );

    AppSnackbar.success(
      message: "Password changed successfully",
    );

    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  } catch (e) {
    AppSnackbar.error(
      message: e.toString(),
    );
  }
}
  
  }

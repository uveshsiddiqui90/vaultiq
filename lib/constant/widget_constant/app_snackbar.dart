import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/color_constant.dart';

class AppSnackbar {
  
  static void success({
    String title = "Success",
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: ColorConstant.primary,
      colorText: ColorConstant.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  static void error({
    String title = "Error",
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: ColorConstant.red,
      colorText: ColorConstant.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  static void warning({
    String title = "Warning",
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: ColorConstant.amber,
      colorText: ColorConstant.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/change_password/change_password_controller/change_password_controller_v2.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});
  ChangePasswordControllerV2 changePasswordController =
      Get.put(ChangePasswordControllerV2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: Column(
        children: [
          /// Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ColorConstant.darkBg, ColorConstant.darkBg2],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Change Password',
                    style: AppStyles.syne(
                      size: 26.sp,
                      weight: AppFontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Keep your account secure',
                    style: AppStyles.dmSans(
                      size: 12.sp,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          /// Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// New Password
                  Text(
                    'New Password',
                    style: AppStyles.dmSans(
                      size: 12.sp,
                      weight: AppFontWeight.bold,
                      color: ColorConstant.inkMuted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => TextField(
                      controller: changePasswordController.newPasswordController,
                      obscureText: !changePasswordController.showPassword.value,
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        hintStyle: AppStyles.dmSans(
                          size: 13.sp,
                          color: ColorConstant.inkMuted,
                        ),
                        filled: true,
                        fillColor: ColorConstant.bgLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.r),
                          borderSide: BorderSide(color: ColorConstant.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.r),
                          borderSide: BorderSide(color: ColorConstant.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.r),
                          borderSide: BorderSide(
                            color: ColorConstant.primary,
                            width: 2,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: changePasswordController.togglePasswordVisibility,
                          child: Icon(
                            changePasswordController.showPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: ColorConstant.inkMuted,
                            size: 20.sp,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: AppStyles.dmSans(
                        size: 13.sp,
                        color: ColorConstant.inkDark,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(
                    () => Text(
                      changePasswordController.passwordStrengthMessage,
                      style: AppStyles.dmSans(
                        size: 11.sp,
                        color: _getStrengthColor(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  /// Confirm Password
                  Text(
                    'Confirm Password',
                    style: AppStyles.dmSans(
                      size: 12.sp,
                      weight: AppFontWeight.bold,
                      color: ColorConstant.inkMuted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => TextField(
                      controller:
                          changePasswordController.confirmPasswordController,
                      obscureText: !changePasswordController.showPassword.value,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        hintStyle: AppStyles.dmSans(
                          size: 13.sp,
                          color: ColorConstant.inkMuted,
                        ),
                        filled: true,
                        fillColor: ColorConstant.bgLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.r),
                          borderSide: BorderSide(color: ColorConstant.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.r),
                          borderSide: BorderSide(color: ColorConstant.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.r),
                          borderSide: BorderSide(
                            color: ColorConstant.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: AppStyles.dmSans(
                        size: 13.sp,
                        color: ColorConstant.inkDark,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(
                    () => Text(
                      changePasswordController.doPasswordsMatch
                          ? ''
                          : 'Passwords do not match',
                      style: AppStyles.dmSans(
                        size: 11.sp,
                        color: ColorConstant.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  /// Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: changePasswordController.isLoading.value
                            ? 'Updating...'
                            : 'Update Password',
                        onPressed: changePasswordController.isLoading.value
                            ? null
                            : () {
                                changePasswordController.changePassword();
                              },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor() {
    final msg = changePasswordController.passwordStrengthMessage;
    if (msg.contains('Too short')) return ColorConstant.red;
    if (msg.contains('Weak')) return ColorConstant.amber;
    if (msg.contains('Medium')) return ColorConstant.amber;
    if (msg.contains('Strong')) return ColorConstant.primary;
    return ColorConstant.inkMuted;
  }
}

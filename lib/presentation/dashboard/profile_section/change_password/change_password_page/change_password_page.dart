import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/change_password/change_password_controller/change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});
  ChangePasswordController changePasswordController =
      ChangePasswordController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(color: ColorConstant.darkBg2),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSize.h40,
                  Icon(
                    Icons.arrow_forward,
                    size: 50.sp,
                    color: Colors.grey[700],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Change Password Page',
                    style: AppStyles.dmSans(
                      size: AppTextSize.heading,
                      weight: AppFontWeight.semiBold,
                      color: ColorConstant.white,
                    ),
                  ),
                  Text(
                    'String Password = Secure Account',
                    style: AppStyles.dmSans(
                      size: AppTextSize.small,
                      weight: AppFontWeight.semiBold,
                      color: ColorConstant.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: AppPadding.screen,
              child: Column(
                children: [
                  AppSize.h20,
                  CustomTextField(
                    label: "Enter New Password",
                    hint: "Enter new password",
                    controller:
                        changePasswordController.newPasswordController,
                  ),
                  AppSize.h20,

                  AppSize.h20,
                  CustomTextField(
                    label: "Confirm Password",
                    hint: "Confirm new password",
                    controller:
                        changePasswordController.confirmPasswordController,
                  ),
                  AppSize.h40,
                  CustomButton(label: "Update Password", onPressed: () {
                    changePasswordController.changePassword();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

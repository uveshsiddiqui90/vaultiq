import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/edit_profile_controller/edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  EditProfileController editProfileController = Get.put(
    EditProfileController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: ColorConstant.inkMid,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  AppSize.h40,
                  Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorConstant.white,
                        ),
                      ),
                      Center(
                        child: Text(
                          TextConstant.editProfile,
                          style: AppStyles.syne(
                            color: ColorConstant.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Container(
                      height: 120.h,
                      width: 120.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: editProfileController.profileImageUrl.value.isNotEmpty
                          ? Image.network(
                              editProfileController.profileImageUrl.value,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 60,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 60,
                            ),
                    ),
                  ),
                  AppSize.h10,
                  Text(
                    "Uvesh Siddiqui",
                    style: AppStyles.syne(
                      color: ColorConstant.white,
                      weight: AppFontWeight.extraBold,
                      size: AppTextSize.title,
                    ),
                  ),
                  AppSize.h10,
                  Text(
                    "uveshsidd@gmail.com",
                    style: AppStyles.dmSans(
                      color: ColorConstant.white,
                      weight: AppFontWeight.bold,
                      size: AppTextSize.body,
                    ),
                  ),
                  AppSize.h10,
                  Text(
                    "Tap to change profile picture",
                    style: AppStyles.dmSans(
                      color: ColorConstant.primary,
                      weight: AppFontWeight.bold,
                      size: AppTextSize.body,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: AppPadding.screen,
            child: Column(
              children: [
                AppSize.h20,
                CustomTextField(
                  controller: editProfileController.nameController,
                  label: TextConstant.nameLabel,
                  hint: '',
                ),
                AppSize.h20,
                CustomTextField(
                  controller: editProfileController.emailController,
                  label: TextConstant.emailLabel,
                  hint: '',
                ),
                AppSize.h40,
                CustomButton(
                  label: "Save Changes",
                  onPressed: () {
                    editProfileController.updateProfile();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:dotted_border/dotted_border.dart';
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
import '../profile_picture_controller/profile_picture_controller.dart';

class ProfilePicturePage extends StatelessWidget {
  ProfilePicturePage({super.key});

  final ProfilePictureController controller =
      Get.find<ProfilePictureController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: AppPadding.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSize.h40,

            Text(
              TextConstant.profilePictureTitle,
              textAlign: TextAlign.center,
              style: AppStyles.dmSans(
                size: AppTextSize.largeTitle,
                weight: AppFontWeight.regular,
                color: ColorConstant.darkBg,
              ),
            ),

            AppSize.h10,

            Text(
              TextConstant.addProfilePhoto,
              textAlign: TextAlign.center,
              style: AppStyles.dmSans(
                size: AppTextSize.medium,
                weight: AppFontWeight.regular,
                color: ColorConstant.inkMuted,
              ),
            ),

            AppSize.h20,

            // ───────── Profile Image ─────────
            Obx(
              () => Stack(
                clipBehavior: Clip.none,
                children: [
                  DottedBorder(
                    options: CircularDottedBorderOptions(
                      dashPattern: [3, 5],
                      strokeWidth: 2,
                      color: ColorConstant.hinttxtColor,
                      padding: EdgeInsets.all(4),
                    ),
                    child: Container(
                      height: 170.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConstant.inkMuted.withOpacity(0.2),

                        image: controller.profileImage.value != null
                            ? DecorationImage(
                                image: FileImage(
                                  controller.profileImage.value!,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),

                      child: controller.profileImage.value == null
                          ? Icon(
                              Icons.person,
                              size: 80.sp,
                              color: ColorConstant.inkMuted,
                            )
                          : null,
                    ),
                  ),
                  Visibility(
                    visible: controller.profileImage.value != null,
                    child: Positioned(
                      bottom: 10.h,
                      right: -10.w,
                      child: GestureDetector(
                        onTap: controller.removeProfileImage,
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstant.primaryDark,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: ColorConstant.white,
                            size: 25.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppSize.h10,

            Text(
              TextConstant.uploadPhoto,
              style: AppStyles.dmSans(
                size: AppTextSize.medium,
                weight: AppFontWeight.regular,
                color: ColorConstant.primary,
              ),
            ),

            AppSize.h40,

            // ───────── Camera ─────────
            CustomButton(
              label: TextConstant.choosefromCamera,
              onPressed: controller.pickFromCamera,
              prefixIcon: Icon(
                Icons.camera_alt,
                color: ColorConstant.primaryDark,
                size: 30,
              ),
              variant: ButtonVariant.outline,
              textColor: ColorConstant.primaryDark,
            ),

            AppSize.h20,

            // ───────── Gallery ─────────
            CustomButton(
              label: TextConstant.choosefromGallery,
              onPressed: controller.pickFromGallery,
              prefixIcon: Icon(
                Icons.photo_library,
                color: ColorConstant.primaryDark,
                size: 30,
              ),
              variant: ButtonVariant.outline,
              textColor: ColorConstant.primaryDark,
            ),

            AppSize.h60,

            // ───────── Continue ─────────
            CustomButton(
              label: TextConstant.continueButton,
              onPressed: () async {
                final imageUrl = await controller.uploadProfileImage();

                if (imageUrl != null) {
                  debugPrint("Uploaded URL: $imageUrl");

                  // next screen par jao
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

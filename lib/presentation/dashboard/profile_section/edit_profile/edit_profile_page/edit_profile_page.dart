import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:vaultiq/app_utils/image_picker_bottomsheet/image_picker_bottomsheet.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/edit_profile_controller/edit_profile_controller_v2.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final EditProfileControllerV2 editProfileController = Get.put(
    EditProfileControllerV2(),
  );

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
                        color: Colors.white.withValues(alpha: 0.1),
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
                    'Edit Profile',
                    style: AppStyles.syne(
                      size: 26.sp,
                      weight: AppFontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Update your profile information',
                    style: AppStyles.dmSans(
                      size: 12.sp,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  /// Avatar
                  Center(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          ImagePickerBottomSheet.show(
                            context: context,
                            onCameraTap: () {
                              editProfileController.pickImageFromCamera();
                            },
                            onGalleryTap: () {
                              editProfileController.pickImageFromGallery();
                            },
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: ColorConstant.primary,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: editProfileController.hasSelectedImage
                                    ? Image.file(
                                        File(editProfileController
                                            .selectedImagePath.value),
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 48.sp,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: -8,
                              right: -8,
                              child: Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstant.primary,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: Text(
                      'Tap to change photo',
                      style: AppStyles.dmSans(
                        size: 11.sp,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
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
                  /// Name Field
                  Text(
                    'Full Name',
                    style: AppStyles.dmSans(
                      size: 12.sp,
                      weight: AppFontWeight.bold,
                      color: ColorConstant.inkMuted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: editProfileController.nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
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
                  SizedBox(height: 28.h),
                  /// Upload Picture Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: editProfileController.isLoading.value
                            ? 'Uploading...'
                            : 'Upload Profile Picture',
                        onPressed: editProfileController.isLoading.value
                            ? null
                            : () {
                                editProfileController.uploadProfilePicture();
                              },
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  /// Save Changes Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: editProfileController.isLoading.value
                            ? 'Saving...'
                            : 'Save Changes',
                        onPressed: editProfileController.isLoading.value
                            ? null
                            : () {
                                editProfileController.updateName();
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
}

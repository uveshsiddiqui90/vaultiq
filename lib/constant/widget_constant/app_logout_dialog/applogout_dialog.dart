import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';

class AppLogoutDialog {
  static Future<void> show({required VoidCallback onLogout}) {
    return Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Icon Background
              Container(
                height: 72.h,
                width: 72.w,
                decoration: BoxDecoration(
                  color: const Color(0xffFFECEF),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Center(
                  child: Text("🚪", style: TextStyle(fontSize: 34.sp)),
                ),
              ),

              SizedBox(height: 22.h),

              /// Title
              Text(
                "Logout?",
                style: AppStyles.syne(
                  size: 28,
                  weight: AppFontWeight.bold,
                  color: ColorConstant.darkBg,
                ),
              ),

              SizedBox(height: 12.h),

              /// Subtitle
              Text(
                "Are you sure you want to logout?\nYou'll need to sign in again to accessyour account.",
                textAlign: TextAlign.center,
                style: AppStyles.dmSans(
                  size: AppTextSize.body,
                  weight: AppFontWeight.medium,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 30.h),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55.h,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xffF5F5F5),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                        child: Text(
                          "Stay",
                          style: AppStyles.dmSans(
                            size: AppTextSize.body,
                            weight: AppFontWeight.bold,
                            color: ColorConstant.darkBg,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 14.w),

                  Expanded(
                    child: SizedBox(
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          onLogout();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8,
                          shadowColor: const Color(0xffFF4F73).withOpacity(.45),
                          backgroundColor: const Color(0xffFF4F73),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: AppStyles.dmSans(
                            size: AppTextSize.body,
                            weight: AppFontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}

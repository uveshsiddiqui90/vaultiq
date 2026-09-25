import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';

/// Light-green reassurance card shown under the profile fields.
///
/// Green shield + title + one line of copy, exactly like the design mock-up.
class SecureProfileBanner extends StatelessWidget {
  const SecureProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorConstant.primaryLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shield(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextConstant.profileSecureTitle,
                  style: AppStyles.dmSans(
                    size: 13.sp,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.primaryDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  TextConstant.profileSecureDesc,
                  style: AppStyles.dmSans(
                    size: 11.5.sp,
                    weight: AppFontWeight.regular,
                    color: ColorConstant.inkMuted,
                  ).copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Round green gradient shield on the left of the card.
  Widget _shield() {
    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: ColorConstant.primaryGradient,
      ),
      child: Icon(
        Icons.verified_user_rounded,
        size: 18.sp,
        color: ColorConstant.white,
      ),
    );
  }
}

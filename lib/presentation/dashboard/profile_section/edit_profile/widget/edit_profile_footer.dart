import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';

/// Closing note of the Edit Profile screen: two decorative dashes and a green
/// heart on both sides of the two-line motivational copy.
class EditProfileFooter extends StatelessWidget {
  const EditProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dash(ColorConstant.amber),
        SizedBox(width: 4.w),
        _dash(ColorConstant.primaryDark),
        SizedBox(width: 10.w),
        Icon(Icons.favorite_rounded, size: 15.sp, color: ColorConstant.primary),
        SizedBox(width: 10.w),
        Flexible(
          child: Text(
            TextConstant.profileJourneyFooter,
            textAlign: TextAlign.center,
            style: AppStyles.dmSans(
              size: 11.5.sp,
              weight: AppFontWeight.medium,
              color: ColorConstant.inkMuted,
            ).copyWith(height: 1.4),
          ),
        ),
        SizedBox(width: 10.w),
        _dash(ColorConstant.primaryDark),
        SizedBox(width: 4.w),
        _dash(ColorConstant.amber),
      ],
    );
  }

  /// Tiny rounded accent line ("sparkle" of the mock-up).
  Widget _dash(Color color) {
    return Container(
      width: 9.w,
      height: 3.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

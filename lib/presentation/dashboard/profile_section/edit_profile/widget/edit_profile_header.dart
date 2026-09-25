import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';

/// Gradient top bar of the Edit Profile screen.
///
/// Content order (top → bottom):
///  1. round back button in the top-left corner
///  2. big screen title with its subtitle underneath
///  3. free space at the bottom that the avatar is allowed to overlap
///
/// The bottom edge is a soft wave ([_HeaderWaveClipper]) instead of a straight
/// line, matching the design mock-up.
class EditProfileHeader extends StatelessWidget {
  /// Fired when the round back button is tapped.
  final VoidCallback onBack;

  /// Vertical room kept free below the subtitle for the overlapping avatar.
  final double bottomSpace;

  const EditProfileHeader({
    super.key,
    required this.onBack,
    this.bottomSpace = 64,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderWaveClipper(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          20.w,
          // The gradient has to run behind the status bar like the mock-up,
          // so the system inset is added as padding instead of using SafeArea.
          MediaQuery.paddingOf(context).top + 18.h,
          20.w,
          bottomSpace.h,
        ),
        decoration: const BoxDecoration(
          gradient: ColorConstant.profileHeaderGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _backButton(),
            SizedBox(height: 18.h),
            Text(
              TextConstant.editProfile,
              style: AppStyles.syne(
                size: 27.sp,
                weight: AppFontWeight.extraBold,
                color: ColorConstant.white,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              TextConstant.editProfileSubtitle,
              style: AppStyles.dmSans(
                size: 13.sp,
                weight: AppFontWeight.medium,
                color: ColorConstant.white.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Translucent circular back button.
  Widget _backButton() {
    return InkWell(
      onTap: onBack,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstant.white.withValues(alpha: 0.12),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 15.sp,
          color: ColorConstant.white,
        ),
      ),
    );
  }
}

/// Replaces the header's straight bottom edge with a soft two-curve wave.
class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Wave amplitude is derived from the header height so the curve keeps the
    // same proportion on every screen size.
    final double waveHeight = size.height * 0.16;

    return Path()
      ..moveTo(0, size.height - waveHeight)
      // gentle dip through the middle of the header
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height + waveHeight * 0.30,
        size.width * 0.55,
        size.height - waveHeight * 0.35,
      )
      // rising back up towards the right edge
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height - waveHeight * 1.10,
        size.width,
        size.height - waveHeight * 0.60,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

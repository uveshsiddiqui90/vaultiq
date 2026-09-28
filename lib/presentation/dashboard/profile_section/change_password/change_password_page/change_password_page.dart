import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/change_password/change_password_controller/change_password_controller_v2.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/edit_profile/widget/secure_profile_banner.dart';

/// Change Password screen — opened from the Profile tab.
///
/// Layout, top → bottom:
///  1. gradient header (the same dark navy → teal used by Profile and Edit
///     Profile) with the round back button, the title, the subtitle and a small
///     lock badge on the right
///  2. a white card that rises into the header with the three password fields,
///     the strength bar, the single "Update Password" action and the security
///     note
///
/// Behaviour is unchanged: the screen still only calls
/// [ChangePasswordControllerV2.changePassword]. The widgets that read Rx state
/// (visibility toggles, hints, strength bar, button) are wrapped in `Obx` and
/// every one of those builders reads at least one observable.
class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final ChangePasswordControllerV2 changePasswordController = Get.put(
    ChangePasswordControllerV2(),
  );

  /// How far the form card rises into the header.
  static const double _cardOverlap = 26;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _header(context),

            // Pulls the card up over the header so the two areas feel joined
            // instead of leaving a visible seam between them.
            Transform.translate(
              offset: Offset(0, -_cardOverlap.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _formCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // HEADER
  // ──────────────────────────────────────────────────────────
  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20.w,
        // The gradient runs behind the status bar like the other profile
        // screens, so the inset is added as padding instead of using SafeArea.
        MediaQuery.paddingOf(context).top + 14.h,
        20.w,
        // Room for the part of the card that overlaps the header.
        44.h,
      ),
      decoration: BoxDecoration(
        gradient: ColorConstant.profileHeaderGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _backButton(context),
          AppSize.h16,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TextConstant.changePassword,
                      style: AppStyles.syne(
                        size: AppTextSize.largeTitle,
                        weight: AppFontWeight.bold,
                        color: ColorConstant.white,
                      ),
                    ),
                    AppSize.h6,
                    Text(
                      TextConstant.changePasswordSubtitle,
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.medium,
                        color: ColorConstant.white.withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ),
              ),
              AppSize.w12,
              _securityBadge(),
            ],
          ),
        ],
      ),
    );
  }

  /// Round, translucent back button — the same one the Edit Profile header uses.
  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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

  /// Security cue of the header: a translucent lock disc with a tiny mint
  /// "verified" mark, so the screen reads as a security screen without pulling
  /// in an illustration asset.
  Widget _securityBadge() {
    return SizedBox(
      width: 56.w,
      height: 56.w,
      child: Stack(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstant.white.withValues(alpha: 0.10),
              border: Border.all(
                color: ColorConstant.white.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 24.sp,
              color: ColorConstant.white.withValues(alpha: 0.92),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 21.w,
              height: 21.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: ColorConstant.primaryGradient,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 12.sp,
                color: ColorConstant.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // FORM CARD
  // ──────────────────────────────────────────────────────────
  Widget _formCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.inkMid.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. The password that is on the account right now.
          Obx(
            () => CustomTextField(
              label: TextConstant.currentPasswordLabel,
              hint: TextConstant.currentPasswordHint,
              controller: changePasswordController.currentPasswordController,
              isPassword: true,
              isPasswordVisible:
                  changePasswordController.showCurrentPassword.value,
              onTogglePassword:
                  changePasswordController.toggleCurrentPasswordVisibility,
              prefixIcon: _lockIcon(),
            ),
          ),
          AppSize.h16,

          // 2. The replacement password, followed by the strength bar.
          Obx(
            () => CustomTextField(
              label: TextConstant.newPasswordLabel,
              hint: TextConstant.newPasswordHint,
              controller: changePasswordController.newPasswordController,
              isPassword: true,
              isPasswordVisible: changePasswordController.showPassword.value,
              onTogglePassword:
                  changePasswordController.togglePasswordVisibility,
              prefixIcon: _lockIcon(),
            ),
          ),
          AppSize.h10,
          _strengthMeter(),
          AppSize.h16,

          // 3. Confirmation, with the mismatch line right underneath it.
          Obx(
            () => CustomTextField(
              label: TextConstant.confirmPasswordLabel,
              hint: TextConstant.confirmNewPasswordHint,
              controller: changePasswordController.confirmPasswordController,
              isPassword: true,
              isPasswordVisible:
                  changePasswordController.showConfirmPassword.value,
              onTogglePassword:
                  changePasswordController.toggleConfirmPasswordVisibility,
              prefixIcon: _lockIcon(),
            ),
          ),
          _mismatchHint(),
          AppSize.h24,

          _updateButton(),
          AppSize.h20,

          // Security note — the same reassurance block Edit Profile uses, with
          // the password-focused wording.
          SecureProfileBanner(
            title: TextConstant.passwordSecureTitle,
            description: TextConstant.passwordSecureDesc,
          ),
        ],
      ),
    );
  }

  /// Lock glyph that starts every password field.
  Widget _lockIcon() {
    return Icon(
      Icons.lock_outline_rounded,
      size: 18.sp,
      color: ColorConstant.primaryDark,
    );
  }

  /// Compact strength bar: four segments that fill up as the password gets
  /// stronger, with the qualitative label on the right. The builder reads only
  /// Rx values, so typing re-renders the bar without touching the rest of the
  /// card.
  Widget _strengthMeter() {
    return Obx(() {
      final int level = changePasswordController.passwordStrengthLevel;
      final String message = changePasswordController.passwordStrengthMessage;
      final Color activeColor = _strengthColor(level);

      return Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index == 3 ? 0 : 5.w),
                    child: Container(
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: index < level
                            ? activeColor
                            : ColorConstant.border,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppSize.w12,
          Text(
            message.isEmpty ? TextConstant.passwordStrength : message,
            style: AppStyles.dmSans(
              size: 10.5.sp,
              weight: AppFontWeight.semiBold,
              color: message.isEmpty ? ColorConstant.inkMuted : activeColor,
            ),
          ),
        ],
      );
    });
  }

  /// Red "passwords do not match" line, hidden while the two fields still agree.
  Widget _mismatchHint() {
    return Obx(() {
      if (changePasswordController.doPasswordsMatch) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 13.sp,
              color: ColorConstant.red,
            ),
            AppSize.w6,
            Text(
              TextConstant.passwordsDoNotMatch,
              style: AppStyles.dmSans(
                size: 10.5.sp,
                weight: AppFontWeight.medium,
                color: ColorConstant.red,
              ),
            ),
          ],
        ),
      );
    });
  }

  /// The screen's only action. [CustomButton] already renders its own spinner
  /// and disables itself while [ChangePasswordControllerV2.isLoading] is true.
  Widget _updateButton() {
    return Obx(
      () => CustomButton(
        label: TextConstant.updatePassword,
        radius: 18.r,
        isLoading: changePasswordController.isLoading.value,
        onPressed: changePasswordController.changePassword,
        prefixIcon: Icon(
          Icons.verified_user_rounded,
          size: 19.sp,
          color: ColorConstant.white,
        ),
      ),
    );
  }

  /// Green only once the password is genuinely strong; amber while it is still
  /// improving and red when it is too short to be useful.
  Color _strengthColor(int level) {
    if (level <= 1) return ColorConstant.red;
    if (level <= 3) return ColorConstant.amber;
    return ColorConstant.primary;
  }
}

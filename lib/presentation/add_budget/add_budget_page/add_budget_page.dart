import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_utils/currency_formatter/currency_formatter.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/core/config/app_config.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_controller/add_budget_controller.dart';

/// "Set Your Monthly Budget" — the last onboarding screen.
///
/// Reached from the profile-photo step. The amount saved here becomes the
/// dashboard's monthly budget, and "Save Budget" clears the onboarding stack
/// before opening the dashboard.
class AddBudgetPage extends StatelessWidget {
  AddBudgetPage({super.key});

  final AddBudgetController controller = Get.find<AddBudgetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: Stack(
        children: [
          // Soft mint wave pinned to the bottom of the screen (matches the mock).
          _backgroundWave(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(),
                  SizedBox(height: 18.h),
                  _headerCopy(),
                  SizedBox(height: 22.h),
                  _budgetCard(),
                  _onboardingFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // HEADER
  // ──────────────────────────────────────────────────────────

  /// Round white back button. The photo step sits below this route, so
  /// [Get.back] simply returns there.
  Widget _backButton() {
    return GestureDetector(
      onTap: Get.back,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: ColorConstant.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorConstant.inkDark.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16.sp,
          color: ColorConstant.inkDark,
        ),
      ),
    );
  }

  /// Wordmark, headline and supporting copy.
  ///
  /// The illustration deliberately shares the top row with the *wordmark* and
  /// not with the headline: the headline then gets the full content width, so
  /// "Monthly Budget" can never be squeezed into a mid-word break on narrow
  /// phones (which is exactly what happened when it sat next to the artwork).
  Widget _headerCopy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _wordmark()),
            AppSize.w12,
            _heroIllustration(),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          TextConstant.setBudgetTitle,
          style: AppStyles.syne(
            size: 27.sp,
            weight: AppFontWeight.extraBold,
            color: ColorConstant.inkDark,
            letterSpacing: -0.6,
          ).copyWith(height: 1.2),
        ),
        SizedBox(height: 10.h),
        Text(
          TextConstant.setBudgetSubtitle,
          style: AppStyles.dmSans(
            size: 13.5.sp,
            weight: AppFontWeight.regular,
            color: ColorConstant.inkMuted,
          ).copyWith(height: 1.45),
        ),
      ],
    );
  }

  /// The "VaultIQ" wordmark, with the trailing "IQ" in the brand green.
  Widget _wordmark() {
    return Text.rich(
      TextSpan(
        text: TextConstant.vaultWordmark,
        children: [
          TextSpan(
            text: TextConstant.iqWordmark,
            // Spelled out in full rather than relying on style inheritance,
            // so the brand green can never be lost.
            style: AppStyles.syne(
              size: 23.sp,
              weight: AppFontWeight.extraBold,
              color: ColorConstant.primary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      style: AppStyles.syne(
        size: 23.sp,
        weight: AppFontWeight.extraBold,
        color: ColorConstant.inkDark,
        letterSpacing: -0.5,
      ),
    );
  }

  /// Content-drawn stand-in for the mock-up's wallet illustration: a soft mint
  /// tile with a wallet glyph and a brand "₹" coin, so no new asset is needed.
  Widget _heroIllustration() {
    return SizedBox(
      width: 84.w,
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 68.w,
              height: 68.w,
              decoration: BoxDecoration(
                color: ColorConstant.primaryLight,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 34.sp,
                color: ColorConstant.primaryDark,
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                gradient: ColorConstant.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  AppConfig.currencySymbol,
                  style: AppStyles.syne(
                    size: 14.sp,
                    weight: AppFontWeight.extraBold,
                    color: ColorConstant.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ──────────────────────────────────────────────────────────
  // BUDGET CARD
  // ──────────────────────────────────────────────────────────

  /// White card holding the amount input, the quick-pick chips, the tip and the
  /// single "Save Budget" action.
  Widget _budgetCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.inkDark.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(),
          SizedBox(height: 20.h),
          _amountField(),
          SizedBox(height: 16.h),
          _quickAmountChips(),
          SizedBox(height: 20.h),
          _quickTip(),
          SizedBox(height: 22.h),

          // `Obx` so the button swaps its label for a spinner (and stops
          // accepting taps) while the budget is being saved.
          Obx(
            () => CustomButton(
              label: TextConstant.saveBudget,
              isLoading: controller.isLoading.value,
              onPressed: controller.saveBudget,
              prefixIcon: Icon(
                Icons.account_balance_wallet_rounded,
                size: 20.sp,
                color: ColorConstant.white,
              ),
              suffixIcon: Icon(
                Icons.arrow_forward_rounded,
                size: 20.sp,
                color: ColorConstant.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Icon chip + "Monthly Budget" title and its two-line explanation.
  Widget _cardHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46.w,
          height: 46.w,
          decoration: const BoxDecoration(
            color: ColorConstant.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            size: 22.sp,
            color: ColorConstant.primaryDark,
          ),
        ),
        AppSize.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TextConstant.monthlyBudget,
                style: AppStyles.syne(
                  size: 17.sp,
                  weight: AppFontWeight.bold,
                  color: ColorConstant.inkDark,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                TextConstant.setBudgetCardDesc,
                style: AppStyles.dmSans(
                  size: 12.5.sp,
                  weight: AppFontWeight.regular,
                  color: ColorConstant.inkMuted,
                ).copyWith(height: 1.45),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Amount input: brand "₹" prefix, big digits, and a clear (✕) button that
  /// only appears once something has been typed.
  ///
  /// The whole field sits inside one `Obx` so the border and the clear button
  /// follow `AddBudgetController.amountText`; the `TextField` keeps its focus
  /// because the text controller and the focus node live in the GetX controller.
  Widget _amountField() {
    return Obx(() {
      final bool hasText = controller.amountText.value.trim().isNotEmpty;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: ColorConstant.primaryLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasText ? ColorConstant.primary : ColorConstant.border,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Text(
              AppConfig.currencySymbol,
              style: AppStyles.syne(
                size: 22.sp,
                weight: AppFontWeight.extraBold,
                color: ColorConstant.primaryDark,
              ),
            ),
            AppSize.w8,
            Expanded(
              child: TextField(
                controller: controller.budgetController,
                focusNode: controller.budgetFocusNode,
                keyboardType: TextInputType.number,
                // Digits only — the ₹ sign is drawn in front of the field.
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                cursorColor: ColorConstant.primary,
                style: AppStyles.syne(
                  size: 26.sp,
                  weight: AppFontWeight.extraBold,
                  color: ColorConstant.inkDark,
                ),
                decoration: InputDecoration(
                  hintText: TextConstant.budgetAmountHint,
                  hintStyle: AppStyles.syne(
                    size: 26.sp,
                    weight: AppFontWeight.extraBold,
                    color: ColorConstant.inkMuted.withValues(alpha: 0.55),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                ),
              ),
            ),
            if (hasText)
              GestureDetector(
                onTap: controller.clearAmount,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: ColorConstant.inkMuted.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14.sp,
                    color: ColorConstant.white,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  /// The four "₹10,000 / ₹20,000 / …" shortcuts. The `Obx` reads
  /// [AddBudgetController.amountText] so tapping a chip immediately re-paints
  /// which one is active.
  Widget _quickAmountChips() {
    return Obx(() {
      final String current = controller.amountText.value.trim();

      return Row(
        children: [
          for (final amount in AddBudgetController.quickAmounts) ...[
            Expanded(child: _quickChip(amount, current)),
            if (amount != AddBudgetController.quickAmounts.last) AppSize.w8,
          ],
        ],
      );
    });
  }

  /// One quick-pick chip: brand-tinted while it matches what is in the field.
  Widget _quickChip(double amount, String currentText) {
    final bool isSelected = currentText == amount.toStringAsFixed(0);

    return GestureDetector(
      onTap: () => controller.selectQuickAmount(amount),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstant.primaryLight : ColorConstant.bgLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? ColorConstant.primary : ColorConstant.border,
          ),
        ),
        child: Center(
          child: Text(
            '${AppConfig.currencySymbol}${CurrencyFormatter.format(amount)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.dmSans(
              size: 11.5.sp,
              weight: AppFontWeight.bold,
              color: isSelected
                  ? ColorConstant.primaryDark
                  : ColorConstant.inkMid,
            ),
          ),
        ),
      ),
    );
  }

  /// Mint tip block: bulb badge, "Quick Tip" headline and the one-line advice.
  Widget _quickTip() {
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
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(
              color: ColorConstant.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              size: 18.sp,
              color: ColorConstant.primaryDark,
            ),
          ),
          AppSize.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextConstant.quickTipTitle,
                  style: AppStyles.dmSans(
                    size: 13.sp,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.primaryDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  TextConstant.quickTipDesc,
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

  /// Step dots (third one active — this is the last onboarding step) plus the
  /// "You're all set!" closing note.
  Widget _onboardingFooter() {
    return Column(
      children: [
        SizedBox(height: 26.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _stepDot(active: false),
            AppSize.w8,
            _stepDot(active: false),
            AppSize.w8,
            _stepDot(active: true),
          ],
        ),
        SizedBox(height: 14.h),
        Text(
          TextConstant.allSet,
          textAlign: TextAlign.center,
          style: AppStyles.syne(
            size: 14.sp,
            weight: AppFontWeight.bold,
            color: ColorConstant.inkDark,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          TextConstant.allSetDesc,
          textAlign: TextAlign.center,
          style: AppStyles.dmSans(
            size: 12.5.sp,
            weight: AppFontWeight.regular,
            color: ColorConstant.inkMuted,
          ),
        ),
      ],
    );
  }

  /// One progress pill — wider and brand-coloured while [active].
  Widget _stepDot({required bool active}) {
    return Container(
      width: active ? 26.w : 18.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: active ? ColorConstant.primary : ColorConstant.primaryLight,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  /// Soft mint wave fixed to the bottom of the screen, mirroring the About App
  /// screen. Purely decorative, so it ignores pointers.
  Widget _backgroundWave() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: SizedBox(
          height: 150.h,
          width: double.infinity,
          child: CustomPaint(painter: _WavePainter()),
        ),
      ),
    );
  }
}

/// Draws the two-curve decorative wave used behind the onboarding screen.
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstant.primaryLight
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.05,
        size.width * 0.55,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.72,
        size.width,
        size.height * 0.35,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

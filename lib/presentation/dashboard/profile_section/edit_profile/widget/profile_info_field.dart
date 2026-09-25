import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/color_constant.dart';

/// One row of the "personal information" card: a coloured icon chip, the
/// field label and a rounded input box.
///
/// Disabled rows (`enabled: false`, the email address) drop into a muted,
/// non-focusable state so it is obvious that they cannot be changed.
class ProfileInfoField extends StatelessWidget {
  /// Icon shown inside the coloured chip.
  final IconData icon;

  /// Chip icon colour.
  final Color iconColor;

  /// Chip background colour (tinted version of [iconColor]).
  final Color iconBackgroundColor;

  /// Small label printed above the input.
  final String label;

  /// Placeholder shown while the field is empty (optional).
  final String hint;

  /// Value shown / edited by this row.
  final TextEditingController controller;

  /// When `false` the row is rendered disabled: it cannot be focused or edited
  /// and uses a muted background/text (used for the email address).
  final bool enabled;

  /// Keyboard type used when the field is enabled.
  final TextInputType keyboardType;

  const ProfileInfoField({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.label,
    required this.controller,
    this.hint = '',
    this.enabled = true,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconChip(),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.dmSans(
                  size: 12.5.sp,
                  weight: AppFontWeight.bold,
                  color: ColorConstant.inkMid,
                ),
              ),
              SizedBox(height: 8.h),
              _input(),
            ],
          ),
        ),
      ],
    );
  }

  /// Circular tinted icon chip on the left of the row.
  Widget _iconChip() {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconBackgroundColor,
      ),
      child: Icon(icon, size: 20.sp, color: iconColor),
    );
  }

  /// Rounded input box — white fill with a soft border that turns into the
  /// brand green while the field is focused. Disabled rows get a muted fill and
  /// text so they read as read-only.
  Widget _input() {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      cursorColor: ColorConstant.primary,
      style: AppStyles.dmSans(
        size: 13.5.sp,
        weight: AppFontWeight.medium,
        color: enabled ? ColorConstant.inkDark : ColorConstant.inkMuted,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.dmSans(
          size: 13.sp,
          weight: AppFontWeight.regular,
          color: ColorConstant.inkMuted,
        ),
        filled: true,
        fillColor: enabled ? ColorConstant.white : ColorConstant.bgLight,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: _border(ColorConstant.border),
        enabledBorder: _border(ColorConstant.border),
        disabledBorder: _border(ColorConstant.border),
        focusedBorder: _border(ColorConstant.primary, width: 1.6),
      ),
    );
  }

  /// Shared outline for every input state.
  OutlineInputBorder _border(Color color, {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(13.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';

class AuthFooterText extends StatelessWidget {
  final String normalText;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterText({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: normalText,
        style: AppStyles.dmSans(
          size: AppTextSize.medium,
          weight: AppFontWeight.regular,
          color: ColorConstant.inkMuted,
        ),
        children: [
          TextSpan(
            text: actionText,
            style: AppStyles.dmSans(
              size: AppTextSize.medium,
              weight: AppFontWeight.bold,
              color: ColorConstant.txtColor2nd,
            ),

            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(
            text: actionText,
            style: const TextStyle(
              fontSize: 14,
              color: ColorConstant.txtColor2nd,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}

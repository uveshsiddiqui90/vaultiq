import 'package:flutter/material.dart';
import 'package:vaultiq/constant/color_constant.dart';

enum ButtonVariant { primary, outline, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final Widget? prefixIcon;
  final double width;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.prefixIcon,
    this.width = double.infinity,
  });

  // ─── colors per variant ──────────────────────────────
  Color _bg() => variant == ButtonVariant.primary
      ? ColorConstant.btnColor
      : Colors.transparent;

  Color _fg() =>
      variant == ButtonVariant.primary ? Colors.white : ColorConstant.txtColor;

  BorderSide _border() => variant == ButtonVariant.outline
      ? const BorderSide(color: ColorConstant.borderColor, width: 1.5)
      : BorderSide.none;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _bg(),
          foregroundColor: _fg(),
          disabledBackgroundColor: _bg().withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: _border(),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: _fg(),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _fg(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

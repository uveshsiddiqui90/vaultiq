import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';

enum ButtonVariant {
  primary,
  outline,
  text,
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;

  // Icon / Image / SVG kuch bhi pass kar sakte ho
  final Widget? prefixIcon;

  // Optional right side icon/image
  final Widget? suffixIcon;

  final double width;

  // Button text/icon ka custom color
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width = double.infinity,
    this.textColor,
  });

  // ─────────────────────────────────────────────
  // Foreground Color
  // ─────────────────────────────────────────────

  Color _fg() {
    if (textColor != null) {
      return textColor!;
    }

    return variant == ButtonVariant.primary
        ? ColorConstant.white
        : ColorConstant.inkDark;
  }

  // ─────────────────────────────────────────────
  // Border
  // ─────────────────────────────────────────────

  BorderSide _border() {
    return variant == ButtonVariant.outline
        ? BorderSide(
            color: ColorConstant.border,
            width: 1.5,
          )
        : BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 56.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          // Primary gradient
          gradient: variant == ButtonVariant.primary
              ? ColorConstant.primaryGradient
              : null,

          // Outline / Text background
          color: variant == ButtonVariant.outline
              ? ColorConstant.white
              : variant == ButtonVariant.text
                  ? Colors.transparent
                  : null,

          borderRadius: BorderRadius.circular(18.r),

          // Outline border
          border: variant == ButtonVariant.outline
              ? Border.fromBorderSide(_border())
              : null,

          // Primary shadow
          boxShadow: variant == ButtonVariant.primary
              ? [
                  BoxShadow(
                    color: ColorConstant.primary.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),

        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: _fg(),
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),

          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: _fg(),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ───────── Prefix Icon / Image ─────────
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: 8.w),
                    ],

                    // ───────── Button Text ─────────
                    Text(
                      label,
                      style: AppStyles.dmSans(
                        size: AppTextSize.title,
                        weight: AppFontWeight.bold,
                        color: _fg(),
                      ),
                    ),

                    // ───────── Suffix Icon / Image ─────────
                    if (suffixIcon != null) ...[
                      SizedBox(width: 8.w),
                      suffixIcon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
















// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
// import 'package:vaultiq/constant/app_style/app_style.dart';
// import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
// import 'package:vaultiq/constant/color_constant.dart';

// enum ButtonVariant { primary, outline, text }

// class CustomButton extends StatelessWidget {
//   final String label;
//   final VoidCallback? onPressed;
//   final ButtonVariant variant;
//   final bool isLoading;
//   final Widget? prefixIcon;
//   final double width;

//   const CustomButton({
//     super.key,
//     required this.label,
//     required this.onPressed,
//     this.variant = ButtonVariant.primary,
//     this.isLoading = false,
//     this.prefixIcon,
//     this.width = double.infinity,
//   });

//   // ─── colors per variant ──────────────────────────────

//   Color _bg() => variant == ButtonVariant.primary
//       ? Colors.transparent
//       : Colors.transparent;

//   Color _fg() => variant == ButtonVariant.primary
//       ? ColorConstant.white
//       : ColorConstant.inkDark;

//   BorderSide _border() => variant == ButtonVariant.outline
//       ? BorderSide(color: ColorConstant.border, width: 1.5)
//       : BorderSide.none;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: 56.h,

//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: variant == ButtonVariant.primary
//               ? ColorConstant.primaryGradient
//               : null,

//           color: variant == ButtonVariant.outline
//               ? ColorConstant.white
//               : variant == ButtonVariant.text
//               ? Colors.transparent
//               : null,

//           borderRadius: BorderRadius.circular(18.r),

//           border: variant == ButtonVariant.outline
//               ? Border.fromBorderSide(_border())
//               : null,

//           boxShadow: variant == ButtonVariant.primary
//               ? [
//                   BoxShadow(
//                     color: ColorConstant.primary.withOpacity(0.25),
//                     blurRadius: 16,
//                     offset: const Offset(0, 8),
//                   ),
//                 ]
//               : [],
//         ),

//         child: ElevatedButton(
//           onPressed: isLoading ? null : onPressed,

//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,

//             foregroundColor: _fg(),

//             disabledBackgroundColor: Colors.transparent,

//             shadowColor: Colors.transparent,

//             elevation: 0,

//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(18.r),
//             ),
//           ),

//           child: isLoading
//               ? SizedBox(
//                   width: 22.w,
//                   height: 22.h,

//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     color: _fg(),
//                   ),
//                 )
//               : Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (prefixIcon != null) ...[
//                       prefixIcon!,
//                       SizedBox(width: 8.w),
//                     ],

//                     Text(
//                       label,
//                       style: AppStyles.dmSans(
//                         size: AppTextSize.title,
//                         weight: AppFontWeight.bold,
//                         color: _fg(),
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }

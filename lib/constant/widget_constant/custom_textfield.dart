import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;

  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();

  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
            style: AppStyles.dmSans(
            size: AppTextSize.small,
            weight: AppFontWeight.semiBold,
            color: ColorConstant.inkMuted,
          ),
        ),

        SizedBox(height: 8.h),

        AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          decoration: BoxDecoration(
            color: isFocused
                ? ColorConstant.focusedFieldBg
                : ColorConstant.border,

            borderRadius: BorderRadius.circular(16.r),

            border: Border.all(
              color: isFocused ? ColorConstant.primary : Colors.transparent,

              width: 1.5,
            ),
          ),

          child: TextFormField(
            focusNode: _focusNode,

            controller: widget.controller,

            validator: widget.validator,

            keyboardType: widget.keyboardType,

            obscureText: widget.isPassword && !widget.isPasswordVisible,

            style: AppStyles.dmSans(
              size: AppTextSize.small,
              weight: AppFontWeight.semiBold,
              color: ColorConstant.inkMuted,
            ),

            decoration: InputDecoration(
              hintText: widget.hint,

              hintStyle: AppStyles.dmSans(
                size: AppTextSize.body,
                weight: AppFontWeight.medium,
                color: ColorConstant.inkMuted,
              ),

              prefixIcon: widget.prefixIcon,

              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: widget.onTogglePassword,
                      icon: Icon(
                        widget.isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20.sp,
                        color: ColorConstant.inkMuted,
                      ),
                    )
                  : null,

              border: InputBorder.none,

              enabledBorder: InputBorder.none,

              focusedBorder: InputBorder.none,

              errorBorder: InputBorder.none,

              focusedErrorBorder: InputBorder.none,

              filled: true,

              fillColor: Colors.transparent,

              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 18.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

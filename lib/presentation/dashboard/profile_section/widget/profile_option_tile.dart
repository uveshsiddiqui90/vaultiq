import 'package:flutter/material.dart';
import 'package:vaultiq/constant/color_constant.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final String? subtitle;
  final Color? iconBackgroundColor;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.subtitle,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor ?? Colors.black),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorConstant.darkBg, //textColor ?? Colors.black,
            ),
          ),
          subtitle: Text(
            subtitle ?? '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: ColorConstant.darkBg.withOpacity(0.5),
            ),
          ),
          trailing:
              trailing ??
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
        ),
      ),
    );
  }
}

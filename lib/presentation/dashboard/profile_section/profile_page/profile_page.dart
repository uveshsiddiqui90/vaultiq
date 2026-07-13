import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/profile_controller/profile_controller.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/widget/profile_option_tile.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(color: ColorConstant.darkBg),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  AppSize.h10,
                  Text(
                    "John Doe",
                    style: AppStyles.syne(
                      size: AppTextSize.title,
                      weight: AppFontWeight.semiBold,
                      color: ColorConstant.white,
                    ),
                  ),
                  Text(
                    "john.doe@example.com",
                    style: AppStyles.dmSans(
                      size: AppTextSize.medium,
                      weight: AppFontWeight.semiBold,
                      color: ColorConstant.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: AppPadding.screen,
            child: Column(
              children: [
                AppSize.h60,
                Text(
                  TextConstant.profileTitle,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                AppSize.h20,
                profileNameWidget(),
                AppSize.h20,
                ProfileOptionTile(
                  icon: Icons.person_outline,
                  title: TextConstant.editProfile,
                  onTap: () {},
                ),
                ProfileOptionTile(
                  icon: Icons.dark_mode_outlined,
                  title: TextConstant.darkMode,
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
                ProfileOptionTile(
                  icon: Icons.currency_rupee,
                  title: TextConstant.currency,
                  trailing: const Text(
                    "INR (₹)",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {},
                ),
                ProfileOptionTile(
                  icon: Icons.logout,
                  title: TextConstant.logout,
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    profileController.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileNameWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage("")),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "John Doe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "john.doe@example.com",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

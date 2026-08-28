import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_logout_dialog/applogout_dialog.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/profile_controller/profile_controller.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/widget/profile_option_tile.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgLight,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                width: double.infinity,

                decoration: BoxDecoration(
                  gradient: ColorConstant.profileHeaderGradient,
                ),
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
                        profileController.userName.value,
                        style: AppStyles.syne(
                          size: AppTextSize.title,
                          weight: AppFontWeight.semiBold,
                          color: ColorConstant.white,
                        ),
                      ),
                      Text(
                        profileController.userEmail.value,
                        style: AppStyles.dmSans(
                          size: AppTextSize.medium,
                          weight: AppFontWeight.semiBold,
                          color: ColorConstant.white,
                        ),
                      ),
                      AppSize.h10,
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            profiledesc(
                              profileController.totalExpense.value.toString(),
                              "Spent",
                            ),
                            Divider(color: Colors.white, thickness: 1),
                            profiledesc(
                              profileController.totalTransaction.value
                                  .toString(),
                              "Transactions",
                            ),
                            Divider(color: Colors.white, thickness: 1),
                            profiledesc(
                              profileController.remainingBudget.value
                                  .toString(),
                              "Saved",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                right: 20,
                left: 20,

                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      topDatadesc(
                        title: "Spent",
                        data: profileController.totalExpense.value.toString(),
                        color: ColorConstant.focusedFieldBg,
                        iconData: Icons.arrow_downward,
                        iconColor: ColorConstant.primaryDark,
                      ),
                      topDatadesc(
                        title: "Transactions",
                        data: profileController.totalTransaction.value
                            .toString(),
                        iconData: Icons.note,
                        color: ColorConstant.txtColor2nd.withAlpha(50),
                        iconColor: ColorConstant.txtColor2nd,
                      ),
                      topDatadesc(
                        title: "Saved",
                        data: profileController.remainingBudget.value
                            .toString(),
                        iconData: Icons.arrow_upward,
                        color: ColorConstant.red.withAlpha(50),
                        iconColor: ColorConstant.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AppSize.h20,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // ⭐ CHANGED
              padding: EdgeInsets.only(bottom: 100.h),
              child: Padding(
                padding: AppPadding.screen,
                child: Column(
                  children: [
                    AppSize.h40,
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Account",
                        style: AppStyles.syne(
                          size: AppTextSize.title,
                          weight: AppFontWeight.bold,
                          color: ColorConstant.darkBg,
                        ),
                      ),
                    ),
                    AppSize.h20,
                    ProfileOptionTile(
                      title: TextConstant.editProfile,
                      icon: Icons.edit,
                      subtitle: "Update your profile information",
                      iconBackgroundColor: ColorConstant.primaryDark,
                      iconColor: ColorConstant.white,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.EDITPROFILE,
                          arguments: {
                            "name": profileController.userName.value,
                            "email": profileController.userEmail.value,
                          },
                        );
                        // Handle edit profile tap
                      },
                    ),
                    ProfileOptionTile(
                      title: TextConstant.changePassword,
                      icon: Icons.lock,
                      subtitle: "Change your account password",
                      onTap: () {
                        Get.toNamed(AppRoutes.CHANGEPASSWORD);
                        // Handle change password tap
                      },
                      iconBackgroundColor: ColorConstant.amber,
                      iconColor: ColorConstant.white,
                    ),
                    ProfileOptionTile(
                      title: TextConstant.aboutApp,
                      icon: Icons.info,
                      subtitle: "Learn more about this application",
                      iconBackgroundColor: ColorConstant.txtColor2nd,
                      iconColor: ColorConstant.white,
                      onTap: () {
                        // Handle about app tap
                      },
                    ),
                    ProfileOptionTile(
                      title: TextConstant.logout,
                      icon: Icons.logout,
                      subtitle: "Sign out of your account",
                      iconBackgroundColor: ColorConstant.red,
                      iconColor: ColorConstant.white,

                      onTap: () {
                        AppLogoutDialog.show(
                          onLogout: () async {
                            profileController.logout();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
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

  Widget profiledesc(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppStyles.syne(
            size: AppTextSize.medium,
            weight: AppFontWeight.semiBold,
            color: ColorConstant.white,
          ),
        ),
        // AppSize.h10,
        Text(
          value,
          style: AppStyles.dmSans(
            size: AppTextSize.small,
            weight: AppFontWeight.semiBold,
            color: ColorConstant.white,
          ),
        ),
      ],
    );
  }

  Widget topDatadesc({
    String? data,
    String? title,
    Color? color,
    IconData? iconData,
    Color? iconColor,
  }) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? ColorConstant.amberLight,
          ),
          child: Icon(iconData, color: iconColor ?? ColorConstant.darkBg),
        ),

        Text(
          data ?? '',
          style: AppStyles.dmSans(
            size: AppTextSize.medium,
            weight: AppFontWeight.semiBold,
            color: ColorConstant.darkBg,
          ),
        ),
        AppSize.h10,
        Text(
          title ?? '',
          style: AppStyles.dmSans(
            size: AppTextSize.small,
            weight: AppFontWeight.semiBold,
            color: ColorConstant.darkBg,
          ),
        ),
      ],
    );
  }
}

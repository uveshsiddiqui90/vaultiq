import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/profile_controller/profile_controller.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/widget/profile_option_tile.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Padding(
        padding: AppPadding.screen,
        child: Column(
          children: [
            AppSize.h60,
            Text(
              "Profile Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            AppSize.h20,
            profileNameWidget(),
            AppSize.h20,
            ProfileOptionTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ProfileOptionTile(
              icon: Icons.currency_rupee,
              title: "Currency",
              trailing: const Text(
                "INR (₹)",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.logout,
              title: "Logout",
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () {
                profileController.logout();
              },
            ),
          ],
        ),
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

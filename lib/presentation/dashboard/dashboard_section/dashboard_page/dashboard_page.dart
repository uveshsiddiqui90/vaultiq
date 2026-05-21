import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_page/addexpense_page.dart';
import 'package:vaultiq/presentation/dashboard/budget_section/budget_page/budget_page.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_bottom_nav/dashboard_bottom_nav.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_controller/dashboard_controller.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_controller/home_controller.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_page/home_page.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/profile_page/profile_page.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final HomeController homeController = Get.put(HomeController());

  final List<Widget> screens = [
    HomePage(),
    AddexpensePage(),
    BudgetPage(),
    const Center(child: Text("Analytics Screen")),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: ColorConstant.primaryColor,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
        bottomNavigationBar: DashboardBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}

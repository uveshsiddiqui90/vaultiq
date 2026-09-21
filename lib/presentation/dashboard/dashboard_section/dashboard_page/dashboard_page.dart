import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_page/addexpense_page.dart';
import 'package:vaultiq/presentation/dashboard/analytics_section/analytics_page/analytics_page.dart';
import 'package:vaultiq/presentation/dashboard/budget_section/budget_page/budget_page.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_bottom_nav/dashboard_bottom_nav.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_controller/dashboard_controller.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_page/home_page.dart';
import 'package:vaultiq/presentation/dashboard/profile_section/profile_page/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const int _tabCount = 5;

  final DashboardController controller = Get.put(DashboardController());

  /// One slot per tab; a slot is filled the first time the user opens that tab.
  ///
  /// Building all five tabs up front made five controllers fire their Supabase
  /// queries at the same moment during a cold start. On a weak connection some
  /// of those requests lost the race, and because the controllers swallow their
  /// errors the affected screen stayed on its initial zeros until a reload.
  /// Widgets are cached here so each tab is created once — and therefore its
  /// controller's `onInit` runs only once.
  final List<Widget?> _tabWidgets = List<Widget?>.filled(_tabCount, null);

  Widget _tabAt(int index) {
    final existing = _tabWidgets[index];
    if (existing != null) return existing;

    final created = switch (index) {
      DashboardTabs.home => HomePage(),
      DashboardTabs.budget => BudgetPage(),
      DashboardTabs.addExpense => AddexpensePage(),
      DashboardTabs.analytics => AnalyticsPage(),
      DashboardTabs.profile => ProfilePage(),
      _ => const SizedBox.shrink(),
    };

    _tabWidgets[index] = created;
    return created;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final index = controller.currentIndex.value;

      return Scaffold(
        backgroundColor: ColorConstant.primaryColor,
        extendBody: true,
        body: IndexedStack(
          index: index,
          children: List<Widget>.generate(
            _tabCount,
            (i) => (i == index || _tabWidgets[i] != null)
                ? _tabAt(i)
                : const SizedBox.shrink(),
          ),
        ),
        bottomNavigationBar: DashboardBottomNav(),
      );
    });
  }
}

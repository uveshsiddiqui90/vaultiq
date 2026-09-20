import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/presentation/dashboard/analytics_section/analytics_controller/analytics_controller.dart';
import 'package:vaultiq/presentation/dashboard/analytics_section/shimmer/analytics_shimmer.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_controller/dashboard_controller.dart';

class AnalyticsPage extends StatelessWidget {
  AnalyticsPage({super.key});

  final AnalyticsController analyticsController = Get.put(
    AnalyticsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: SafeArea(
        child: Obx(() {
          if (analyticsController.isLoading.value) {
            return const AnalyticsShimmer();
          }

          return RefreshIndicator(
            color: ColorConstant.primary,
            onRefresh: analyticsController.reloadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppPadding.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  AppSize.h20,
                  _filterDropdown(context),
                  AppSize.h20,
                  _totalExpenseCard(),
                  AppSize.h20,
                  _spendingByCategoryCard(context),
                  AppSize.h20,
                  _budgetOverviewCard(),
                  AppSize.h20,
                  _topSpendingCategoryCard(context),
                  AppSize.h20,
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────── HEADER ───────────────────────────
  Widget _header(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorConstant.primaryLight,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.bar_chart_rounded,
            color: ColorConstant.primaryDark,
            size: 24.sp,
          ),
        ),
        AppSize.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Analytics",
                style: AppStyles.syne(
                  size: AppTextSize.largeTitle,
                  weight: AppFontWeight.extraBold,
                  color: ColorConstant.inkDark,
                ),
              ),
              Text(
                "Track your spending. Build better habits.",
                style: AppStyles.dmSans(
                  size: AppTextSize.small,
                  weight: AppFontWeight.medium,
                  color: ColorConstant.inkMuted,
                ),
              ),
            ],
          ),
        ),
        AppSize.w12,
        GestureDetector(
          onTap: () => _showFilterSheet(context),
          child: Container(
            padding: EdgeInsets.all(11.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorConstant.border),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: ColorConstant.inkDark,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────── FILTER DROPDOWN ───────────────────────────
  Widget _filterDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFilterSheet(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: ColorConstant.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 18.sp,
              color: ColorConstant.inkMid,
            ),
            AppSize.w8,
            Obx(
              () => Text(
                analyticsController.filterLabel,
                style: AppStyles.dmSans(
                  size: AppTextSize.body,
                  weight: AppFontWeight.semiBold,
                  color: ColorConstant.inkDark,
                ),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ColorConstant.inkMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              AppSize.h20,
              Text(
                "Select Range",
                style: AppStyles.syne(
                  size: AppTextSize.title,
                  weight: AppFontWeight.extraBold,
                  color: ColorConstant.inkDark,
                ),
              ),
              AppSize.h16,
              ...AnalyticsFilter.values.map(
                (option) => Obx(
                  () => _filterOptionTile(context, option),
                ),
              ),
              AppSize.h8,
            ],
          ),
        );
      },
    );
  }

  Widget _filterOptionTile(BuildContext context, AnalyticsFilter option) {
    final isSelected = analyticsController.filter.value == option;
    return GestureDetector(
      onTap: () {
        analyticsController.changeFilter(option);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstant.focusedFieldBg : ColorConstant.bgLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? ColorConstant.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(
              _filterOptionLabel(option),
              style: AppStyles.dmSans(
                size: AppTextSize.body,
                weight: AppFontWeight.semiBold,
                color: ColorConstant.inkDark,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: ColorConstant.primary, size: 20.sp),
          ],
        ),
      ),
    );
  }

  String _filterOptionLabel(AnalyticsFilter option) {
    switch (option) {
      case AnalyticsFilter.thisMonth:
        return "This Month";
      case AnalyticsFilter.lastMonth:
        return "Last Month";
      case AnalyticsFilter.allTime:
        return "All Time";
    }
  }

  // ─────────────────────────── TOTAL EXPENSE CARD ───────────────────────────
  Widget _totalExpenseCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: ColorConstant.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10.w,
            top: -10.h,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 90.sp,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Expense",
                style: AppStyles.dmSans(
                  size: AppTextSize.body,
                  weight: AppFontWeight.semiBold,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              AppSize.h8,
              Obx(
                () => Text(
                  "₹${analyticsController.currencyFormatter.format(analyticsController.totalExpense)}",
                  style: AppStyles.syne(
                    size: AppTextSize.extraLarge,
                    weight: AppFontWeight.extraBold,
                    color: Colors.white,
                  ),
                ),
              ),
              AppSize.h8,
              Obx(() {
                if (!analyticsController.showMonthComparison) {
                  return const SizedBox.shrink();
                }
                final change = analyticsController.monthOverMonthChange;
                final isIncrease = change >= 0;
                return Row(
                  children: [
                    Icon(
                      isIncrease
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 16.sp,
                      color: isIncrease
                          ? const Color(0xFFFFB4B4)
                          : const Color(0xFFC8FFE0),
                    ),
                    Text(
                      " ${change.abs().toStringAsFixed(0)}%",
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.bold,
                        color: isIncrease
                            ? const Color(0xFFFFB4B4)
                            : const Color(0xFFC8FFE0),
                      ),
                    ),
                    Text(
                      " from last month",
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.medium,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── SPENDING BY CATEGORY CARD ───────────────────────────
  Widget _spendingByCategoryCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorConstant.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: ColorConstant.primaryLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: ColorConstant.primaryDark,
                  size: 18.sp,
                ),
              ),
              AppSize.w8,
              Expanded(
                child: Text(
                  "Spending by Category",
                  style: AppStyles.syne(
                    size: AppTextSize.body,
                    weight: AppFontWeight.extraBold,
                    color: ColorConstant.inkDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showAllCategoriesSheet(context),
                child: Row(
                  children: [
                    Text(
                      "See All",
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.bold,
                        color: ColorConstant.primaryDark,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: ColorConstant.primaryDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSize.h20,
          Obx(() {
            if (analyticsController.categoryBreakdown.isEmpty) {
              return _emptyState("No expenses for ${analyticsController.filterLabel}");
            }
            return Column(
              children: [
                _donutChart(),
                AppSize.h20,
                ...analyticsController.chartCategories.map(
                  (c) => _categoryLegendTile(c),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _donutChart() {
    return SizedBox(
      height: 220,
      child: Obx(() {
        final categories = analyticsController.chartCategories;
        return Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 60,
                sections: categories
                    .map(
                      (c) => PieChartSectionData(
                        value: c.amount <= 0 ? 0.001 : c.amount,
                        title: '',
                        radius: 45,
                        color: _categoryColor(c.category),
                      ),
                    )
                    .toList(),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total",
                  style: AppStyles.dmSans(
                    size: AppTextSize.small,
                    weight: AppFontWeight.medium,
                    color: ColorConstant.inkMuted,
                  ),
                ),
                AppSize.h4,
                Text(
                  "₹${analyticsController.currencyFormatter.format(analyticsController.totalExpense)}",
                  style: AppStyles.syne(
                    size: AppTextSize.heading,
                    weight: AppFontWeight.extraBold,
                    color: ColorConstant.inkDark,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _categoryLegendTile(CategorySpend category) {
    final color = _categoryColor(category.category);
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          AppSize.w12,
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(_categoryIcon(category.category), color: color, size: 18.sp),
          ),
          AppSize.w12,
          Expanded(
            child: Text(
              _categoryDisplayName(category.category),
              style: AppStyles.dmSans(
                size: AppTextSize.body,
                weight: AppFontWeight.semiBold,
                color: ColorConstant.inkDark,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${analyticsController.currencyFormatter.format(category.amount)}",
                style: AppStyles.syne(
                  size: AppTextSize.body,
                  weight: AppFontWeight.extraBold,
                  color: ColorConstant.inkDark,
                ),
              ),
              Text(
                "${category.percentage.toStringAsFixed(0)}%",
                style: AppStyles.dmSans(
                  size: AppTextSize.small,
                  weight: AppFontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAllCategoriesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  AppSize.h20,
                  Text(
                    "All Categories",
                    style: AppStyles.syne(
                      size: AppTextSize.title,
                      weight: AppFontWeight.extraBold,
                      color: ColorConstant.inkDark,
                    ),
                  ),
                  AppSize.h16,
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        controller: scrollController,
                        itemCount: analyticsController.categoryBreakdown.length,
                        itemBuilder: (context, index) {
                          return _categoryLegendTile(
                            analyticsController.categoryBreakdown[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─────────────────────────── BUDGET OVERVIEW CARD ───────────────────────────
  Widget _budgetOverviewCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorConstant.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: ColorConstant.primaryLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.track_changes_rounded,
                  color: ColorConstant.primaryDark,
                  size: 18.sp,
                ),
              ),
              AppSize.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Budget Overview",
                      style: AppStyles.syne(
                        size: AppTextSize.body,
                        weight: AppFontWeight.extraBold,
                        color: ColorConstant.inkDark,
                      ),
                    ),
                    Text(
                      "Your monthly budget progress",
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.medium,
                        color: ColorConstant.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (Get.isRegistered<DashboardController>()) {
                    Get.find<DashboardController>().changeTab(1);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: ColorConstant.focusedFieldBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, size: 14.sp, color: ColorConstant.primaryDark),
                      AppSize.w4,
                      Text(
                        "Edit Budget",
                        style: AppStyles.dmSans(
                          size: AppTextSize.small,
                          weight: AppFontWeight.bold,
                          color: ColorConstant.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AppSize.h20,
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _statBox(
                    icon: Icons.account_balance_wallet_rounded,
                    label: "Monthly Budget",
                    value:
                        "₹${analyticsController.currencyFormatter.format(analyticsController.monthlyBudget.value)}",
                    color: ColorConstant.inkDark,
                    iconColor: ColorConstant.primaryDark,
                  ),
                ),
                AppSize.w8,
                Expanded(
                  child: _statBox(
                    icon: Icons.trending_up_rounded,
                    label: "Spent",
                    value:
                        "₹${analyticsController.currencyFormatter.format(analyticsController.currentMonthTotal)}",
                    color: ColorConstant.red,
                    iconColor: ColorConstant.red,
                  ),
                ),
                AppSize.w8,
                Expanded(
                  child: _statBox(
                    icon: Icons.arrow_downward_rounded,
                    label: "Remaining",
                    value:
                        "₹${analyticsController.currencyFormatter.format(analyticsController.remainingBudget.abs())}",
                    color: ColorConstant.primaryDark,
                    iconColor: ColorConstant.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          AppSize.h20,
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: analyticsController.budgetProgress,
                      minHeight: 10.h,
                      backgroundColor: ColorConstant.pageBg,
                      valueColor: AlwaysStoppedAnimation(
                        analyticsController.isWithinBudget
                            ? ColorConstant.primary
                            : ColorConstant.red,
                      ),
                    ),
                  ),
                ),
                AppSize.w12,
                Text(
                  "${analyticsController.percentageUsed.toStringAsFixed(0)}%",
                  style: AppStyles.syne(
                    size: AppTextSize.body,
                    weight: AppFontWeight.extraBold,
                    color: ColorConstant.inkDark,
                  ),
                ),
              ],
            ),
          ),
          AppSize.h16,
          Obx(() {
            final within = analyticsController.isWithinBudget;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: within ? ColorConstant.primaryLight : ColorConstant.redLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    within ? Icons.check_circle_rounded : Icons.warning_rounded,
                    size: 18.sp,
                    color: within ? ColorConstant.primaryDark : ColorConstant.red,
                  ),
                  AppSize.w8,
                  Expanded(
                    child: Text(
                      within
                          ? "You're within your budget! Keep it up!"
                          : "You've exceeded your monthly budget!",
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.semiBold,
                        color: within ? ColorConstant.primaryDark : ColorConstant.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statBox({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorConstant.bgLight,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: iconColor),
          AppSize.h8,
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.dmSans(
              size: 10,
              weight: AppFontWeight.medium,
              color: ColorConstant.inkMuted,
            ),
          ),
          AppSize.h4,
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.syne(
              size: AppTextSize.body,
              weight: AppFontWeight.extraBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── TOP SPENDING CATEGORY CARD ───────────────────────────
  Widget _topSpendingCategoryCard(BuildContext context) {
    return Obx(() {
      final top = analyticsController.topCategory;
      if (top == null) {
        return const SizedBox.shrink();
      }

      final color = _categoryColor(top.category);
      final suffix = analyticsController.filter.value == AnalyticsFilter.thisMonth
          ? "this month"
          : analyticsController.filter.value == AnalyticsFilter.lastMonth
              ? "last month"
              : "overall";

      return GestureDetector(
        onTap: () => _showAllCategoriesSheet(context),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: ColorConstant.border),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorConstant.primaryLight,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: ColorConstant.primaryDark,
                  size: 22.sp,
                ),
              ),
              AppSize.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top Spending Category",
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.medium,
                        color: ColorConstant.inkMuted,
                      ),
                    ),
                    Text(
                      _categoryDisplayName(top.category),
                      style: AppStyles.syne(
                        size: AppTextSize.title,
                        weight: AppFontWeight.extraBold,
                        color: ColorConstant.inkDark,
                      ),
                    ),
                    Text(
                      "You spent the most on ${_categoryDisplayName(top.category)} $suffix.",
                      style: AppStyles.dmSans(
                        size: AppTextSize.small,
                        weight: AppFontWeight.medium,
                        color: ColorConstant.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              AppSize.w8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${analyticsController.currencyFormatter.format(top.amount)}",
                    style: AppStyles.syne(
                      size: AppTextSize.body,
                      weight: AppFontWeight.extraBold,
                      color: color,
                    ),
                  ),
                  Text(
                    "${top.percentage.toStringAsFixed(0)}%",
                    style: AppStyles.dmSans(
                      size: AppTextSize.small,
                      weight: AppFontWeight.bold,
                      color: ColorConstant.inkMuted,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: ColorConstant.inkMuted),
            ],
          ),
        ),
      );
    });
  }

  Widget _emptyState(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.insert_chart_outlined_rounded, size: 40.sp, color: ColorConstant.inkMuted),
            AppSize.h12,
            Text(
              message,
              style: AppStyles.dmSans(
                size: AppTextSize.body,
                weight: AppFontWeight.medium,
                color: ColorConstant.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'groceries':
      return ColorConstant.primary;
    case 'transport':
      return ColorConstant.blue;
    case 'shopping':
      return ColorConstant.amber;
    case 'food':
      return ColorConstant.purple;
    case 'bills':
      return ColorConstant.red;
    case 'health':
      return const Color(0xFF06B6D4);
    default:
      return ColorConstant.inkMuted;
  }
}

IconData _categoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'groceries':
      return Icons.shopping_cart_rounded;
    case 'transport':
      return Icons.directions_car_rounded;
    case 'shopping':
      return Icons.shopping_bag_rounded;
    case 'food':
      return Icons.restaurant_rounded;
    case 'bills':
      return Icons.receipt_long_rounded;
    case 'health':
      return Icons.favorite_rounded;
    default:
      return Icons.category_rounded;
  }
}

String _categoryDisplayName(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return "Food & Dining";
    case 'others':
      return "Others";
    default:
      return category;
  }
}

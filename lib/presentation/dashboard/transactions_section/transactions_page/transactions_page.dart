import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_utils/category_helper/category_helper.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';
import 'package:vaultiq/presentation/dashboard/transactions_section/shimmer/transactions_shimmer.dart';
import 'package:vaultiq/presentation/dashboard/transactions_section/transactions_controller/transactions_controller_v2.dart';

/// Full transaction history — opened from the Home tab's "Recent Transactions
/// → See All" action.
class TransactionsPage extends StatelessWidget {
  TransactionsPage({super.key});

  final TransactionsControllerV2 transactionsController = Get.put(
    TransactionsControllerV2(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: SafeArea(
        child: Obx(() {
          if (transactionsController.isLoading.value) {
            return const TransactionsShimmer();
          }

          return RefreshIndicator(
            color: ColorConstant.primary,
            onRefresh: transactionsController.reloadData,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      AppSize.h16,
                      _header(context),
                      AppSize.h16,
                      _filterPill(context),
                    ],
                  ),
                ),
                AppSize.h16,
                Expanded(child: _transactionList()),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────── HEADER ───────────────────────────
  Widget _header(BuildContext context) {
    return Row(
      children: [
        _backButton(context),
        AppSize.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TextConstant.recentTransactions,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.syne(
                  size: AppTextSize.title,
                  weight: AppFontWeight.extraBold,
                  color: ColorConstant.inkDark,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                TextConstant.recentTransactionsSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.dmSans(
                  size: AppTextSize.small,
                  weight: AppFontWeight.medium,
                  color: ColorConstant.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: ColorConstant.border),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorConstant.inkDark,
          size: 16.sp,
        ),
      ),
    );
  }

  // ────────────────────────── FILTER ──────────────────────────
  Widget _filterPill(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _showFilterSheet(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: ColorConstant.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 16.sp,
                color: ColorConstant.inkMid,
              ),
              AppSize.w8,
              Obx(
                () => Text(
                  transactionsController.filterLabel,
                  style: AppStyles.dmSans(
                    size: AppTextSize.body,
                    weight: AppFontWeight.semiBold,
                    color: ColorConstant.inkDark,
                  ),
                ),
              ),
              AppSize.w4,
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.sp,
                color: ColorConstant.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
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
                TextConstant.selectRange,
                style: AppStyles.syne(
                  size: AppTextSize.title,
                  weight: AppFontWeight.extraBold,
                  color: ColorConstant.inkDark,
                ),
              ),
              AppSize.h16,
              ...TransactionsFilter.values.map(
                (option) => Obx(() => _filterOptionTile(sheetContext, option)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterOptionTile(
    BuildContext sheetContext,
    TransactionsFilter option,
  ) {
    final isSelected = transactionsController.filter.value == option;

    return GestureDetector(
      onTap: () {
        transactionsController.changeFilter(option);
        Navigator.pop(sheetContext);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstant.primaryLight : ColorConstant.bgLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? ColorConstant.primary : ColorConstant.border,
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
              Icon(
                Icons.check_circle_rounded,
                color: ColorConstant.primary,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  String _filterOptionLabel(TransactionsFilter option) {
    switch (option) {
      case TransactionsFilter.thisMonth:
        return TextConstant.thisMonth;
      case TransactionsFilter.lastMonth:
        return TextConstant.lastMonth;
      case TransactionsFilter.allTime:
        return TextConstant.allTime;
    }
  }

  // ─────────────────────────── LIST ───────────────────────────
  Widget _transactionList() {
    final expenses = transactionsController.filteredExpenses;

    if (expenses.isEmpty) {
      return _emptyState();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorConstant.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: expenses.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            thickness: 1,
            color: ColorConstant.border,
          ),
          itemBuilder: (context, index) =>
              _transactionTile(context, expenses[index]),
        ),
      ),
    );
  }

  Widget _transactionTile(BuildContext context, ExpenseModel expense) {
    final color = CategoryHelper.color(expense.category);

    return GestureDetector(
      onTap: () => _showExpenseDetails(context, expense),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            /// Category icon
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: CategoryHelper.softColor(expense.category),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CategoryHelper.icon(expense.category),
                color: color,
                size: 22.sp,
              ),
            ),

            AppSize.w12,

            /// Title + date + category chip
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactionsController.titleFor(expense),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.syne(
                      size: AppTextSize.body,
                      weight: AppFontWeight.bold,
                      color: ColorConstant.inkDark,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    transactionsController.formatDate(expense.date),
                    style: AppStyles.dmSans(
                      size: AppTextSize.small,
                      weight: AppFontWeight.medium,
                      color: ColorConstant.inkMuted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _categoryChip(expense.category, color),
                ],
              ),
            ),

            AppSize.w8,

            /// Amount
            Text(
              transactionsController.amountFor(expense),
              style: AppStyles.syne(
                size: AppTextSize.body,
                weight: AppFontWeight.extraBold,
                color: ColorConstant.red,
              ),
            ),

            AppSize.w4,

            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: ColorConstant.inkMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String category, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: CategoryHelper.softColor(category),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CategoryHelper.icon(category), size: 12.sp, color: color),
          SizedBox(width: 5.w),
          Text(
            CategoryHelper.displayName(category),
            style: AppStyles.dmSans(
              size: 11.sp,
              weight: AppFontWeight.semiBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 80.h),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 44.sp,
                color: ColorConstant.inkMuted,
              ),
              AppSize.h12,
              Text(
                TextConstant.noTransactions,
                style: AppStyles.dmSans(
                  size: AppTextSize.body,
                  weight: AppFontWeight.medium,
                  color: ColorConstant.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────── EXPENSE DETAILS ───────────────────────
  void _showExpenseDetails(BuildContext context, ExpenseModel expense) {
    final color = CategoryHelper.color(expense.category);

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

              /// Icon + title
              Row(
                children: [
                  Container(
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      color: CategoryHelper.softColor(expense.category),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CategoryHelper.icon(expense.category),
                      color: color,
                      size: 22.sp,
                    ),
                  ),
                  AppSize.w12,
                  Expanded(
                    child: Text(
                      transactionsController.titleFor(expense),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.syne(
                        size: AppTextSize.medium,
                        weight: AppFontWeight.extraBold,
                        color: ColorConstant.inkDark,
                      ),
                    ),
                  ),
                ],
              ),

              AppSize.h20,

              _detailRow(
                TextConstant.amountLabel,
                transactionsController.amountFor(expense),
                valueColor: ColorConstant.red,
              ),
              _detailRow(
                TextConstant.dateTitle,
                transactionsController.formatDate(expense.date),
              ),
              _detailRow(
                TextConstant.categoryTitle,
                CategoryHelper.displayName(expense.category),
                valueColor: color,
              ),

              AppSize.h16,
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Text(
            label,
            style: AppStyles.dmSans(
              size: AppTextSize.body,
              weight: AppFontWeight.medium,
              color: ColorConstant.inkMuted,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppStyles.syne(
              size: AppTextSize.body,
              weight: AppFontWeight.bold,
              color: valueColor ?? ColorConstant.inkDark,
            ),
          ),
        ],
      ),
    );
  }
}

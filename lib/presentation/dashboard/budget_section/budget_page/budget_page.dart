import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_utils/currency_formatter/currency_formatter.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_bottom_nav/bottom_nav.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/presentation/dashboard/budget_section/budget_controller/budget_controller.dart';
import 'package:vaultiq/presentation/dashboard/budget_section/shimmer/budget_shimmer.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_controller/home_controller.dart';

class BudgetPage extends StatelessWidget {
  BudgetPage({super.key});
  final BudgetController budgetController = Get.put(BudgetController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Padding(
        padding: AppPadding.screen,
        child: Obx(
          () {
             if (budgetController.isLoading.value) {
                return const BudgetShimmer();
              }
          
           return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              AppSize.h40,
              Center(
                child: Text(
                  TextConstant.budgetTitle,
                  style: AppStyles.dmSans(
                    size: AppTextSize.extraLarge,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.darkBg,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSize.h20,
              monthlyBudgetWidget(),
              AppSize.h20,
              budgetUsageWidget(),
              AppSize.h20,
              remainingBudgetWidget(),
              AppSize.h40,
              CustomButton(
                label: TextConstant.editBudget,
                onPressed: () {
                  AppBottomSheet.showAmountBottomSheet(
                    context: context,
                    controller: budgetController.budgettxt,
                    onSave: () async {
                      budgetController.saveBudget();
                    },
                  );
                },
              ),
            ],
          );
  }),
      ),
    );
  }

  Widget monthlyBudgetWidget() {
    return Container(
      width: double.infinity,
      padding: AppPadding.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstant.monthlyBudget,
            style: AppStyles.syne(
              size: AppTextSize.medium,
              weight: AppFontWeight.bold,
              color: ColorConstant.darkBg,
            ),
          ),
          SizedBox(height: 8),
          Obx(
            () => Text(
              "₹ ${CurrencyFormatter.format(budgetController.monthlyBudget.value)}",
              style: AppStyles.syne(
                size: AppTextSize.largeTitle,
                weight: AppFontWeight.bold,
                color: ColorConstant.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget budgetUsageWidget() {
    return Container(
      padding: AppPadding.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstant.budgetUsage,
            style: AppStyles.syne(
              size: AppTextSize.medium,
              weight: AppFontWeight.bold,
              color: ColorConstant.inkDark,
            ),
          ),
          SizedBox(height: 8),

          Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: budgetController.budgetProgress,
                minHeight: 8.h,
                backgroundColor: ColorConstant.pageBg,
                valueColor: AlwaysStoppedAnimation(ColorConstant.primary),
              ),
            ),
          ),
          SizedBox(height: 8),
          Obx(
            () => Text(
              '${budgetController.percentageUsed.toStringAsFixed(0)}% used',
              style: TextStyle(
                fontSize: AppTextSize.body,
                fontWeight: AppFontWeight.regular,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget remainingBudgetWidget() {
    return Container(
      padding: AppPadding.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstant.remainingBudget,
            style: TextStyle(
              fontSize: AppTextSize.title,
              fontWeight: AppFontWeight.medium,
            ),
          ),
          SizedBox(height: 8),
          Obx(
            () => Text(
              "₹ ${CurrencyFormatter.format(budgetController.remainingBudget.value)}",
              style: TextStyle(
                fontSize: AppTextSize.title,
                fontWeight: AppFontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

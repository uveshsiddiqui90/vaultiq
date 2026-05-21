import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_padding/app_padding.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_bottom_nav/bottom_nav.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/presentation/dashboard/budget_section/budget_controller/budget_controller.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSize.h40,
            Center(
              child: Row(
                children: [
                  Text(
                    TextConstant.budgetTitle,
                    style: TextStyle(
                      fontSize: AppTextSize.largeTitle,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                ],
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
              label: "Edit Budget",
              onPressed: () {
                AppBottomSheet.showAmountBottomSheet(
                  context: context,
                  controller: budgetController.budgettxt,
                  onSave: () async {
                    await budgetController.updateBudget();
                    await budgetController.fetchBudget();
                    await homeController.fetchBudget();
                    
                  },
                );
              },
            ),
          ],
        ),
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
            'Monthly Budget',
            style: TextStyle(
              fontSize: AppTextSize.title,
              fontWeight: AppFontWeight.medium,
            ),
          ),
          SizedBox(height: 8),
          Obx(
            () => Text(
              budgetController.monthlyBudget.value.toString(),
              style: TextStyle(
                fontSize: AppTextSize.title,
                fontWeight: AppFontWeight.bold,
                color: Colors.green,
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
            'Budget Usage',
            style: TextStyle(
              fontSize: AppTextSize.title,
              fontWeight: AppFontWeight.medium,
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.75, // Example usage percentage
            backgroundColor: Colors.grey.shade300,
            color: Colors.green,
          ),
          SizedBox(height: 8),
          Text(
            '75% used',
            style: TextStyle(
              fontSize: AppTextSize.body,
              fontWeight: AppFontWeight.regular,
              color: Colors.grey,
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
            'Remaining Budget',
            style: TextStyle(
              fontSize: AppTextSize.title,
              fontWeight: AppFontWeight.medium,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$500',
            style: TextStyle(
              fontSize: AppTextSize.title,
              fontWeight: AppFontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

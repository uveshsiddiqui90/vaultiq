import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/app_asset_size/appassetsize.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/icon_constant.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_controller/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topContainer(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hi, User!",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.notification_add, size: 40.sp),
            ],
          ),
          AppSize.h24,
          totalBalanceCard(),
          AppSize.h24,
          Text(
            "This Month",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.h),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Expanded(
                  child: thisMonthCard(
                    "Monthly Budget",
                    homeController.monthlyBudget.value.toString(),
                    Colors.green,
                    context,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: thisMonthCard(
                  "Expense",
                  homeController.totalExpense.value.toString(),
                  Colors.redAccent,
                  context,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                "View All",
                style: TextStyle(fontSize: 14.sp, color: Colors.blueAccent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              //shrinkWrap: true,
              // physics: AlwaysScrollableScrollPhysics(),
              itemCount: homeController.expenses.length,
              itemBuilder: (context, index) {
                return transactionTile(homeController.expenses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget totalBalanceCard() {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Balance",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withAlpha(255),
                ),
              ),
              Text(
                homeController.remainingBudget.value.toString(),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Icon(Icons.account_balance_wallet, size: 40.sp, color: Colors.white),
        ],
      ),
    );
  }

  Widget topContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSize.height(context, 0.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1025), Color(0xFF161A38)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning,",
                  style: AppStyles.dmSans(
                    size: AppTextSize.small,
                    weight: AppFontWeight.bold,
                    color: ColorConstant.inkMuted,
                    //color: ColorConstant.blue,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Uvesh Siddiqui",
                      style: AppStyles.syne(
                        size: AppTextSize.title,
                        weight: AppFontWeight.extraBold,
                        color: ColorConstant.white,
                        //color: ColorConstant.blue,
                      ),
                    ),
                    Image.asset(
                      IconConstant.wavingHand,
                      height: AppAssetSize.large,
                      width: AppAssetSize.large,
                    ),
                  ],
                ),
                AppSize.h24,
                Container(
                  margin: EdgeInsets.only(bottom: 20.w),
                  width: double.infinity,
                  height: AppSize.height(context, 0.3),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: Colors.white.withAlpha(100),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSize.h8,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Available Balance",
                              style: AppStyles.syne(
                                size: AppTextSize.body,
                                weight: AppFontWeight.bold,
                                color: ColorConstant.inkMuted,
                              ),
                            ),
                            Text(
                              "16,000",
                              // homeController.remainingBudget.value.toString(),
                              style: AppStyles.syne(
                                size: AppTextSize.extraLarge,
                                weight: AppFontWeight.bold,
                                color: ColorConstant.white,
                              ),
                            ),
                            AppSize.h16,
                            Row(
                              children: [
                                Expanded(
                                  child: thisMonthCard(
                                    "Budget",
                                    "10,000",

                                    ColorConstant.white,
                                    context,
                                  ),
                                ),
                                AppSize.w16,

                                Expanded(
                                  child: thisMonthCard(
                                    "Spent this Month",
                                    "6,000",

                                    ColorConstant.red,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget thisMonthCard(
    String title,
    String amount,
    Color amountColor,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.h,
              child: Text(
                title,
                style: AppStyles.dmSans(
                  size: AppTextSize.small,
                  weight: AppFontWeight.bold,
                  color: ColorConstant.hinttxtColor,
                ),
              ),
            ),
            Text(
              amount,
              style: AppStyles.syne(
                size: AppTextSize.medium,
                weight: AppFontWeight.bold,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionTile(ExpenseModel transaction) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        radius: 20,

        child: Text(
          transaction.category[0].toUpperCase(),

          style: const TextStyle(fontSize: 18),
        ),
      ),

      title: Text(
        transaction.category,

        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),

      subtitle: Text(
        transaction.date,

        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),

      trailing: Text(
        "-₹${transaction.amount}",

        style: const TextStyle(
          fontWeight: FontWeight.w700,

          fontSize: 14,

          color: Colors.red,
        ),
      ),
    );
  }

  Widget budgetexpensecard(
    String title,
    String amount,
    Color color,
    BuildContext context,
  ) {
    return Container(
      height: AppSize.height(context, 0.1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.syne(
                size: AppTextSize.body,
                weight: AppFontWeight.bold,
                color: ColorConstant.pageBg,
              ),
            ),
            Text(
              amount,
              style: AppStyles.syne(
                size: AppTextSize.medium,
                weight: AppFontWeight.bold,
                color: ColorConstant.hinttxtColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

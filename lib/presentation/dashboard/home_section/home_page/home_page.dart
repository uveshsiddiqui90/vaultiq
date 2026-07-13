import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_utils/greeting_helper/greeting_helper.dart';
import 'package:vaultiq/constant/app_asset_size/appassetsize.dart';
import 'package:vaultiq/constant/app_fontweight/app_fontweight.dart';
import 'package:vaultiq/constant/app_size/app_size.dart';
import 'package:vaultiq/constant/app_style/app_style.dart';
import 'package:vaultiq/constant/app_textsize/app_textsize.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/constant/icon_constant.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_controller/home_controller.dart';
import 'package:vaultiq/presentation/dashboard/home_section/shimmer/home_shimmer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController homeController = Get.put(HomeController());
  GreetingHelper? greetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Obx(() {
         if (homeController.isLoading.value) {
            return const HomeShimmer();
          }
         return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => topContainer(
                    context,
                    monthlyBudget: homeController.monthlyBudget.value,
                    totalExpense: homeController.totalExpense.value,
                    remainingBudget: homeController.remainingBudget.value,
                    homeController: homeController,
                    userName: homeController.userName.value,
                  ),
                ),
                AppSize.h16,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        budgetCardRecentTransactions(),
                        AppSize.h16,
                        Obx(
                          () => amountUsedCard(
                            context,
                            usedAmount: homeController.totalExpense.value,
                            totalAmount: homeController.monthlyBudget.value,
                            percentageUsed:"${homeController.percentageUsed.toStringAsFixed(0)}%",
                            progress: homeController.budgetProgress,
                            homeController: homeController,
                    ),
                  ),
                  AppSize.h16,
                  budgetCardRecentTransactions(
                    title: "Recent Transactions",
                    secondaryTitle: "See All",
                  ),
                  AppSize.h8,
                  
                  Obx(
                    () => recentTransactionList(
                      expenses: homeController.expenses,
                      homeController: homeController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
   } ));
  }
}

Widget topContainer(
  BuildContext context, {
  double monthlyBudget = 0.0,
  double totalExpense = 0.0,
  double remainingBudget = 0.0,
  HomeController? homeController,
  String greeting = "Good Morning",
  String userName = "User",
}) {
  return Container(
    width: double.infinity,
    height: AppSize.height(context, 0.5),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xFF0D1025), Color(0xFF161A38)]),
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
                "${GreetingHelper.greeting()},",
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
                    userName.toString(),
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
                            "₹ ${homeController?.currencyFormatter.format(homeController.monthlyBudget.value - homeController.totalExpense.value)}",
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
                                  "₹ ${homeController?.currencyFormatter.format(monthlyBudget)}",
                                  ColorConstant.white,
                                  context,
                                ),
                              ),

                              AppSize.w16,

                              Expanded(
                                child: thisMonthCard(
                                  "Spent this Month",
                                  "₹ ${homeController?.currencyFormatter.format(totalExpense)}",
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

Widget budgetCardRecentTransactions({
  String title = "Budget Overview",
  String secondaryTitle = "Edit",
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Text(
        title,
        style: AppStyles.syne(
          size: AppTextSize.body,
          weight: AppFontWeight.extraBold,
          color: ColorConstant.txtColor,
        ),
      ),

      Row(
        children: [
          Text(
            secondaryTitle,
            style: AppStyles.syne(
              size: AppTextSize.body,
              weight: AppFontWeight.bold,
              color: ColorConstant.blue,
            ),
          ),
          Icon(Icons.arrow_forward, size: 16.sp, color: ColorConstant.blue),
        ],
      ),
    ],
  );
}

Widget amountUsedCard(
  BuildContext context, {
  double usedAmount = 8500,
  double totalAmount = 25000,
  String percentageUsed = "34%",
  double progress = 0.34,
  HomeController? homeController,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: ColorConstant.pageBg, width: 1),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Text(
                    "₹ ${homeController?.currencyFormatter.format(usedAmount)}",
                    style: AppStyles.syne(
                      size: AppTextSize.small,
                      weight: AppFontWeight.extraBold,
                      color: ColorConstant.txtColor,
                    ),
                  ),
                  Text(
                    " of",
                    style: AppStyles.syne(
                      size: AppTextSize.small,
                      weight: AppFontWeight.extraBold,
                      color: ColorConstant.txtColor,
                    ),
                  ),
                  Text(
                    " ₹ ${homeController?.currencyFormatter.format(totalAmount)}",
                    style: AppStyles.syne(
                      size: AppTextSize.small,
                      weight: AppFontWeight.extraBold,
                      color: ColorConstant.txtColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    " $percentageUsed",
                    style: AppStyles.syne(
                      size: AppTextSize.small,
                      weight: AppFontWeight.extraBold,
                      color: ColorConstant.amber,
                    ),
                  ),
                  AppSize.w4,
                  Icon(Icons.warning, size: 16.sp, color: ColorConstant.amber),
                ],
              ),
            ],
          ),
          AppSize.h12,

          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: ColorConstant.pageBg,
              valueColor: AlwaysStoppedAnimation(ColorConstant.primary),
            ),
          ),
          AppSize.h8,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹ ${homeController?.currencyFormatter.format(totalAmount - usedAmount)} remaining",
                style: AppStyles.dmSans(
                  size: AppTextSize.small,
                  weight: AppFontWeight.medium,
                  color: ColorConstant.hinttxtColor,
                ),
              ),

              Text(
                percentageUsed,
                style: AppStyles.dmSans(
                  size: AppTextSize.small,
                  weight: AppFontWeight.medium,
                  color: ColorConstant.hinttxtColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget reecentTransactionList({
  required String title,
  required String date,
  required String amount,
  required Color amountColor,
}) {
  return Expanded(
    child: ListView.separated(
      padding: EdgeInsets.zero,
      // shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: 20, //homeController.transactions.length,
      itemBuilder: (context, index) {
        //final transaction = homeController.transactions[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorConstant.pageBg, width: 1),
          ),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: ColorConstant.borderColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart, color: ColorConstant.blue),
              ),
            ),
            title: Text(
              "Groceries", //
              // transaction['description'],
              style: AppStyles.syne(
                size: AppTextSize.body,
                weight: AppFontWeight.bold,
                color: ColorConstant.txtColor,
              ),
            ),
            subtitle: Text(
              "Aug 20, 2024", //
              // transaction['date'],
              style: AppStyles.dmSans(
                size: AppTextSize.small,
                weight: AppFontWeight.medium,
                color: ColorConstant.hinttxtColor,
              ),
            ),
            trailing: Text(
              "-\$50.00", //
              //"-\$${transaction['amount']}",
              style: AppStyles.syne(
                size: AppTextSize.body,
                weight: AppFontWeight.bold,
                color: ColorConstant.red,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return AppSize.h8;
      },
    ),
  );
}

Widget recentTransactionList({
  required RxList<ExpenseModel> expenses,
  required HomeController homeController,
}) {
  if (expenses.isEmpty) {
    return Expanded(
      child: Center(
        child: Text(
          "No Transactions Found",
          style: AppStyles.dmSans(
            size: AppTextSize.body,
            weight: AppFontWeight.medium,
            color: ColorConstant.hinttxtColor,
          ),
        ),
      ),
    );
  }

  return Expanded(
    child: ListView.separated(
      itemCount: expenses.length > 3 ? 3 : expenses.length,
      separatorBuilder: (_, __) => AppSize.h8,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ColorConstant.pageBg),
          ),

          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 4.h,
            ),

            leading: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: ColorConstant.borderColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _getCategoryIcon(expense.category),
                color: ColorConstant.primary,
                size: 22.sp,
              ),
            ),

            title: Text(
              expense.category,
              style: AppStyles.syne(
                size: AppTextSize.body,
                weight: AppFontWeight.bold,
                color: ColorConstant.txtColor,
              ),
            ),

            subtitle: Text(
              expense.date,
              style: AppStyles.dmSans(
                size: AppTextSize.small,
                weight: AppFontWeight.medium,
                color: ColorConstant.hinttxtColor,
              ),
            ),

            trailing: Text(
              "- ₹${homeController.currencyFormatter.format(expense.amount)}",
              style: AppStyles.syne(
                size: AppTextSize.body,
                weight: AppFontWeight.bold,
                color: ColorConstant.red,
              ),
            ),
          ),
        );
      },
    ),
  );
}

IconData _getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'groceries':
      return Icons.shopping_cart;

    case 'food':
      return Icons.restaurant;

    case 'travel':
      return Icons.directions_bus;

    case 'shopping':
      return Icons.shopping_bag;

    case 'bills':
      return Icons.receipt_long;

    default:
      return Icons.account_balance_wallet;
  }
}

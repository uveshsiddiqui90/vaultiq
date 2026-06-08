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
          AppSize.h16,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  budgetCardRecentTransactions(),
                  AppSize.h16,
                  amountUsedCard(context),
                  AppSize.h16,
                  budgetCardRecentTransactions(
                    title: "Recent Transactions",
                    secondaryTitle: "See All",
                  ),
                  AppSize.h8,
                  recentTransactionList(
                    title: "Grocery Shopping",
                    date: "Aug 20, 2024",
                    amount: "-\$50.00",
                    amountColor: ColorConstant.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget topContainer(BuildContext context) {
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
  String usedAmount = "8500",
  String totalAmount = "25000",
  String percentageUsed = "34%",
}) {
  return Container(
    width: double.infinity,
    height: AppSize.height(context, 0.12),
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
                    " $usedAmount",
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
                    " $totalAmount used",
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
        ],
      ),
    ),
  );
}

Widget recentTransactionList({
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

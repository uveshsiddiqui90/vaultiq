import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/color_constant.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';
import 'package:vaultiq/presentation/dashboard/home_section/home_controller/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hi, User!",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.notification_add, size: 40.sp),
              ],
            ),
            SizedBox(height: 20.h),
            totalBalanceCard(),
            SizedBox(height: 20.h),
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
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
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

  Widget thisMonthCard(
    String title,
    String amount,
    Color color,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withAlpha(255),
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
}

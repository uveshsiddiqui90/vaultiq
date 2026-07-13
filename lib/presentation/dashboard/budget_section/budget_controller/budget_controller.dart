import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';
import 'package:vaultiq/data/services/expense_service/expense_service.dart';

class BudgetController extends GetxController {
  TextEditingController budgettxt = TextEditingController();
  final BudgetService _budgetService = BudgetService();
  RxDouble monthlyBudget = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;
  final ExpenseService _expenseService = ExpenseService();
  RxDouble remainingBudget = 0.0.obs;
  RxBool isLoading = true.obs;
   

Future<void> updateBudget() async {
  try {

    final budget = double.parse(
      budgettxt.text.trim(),
    );

    await _budgetService.updateBudget(
      monthlyBudget: budget,
    );

    AppSnackbar.success(
      message: "Budget updated successfully",
    );

  } catch (e) {

    AppSnackbar.error(
      message: "Failed to update budget",
    );
  }
}


  Future<void> fetchBudget() async {
    try {
      final budget = await _budgetService.fetchBudget();
      monthlyBudget.value = budget?.toDouble() ?? 0.0;
      print("Fetched budget: ${monthlyBudget.value}");
     
    } catch (e) {
      print("Error fetching budget: $e");
    }
  }

Future<void> fetchTotalExpense() async {
    try {
      final expenses = await _expenseService.fetchExpenses();

      double total = 0;

      for (var expense in expenses) {
        total += expense.amount;
      }

      totalExpense.value = total;
      

      calculateRemainingBudget();
    } catch (e) {
      print(e);
    }
  }
   double get budgetProgress {
  if (monthlyBudget.value <= 0) return 0.0;

  return (totalExpense.value / monthlyBudget.value).clamp(0.0, 1.0);
}

  Future<void> calculateRemainingBudget() async {
    remainingBudget.value = monthlyBudget.value - totalExpense.value;
    print("Remaining budget: ${remainingBudget.value}");
  }

double get percentageUsed {
  if (monthlyBudget.value <= 0) return 0;

  return (totalExpense.value / monthlyBudget.value) * 100;
}

Future saveBudget() async {
  
      await updateBudget();
      await fetchBudget();
      await fetchTotalExpense();
      await calculateRemainingBudget();
}

@override
  void onInit() async {
    super.onInit();
     isLoading.value = true;

  await fetchBudget();
  await fetchTotalExpense();

  isLoading.value = false;
  }


  @override
  void onClose() {
    budgettxt.dispose();
    super.onClose();
  }
}
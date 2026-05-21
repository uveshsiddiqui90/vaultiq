import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';

class BudgetController extends GetxController {
  TextEditingController budgettxt = TextEditingController();
  final BudgetService _budgetService = BudgetService();
  RxDouble monthlyBudget = 0.0.obs;

   

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




@override
  void onInit() {
    // TODO: implement onInit
    fetchBudget();
    super.onInit();
  }


  @override
  void onClose() {
    budgettxt.dispose();
    super.onClose();
  }
}
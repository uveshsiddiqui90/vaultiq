import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';

class AddBudgetController extends GetxController {
  TextEditingController budgetController = TextEditingController();

  final BudgetService _budgetService = BudgetService();

  Future<void> saveBudget() async {

  try {

    final budget = double.parse(
      budgetController.text.trim(),
    );

    await _budgetService.saveBudget(
      monthlyBudget: budget,
    );

    AppSnackbar.success(
      message: "Budget saved successfully",
    );
    Get.toNamed(AppRoutes.DASHBOARD);

  } catch (e) {

    debugPrint(e.toString());

    AppSnackbar.error(
      message: "Failed to save budget",
    );
  }
}


  

  @override
  void onClose() {
    budgetController.dispose();
    super.onClose();
  }


}
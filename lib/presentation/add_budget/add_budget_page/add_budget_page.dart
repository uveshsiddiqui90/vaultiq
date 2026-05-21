import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/constant/widget_constant/custom_button.dart';
import 'package:vaultiq/constant/widget_constant/custom_textfield.dart';
import 'package:vaultiq/presentation/add_budget/add_budget_controller/add_budget_controller.dart';

class AddBudgetPage extends StatelessWidget {
  AddBudgetPage({super.key});

  final AddBudgetController addBudgetController = Get.put(
    AddBudgetController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Add Budget Page'),
            CustomTextField(
              label: "Budget",
              hint: "Enter your budget",
              controller: addBudgetController.budgetController,
            ),
            CustomButton(
              label: "Save",
              onPressed: () {
                addBudgetController.saveBudget();
              },
            ),
          ],
        ),
      ),
    );
  }
}

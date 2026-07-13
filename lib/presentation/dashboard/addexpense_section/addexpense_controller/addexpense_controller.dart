import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/services/expense_service/expense_service.dart';


class AddExpenseController extends GetxController {

TextEditingController amountController = TextEditingController();

TextEditingController noteController = TextEditingController();

TextEditingController dateController = TextEditingController();

RxString selectedCategory = "Groceries".obs;

final ExpenseService _expenseService =ExpenseService();
Rx<DateTime> selectedDate = DateTime.now().obs;


Future<void> addExpense() async {

  try {

    final amount = double.parse(amountController.text.trim());

    await _expenseService.addExpense(

      amount: amount,

      category: selectedCategory.value,

      date: dateController.text.trim(),

      note: noteController.text.trim(),
    );

    AppSnackbar.success(
      message: "Expense Added Successfully",
    );
    amountController.clear();
    noteController.clear();
    dateController.clear();
    selectedCategory.value = "Groceries";

  } catch (e) {

    AppSnackbar.error(
      message: e.toString(),
    );
  }
}




}
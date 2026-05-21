import 'package:get/get.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';
import 'package:vaultiq/data/services/expense_service/expense_service.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';

class HomeController extends GetxController {
  final BudgetService _budgetService = BudgetService();
  RxDouble monthlyBudget = 0.0.obs;
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  RxBool isLoading = false.obs;
  final ExpenseService _expenseService = ExpenseService();

  RxDouble totalExpense = 0.0.obs;

  RxDouble remainingBudget = 0.0.obs;

  @override
  void onInit() async {
    await fetchBudget();
    await fetchExpenses();
    await fetchTotalExpense();
    super.onInit();
  }

  Future<void> fetchBudget() async {
    try {
      final budget = await _budgetService.fetchBudget();
      monthlyBudget.value = budget?.toDouble() ?? 0.0;
    } catch (e) {
      print("Error fetching budget: $e");
    }
  }

  Future<void> fetchExpenses() async {
    try {
      isLoading.value = true;

      final fetchedExpenses = await _expenseService.fetchExpenses();

      expenses.assignAll(fetchedExpenses);
    } catch (e) {
      AppSnackbar.error(message: e.toString());
    } finally {
      isLoading.value = false;
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

  void calculateRemainingBudget() {
    remainingBudget.value = monthlyBudget.value - totalExpense.value;

    print("Remaining Budget: ${remainingBudget.value}");
  }
}

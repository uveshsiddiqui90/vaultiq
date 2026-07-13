import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final currencyFormatter = NumberFormat('#,##0');
  RxString userName = "User".obs;

  @override
  void onInit() async {
    loadHomeData();
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
    final fetchedExpenses =
        await _expenseService.fetchExpenses();

    expenses.assignAll(fetchedExpenses);
  } catch (e) {
    AppSnackbar.error(message: e.toString());
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
  }

    Future<void> getUserName() async {

    final user = Supabase.instance.client.auth.currentUser;
    userName.value = user?.userMetadata?['name'] ?? 'User';
  }


  double get budgetProgress {
  if (monthlyBudget.value <= 0) return 0.0;

  return (totalExpense.value / monthlyBudget.value).clamp(0.0, 1.0);
}

double get percentageUsed {
  if (monthlyBudget.value <= 0) return 0;

  return (totalExpense.value / monthlyBudget.value) * 100;
}


Future<void> loadHomeData() async {
  try {
    isLoading.value = true;

    await Future.wait([
      getUserName(),
      fetchBudget(),
      fetchExpenses(),
      fetchTotalExpense(),
    ]);
  } catch (e) {
    print(e);
  } finally {
    isLoading.value = false;
  }
}


}

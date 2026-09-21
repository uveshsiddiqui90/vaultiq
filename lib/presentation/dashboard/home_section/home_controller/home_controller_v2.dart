/// HomeController V2 — refactored with proper architecture
/// Uses repositories, error handling, logging, validation
/// This is a replacement for the old home_controller.dart
library;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/data/repositories/auth_repository.dart';
import 'package:vaultiq/data/repositories/budget_repository.dart';
import 'package:vaultiq/data/repositories/expense_repository.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';

class HomeControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORIES & SERVICES
  // ──────────────────────────────────────────────────────────
  final _authRepository = AuthRepository();
  final _budgetRepository = BudgetRepository();
  final _expenseRepository = ExpenseRepository();

  // ──────────────────────────────────────────────────────────
  // REACTIVE STATE
  // ──────────────────────────────────────────────────────────
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  RxDouble monthlyBudget = 0.0.obs;
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  RxDouble totalExpense = 0.0.obs;
  RxDouble remainingBudget = 0.0.obs;
  RxString userName = 'User'.obs;

  // ──────────────────────────────────────────────────────────
  // COMPUTED PROPERTIES
  // ──────────────────────────────────────────────────────────
  double get budgetProgress {
    if (monthlyBudget.value <= 0) return 0.0;
    return (totalExpense.value / monthlyBudget.value).clamp(0.0, 1.0);
  }

  double get percentageUsed {
    if (monthlyBudget.value <= 0) return 0.0;
    return (totalExpense.value / monthlyBudget.value) * 100;
  }

  final currencyFormatter = NumberFormat('#,##0');

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  // ──────────────────────────────────────────────────────────
  // MAIN DATA LOADING
  // ──────────────────────────────────────────────────────────

  /// Load all home screen data: budget, expenses, user name
  /// Orchestrates: User name → Budget → Expenses → Calculations
  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      logInfo('Loading home data...');

      // ─── Step 1: Get user name ───
      await _fetchUserName();

      // ─── Step 2: Get current month budget ───
      await _fetchBudget();

      // ─── Step 3: Get current month expenses ───
      await _fetchExpenses();

      // ─── Step 4: Calculate totals ───
      _calculateTotals();

      logInfo('Home data loaded successfully');
    } on AppException catch (e) {
      errorMessage.value = e.message;
      logError('Failed to load home data', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      final message = 'Unexpected error loading home data';
      errorMessage.value = message;
      logError(message, error: e, st: st);
      AppSnackbar.error(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ──────────────────────────────────────────────────────────
  // STEP 1: USER NAME
  // ──────────────────────────────────────────────────────────

  /// Fetch user name from auth metadata
  /// Sets: userName
  Future<void> _fetchUserName() async {
    try {
      final name = _authRepository.getUserName();
      userName.value = name;
      logDebug('User name: $name');
    } catch (e) {
      logWarn('Could not fetch user name');
      logDebug('Error: $e');
      userName.value = 'User'; // Fallback
    }
  }

  // ──────────────────────────────────────────────────────────
  // STEP 2: BUDGET
  // ──────────────────────────────────────────────────────────

  /// Fetch current month's budget (with auto-carry-forward logic)
  /// Sets: monthlyBudget
  /// Throws: DatabaseException, ServerException, NetworkException
  Future<void> _fetchBudget() async {
    try {
      final budget = await _budgetRepository.getCurrentMonthBudget();
      monthlyBudget.value = budget;
      logDebug('Budget fetched: ₹$budget');
    } catch (e, st) {
      logError('Failed to fetch budget', error: e, st: st);
      monthlyBudget.value = 0.0; // Fallback
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────
  // STEP 3: EXPENSES
  // ──────────────────────────────────────────────────────────

  /// Fetch all expenses (unfiltered, sorted by date)
  /// Sets: expenses
  /// Throws: DatabaseException, ServerException, NetworkException
  Future<void> _fetchExpenses() async {
    try {
      final allExpenses = await _expenseRepository.fetchAllExpenses();

      // Filter for current month
      final currentMonthKey = ExpenseRepository.getCurrentMonthString();
      final monthExpenses = allExpenses
          .where((e) => e.date.startsWith(currentMonthKey))
          .toList();

      expenses.assignAll(monthExpenses);
      logDebug('Expenses fetched: ${monthExpenses.length} items');
    } catch (e, st) {
      logError('Failed to fetch expenses', error: e, st: st);
      expenses.clear(); // Fallback
      rethrow;
    }
  }

  // ──────────────────────────────────────────────────────────
  // STEP 4: CALCULATIONS
  // ──────────────────────────────────────────────────────────

  /// Calculate totals: totalExpense, remainingBudget
  /// Uses: monthlyBudget, expenses
  void _calculateTotals() {
    try {
      // Calculate total spent this month
      totalExpense.value = _expenseRepository.calculateTotal(expenses.toList());

      // Calculate remaining budget
      remainingBudget.value = monthlyBudget.value - totalExpense.value;

      logDebug(
        'Calculations: Spent=₹${totalExpense.value}, '
        'Remaining=₹${remainingBudget.value}, Progress=${(percentageUsed).toStringAsFixed(1)}%',
      );
    } catch (e, st) {
      logError('Failed to calculate totals', error: e, st: st);
    }
  }

  // ──────────────────────────────────────────────────────────
  // REFRESH
  // ──────────────────────────────────────────────────────────

  /// Refresh all home data (used in pull-to-refresh)
  Future<void> refreshHomeData() async {
    await loadHomeData();
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY METHODS
  // ──────────────────────────────────────────────────────────

  /// Get recent transactions (first 3 for home display)
  List<ExpenseModel> getRecentTransactions({int limit = 3}) {
    return expenses.take(limit).toList();
  }

  /// Format currency amount for display
  String formatAmount(double amount) {
    return currencyFormatter.format(amount);
  }

  /// Get budget status message
  String getBudgetStatusMessage() {
    if (monthlyBudget.value <= 0) {
      return 'No budget set. Set one in Settings!';
    }

    if (percentageUsed <= 80) {
      return "You've used ${percentageUsed.toStringAsFixed(0)}% of your budget.";
    } else if (percentageUsed <= 100) {
      return "⚠️ You've used ${percentageUsed.toStringAsFixed(0)}% of your budget. Be careful!";
    } else {
      final overspent = (percentageUsed - 100).toStringAsFixed(0);
      return "❌ You've overspent by $overspent% of your budget!";
    }
  }
}

// ──────────────────────────────────────────────────────────
// CONVENIENCE LOGGING METHODS
// ──────────────────────────────────────────────────────────
void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

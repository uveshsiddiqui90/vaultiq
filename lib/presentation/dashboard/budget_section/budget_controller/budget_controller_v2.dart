/// BudgetController V2 — refactored with repository pattern & error handling
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/repositories/budget_repository.dart';
import 'package:vaultiq/data/repositories/expense_repository.dart';
import 'package:vaultiq/constant/widget_constant/app_bottom_nav/bottom_nav.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/presentation/dashboard/dashboard_section/dashboard_controller/dashboard_controller.dart';

class BudgetControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORIES
  // ──────────────────────────────────────────────────────────
  final _budgetRepository = BudgetRepository();
  final _expenseRepository = ExpenseRepository();

  // ──────────────────────────────────────────────────────────
  // REACTIVE STATE
  // ──────────────────────────────────────────────────────────
  RxBool isLoading = true.obs;
  TextEditingController budgetInputController = TextEditingController();

  RxDouble monthlyBudget = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;
  RxDouble remainingBudget = 0.0.obs;

  final currencyFormatter = NumberFormat('#,##0');

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

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadBudgetData();

    // Reload this tab's data whenever the user switches back to it.
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().registerTabRefresher(
        DashboardTabs.budget,
        loadBudgetData,
      );
    }
  }

  @override
  void onClose() {
    budgetInputController.dispose();
    super.onClose();
  }

  // ──────────────────────────────────────────────────────────
  // LOAD DATA
  // ──────────────────────────────────────────────────────────

  /// Load budget and expense data
  Future<void> loadBudgetData() async {
    try {
      isLoading.value = true;
      logInfo('Loading budget data...');

      // Fetch budget and expenses in parallel
      await Future.wait([
        _fetchBudget(),
        _fetchExpenses(),
      ]);

      // Calculate totals
      await _calculateTotals();

      logInfo('Budget data loaded successfully');
    } on AppException catch (e) {
      logError('Failed to load budget data', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error loading budget data', error: e, st: st);
      AppSnackbar.error(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch current month's budget
  Future<void> _fetchBudget() async {
    try {
      final budget = await _budgetRepository.getCurrentMonthBudget();
      monthlyBudget.value = budget;
      logDebug('Budget fetched: ₹$budget');
    } catch (e, st) {
      logError('Failed to fetch budget', error: e, st: st);
      monthlyBudget.value = 0.0;
      rethrow;
    }
  }

  /// Fetch current month's expenses
  Future<void> _fetchExpenses() async {
    try {
      final currentMonthKey = ExpenseRepository.getCurrentMonthString();
      final allExpenses = await _expenseRepository.fetchAllExpenses();

      final monthExpenses = allExpenses
          .where((e) => e.date.startsWith(currentMonthKey))
          .toList();

      totalExpense.value = _expenseRepository.calculateTotal(monthExpenses);
      logDebug('Expenses fetched: ₹${totalExpense.value}');
    } catch (e, st) {
      logError('Failed to fetch expenses', error: e, st: st);
      totalExpense.value = 0.0;
      rethrow;
    }
  }

  /// Calculate remaining budget
  Future<void> _calculateTotals() async {
    try {
      remainingBudget.value = monthlyBudget.value - totalExpense.value;
      logDebug('Remaining budget: ₹${remainingBudget.value}');
    } catch (e, st) {
      logError('Failed to calculate totals', error: e, st: st);
    }
  }

  // ──────────────────────────────────────────────────────────
  // UPDATE BUDGET
  // ──────────────────────────────────────────────────────────

  /// Update monthly budget with validation
  /// Validates amount, updates repository, refreshes UI
  Future<void> updateBudgetAmount() async {
    try {
      // ─── Validation ───
      final amountStr = budgetInputController.text.trim();
      if (amountStr.isEmpty) {
        AppSnackbar.warning(message: 'Please enter a budget amount');
        return;
      }

      final amount = double.parse(amountStr);
      ValidationService.validateBudgetAmount(amount);

      logInfo('Updating budget to ₹$amount');

      // ─── Update ───
      await _budgetRepository.setBudget(amount);

      // ─── Refresh UI ───
      monthlyBudget.value = amount;
      budgetInputController.clear();
      await _calculateTotals();

      AppSnackbar.success(message: 'Budget updated successfully!');
      logInfo('Budget updated and UI refreshed');
    } on ValidationException catch (e) {
      logWarn('Budget validation failed: ${e.message}');
      AppSnackbar.warning(message: e.message);
    } on AppException catch (e) {
      logError('Failed to update budget', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error updating budget', error: e, st: st);
      AppSnackbar.error(message: 'Something went wrong. Please try again.');
    }
  }

  /// Opens the shared "edit monthly budget" sheet.
  ///
  /// Any screen (for example the Home tab's "Budget Overview → Edit" action)
  /// can call this so the edit experience is identical to the Budget tab's
  /// "Edit Budget" button.
  void showEditBudgetSheet(BuildContext context) {
    AppBottomSheet.showAmountBottomSheet(
      context: context,
      controller: budgetInputController,
      onSave: () async {
        await updateBudgetAmount();
      },
    );
  }

  // ──────────────────────────────────────────────────────────
  // REFRESH
  // ──────────────────────────────────────────────────────────

  Future<void> refreshBudgetData() async {
    await loadBudgetData();
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY
  // ──────────────────────────────────────────────────────────

  String formatAmount(double amount) {
    return currencyFormatter.format(amount);
  }

  String getBudgetStatus() {
    if (monthlyBudget.value <= 0) return 'No budget set';
    if (percentageUsed <= 80) return 'On track';
    if (percentageUsed <= 100) return 'Getting close to limit';
    return 'Budget exceeded!';
  }
}

void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

/// Budget Repository — handle all monthly budget operations
/// Auto-carry-forward logic, validation, and error handling
library;

import 'package:intl/intl.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';

class BudgetRepository {
  final BudgetService _budgetService = BudgetService();

  /// Fetch current month's budget (or create default if month changed)
  /// Auto-carry-forward logic: if month changed, carries previous budget forward
  /// Returns: Monthly budget amount
  /// Throws: DatabaseException, ServerException, NetworkException
  Future<double> getCurrentMonthBudget() async {
    try {
      logInfo('Fetching current month budget');

      // ──────────────────────────────────────────────────────────
      // MONTH-END LOGIC: Check if month has changed
      // ──────────────────────────────────────────────────────────
      final currentMonthKey = _getMonthKey(DateTime.now());
      final lastBudgetMonth = await _getLastBudgetMonthKey();

      // If month changed, carry forward previous budget
      if (lastBudgetMonth != null && lastBudgetMonth != currentMonthKey) {
        logInfo('Month changed from $lastBudgetMonth to $currentMonthKey');
        logInfo('Auto-carrying forward budget to new month');

        final previousBudget = await _budgetService.fetchBudget();
        if (previousBudget != null) {
          // Set same budget for new month
          await _budgetService.saveBudget(monthlyBudget: previousBudget);
          logInfo('Budget carried forward: ₹$previousBudget');
          return previousBudget;
        }
      }

      // Fetch existing budget
      final budget = await _budgetService.fetchBudget() ?? 0.0;
      logInfo('Current month budget: ₹$budget');
      return budget;
    } catch (e, st) {
      logError('Failed to get current month budget', error: e, st: st);
      rethrow;
    }
  }

  /// Set/Update monthly budget with validation
  /// Throws: InvalidBudgetException, DatabaseException, ServerException, NetworkException
  Future<void> setBudget(double amount) async {
    try {
      // ──────────────────────────────────────────────────────────
      // VALIDATION
      // ──────────────────────────────────────────────────────────
      ValidationService.validateBudgetAmount(amount);

      logInfo('Setting monthly budget to ₹$amount');

      // ──────────────────────────────────────────────────────────
      // DATABASE OPERATION
      // ──────────────────────────────────────────────────────────
      await _budgetService.updateBudget(monthlyBudget: amount);

      logInfo('Budget updated successfully');
    } catch (e, st) {
      logError('Failed to set budget', error: e, st: st);
      rethrow;
    }
  }

  /// Calculate how much budget is remaining
  /// Formula: Budget - Total Spent
  /// Returns: Remaining amount (can be negative if overspent)
  Future<double> getRemainingBudget(
    List<ExpenseModel> currentMonthExpenses,
  ) async {
    try {
      final budget = await getCurrentMonthBudget();
      final spent = currentMonthExpenses.fold(
        0.0,
        (sum, expense) => sum + expense.amount,
      );

      final remaining = budget - spent;
      logInfo('Remaining budget: ₹$remaining (Budget: ₹$budget, Spent: ₹$spent)');

      return remaining;
    } catch (e, st) {
      logError('Failed to calculate remaining budget', error: e, st: st);
      rethrow;
    }
  }

  /// Calculate budget usage percentage (0.0 to 1.0+)
  /// 0.34 = 34% used
  /// 1.5 = 150% used (overspent)
  Future<double> getBudgetProgress(
    List<ExpenseModel> currentMonthExpenses,
  ) async {
    try {
      final budget = await getCurrentMonthBudget();
      if (budget <= 0) return 0.0;

      final spent = currentMonthExpenses.fold(
        0.0,
        (sum, expense) => sum + expense.amount,
      );

      final progress = spent / budget;
      logInfo('Budget progress: ${(progress * 100).toStringAsFixed(1)}%');

      return progress.clamp(0.0, double.infinity);
    } catch (e, st) {
      logError('Failed to calculate budget progress', error: e, st: st);
      rethrow;
    }
  }

  /// Check if budget alert should be shown (> 80% used)
  Future<bool> shouldShowBudgetAlert(
    List<ExpenseModel> currentMonthExpenses,
  ) async {
    try {
      final progress = await getBudgetProgress(currentMonthExpenses);
      return progress > 0.80; // 80% threshold
    } catch (e, st) {
      logError('Failed to check budget alert', error: e, st: st);
      return false;
    }
  }

  /// Get budget status message for user
  /// Example: "You've used 34% of your budget"
  Future<String> getBudgetStatusMessage(
    List<ExpenseModel> currentMonthExpenses,
  ) async {
    try {
      final budget = await getCurrentMonthBudget();
      final progress = await getBudgetProgress(currentMonthExpenses);
      final percentage = (progress * 100).toStringAsFixed(0);

      if (budget <= 0) {
        return 'No budget set for this month. Set one in Settings!';
      }

      if (progress <= 0.8) {
        return "You've used $percentage% of your budget.";
      } else if (progress <= 1.0) {
        return "⚠️ You've used $percentage% of your budget. Be careful!";
      } else {
        final overspent = ((progress - 1.0) * 100).toStringAsFixed(0);
        return "❌ You've overspent by $overspent% of your budget!";
      }
    } catch (e, st) {
      logError('Failed to get budget status message', error: e, st: st);
      return 'Error loading budget status';
    }
  }

  // ──────────────────────────────────────────────────────────
  // PRIVATE HELPER METHODS
  // ──────────────────────────────────────────────────────────

  /// Get month key in format "YYYY-MM" for tracking budget period
  String _getMonthKey(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  /// Get month key of last saved budget (dummy implementation)
  /// In a real app, would query database for timestamp of last budget
  Future<String?> _getLastBudgetMonthKey() async {
    try {
      // This would be stored in user preferences or metadata
      // For now, return null to check every time
      return null;
    } catch (e) {
      logWarn('Could not get last budget month key');
      return null;
    }
  }

  /// Reset budget for the month (admin use only)
  Future<void> resetBudgetForMonth() async {
    try {
      logWarn('Resetting budget for month');
      await _budgetService.deleteBudget();
      logInfo('Budget reset successfully');
    } catch (e, st) {
      logError('Failed to reset budget', error: e, st: st);
      rethrow;
    }
  }
}

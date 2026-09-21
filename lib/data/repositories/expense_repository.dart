/// Expense Repository — single source of truth for all expense operations
/// Wraps ExpenseService and handles error conversion, validation, logging

import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/services/expense_service/expense_service.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';

class ExpenseRepository {
  final ExpenseService _expenseService = ExpenseService();

  /// Add new expense with validation
  /// Throws: InvalidExpenseException, DatabaseException, ServerException, NetworkException
  Future<void> addExpense({
    required double amount,
    required String category,
    required String date,
    required String note,
  }) async {
    try {
      // ──────────────────────────────────────────────────────────
      // VALIDATION LAYER — prevent invalid data from reaching backend
      // ──────────────────────────────────────────────────────────
      ValidationService.validateExpense(
        amount: amount,
        category: category,
        date: date,
        note: note,
      );

      logInfo('Adding expense: ₹$amount in $category');

      // ──────────────────────────────────────────────────────────
      // DATABASE OPERATION
      // ──────────────────────────────────────────────────────────
      await _expenseService.addExpense(
        amount: amount,
        category: category,
        date: date,
        note: note,
      );

      logInfo('Expense added successfully');
    } catch (e, st) {
      // ──────────────────────────────────────────────────────────
      // ERROR CONVERSION & LOGGING
      // ──────────────────────────────────────────────────────────
      logError('Failed to add expense', error: e, st: st);
      rethrow;
    }
  }

  /// Fetch all expenses for current user
  /// Returns: List of ExpenseModel (most recent first)
  /// Throws: DatabaseException, ServerException, NetworkException
  Future<List<ExpenseModel>> fetchAllExpenses() async {
    try {
      logInfo('Fetching all expenses');

      final expenses = await _expenseService.fetchExpenses();

      logInfo('Fetched ${expenses.length} expenses');
      return expenses;
    } catch (e, st) {
      logError('Failed to fetch expenses', error: e, st: st);
      rethrow;
    }
  }

  /// Fetch expenses for specific month
  /// Returns: List of expenses from given month (year-month)
  /// Example: fetchExpensesForMonth('2024-05') returns all May 2024 expenses
  Future<List<ExpenseModel>> fetchExpensesForMonth(String yearMonth) async {
    try {
      logInfo('Fetching expenses for month: $yearMonth');

      final allExpenses = await fetchAllExpenses();

      // Filter by year-month (date format: YYYY-MM-DD)
      final monthExpenses = allExpenses
          .where((e) => e.date.startsWith(yearMonth))
          .toList();

      logInfo('Fetched ${monthExpenses.length} expenses for $yearMonth');
      return monthExpenses;
    } catch (e, st) {
      logError('Failed to fetch expenses for month $yearMonth', error: e, st: st);
      rethrow;
    }
  }

  /// Calculate total spent for given expenses
  double calculateTotal(List<ExpenseModel> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Calculate total spent in a category
  double calculateCategoryTotal(
    List<ExpenseModel> expenses,
    String category,
  ) {
    return expenses
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Group expenses by category with totals
  /// Returns: Map<category, total_amount>
  Map<String, double> groupByCategory(List<ExpenseModel> expenses) {
    final grouped = <String, double>{};
    for (final expense in expenses) {
      grouped[expense.category] =
          (grouped[expense.category] ?? 0.0) + expense.amount;
    }
    return grouped;
  }

  /// Get most recent expense
  ExpenseModel? getMostRecentExpense(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.first; // Already sorted by date descending from service
  }

  /// Get current month's year-month string (e.g., "2024-05")
  static String getCurrentMonthString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  /// Get previous month's year-month string
  static String getPreviousMonthString() {
    final now = DateTime.now();
    final prevMonth = DateTime(now.year, now.month - 1);
    return '${prevMonth.year}-${prevMonth.month.toString().padLeft(2, '0')}';
  }
}

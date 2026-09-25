/// TransactionsController V2 — full transaction history screen.
/// Same repository + error handling pattern as the other dashboard sections.
library;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/core/config/app_config.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/data/repositories/expense_repository.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';

/// Date ranges offered by the filter dropdown.
enum TransactionsFilter { thisMonth, lastMonth, allTime }

class TransactionsControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORY
  // ──────────────────────────────────────────────────────────
  final _expenseRepository = ExpenseRepository();

  // ──────────────────────────────────────────────────────────
  // REACTIVE STATE
  // ──────────────────────────────────────────────────────────
  RxBool isLoading = true.obs;
  RxList<ExpenseModel> allExpenses = <ExpenseModel>[].obs;
  Rx<TransactionsFilter> filter = TransactionsFilter.thisMonth.obs;

  final currencyFormatter = NumberFormat('#,##0');
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  // ──────────────────────────────────────────────────────────
  // FILTER
  // ──────────────────────────────────────────────────────────

  /// Label shown inside the header filter pill.
  String get filterLabel {
    switch (filter.value) {
      case TransactionsFilter.thisMonth:
        return TextConstant.thisMonth;
      case TransactionsFilter.lastMonth:
        return TextConstant.lastMonth;
      case TransactionsFilter.allTime:
        return TextConstant.allTime;
    }
  }

  void changeFilter(TransactionsFilter value) {
    filter.value = value;
  }

  // ──────────────────────────────────────────────────────────
  // LOAD DATA
  // ──────────────────────────────────────────────────────────

  /// Fetch every expense of the signed-in user.
  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;

      logInfo('Loading transactions...');

      final expenses = await _expenseRepository.fetchAllExpenses();
      allExpenses.assignAll(expenses);

      logInfo('Loaded ${expenses.length} transactions');
    } on AppException catch (e) {
      logError('Failed to load transactions', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error loading transactions', error: e, st: st);
      AppSnackbar.error(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Used by pull-to-refresh.
  Future<void> reloadData() => loadTransactions();

  // ──────────────────────────────────────────────────────────
  // FILTERED LIST
  // ──────────────────────────────────────────────────────────
  DateTime? _parseDate(String value) => DateTime.tryParse(value);

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  List<ExpenseModel> _expensesInMonth(DateTime month) {
    return allExpenses.where((e) {
      final date = _parseDate(e.date);
      return date != null && _isSameMonth(date, month);
    }).toList();
  }

  /// Expenses matching the selected [filter].
  List<ExpenseModel> get filteredExpenses {
    final now = DateTime.now();

    switch (filter.value) {
      case TransactionsFilter.thisMonth:
        return _expensesInMonth(now);
      case TransactionsFilter.lastMonth:
        return _expensesInMonth(DateTime(now.year, now.month - 1));
      case TransactionsFilter.allTime:
        return allExpenses;
    }
  }

  /// Total of the currently visible transactions.
  double get filteredTotal =>
      filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

  // ──────────────────────────────────────────────────────────
  // DISPLAY HELPERS
  // ──────────────────────────────────────────────────────────

  /// `2025-09-28` → `28 Sep 2025` (raw value when unparsable).
  String formatDate(String raw) {
    final parsed = _parseDate(raw);
    if (parsed == null) return raw;
    return _dateFormat.format(parsed);
  }

  /// Row title — the user's note when present, otherwise the category.
  String titleFor(ExpenseModel expense) {
    final note = expense.note.trim();
    return note.isEmpty ? expense.category : note;
  }

  /// Formatted amount, e.g. `- ₹850`.
  String amountFor(ExpenseModel expense) =>
      '- ${AppConfig.currencySymbol}${currencyFormatter.format(expense.amount)}';
}

/// AddExpenseController V2 — refactored with validation & error handling

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/repositories/expense_repository.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';

class AddExpenseControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORIES
  // ──────────────────────────────────────────────────────────
  final _expenseRepository = ExpenseRepository();

  // ──────────────────────────────────────────────────────────
  // FORM CONTROLLERS
  // ──────────────────────────────────────────────────────────
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  // ──────────────────────────────────────────────────────────
  // REACTIVE STATE
  // ──────────────────────────────────────────────────────────
  RxString selectedCategory = 'Groceries'.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxBool isSubmitting = false.obs;

  // ──────────────────────────────────────────────────────────
  // CATEGORIES
  // ──────────────────────────────────────────────────────────
  static const List<String> categories = [
    'Groceries',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Health',
  ];

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    dateController.dispose();
    super.onClose();
  }

  // ──────────────────────────────────────────────────────────
  // DATE HANDLING
  // ──────────────────────────────────────────────────────────

  /// Set selected date
  void setDate(DateTime date) {
    selectedDate.value = date;
    dateController.text = date.toIso8601String();
    logDebug('Date set to: ${selectedDate.value}');
  }

  /// Get formatted date string for display
  String getFormattedDate() {
    final date = selectedDate.value;
    return '${date.day}/${date.month}/${date.year}';
  }

  // ──────────────────────────────────────────────────────────
  // CATEGORY HANDLING
  // ──────────────────────────────────────────────────────────

  /// Change selected category
  void setCategory(String category) {
    if (categories.contains(category)) {
      selectedCategory.value = category;
      logDebug('Category changed to: $category');
    }
  }

  // ──────────────────────────────────────────────────────────
  // FORM SUBMISSION
  // ──────────────────────────────────────────────────────────

  /// Add expense with full validation & error handling
  /// Validates all fields before submitting to repository
  Future<void> addExpense() async {
    try {
      // ─── Set loading state ───
      isSubmitting.value = true;
      logInfo('Adding expense...');

      // ─── Extract values ───
      final amountStr = amountController.text.trim();
      final category = selectedCategory.value;
      final date = dateController.text.trim();
      final note = noteController.text.trim();

      // ─── Validate all fields ───
      _validateAllFields(amountStr, category, date, note);
      final amount = double.parse(amountStr);

      // ─── Submit to repository ───
      await _expenseRepository.addExpense(
        amount: amount,
        category: category,
        date: date,
        note: note,
      );

      // ─── Clear form ───
      _clearForm();

      logInfo('Expense added successfully');
      AppSnackbar.success(message: 'Expense added successfully!');

      // ─── Navigate back ───
      Get.back();
    } on ValidationException catch (e) {
      logWarn('Validation error: ${e.message}');
      AppSnackbar.warning(message: e.message);
    } on InvalidExpenseException catch (e) {
      logWarn('Invalid expense: ${e.message}');
      AppSnackbar.error(message: e.message);
    } on AppException catch (e) {
      logError('Failed to add expense', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error adding expense', error: e, st: st);
      AppSnackbar.error(message: 'Something went wrong. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  // ──────────────────────────────────────────────────────────
  // VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Validate all form fields together
  /// Throws: ValidationException or InvalidExpenseException
  void _validateAllFields(String amount, String category, String date, String note) {
    // Check each field individually
    if (amount.isEmpty) {
      throw ValidationException(message: 'Please enter an amount');
    }

    final amountValue = double.tryParse(amount);
    if (amountValue == null) {
      throw ValidationException(message: 'Please enter a valid amount');
    }

    // Use ValidationService for standard validations
    ValidationService.validateExpense(
      amount: amountValue,
      category: category,
      date: date,
      note: note,
    );

    logDebug('Form validation passed');
  }

  // ──────────────────────────────────────────────────────────
  // FORM MANAGEMENT
  // ──────────────────────────────────────────────────────────

  /// Clear form after successful submission
  void _clearForm() {
    amountController.clear();
    noteController.clear();
    selectedCategory.value = 'Groceries';
    selectedDate.value = DateTime.now();
    dateController.clear();
    logDebug('Form cleared');
  }

  /// Reset form to initial state
  void resetForm() {
    _clearForm();
    isSubmitting.value = false;
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY
  // ──────────────────────────────────────────────────────────

  /// Check if form is valid (for UI button state)
  bool get isFormValid {
    return amountController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        selectedCategory.value.isNotEmpty;
  }

  /// Get category icon emoji
  static String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return '🛒';
      case 'food':
        return '🍔';
      case 'transport':
        return '🚌';
      case 'shopping':
        return '🛍️';
      case 'bills':
        return '⚡';
      case 'health':
        return '🏥';
      default:
        return '💰';
    }
  }
}

void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

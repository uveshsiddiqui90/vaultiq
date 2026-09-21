/// Validation service — all input validation rules in one place
/// Prevents invalid data from reaching Supabase
library;

import 'package:vaultiq/core/config/app_config.dart';
import 'package:vaultiq/core/errors/app_exception.dart';

class ValidationService {
  ValidationService._();

  // ──────────────────────────────────────────────────────────
  // EMAIL VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Validate email format
  static void validateEmail(String email) {
    email = email.trim();
    if (email.isEmpty) {
      throw ValidationException(message: 'Email cannot be empty.');
    }

    // Simple regex for email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      throw ValidationException(message: 'Please enter a valid email address.');
    }
  }

  // ──────────────────────────────────────────────────────────
  // PASSWORD VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Validate password (at least 6 characters)
  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw ValidationException(message: 'Password cannot be empty.');
    }
    if (password.length < 6) {
      throw ValidationException(message: 'Password must be at least 6 characters long.');
    }
  }

  /// Validate password confirmation
  static void validatePasswordConfirmation(String password, String confirmation) {
    validatePassword(password);
    if (password != confirmation) {
      throw ValidationException(message: 'Passwords do not match.');
    }
  }

  // ──────────────────────────────────────────────────────────
  // NAME VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Validate user name (non-empty, 2-100 chars)
  static void validateName(String name) {
    name = name.trim();
    if (name.isEmpty) {
      throw ValidationException(message: 'Name cannot be empty.');
    }
    if (name.length < 2) {
      throw ValidationException(message: 'Name must be at least 2 characters.');
    }
    if (name.length > 100) {
      throw ValidationException(message: 'Name must be less than 100 characters.');
    }
  }

  // ──────────────────────────────────────────────────────────
  // BUDGET VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Validate monthly budget amount
  static void validateBudgetAmount(double amount) {
    if (amount < AppConfig.minBudgetAmount) {
      throw InvalidBudgetException(
        message: 'Budget must be at least ₹${AppConfig.minBudgetAmount.toStringAsFixed(0)}.',
      );
    }
    if (amount > AppConfig.maxBudgetAmount) {
      throw InvalidBudgetException(
        message: 'Budget cannot exceed ₹${AppConfig.maxBudgetAmount.toStringAsFixed(0)}.',
      );
    }
  }

  // ──────────────────────────────────────────────────────────
  // EXPENSE VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Validate expense amount
  static void validateExpenseAmount(double amount) {
    if (amount <= 0) {
      throw InvalidExpenseException(
        message: 'Expense amount must be greater than 0.',
      );
    }
    if (amount < AppConfig.minExpenseAmount) {
      throw InvalidExpenseException(
        message: 'Expense must be at least ₹${AppConfig.minExpenseAmount.toStringAsFixed(2)}.',
      );
    }
    if (amount > AppConfig.maxExpenseAmount) {
      throw InvalidExpenseException(
        message: 'Expense cannot exceed ₹${AppConfig.maxExpenseAmount.toStringAsFixed(2)}.',
      );
    }
  }

  /// Validate expense category
  static void validateCategory(String category) {
    category = category.trim();
    if (category.isEmpty) {
      throw InvalidExpenseException(message: 'Please select a category.');
    }

    final validCategories = [
      'Groceries',
      'Food',
      'Transport',
      'Shopping',
      'Bills',
      'Health',
    ];

    if (!validCategories.contains(category)) {
      throw InvalidExpenseException(message: 'Invalid category selected.');
    }
  }

  /// Validate expense date (must be today or in the past)
  static void validateExpenseDate(String dateString) {
    if (dateString.trim().isEmpty) {
      throw InvalidExpenseException(message: 'Please select a date.');
    }

    final DateTime expenseDate;
    try {
      expenseDate = DateTime.parse(dateString);
    } catch (e) {
      throw InvalidExpenseException(message: 'Invalid date format.');
    }

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    // Expense date should be today or in the past, not future
    if (expenseDate.isAfter(todayOnly)) {
      throw InvalidExpenseException(
        message: 'Expense date cannot be in the future.',
      );
    }
  }

  /// Validate expense note
  static void validateNote(String? note) {
    if (note != null && note.length > AppConfig.maxNoteLength) {
      throw InvalidExpenseException(
        message: 'Note cannot exceed ${AppConfig.maxNoteLength} characters.',
      );
    }
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY VALIDATION
  // ──────────────────────────────────────────────────────────

  /// Check if string is null or empty
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Check if number is valid and positive
  static bool isValidAmount(double? value) {
    return value != null && value > 0;
  }

  /// Validate all expense fields together
  static void validateExpense({
    required double amount,
    required String category,
    required String date,
    required String note,
  }) {
    validateExpenseAmount(amount);
    validateCategory(category);
    validateExpenseDate(date);
    validateNote(note);
  }
}

/// ProfileController V2 — refactored with repositories & error handling
library;

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/data/repositories/auth_repository.dart';
import 'package:vaultiq/data/repositories/budget_repository.dart';
import 'package:vaultiq/data/repositories/expense_repository.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';

class ProfileControllerV2 extends GetxController {
  // ──────────────────────────────────────────────────────────
  // REPOSITORIES
  // ──────────────────────────────────────────────────────────
  final _authRepository = AuthRepository();
  final _budgetRepository = BudgetRepository();
  final _expenseRepository = ExpenseRepository();

  // ──────────────────────────────────────────────────────────
  // REACTIVE STATE
  // ──────────────────────────────────────────────────────────
  RxBool isLoading = true.obs;
  RxString userName = 'User'.obs;
  RxString userEmail = ''.obs;
  RxInt totalTransactions = 0.obs;
  RxDouble totalExpenseAmount = 0.0.obs;
  RxDouble totalSavedAmount = 0.0.obs;
  RxString profileImageUrl = ''.obs;

  final currencyFormatter = NumberFormat('#,##0');

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  // ──────────────────────────────────────────────────────────
  // LOAD DATA
  // ──────────────────────────────────────────────────────────

  /// Load all profile data: user info, stats, transactions
  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;
      logInfo('Loading profile data...');

      // Get user info from auth
      await _loadUserInfo();

      // Get transactions count & amounts
      await _loadStatistics();

      logInfo('Profile data loaded successfully');
    } on AppException catch (e) {
      logError('Failed to load profile', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error loading profile', error: e, st: st);
      AppSnackbar.error(message: 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user name and email from auth
  Future<void> _loadUserInfo() async {
    try {
      userName.value = _authRepository.getUserName();
      userEmail.value = _authRepository.getUserEmail();
      logDebug('User info loaded: $userName / $userEmail');
    } catch (e, st) {
      logError('Failed to load user info', error: e, st: st);
    }
  }

  /// Load transaction statistics (current month only)
  Future<void> _loadStatistics() async {
    try {
      final allExpenses = await _expenseRepository.fetchAllExpenses();
      final monthlyBudget = await _budgetRepository.getCurrentMonthBudget();

      // Filter by current month
      final currentMonthKey = ExpenseRepository.getCurrentMonthString();
      final currentMonthExpenses = allExpenses
          .where((e) => e.date.startsWith(currentMonthKey))
          .toList();

      // Count current month transactions only
      totalTransactions.value = currentMonthExpenses.length;

      // Calculate current month spent only
      totalExpenseAmount.value = _expenseRepository.calculateTotal(currentMonthExpenses);

      // Calculate current month saved
      final currentMonthSpent = totalExpenseAmount.value;
      totalSavedAmount.value = monthlyBudget - currentMonthSpent;

      logDebug(
        'Stats loaded: Transactions=$totalTransactions, '
        'Spent=₹$totalExpenseAmount, Saved=₹$totalSavedAmount',
      );
    } catch (e, st) {
      logError('Failed to load statistics', error: e, st: st);
    }
  }

  // ──────────────────────────────────────────────────────────
  // LOGOUT
  // ──────────────────────────────────────────────────────────

  /// Logout user and return to login screen
  Future<void> logout() async {
    try {
      logInfo('Logging out...');
      await _authRepository.logout();
      logInfo('Logout successful');

      // Navigate to login
      Get.offAllNamed(AppRoutes.LOGIN);
      AppSnackbar.success(message: 'Logged out successfully');
    } on AppException catch (e) {
      logError('Logout failed', error: e);
      AppSnackbar.error(message: e.message);
    } catch (e, st) {
      logError('Unexpected error during logout', error: e, st: st);
      AppSnackbar.error(message: 'Logout failed. Please try again.');
    }
  }

  // ──────────────────────────────────────────────────────────
  // REFRESH
  // ──────────────────────────────────────────────────────────

  Future<void> refreshProfile() async {
    await loadProfileData();
  }

  // ──────────────────────────────────────────────────────────
  // UTILITY
  // ──────────────────────────────────────────────────────────

  String formatAmount(double amount) {
    return currencyFormatter.format(amount);
  }

  bool get isLoggedIn => _authRepository.isLoggedIn();

  User? get currentUser => _authRepository.getCurrentUser();
}

void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

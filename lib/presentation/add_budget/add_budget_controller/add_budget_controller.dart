import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/constant/text_constant.dart';
import 'package:vaultiq/constant/widget_constant/app_snackbar.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';

/// "Set Your Monthly Budget" — the third and final onboarding step.
///
/// It runs right after the profile photo, and whatever the user types here is
/// what the dashboard (Home + Budget tab) shows from then on.
///
/// [BudgetService.saveBudget] only ever inserts, so an existing row — the user
/// re-ran onboarding, or already set a budget from the Budget tab — is updated
/// instead of duplicated.
class AddBudgetController extends GetxController {
  final TextEditingController budgetController = TextEditingController();
  final FocusNode budgetFocusNode = FocusNode();

  final BudgetService _budgetService = BudgetService();

  /// Quick-pick amounts offered as chips under the input.
  static const List<double> quickAmounts = [10000, 20000, 30000, 50000];

  /// `true` while the budget is being written to Supabase — drives the spinner
  /// inside "Save Budget" and blocks a second tap.
  final RxBool isLoading = false.obs;

  /// Mirrors [budgetController]'s text so the clear (✕) button, the active
  /// border and the selected quick chip stay in sync while the user types.
  final RxString amountText = ''.obs;

  // ──────────────────────────────────────────────────────────
  // LIFECYCLE
  // ──────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    budgetController.addListener(_onAmountChanged);
  }

  @override
  void onClose() {
    budgetController.removeListener(_onAmountChanged);
    budgetController.dispose();
    budgetFocusNode.dispose();
    super.onClose();
  }

  void _onAmountChanged() {
    amountText.value = budgetController.text;
  }

  // ──────────────────────────────────────────────────────────
  // INPUT HELPERS
  // ──────────────────────────────────────────────────────────

  /// Pre-fills the field when a quick-amount chip is tapped, leaving the caret
  /// at the end so the user can keep typing.
  void selectQuickAmount(double amount) {
    final text = amount.toStringAsFixed(0);

    budgetController.text = text;
    budgetController.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    amountText.value = text;
  }

  /// Clears the field from the ✕ button inside the input.
  void clearAmount() {
    budgetController.clear();
    amountText.value = '';
  }

  bool isQuickAmountSelected(double amount) =>
      budgetController.text.trim() == amount.toStringAsFixed(0);

  // ──────────────────────────────────────────────────────────
  // SAVE
  // ──────────────────────────────────────────────────────────

  /// Persists the typed amount as the monthly budget and moves on to the
  /// dashboard. Returns `true` when onboarding can continue.
  Future<bool> saveBudget() async {
    if (isLoading.value) return false;

    final raw = budgetController.text.trim();

    if (raw.isEmpty) {
      AppSnackbar.warning(message: TextConstant.budgetEmptyError);
      return false;
    }

    final double? amount = double.tryParse(raw);

    if (amount == null) {
      AppSnackbar.warning(message: TextConstant.budgetInvalidError);
      return false;
    }

    try {
      // Same rules the Budget tab enforces (min ₹100 / max ₹1,00,00,000).
      ValidationService.validateBudgetAmount(amount);
    } on AppException catch (e) {
      AppSnackbar.warning(message: e.message);
      return false;
    }

    try {
      isLoading.value = true;

      await _persistBudget(amount);

      LoggerService.info('Onboarding budget saved: ₹$amount');
      AppSnackbar.success(message: TextConstant.budgetSaved);

      // `offAllNamed` clears the whole onboarding stack, so the back button can
      // never drop the user into the signup / photo steps again. The dashboard
      // is built fresh from here, which is why it picks up the budget through
      // its own `onInit` and needs no manual syncing.
      Get.offAllNamed(AppRoutes.DASHBOARD);

      return true;
    } on AppException catch (e) {
      LoggerService.error('Failed to save the onboarding budget', error: e);
      AppSnackbar.error(message: e.message);
      return false;
    } catch (e, st) {
      LoggerService.error(
        'Unexpected error saving the onboarding budget',
        error: e,
        stackTrace: st,
      );
      AppSnackbar.error(message: TextConstant.budgetSaveFailed);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Inserts the first row, updates it on every later run.
  Future<void> _persistBudget(double amount) async {
    final existing = await _budgetService.fetchBudget();

    if (existing == null) {
      await _budgetService.saveBudget(monthlyBudget: amount);
    } else {
      await _budgetService.updateBudget(monthlyBudget: amount);
    }
  }
}

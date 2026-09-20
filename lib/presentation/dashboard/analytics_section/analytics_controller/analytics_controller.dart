import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';
import 'package:vaultiq/data/services/expense_service/expense_service.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';

enum AnalyticsFilter { thisMonth, lastMonth, allTime }

class CategorySpend {
  final String category;
  final double amount;
  final double percentage;

  CategorySpend({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

class AnalyticsController extends GetxController {
  final BudgetService _budgetService = BudgetService();
  final ExpenseService _expenseService = ExpenseService();

  final currencyFormatter = NumberFormat('#,##0');

  RxBool isLoading = true.obs;
  RxList<ExpenseModel> allExpenses = <ExpenseModel>[].obs;
  RxDouble monthlyBudget = 0.0.obs;
  Rx<AnalyticsFilter> filter = AnalyticsFilter.thisMonth.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnalyticsData();
  }

  String get filterLabel {
    switch (filter.value) {
      case AnalyticsFilter.thisMonth:
        return "This Month";
      case AnalyticsFilter.lastMonth:
        return "Last Month";
      case AnalyticsFilter.allTime:
        return "All Time";
    }
  }

  void changeFilter(AnalyticsFilter value) {
    filter.value = value;
  }

  Future<void> fetchExpenses() async {
    try {
      final data = await _expenseService.fetchExpenses();
      allExpenses.assignAll(data);
    } catch (e) {
      print("Error fetching expenses: $e");
    }
  }

  Future<void> fetchBudget() async {
    try {
      final budget = await _budgetService.fetchBudget();
      monthlyBudget.value = budget ?? 0.0;
    } catch (e) {
      print("Error fetching budget: $e");
    }
  }

  Future<void> loadAnalyticsData() async {
    try {
      isLoading.value = true;
      await Future.wait([fetchExpenses(), fetchBudget()]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reloadData() => loadAnalyticsData();

  DateTime? _parseDate(String value) => DateTime.tryParse(value);

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  List<ExpenseModel> _expensesForMonth(DateTime month) {
    return allExpenses.where((e) {
      final d = _parseDate(e.date);
      return d != null && _isSameMonth(d, month);
    }).toList();
  }

  List<ExpenseModel> get filteredExpenses {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);

    switch (filter.value) {
      case AnalyticsFilter.thisMonth:
        return _expensesForMonth(now);
      case AnalyticsFilter.lastMonth:
        return _expensesForMonth(lastMonth);
      case AnalyticsFilter.allTime:
        return allExpenses;
    }
  }

  double get totalExpense =>
      filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

  double get currentMonthTotal =>
      _expensesForMonth(DateTime.now()).fold(0.0, (sum, e) => sum + e.amount);

  double get lastMonthTotal {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    return _expensesForMonth(lastMonth).fold(0.0, (sum, e) => sum + e.amount);
  }

  bool get showMonthComparison =>
      filter.value == AnalyticsFilter.thisMonth && lastMonthTotal > 0;

  double get monthOverMonthChange {
    if (lastMonthTotal <= 0) return 0.0;
    return ((currentMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
  }

  List<CategorySpend> get categoryBreakdown {
    final expenses = filteredExpenses;
    if (expenses.isEmpty) return [];

    final Map<String, double> totals = {};
    for (final e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }

    final total = totals.values.fold(0.0, (a, b) => a + b);

    final list = totals.entries
        .map(
          (entry) => CategorySpend(
            category: entry.key,
            amount: entry.value,
            percentage: total <= 0 ? 0 : (entry.value / total) * 100,
          ),
        )
        .toList();

    list.sort((a, b) => b.amount.compareTo(a.amount));
    return list;
  }

  List<CategorySpend> get chartCategories {
    final all = categoryBreakdown;
    if (all.length <= 4) return all;

    final top = all.take(4).toList();
    final total = all.fold(0.0, (a, b) => a + b.amount);
    final othersAmount = all.skip(4).fold(0.0, (a, b) => a + b.amount);

    top.add(
      CategorySpend(
        category: "Others",
        amount: othersAmount,
        percentage: total <= 0 ? 0 : (othersAmount / total) * 100,
      ),
    );
    return top;
  }

  CategorySpend? get topCategory =>
      categoryBreakdown.isEmpty ? null : categoryBreakdown.first;

  double get budgetProgress {
    if (monthlyBudget.value <= 0) return 0.0;
    return (currentMonthTotal / monthlyBudget.value).clamp(0.0, 1.0);
  }

  double get percentageUsed {
    if (monthlyBudget.value <= 0) return 0.0;
    return (currentMonthTotal / monthlyBudget.value) * 100;
  }

  double get remainingBudget => monthlyBudget.value - currentMonthTotal;

  bool get isWithinBudget =>
      monthlyBudget.value <= 0 || currentMonthTotal <= monthlyBudget.value;
}

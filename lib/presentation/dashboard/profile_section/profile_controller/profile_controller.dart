import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/app_routes/app_routes.dart';
import 'package:vaultiq/data/services/budget_service/budget_service.dart';
import 'package:vaultiq/data/services/expense_service/expense_service.dart';
import 'package:vaultiq/data/services/profile_image_service/profile_image_service.dart';
import 'package:vaultiq/data/services/profile_service/profile_service.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';

class ProfileController extends GetxController {
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  final ExpenseService _expenseService = ExpenseService();
  RxDouble remainingBudget = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;
  final BudgetService _budgetService = BudgetService();
  RxDouble monthlyBudget = 0.0.obs;
  RxInt totalTransaction = 0.obs;
  RxString userName = "User".obs;
  RxString userEmail = "".obs;
  RxBool isLoading = false.obs;
  final ProfileImageService _profileService = ProfileImageService();
  final profileImageUrl = ''.obs;

 @override
  void onInit() async {
    loadHomeData();
    fetchProfileImage();
    super.onInit();
  }

  Future<void> fetchTotalExpense() async {
    try {
      final expenses = await _expenseService.fetchExpenses();
      totalTransaction.value = expenses.length;

      double total = 0;

      for (var expense in expenses) {
        total += expense.amount;
      }

      totalExpense.value = total;

      calculateRemainingBudget();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBudget() async {
    try {
      final budget = await _budgetService.fetchBudget();
      monthlyBudget.value = budget?.toDouble() ?? 0.0;
    } catch (e) {
      print("Error fetching budget: $e");
    }
  }

  void calculateRemainingBudget() {
    remainingBudget.value = monthlyBudget.value - totalExpense.value;
  }

   Future<void> getUserNameEmail() async
    {
    final user = Supabase.instance.client.auth.currentUser;
    userName.value = user?.userMetadata?['name'] ?? 'User';
    userEmail.value = user?.email ?? '';
  }

  void loadHomeData() async {
    isLoading.value = true;
    await getUserNameEmail();
    await fetchBudget();
    await fetchTotalExpense();
    isLoading.value = false;
  }

  Future<void> logout() async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.auth.signOut();
      Get.toNamed(AppRoutes.LOGIN);
      
    } catch (e) {
      print("❌ Logout Error: $e");
    }
  }

   void fetchProfileImage() {
    final imageUrl = _profileService.getProfileImageUrl();

    if (imageUrl != null) {
      profileImageUrl.value = imageUrl;
    }
  }
}

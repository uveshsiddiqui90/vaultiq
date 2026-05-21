import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetService {

  final SupabaseClient supabase = Supabase.instance.client;

  // =========================
  // SAVE BUDGET
  // =========================

  Future<void> saveBudget({
    required double monthlyBudget,
  }) async {

    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await supabase.from('budgets').insert({

      'user_id': user.id,
      'monthly_budget': monthlyBudget,

    });
  }

  // =========================
  // FETCH LATEST BUDGET
  // =========================

  Future<double?> fetchBudget() async {

    final user = supabase.auth.currentUser;

    if (user == null) return null;

    final response = await supabase
        .from('budgets')
        .select('monthly_budget')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return (response['monthly_budget'] as num).toDouble();
  }

  // =========================
  // UPDATE BUDGET
  // =========================

  Future<void> updateBudget({
    required double monthlyBudget,
  }) async {

    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await supabase
        .from('budgets')
        .update({

          'monthly_budget': monthlyBudget,

        })
        .eq('user_id', user.id);
  }

  // =========================
  // DELETE BUDGET
  // =========================

  Future<void> deleteBudget() async {

    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await supabase
        .from('budgets')
        .delete()
        .eq('user_id', user.id);
  }
}
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/presentation/dashboard/addexpense_section/addexpense_model/addexpense_model.dart';

class ExpenseService {

  final supabase = Supabase.instance.client;

  Future<void> addExpense({

    required double amount,
    required String category,
    required String date,
    required String note,

  }) async {

    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await supabase.from('expenses').insert({

      'user_id': user.id,

      'amount': amount,

      'category': category,

      'date': date,

      'note': note,

    });
  }


  Future<List<ExpenseModel>> fetchExpenses() async {

  final user = supabase.auth.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final response = await supabase

      .from('expenses')

      .select()

      .eq('user_id', user.id)

      .order('created_at', ascending: false);

  return response.map<ExpenseModel>(
        (json) => ExpenseModel.fromJson(json),
      ).toList();
}
}
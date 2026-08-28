import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> changePassword({
    required String newPassword,
  }) async {
    await _supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }
}
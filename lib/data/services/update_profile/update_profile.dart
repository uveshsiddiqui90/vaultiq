import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProfile {

static Future<void> updateProfile({
  required String name,
}) async {
  final supabase = Supabase.instance.client;

  await supabase.auth.updateUser(
    UserAttributes(
      data: {
        'name': name,
      },
    ),
  );
}

}
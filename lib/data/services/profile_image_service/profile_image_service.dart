import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImageService {
  
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadProfileImage(File image) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final extension = image.path.split('.').last.toLowerCase();

    final filePath = '${user.id}/profile.$extension';

    await _supabase.storage
        .from('avatars')
        .upload(
          filePath,
          image,
          fileOptions: FileOptions(
            upsert: true,
          ),
        );

    final imageUrl = _supabase.storage
        .from('avatars')
        .getPublicUrl(filePath);

    return imageUrl;
  }
}
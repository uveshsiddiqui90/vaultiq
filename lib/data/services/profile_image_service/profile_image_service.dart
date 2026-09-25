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
        .upload(filePath, image, fileOptions: FileOptions(upsert: true));

    final publicUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);

    // Every upload lands on the same storage path, so the URL would never change
    // and every screen (plus Flutter's image cache) would keep showing the
    // previous picture. The version suffix makes each upload a brand-new URL.
    final version = DateTime.now().millisecondsSinceEpoch;

    return '$publicUrl?v=$version';
  }

  /// Delete every avatar stored for the signed-in user.
  ///
  /// The upload keeps the original file extension (`profile.png`,
  /// `profile.jpeg`, …), so all known variants are removed instead of guessing
  /// which one happened to be used.
  Future<void> deleteProfileImage() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    const extensions = ['jpg', 'jpeg', 'png', 'webp', 'heic'];

    await _supabase.storage.from('avatars').remove([
      for (final ext in extensions) '${user.id}/profile.$ext',
    ]);
  }
}

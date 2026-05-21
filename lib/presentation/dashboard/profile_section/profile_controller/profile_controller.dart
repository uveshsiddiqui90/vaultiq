import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/app_routes/app_routes.dart';

class ProfileController extends GetxController {
  
  Future<void> logout() async {
  final supabase = Supabase.instance.client;

  try {
    await supabase.auth.signOut();
    Get.toNamed(AppRoutes.LOGIN);
    print("👋 Logged out successfully");
  } catch (e) {
    print("❌ Logout Error: $e");
  }
  }
  }
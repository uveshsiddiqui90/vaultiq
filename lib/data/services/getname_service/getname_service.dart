import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetnameService {
   RxString userName = "User".obs;
   
   
   Future<void> getUserName() async {

    final user = Supabase.instance.client.auth.currentUser;
    userName.value = user?.userMetadata?['name'] ?? 'User';
  }
}
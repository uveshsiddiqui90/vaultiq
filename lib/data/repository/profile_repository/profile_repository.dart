import 'package:vaultiq/data/services/profile_service/profile_service.dart';


class ProfileRepository {
  final ProfileService _service = ProfileService();

  Future<void> changePassword({
    required String newPassword,
  }) async {
    await _service.changePassword(
      newPassword: newPassword,
    );
  }
}
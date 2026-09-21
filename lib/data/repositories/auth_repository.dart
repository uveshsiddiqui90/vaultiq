/// Authentication Repository — single source for all auth operations
/// Login, signup, password reset, session management
library;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaultiq/core/errors/app_exception.dart';
import 'package:vaultiq/core/services/logger_service.dart';
import 'package:vaultiq/core/services/validation_service.dart';
import 'package:vaultiq/data/services/auth_service/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  /// Login user with email and password
  /// Throws: InvalidCredentialsException, NetworkException, ServerException
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      // ──────────────────────────────────────────────────────────
      // VALIDATION
      // ──────────────────────────────────────────────────────────
      ValidationService.validateEmail(email);
      ValidationService.validatePassword(password);

      logInfo('Attempting login for: $email');

      // ──────────────────────────────────────────────────────────
      // AUTH OPERATION
      // ──────────────────────────────────────────────────────────
      final authResponse = await _authService.login(
        email.trim(),
        password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw ServerException(message: 'Login failed. Please try again.');
      }

      logInfo('Login successful for user: ${user.id}');
      return user;
    } on AuthException catch (e, st) {
      logError('Login failed', error: e, st: st);
      throw InvalidCredentialsException(
        originalException: e,
        stackTrace: st,
      );
    } catch (e, st) {
      logError('Unexpected error during login', error: e, st: st);
      rethrow;
    }
  }

  /// Sign up new user with email, password, and name
  /// Throws: EmailAlreadyExistsException, ValidationException, ServerException, NetworkException
  Future<User> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // ──────────────────────────────────────────────────────────
      // VALIDATION
      // ──────────────────────────────────────────────────────────
      ValidationService.validateEmail(email);
      ValidationService.validatePassword(password);
      ValidationService.validateName(name);

      logInfo('Attempting signup for: $email');

      // ──────────────────────────────────────────────────────────
      // AUTH OPERATION
      // ──────────────────────────────────────────────────────────
      final user = await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'name': name.trim()},
      );

      if (user.user == null) {
        throw ServerException(
          message: 'Signup failed. Please try again.',
        );
      }

      logInfo('Signup successful for user: ${user.user?.id}');
      return user.user!;
    } on AuthException catch (e, st) {
      logError('Signup failed', error: e, st: st);

      if (e.message.contains('already exists')) {
        throw EmailAlreadyExistsException(
          originalException: e,
          stackTrace: st,
        );
      }

      throw ServerException(
        message: e.message,
        originalException: e,
        stackTrace: st,
      );
    } catch (e, st) {
      logError('Unexpected error during signup', error: e, st: st);
      rethrow;
    }
  }

  /// Get currently logged-in user
  /// Returns: User object or null if not logged in
  User? getCurrentUser() {
    try {
      return Supabase.instance.client.auth.currentUser;
    } catch (e, st) {
      logError('Failed to get current user', error: e, st: st);
      return null;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return getCurrentUser() != null;
  }

  /// Logout current user
  /// Clears session and tokens
  Future<void> logout() async {
    try {
      logInfo('Logging out user');

      await Supabase.instance.client.auth.signOut();

      logInfo('Logout successful');
    } catch (e, st) {
      logError('Logout failed', error: e, st: st);
      rethrow;
    }
  }

  /// Update user profile (name, metadata)
  Future<void> updateUserProfile({required String name}) async {
    try {
      ValidationService.validateName(name);

      logInfo('Updating user profile');

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {'name': name.trim()},
        ),
      );

      logInfo('Profile updated successfully');
    } catch (e, st) {
      logError('Failed to update profile', error: e, st: st);
      rethrow;
    }
  }

  /// Change user password
  /// Requires: Current user must be logged in
  Future<void> changePassword({required String newPassword}) async {
    try {
      ValidationService.validatePassword(newPassword);

      logInfo('Changing password');

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      logInfo('Password changed successfully');
    } catch (e, st) {
      logError('Failed to change password', error: e, st: st);
      rethrow;
    }
  }

  /// Reset password via email OTP
  Future<void> resetPassword({required String email}) async {
    try {
      ValidationService.validateEmail(email);

      logInfo('Requesting password reset for: $email');

      await Supabase.instance.client.auth.resetPasswordForEmail(
        email.trim(),
      );

      logInfo('Password reset email sent');
    } catch (e, st) {
      logError('Failed to reset password', error: e, st: st);
      rethrow;
    }
  }

  /// Get user's name from auth metadata
  String getUserName() {
    final user = getCurrentUser();
    if (user == null) return 'User';
    return user.userMetadata?['name'] ?? 'User';
  }

  /// Get user's email
  String getUserEmail() {
    final user = getCurrentUser();
    return user?.email ?? 'unknown@example.com';
  }

  /// Get user's unique ID
  String getUserId() {
    final user = getCurrentUser();
    if (user == null) throw SessionExpiredException();
    return user.id;
  }
}

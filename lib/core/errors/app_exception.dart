/// Custom exception classes — structured error handling across the app
/// Helps in debugging and showing user-friendly error messages
library;

abstract class AppException implements Exception {
  /// User-friendly error message shown in UI
  final String message;

  /// Original exception (for logging/debugging)
  final dynamic originalException;

  /// Stack trace for debugging
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

/// ─────────────────────────────────────────────────────────
/// AUTHENTICATION EXCEPTIONS
/// ─────────────────────────────────────────────────────────

/// User entered wrong email/password
class InvalidCredentialsException extends AppException {
  InvalidCredentialsException({super.originalException, super.stackTrace})
    : super(message: 'Invalid email or password. Please try again.');
}

/// Email already exists in system
class EmailAlreadyExistsException extends AppException {
  EmailAlreadyExistsException({super.originalException, super.stackTrace})
    : super(message: 'This email is already registered. Please login instead.');
}

/// User not found (for password reset, etc)
class UserNotFoundException extends AppException {
  UserNotFoundException({super.originalException, super.stackTrace})
    : super(message: 'User account not found.');
}

/// Session expired — user needs to login again
class SessionExpiredException extends AppException {
  SessionExpiredException({super.originalException, super.stackTrace})
    : super(message: 'Your session has expired. Please login again.');
}

/// ─────────────────────────────────────────────────────────
/// VALIDATION EXCEPTIONS
/// ─────────────────────────────────────────────────────────

/// Input validation failed — amount, email format, etc
class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Budget validation failed (amount out of range, etc)
class InvalidBudgetException extends AppException {
  InvalidBudgetException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Expense validation failed (amount, category, etc)
class InvalidExpenseException extends AppException {
  InvalidExpenseException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// ─────────────────────────────────────────────────────────
/// NETWORK & DATABASE EXCEPTIONS
/// ─────────────────────────────────────────────────────────

/// No internet connection or network error
class NetworkException extends AppException {
  NetworkException({super.originalException, super.stackTrace})
    : super(
        message: 'Network error. Please check your connection and try again.',
      );
}

/// Server error (500, etc) — database down, Supabase issue
class ServerException extends AppException {
  ServerException({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? 'Server error. Please try again later.');
}

/// Database operation failed
class DatabaseException extends AppException {
  DatabaseException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Timeout — operation took too long
class TimeoutException extends AppException {
  TimeoutException({super.originalException, super.stackTrace})
    : super(message: 'Request timed out. Please try again.');
}

/// ─────────────────────────────────────────────────────────
/// GENERIC/UNKNOWN EXCEPTIONS
/// ─────────────────────────────────────────────────────────

/// Unknown error — fallback for unexpected exceptions
class UnknownException extends AppException {
  UnknownException({super.originalException, super.stackTrace})
    : super(message: 'Something went wrong. Please try again.');
}

/// ─────────────────────────────────────────────────────────
/// UTILITY FUNCTIONS
/// ─────────────────────────────────────────────────────────

/// Convert any exception to AppException for consistent handling
AppException exceptionHandler(
  dynamic error, [
  StackTrace? stackTrace,
]) {
  if (error is AppException) {
    return error;
  }

  if (error is FormatException) {
    return ValidationException(
      message: 'Invalid format. Please check your input.',
      originalException: error,
      stackTrace: stackTrace,
    );
  }

  return UnknownException(
    originalException: error,
    stackTrace: stackTrace,
  );
}

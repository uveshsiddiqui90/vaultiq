/// Custom exception classes — structured error handling across the app
/// Helps in debugging and showing user-friendly error messages

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
  InvalidCredentialsException({
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: 'Invalid email or password. Please try again.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// Email already exists in system
class EmailAlreadyExistsException extends AppException {
  EmailAlreadyExistsException({
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: 'This email is already registered. Please login instead.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// User not found (for password reset, etc)
class UserNotFoundException extends AppException {
  UserNotFoundException({
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: 'User account not found.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// Session expired — user needs to login again
class SessionExpiredException extends AppException {
  SessionExpiredException({
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: 'Your session has expired. Please login again.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// ─────────────────────────────────────────────────────────
/// VALIDATION EXCEPTIONS
/// ─────────────────────────────────────────────────────────

/// Input validation failed — amount, email format, etc
class ValidationException extends AppException {
  ValidationException({
    required String message,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// Budget validation failed (amount out of range, etc)
class InvalidBudgetException extends AppException {
  InvalidBudgetException({
    required String message,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// Expense validation failed (amount, category, etc)
class InvalidExpenseException extends AppException {
  InvalidExpenseException({
    required String message,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// ─────────────────────────────────────────────────────────
/// NETWORK & DATABASE EXCEPTIONS
/// ─────────────────────────────────────────────────────────

/// No internet connection or network error
class NetworkException extends AppException {
  NetworkException({
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: 'Network error. Please check your connection and try again.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// Server error (500, etc) — database down, Supabase issue
class ServerException extends AppException {
  ServerException({
    String? message,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message ?? 'Server error. Please try again later.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// Database operation failed
class DatabaseException extends AppException {
  DatabaseException({
    required String message,
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// Timeout — operation took too long
class TimeoutException extends AppException {
  TimeoutException({
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: 'Request timed out. Please try again.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
}

/// ─────────────────────────────────────────────────────────
/// GENERIC/UNKNOWN EXCEPTIONS
/// ─────────────────────────────────────────────────────────

/// Unknown error — fallback for unexpected exceptions
class UnknownException extends AppException {
  UnknownException({
    dynamic originalException,
    StackTrace? stackTrace,
  }) : super(
    message: 'Something went wrong. Please try again.',
    originalException: originalException,
    stackTrace: stackTrace,
  );
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

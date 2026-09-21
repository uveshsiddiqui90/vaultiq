/// Logging service — centralized logging instead of print() statements
/// Better for production debugging and monitoring

import 'package:intl/intl.dart';

enum LogLevel { debug, info, warning, error }

class LoggerService {
  LoggerService._();

  static final _dateFormatter = DateFormat('HH:mm:ss.SSS');
  static bool _debugMode = true; // Set to false in production builds

  /// Set debug mode (enable/disable logging)
  static void setDebugMode(bool enable) {
    _debugMode = enable;
  }

  /// Log debug message — development info (low priority)
  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  /// Log info message — general information flow
  static void info(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  /// Log warning message — something unexpected but not critical
  static void warning(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  /// Log error message — something went wrong
  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (!_debugMode) return;

    final timestamp = _dateFormatter.format(DateTime.now());
    final levelStr = _getLevelString(level);
    final prefix = '[$timestamp] [$levelStr]';

    // Main message
    print('$prefix $message');

    // Error details if provided
    if (error != null) {
      print('$prefix ERROR: $error');
    }

    // Stack trace if provided
    if (stackTrace != null) {
      print('$prefix STACK TRACE:\n$stackTrace');
    }
  }

  /// Get log level display string
  static String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍 DEBUG';
      case LogLevel.info:
        return 'ℹ️  INFO';
      case LogLevel.warning:
        return '⚠️  WARN';
      case LogLevel.error:
        return '❌ ERROR';
    }
  }
}

/// Convenience methods for quick logging throughout app
void logDebug(String msg) => LoggerService.debug(msg);
void logInfo(String msg) => LoggerService.info(msg);
void logWarn(String msg) => LoggerService.warning(msg);
void logError(String msg, {dynamic error, StackTrace? st}) =>
    LoggerService.error(msg, error: error, stackTrace: st);

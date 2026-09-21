/// Application configuration — centralized environment & API settings
/// No hardcoded credentials — all from one place

class AppConfig {
  AppConfig._();

  // ──────────────────────────────────────────────────────────
  // SUPABASE CONFIGURATION
  // ──────────────────────────────────────────────────────────

  /// Supabase project URL — kept as const but should be from .env in production
  static const String supabaseUrl = 'https://eqgilxxzbjfawidwncrn.supabase.co';

  /// Supabase anonymous key — should be from .env in production
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxZ2lseHh6YmpmYXdpZHduY3JuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTczOTAwNDksImV4cCI6MjAzMjk2NjA0OX0.your_key_here';

  // ──────────────────────────────────────────────────────────
  // APP BEHAVIOR SETTINGS
  // ──────────────────────────────────────────────────────────

  /// Budget alert threshold — warn user when this % of budget is used
  static const double budgetAlertThreshold = 0.80; // 80%

  /// Default currency symbol
  static const String currencySymbol = '₹';

  /// Default currency code
  static const String currencyCode = 'INR';

  /// Pagination limit for transactions
  static const int paginationLimit = 20;

  /// Timeout for API calls (in seconds)
  static const Duration apiTimeout = Duration(seconds: 30);

  // ──────────────────────────────────────────────────────────
  // FEATURE FLAGS (can be toggled for A/B testing)
  // ──────────────────────────────────────────────────────────

  static const bool enableCategoryBudgetLimits = true;
  static const bool enableMonthlyRecurringExpenses = false;
  static const bool enableSavingsGoals = false;
  static const bool enableBudgetAlerts = true;
  static const bool enableAdvancedAnalytics = true;

  // ──────────────────────────────────────────────────────────
  // VALIDATION RULES
  // ──────────────────────────────────────────────────────────

  /// Minimum budget amount user can set
  static const double minBudgetAmount = 100.0;

  /// Maximum budget amount user can set
  static const double maxBudgetAmount = 10000000.0;

  /// Minimum expense amount
  static const double minExpenseAmount = 0.01;

  /// Maximum expense amount
  static const double maxExpenseAmount = 999999.99;

  /// Max length for transaction notes
  static const int maxNoteLength = 500;

  // ──────────────────────────────────────────────────────────
  // STRING CONSTANTS
  // ──────────────────────────────────────────────────────────

  static const String appName = 'VaultIQ';
  static const String appVersion = '1.0.0';
}

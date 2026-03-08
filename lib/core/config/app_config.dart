/// App configuration constants
class AppConfig {
  static const String appName = 'DrinkLion';
  static const String version = '1.0.0';
  static const int buildNumber = 1;

  // Feature flags
  static const bool enableDarkMode = true;
  static const bool enableI18n = true;
  static const bool enableCrashReporting = false; // For MVP
  static const bool enableAnalytics = false; // Privacy first!

  // Database config
  static const String dbFileName = 'drinklion.db';
  static const int dbVersion = 1;

  // Notification config
  static const int notificationPermissionRequestDelay = 2; // seconds

  // API config (future)
  static const String baseUrl = 'https://api.drinklion.app';

  // Privacy
  static const bool collectPersonalData = false;
  static const bool useAnalytics = false;

  // Defaults
  static const int defaultWaterReminderFrequency = 8;
  static const String defaultLanguage = 'id'; // Indonesian
  static const String defaultTheme = 'light';
}

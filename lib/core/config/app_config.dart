import 'environment.dart';

class AppConfig {
  static const String appName = 'Starter Template Riverpod';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static String get apiBaseUrl => EnvironmentConfig.baseUrl;
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);
  // Retry/Backoff
  static const int maxRetries = 3;
  static const Duration initialBackoff = Duration(milliseconds: 300);
  static const double backoffMultiplier = 2.0; // exponential factor
  static const Duration maxBackoff = Duration(seconds: 3);

  // App Configuration
  static String get displayName => EnvironmentConfig.appName;
  static bool get enableLogging => EnvironmentConfig.enableLogging;
  static bool get enableAnalytics => EnvironmentConfig.enableAnalytics;

  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = false;
  static const bool enableOfflineMode = true;

  // Cache Configuration
  static const Duration imageCacheDuration = Duration(days: 7);
  static const Duration dataCacheDuration = Duration(hours: 1);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration listCacheTtl = Duration(minutes: 5);

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration toastDuration = Duration(seconds: 3);
  static const double defaultBorderRadius = 8.0;

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxUsernameLength = 50;
  static const int maxEmailLength = 254;

  // Google Sign-In Configuration (centralized)
  static String get googleClientIdIOS => EnvironmentConfig.googleClientIdIOS;
  static String get googleClientIdWeb => EnvironmentConfig.googleClientIdWeb;
}

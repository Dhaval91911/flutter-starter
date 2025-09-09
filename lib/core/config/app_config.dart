import 'environment.dart';

class AppConfig {
  static const String appName = 'Starter Template Riverpod';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static String get apiBaseUrl => EnvironmentConfig.baseUrl;
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

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

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration toastDuration = Duration(seconds: 3);
  static const double defaultBorderRadius = 8.0;

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxUsernameLength = 50;
  static const int maxEmailLength = 254;
}

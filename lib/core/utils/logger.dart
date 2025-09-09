import 'package:flutter/foundation.dart';

import '../config/environment.dart';

class AppLogger {
  static const String _tag = '[AppLogger]';

  static void debug(String message, [String? tag]) {
    if (EnvironmentConfig.enableLogging) {
      debugPrint('$_tag [DEBUG] ${tag ?? ''}: $message');
    }
  }

  static void info(String message, [String? tag]) {
    if (EnvironmentConfig.enableLogging) {
      debugPrint('$_tag [INFO] ${tag ?? ''}: $message');
    }
  }

  static void warning(String message, [String? tag]) {
    if (EnvironmentConfig.enableLogging) {
      debugPrint('$_tag [WARNING] ${tag ?? ''}: $message');
    }
  }

  static void error(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    if (EnvironmentConfig.enableLogging) {
      debugPrint('$_tag [ERROR] ${tag ?? ''}: $message');
      if (error != null) {
        debugPrint('$_tag [ERROR] Details: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_tag [ERROR] StackTrace: $stackTrace');
      }
    }
  }

  static void api(String message, [String? tag]) {
    if (EnvironmentConfig.enableLogging) {
      debugPrint('$_tag [API] ${tag ?? ''}: $message');
    }
  }

  static void performance(String message, [String? tag]) {
    if (EnvironmentConfig.enableLogging) {
      debugPrint('$_tag [PERFORMANCE] ${tag ?? ''}: $message');
    }
  }
}

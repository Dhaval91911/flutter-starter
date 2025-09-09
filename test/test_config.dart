import 'package:flutter_test/flutter_test.dart';

/// Test configuration and utilities for the starter template
class TestConfig {
  /// Default timeout for async tests
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Default pump duration for widget tests
  static const Duration defaultPumpDuration = Duration(milliseconds: 100);

  /// Test data constants
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'testPassword123';
  static const String testName = 'Test User';

  /// Mock API responses
  static const Map<String, dynamic> mockSuccessResponse = {'success': true, 'statuscode': 200, 'message': 'Success', 'data': {}};

  static const Map<String, dynamic> mockErrorResponse = {'success': false, 'statuscode': 400, 'message': 'Bad Request', 'data': null};

  /// Test utilities
  static void setupTestEnvironment() {
    // Set up any global test configuration here
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  static void tearDownTestEnvironment() {
    // Clean up any global test configuration here
  }
}

/// Common test matchers
class TestMatchers {
  /// Matcher for checking if a value is not null and not empty
  static Matcher isNotEmpty = predicate((value) {
    if (value == null) return false;
    if (value is String) return value.isNotEmpty;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    return true;
  }, 'is not empty');

  /// Matcher for checking if a value is a valid email
  static Matcher isValidEmail = predicate((value) {
    if (value is! String) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }, 'is a valid email');
}

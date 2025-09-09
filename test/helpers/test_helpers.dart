import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:starter_template_riverpod/core/config/environment.dart';
import 'package:starter_template_riverpod/services/web_service/api_service.dart';

/// Test helpers and utilities for the starter template
class TestHelpers {
  /// Set up test environment
  static void setupTestEnvironment() {
    TestWidgetsFlutterBinding.ensureInitialized();
    EnvironmentConfig.setEnvironment(Environment.dev);
  }

  /// Create a mock API service
  static MockApiService createMockApiService() {
    return MockApiService();
  }

  /// Create a test app widget
  static Widget createTestApp({required Widget child}) {
    return MaterialApp(home: child);
  }

  /// Pump widget with default duration
  static Future<void> pumpWidget(WidgetTester tester, Widget widget, {Duration? duration}) async {
    await tester.pumpWidget(createTestApp(child: widget));
    await tester.pump(duration ?? const Duration(milliseconds: 100));
  }

  /// Find widget by type
  static T findWidgetByType<T extends Widget>(WidgetTester tester) {
    return tester.widget<T>(find.byType(T));
  }

  /// Find text widget by content
  static Finder findText(String text) {
    return find.text(text);
  }

  /// Find widget by key
  static Finder findWidgetByKey(Key key) {
    return find.byKey(key);
  }

  /// Verify widget is displayed
  static void expectWidgetIsDisplayed(WidgetTester tester, Widget widget) {
    expect(find.byWidget(widget), findsOneWidget);
  }

  /// Verify text is displayed
  static void expectTextIsDisplayed(WidgetTester tester, String text) {
    expect(findText(text), findsOneWidget);
  }

  /// Verify widget is not displayed
  static void expectWidgetIsNotDisplayed(WidgetTester tester, Widget widget) {
    expect(find.byWidget(widget), findsNothing);
  }

  /// Verify text is not displayed
  static void expectTextIsNotDisplayed(WidgetTester tester, String text) {
    expect(findText(text), findsNothing);
  }

  /// Tap on widget
  static Future<void> tapWidget(WidgetTester tester, Widget widget) async {
    await tester.tap(find.byWidget(widget));
    await tester.pump();
  }

  /// Enter text in text field
  static Future<void> enterText(WidgetTester tester, String text, {Key? key, int index = 0}) async {
    final finder = key != null ? findWidgetByKey(key) : find.byType(TextField);
    await tester.enterText(finder.at(index), text);
    await tester.pump();
  }

  /// Scroll to find widget
  static Future<void> scrollToFind(WidgetTester tester, Finder finder, {Duration? duration}) async {
    await tester.scrollUntilVisible(finder, 500.0, scrollable: find.byType(Scrollable));
    await tester.pump(duration ?? const Duration(milliseconds: 100));
  }

  /// Wait for async operations
  static Future<void> waitForAsync(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Create test data
  static Map<String, dynamic> createTestData({String? key, dynamic value}) {
    return {key ?? 'test_key': value ?? 'test_value'};
  }

  /// Create test error
  static Exception createTestError([String message = 'Test error']) {
    return Exception(message);
  }
}

/// Mock API service for testing
class MockApiService extends Mock implements ApiService {}

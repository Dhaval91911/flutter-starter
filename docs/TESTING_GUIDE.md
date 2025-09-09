# Testing Guide

This document provides comprehensive guidance on testing the Starter Template Riverpod project.

## Table of Contents

1. [Testing Structure](#testing-structure)
2. [Running Tests](#running-tests)
3. [Test Types](#test-types)
4. [Writing Tests](#writing-tests)
5. [Test Utilities](#test-utilities)
6. [Best Practices](#best-practices)
7. [Common Patterns](#common-patterns)
8. [Troubleshooting](#troubleshooting)

## Testing Structure

The project follows a comprehensive testing structure:

```
test/
├── test_config.dart              # Global test configuration
├── helpers/
│   └── test_helpers.dart        # Common test utilities and helpers
├── unit/                         # Unit tests
│   ├── core/                     # Core functionality tests
│   │   ├── config/
│   │   │   └── environment_test.dart
│   │   ├── error/
│   │   │   └── failures_test.dart
│   │   └── utils/
│   │       └── constants_test.dart
│   └── features/                 # Feature-specific tests
│       └── people/
│           └── people_notifier_test.dart
└── widget/                       # Widget tests
    └── home_screen_test.dart
```

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/unit/core/config/environment_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

### Run Tests in Watch Mode

```bash
flutter test --watch
```

### Run Tests with Verbose Output

```bash
flutter test --verbose
```

## Test Types

### 1. Unit Tests

- **Location**: `test/unit/`
- **Purpose**: Test individual functions, classes, and logic
- **Dependencies**: Minimal, focused on single units of code
- **Example**: Testing a notifier's state changes

### 2. Widget Tests

- **Location**: `test/widget/`
- **Purpose**: Test UI components and user interactions
- **Dependencies**: Flutter framework, mock services
- **Example**: Testing screen rendering and user input

### 3. Integration Tests

- **Location**: `test/integration/`
- **Purpose**: Test complete user flows and feature integration
- **Dependencies**: Full app, real services (optional)
- **Example**: Testing complete user registration flow

## Writing Tests

### Basic Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature Name Tests', () {
    late MockService mockService;
    late FeatureNotifier notifier;

    setUp(() {
      mockService = MockService();
      notifier = FeatureNotifier(mockService);
    });

    tearDown(() {
      notifier.dispose();
    });

    test('should do something specific', () {
      // Arrange
      const expectedValue = 'expected';

      // Act
      final result = notifier.someMethod();

      // Assert
      expect(result, equals(expectedValue));
    });
  });
}
```

### Testing Async Operations

```dart
test('should handle async operation', () async {
  // Arrange
  when(mockService.fetchData()).thenAnswer(
    (_) async => Future.delayed(Duration(milliseconds: 100)),
  );

  // Act
  final future = notifier.loadData();

  // Assert
  expect(notifier.state, const AsyncValue.loading());
  await future;
  expect(notifier.state.hasValue, isTrue);
});
```

### Testing State Changes

```dart
test('should emit correct states', () async {
  // Arrange
  final mockData = MockData();
  when(mockService.getData()).thenAnswer((_) async => mockData);

  // Act & Assert
  expect(notifier.state, const AsyncValue.loading());

  await notifier.loadData();

  expect(notifier.state.hasValue, isTrue);
  expect(notifier.state.value, equals(mockData));
});
```

## Test Utilities

### TestHelpers Class

The `TestHelpers` class provides common utilities:

```dart
import 'package:starter_template_riverpod/test/helpers/test_helpers.dart';

void main() {
  setUp(() {
    TestHelpers.setupTestEnvironment();
  });

  testWidgets('should display widget correctly', (tester) async {
    // Arrange
    final widget = MyWidget();

    // Act
    await TestHelpers.pumpWidget(tester, widget);

    // Assert
    TestHelpers.expectWidgetIsDisplayed(tester, widget);
  });
}
```

### TestConfig Class

Global test configuration:

```dart
import 'package:starter_template_riverpod/test/test_config.dart';

void main() {
  test('should complete within timeout', () async {
    // This test will timeout after 30 seconds
    await someAsyncOperation();
  }, timeout: TestConfig.defaultTimeout);
}
```

### TestMatchers Class

Custom test matchers:

```dart
import 'package:starter_template_riverpod/test/test_config.dart';

test('should have valid email', () {
  const email = 'test@example.com';
  expect(email, TestMatchers.isValidEmail);
});
```

## Best Practices

### 1. Test Organization

- Group related tests using `group()`
- Use descriptive test names that explain the expected behavior
- Follow the Arrange-Act-Assert pattern

### 2. Mocking

- Mock external dependencies (APIs, databases, etc.)
- Use `Mockito` for creating mocks
- Verify mock interactions when relevant

### 3. Test Data

- Use constants for test data
- Create factory methods for complex objects
- Avoid hardcoded values in assertions

### 4. Error Testing

- Test both success and failure scenarios
- Verify error messages and error states
- Test edge cases and boundary conditions

### 5. Async Testing

- Always await async operations
- Test loading states
- Verify state transitions

## Common Patterns

### Testing Riverpod Notifiers

```dart
test('should update state correctly', () async {
  // Arrange
  final mockData = MockData();
  when(mockService.getData()).thenAnswer((_) async => mockData);

  // Act
  await notifier.loadData();

  // Assert
  expect(notifier.state.hasValue, isTrue);
  expect(notifier.state.value, equals(mockData));
});
```

### Testing Widgets

```dart
testWidgets('should display correct content', (tester) async {
  // Arrange
  final widget = MyScreen();

  // Act
  await tester.pumpWidget(MaterialApp(home: widget));

  // Assert
  expect(find.text('Expected Text'), findsOneWidget);
  expect(find.byType(ExpectedWidget), findsOneWidget);
});
```

### Testing API Calls

```dart
test('should call API with correct parameters', () async {
  // Arrange
  const expectedParams = {'key': 'value'};
  when(mockApiService.callApi(expectedParams))
      .thenAnswer((_) async => MockResponse());

  // Act
  await notifier.makeApiCall(expectedParams);

  // Assert
  verify(mockApiService.callApi(expectedParams)).called(1);
});
```

## Troubleshooting

### Common Issues

1. **Test Timeout**

   - Increase timeout duration
   - Check for infinite loops
   - Verify async operations are properly awaited

2. **Mock Not Working**

   - Ensure mocks are properly initialized
   - Check mock setup in setUp()
   - Verify mock method signatures match

3. **State Not Updating**

   - Check if notifier is properly disposed
   - Verify state assignments
   - Check for async state updates

4. **Widget Not Found**
   - Verify widget tree structure
   - Check for conditional rendering
   - Use `pump()` to wait for rebuilds

### Debug Commands

```bash
# Run specific test with verbose output
flutter test test/unit/specific_test.dart --verbose

# Run tests and stop on first failure
flutter test --stop-on-first-failure

# Run tests with coverage report
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
```

## Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 60%+ coverage
- **Integration Tests**: 40%+ coverage
- **Overall**: 70%+ coverage

## Continuous Integration

Tests are automatically run on:

- Pull requests
- Main branch pushes
- Release builds

Ensure all tests pass before merging code.

## Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Riverpod Testing Guide](https://riverpod.dev/docs/cookbooks/testing)
- [Flutter Testing Best Practices](https://docs.flutter.dev/testing/best-practices)

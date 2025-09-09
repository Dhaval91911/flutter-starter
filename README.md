# Starter Template Riverpod

A production-ready Flutter starter template with Riverpod state management, following clean architecture principles and modern Flutter best practices.

## 🚀 Features

- **Modern Architecture**: Feature-based folder structure with clean separation of concerns
- **State Management**: Riverpod for robust and testable state management
- **Dependency Injection**: Injectable for clean dependency management
- **Routing**: GoRouter for declarative routing with custom transitions
- **Network Layer**: Retrofit + Dio for type-safe API calls
- **Localization**: Easy Localization for multi-language support
- **Theme Management**: Dynamic theme switching (light/dark)
- **Error Handling**: Comprehensive error handling with custom failure types
- **Testing**: Structured testing setup for unit, widget, and integration tests
- **Environment Configuration**: Support for dev, staging, and production environments

## 📱 Screenshots

[Add your app screenshots here]

## 🏗️ Architecture

```
lib/
├── core/                    # Core functionality
│   ├── config/             # Environment and app configuration
│   ├── error/              # Error handling and failure types
│   ├── notification_helper/ # Push notification handling
│   ├── shared_pref/        # Local storage utilities
│   ├── theme/              # Theme management
│   ├── utils/              # Common utilities and constants
│   └── widgets/            # Reusable UI components
├── features/               # Feature modules
│   ├── home/              # Home feature
│   ├── people/            # People management feature
│   ├── settings/          # App settings feature
│   └── [other_features]/  # Additional features
├── generated/              # Auto-generated files
├── injectable/            # Dependency injection setup
├── route_config/          # Routing configuration
├── services/              # External services (API, etc.)
└── translations/          # Localization files
```

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK: ^3.8.1
- Dart SDK: ^3.0.0
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/starter_template_riverpod.git
   cd starter_template_riverpod
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run code generation** (if needed)

   ```bash
   # Generate all necessary files (models, API clients, DI, assets)
   flutter packages pub run build_runner build

   # Or use the modern approach
   dart run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Environment Configuration

The template supports multiple environments:

```dart
// Set environment in main.dart
EnvironmentConfig.setEnvironment(Environment.dev); // or staging, production
```

Environment-specific configurations:

- **Dev**: Development API endpoints, debug logging enabled
- **Staging**: Staging API endpoints, logging enabled
- **Production**: Production API endpoints, minimal logging

## 🔧 Configuration

### API Configuration

Update the base URLs in `lib/core/config/environment.dart`:

```dart
static String get baseUrl {
  switch (_environment) {
    case Environment.dev:
      return 'https://your-dev-api.com';
    case Environment.staging:
      return 'https://your-staging-api.com';
    case Environment.production:
      return 'https://your-production-api.com';
  }
}
```

### Theme Configuration

Customize themes in `lib/core/theme/`:

- `app_theme.dart`: Main theme configuration
- `custom_theme_color.dart`: Custom color schemes
- `extension_theme.dart`: Theme extensions

### Localization

Add new languages in `lib/translations/`:

1. Create `[language_code].json` file
2. Add locale to `main.dart` supportedLocales
3. Update `lib/generated/locale_keys.g.dart`

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/features/people/people_notifier_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Structure

```
test/
├── unit/                   # Unit tests
│   ├── core/              # Core functionality tests
│   └── features/          # Feature-specific tests
├── widget/                 # Widget tests
└── integration/            # Integration tests
```

### Writing Tests

#### Unit Test Example

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature Tests', () {
    test('should perform expected behavior', () {
      // Arrange
      // Act
      // Assert
      expect(true, isTrue);
    });
  });
}
```

#### Widget Test Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Widget should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MyWidget(),
        ),
      ),
    );

    expect(find.byType(MyWidget), findsOneWidget);
  });
}
```

#### Testing with Riverpod

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('provider should provide expected value', () {
      final value = container.read(myProvider);
      expect(value, equals('expected value'));
    });
  });
}
```

### Test Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Integration Tests**: 50%+ coverage

### Running Tests with Coverage

```bash
# Generate coverage report
flutter test --coverage

# Install lcov for HTML reports
# macOS: brew install lcov
# Ubuntu: sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/html/index.html
```

## 📦 Dependencies

### Core Dependencies

- **flutter_riverpod**: State management
- **go_router**: Declarative routing
- **injectable**: Dependency injection
- **retrofit**: Type-safe HTTP client
- **dio**: HTTP client
- **easy_localization**: Multi-language support

### Dev Dependencies

- **build_runner**: Code generation
- **flutter_lints**: Code quality
- **mockito**: Testing utilities

### Firebase Compatibility

The project uses stable Firebase versions for better compatibility:

- **firebase_core**: ^3.6.0 (stable)
- **firebase_messaging**: ^15.1.3 (stable)

These versions are tested and compatible with Flutter 3.8.1+.

## 🚀 Deployment

### Android

1. Update `android/app/build.gradle.kts` version
2. Configure signing configs
3. Build release APK:
   ```bash
   flutter build apk --release
   ```

### iOS

1. Update `ios/Runner/Info.plist` version
2. Configure signing in Xcode
3. Build release:
   ```bash
   flutter build ios --release
   ```

## 🔍 Code Quality

### Linting

The project uses `flutter_lints` for code quality. Run:

```bash
flutter analyze
```

### Code Generation

Generate necessary files:

```bash
# Generate without conflicts
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate all
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

## 📚 Best Practices

### State Management

- Use `StateNotifier` for complex state logic
- Prefer `Provider` over `StateProvider` for simple values
- Use `AsyncValue` for async operations
- Implement proper error handling with custom failures

### Error Handling

```dart
try {
  final result = await apiCall();
  state = AsyncValue.data(result);
} catch (e) {
  state = AsyncValue.error(
    ServerFailure('Failed to fetch data'),
    StackTrace.current,
  );
}
```

### Dependency Injection

```dart
@injectable
class MyService {
  final ApiService _apiService;

  MyService(this._apiService);
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod team for excellent state management
- Community contributors

## 📞 Support

For support and questions:

- Create an issue on GitHub
- Contact: [your-email@example.com]
- Documentation: [link-to-docs]

---

**Built with ❤️ using Flutter and Riverpod**

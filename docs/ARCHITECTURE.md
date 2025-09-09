# Architecture Documentation

This document outlines the architecture, design patterns, and best practices used in the Starter Template Riverpod project.

## 🏗️ Architecture Overview

The project follows **Clean Architecture** principles with a **Feature-First** approach, implementing **MVVM** pattern using **Riverpod** for state management.

### Architecture Layers

```
┌───────────────────────────────────────────────────────────┐
│                    Presentation Layer                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Screens   │  │   Widgets   │  │   Routes    │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└───────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────────────────────┐
│                   Business Logic Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ State Mgmt  │  │ Use Cases   │  │ Validators  │        │
│  │ (Riverpod)  │  │             │  │             │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└───────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────────────────────┐
│                     Data Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Models    │  │  Services   │  │ Repositories│        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└───────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────────────────────┐
│                   Infrastructure Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   Network   │  │   Storage   │  │   Utils     │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└───────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

### Core Directory (`lib/core/`)

Contains shared functionality used across the entire application:

```
core/
├── config/              # Configuration management
│   ├── environment.dart # Environment-specific settings
│   └── app_config.dart # App-wide configuration
├── error/               # Error handling
│   ├── failures.dart    # Custom failure types
│   └── result.dart      # Result wrapper for operations
├── notification_helper/ # Push notification handling
├── shared_pref/         # Local storage utilities
├── theme/               # Theme management system
├── utils/               # Common utilities
│   ├── constants.dart   # App constants
│   ├── logger.dart      # Logging utility
│   ├── validators.dart  # Validation functions
│   ├── performance_monitor.dart # Performance tracking
│   └── network_utils.dart # Network utilities
└── widgets/             # Reusable UI components
```

### Features Directory (`lib/features/`)

Each feature is self-contained with its own models, screens, and state management:

```
features/
├── home/                # Home feature
│   ├── model/          # Feature-specific models
│   ├── screens/        # UI screens
│   ├── state_notifier/ # State management
│   └── widgets/        # Feature-specific widgets
├── people/              # People management feature
├── settings/            # App settings feature
└── [other_features]/    # Additional features
```

### Services Directory (`lib/services/`)

External service integrations:

```
services/
├── web_service/         # API services
│   └── api_service.dart # REST API client
├── connectivity_interceptor/ # Network connectivity
└── http_interceptor/    # HTTP interceptors
```

## 🔄 State Management with Riverpod

### Provider Types

1. **Provider**: Simple value providers
2. **StateProvider**: Mutable state providers
3. **StateNotifierProvider**: Complex state management
4. **FutureProvider**: Async operations
5. **StreamProvider**: Stream-based data

### Example Implementation

```dart
// Provider definition
final peopleNotifierProvider = StateNotifierProvider.autoDispose<
    PeopleNotifier,
    AsyncValue<List<PeopleModel>>
>((ref) {
  return getIt<PeopleNotifier>();
});

// State notifier
@injectable
class PeopleNotifier extends StateNotifier<AsyncValue<List<PeopleModel>>> {
  final ApiService _apiService;

  PeopleNotifier(this._apiService) : super(const AsyncValue.loading());

  Future<void> loadPeoples() async {
    try {
      state = const AsyncValue.loading();
      final data = await _apiService.getPeoples();
      state = AsyncValue.data(data.users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
```

## 🎯 Design Patterns

### 1. Repository Pattern

Abstracts data access logic:

```dart
abstract class PeopleRepository {
  Future<List<PeopleModel>> getPeople();
  Future<PeopleModel> getPersonById(int id);
  Future<void> savePerson(PeopleModel person);
}

@Injectable(as: PeopleRepository)
class PeopleRepositoryImpl implements PeopleRepository {
  final ApiService _apiService;
  final LocalStorage _localStorage;

  PeopleRepositoryImpl(this._apiService, this._localStorage);

  @override
  Future<List<PeopleModel>> getPeople() async {
    try {
      return await _apiService.getPeoples();
    } catch (e) {
      // Fallback to local storage
      return _localStorage.getCachedPeople();
    }
  }
}
```

### 2. Dependency Injection

Using Injectable for clean dependency management:

```dart
@module
abstract class RegisterModule {
  @singleton
  Dio dio() => Dio();

  @preResolve
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();
}

@injectable
class PeopleService {
  final PeopleRepository _repository;

  PeopleService(this._repository);

  Future<List<PeopleModel>> getPeople() => _repository.getPeople();
}
```

### 3. Factory Pattern

For creating complex objects:

```dart
@injectable
class ApiServiceFactory {
  ApiService createService({String? baseUrl}) {
    final dio = Dio();

    // Configure interceptors
    dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(),
      ConnectivityInterceptor(),
    ]);

    return ApiService(dio, baseUrl: baseUrl);
  }
}
```

## 🌐 Network Layer Architecture

### HTTP Client Setup

```dart
@RestApi(parser: Parser.FlutterCompute)
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/users')
  Future<PeopleListModel> getPeoples();

  @GET('/users')
  Future<UserListModel> getUsers(
    @Query('limit') int limit,
    @Query('skip') int skip,
  );
}
```

### Interceptor Chain

```
Request → AuthInterceptor → LoggingInterceptor → ConnectivityInterceptor → API
Response ← AuthInterceptor ← LoggingInterceptor ← ConnectivityInterceptor ← API
```

## 🎨 UI Architecture

### Theme System

```dart
final appThemeModeProvider = StateNotifierProvider<
    AppThemeModeNotifier,
    AppThemeState
>((ref) {
  return AppThemeModeNotifier(
    ref.watch(sharedPrefServiceProvider),
  );
});

class AppThemeModeNotifier extends StateNotifier<AppThemeState> {
  final SharedPrefService _sharedPrefService;

  AppThemeModeNotifier(this._sharedPrefService)
      : super(AppThemeState.initial());

  void toggleTheme() {
    final newMode = state.mode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    state = state.copyWith(mode: newMode);
    _sharedPrefService.saveThemeMode(newMode);
  }
}
```

### Responsive Design

Using `flutter_screenutil` for consistent sizing:

```dart
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,        // 100% of screen width
      height: 50.h,         // 50% of screen height
      margin: EdgeInsets.all(16.r), // Responsive margin
      child: Text(
        'Hello',
        style: TextStyle(fontSize: 16.sp), // Responsive font size
      ),
    );
  }
}
```

## 🔒 Error Handling

### Failure Types

```dart
abstract class Failure {
  final String message;
  final String? code;
  const Failure(this.message, [this.code]);
}

class ServerFailure extends Failure {
  const ServerFailure(String message, [String? code]) : super(message, code);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, [String? code]) : super(message, code);
}
```

### Result Wrapper

```dart
abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  Failure? get failure => isFailure ? (this as Failure<T>).failure : null;
}
```

## 📱 Platform Support

### Cross-Platform Considerations

1. **Platform-Specific Code**

   ```dart
   if (Platform.isIOS) {
     // iOS-specific implementation
   } else if (Platform.isAndroid) {
     // Android-specific implementation
   }
   ```

2. **Platform Channels**

   ```dart
   static const platform = MethodChannel('native_methods');

   Future<String> getNativeData() async {
     try {
       final result = await platform.invokeMethod('getData');
       return result;
     } catch (e) {
       throw PlatformException(code: 'ERROR', message: e.toString());
     }
   }
   ```

## 🚀 Performance Optimization

### 1. Lazy Loading

```dart
@lazySingleton
class HeavyService {
  // Only instantiated when first accessed
}
```

### 2. Auto-Dispose Providers

```dart
final temporaryDataProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});
```

### 3. Image Caching

```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  memCacheWidth: 300,
  memCacheHeight: 300,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## 🔧 Configuration Management

### Environment Configuration

```dart
enum Environment { dev, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.dev;

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://dev-api.com';
      case Environment.staging:
        return 'https://staging-api.com';
      case Environment.production:
        return 'https://api.com';
    }
  }
}
```

### Feature Flags

```dart
class FeatureFlags {
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = false;
  static const bool enableOfflineMode = true;
}
```

## 📊 Monitoring and Analytics

### Logging Strategy

```dart
class AppLogger {
  static void debug(String message, [String? tag]) {
    if (EnvironmentConfig.enableLogging && kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    // Log to crash reporting service
    // Send to analytics
  }
}
```

### Performance Monitoring

```dart
class PerformanceMonitor {
  static void startTimer(String name) {
    // Start performance measurement
  }

  static void stopTimer(String name) {
    // Stop and log performance measurement
  }
}
```

## 🧪 Testing Architecture

### Test Structure

```
test/
├── unit/           # Unit tests for business logic
├── widget/         # Widget tests for UI components
└── integration/    # Integration tests for complete flows
```

### Testing Providers

```dart
test('provider should provide expected value', () {
  final container = ProviderContainer();

  final value = container.read(myProvider);
  expect(value, equals('expected value'));

  container.dispose();
});
```

## 🔄 State Synchronization

### Local-First Architecture

1. **Immediate UI Updates**: Update local state first
2. **Background Sync**: Sync with server in background
3. **Conflict Resolution**: Handle conflicts gracefully
4. **Offline Support**: Work without internet connection

### Example Implementation

```dart
class PeopleNotifier extends StateNotifier<AsyncValue<List<PeopleModel>>> {
  Future<void> addPerson(PeopleModel person) async {
    // 1. Update local state immediately
    final currentList = state.value ?? [];
    state = AsyncValue.data([...currentList, person]);

    try {
      // 2. Sync with server
      await _apiService.addPerson(person);
    } catch (e) {
      // 3. Handle sync failure
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
```

## 📈 Scalability Considerations

### 1. Feature Isolation

Each feature is completely independent:

- Own models, screens, and state management
- No cross-feature dependencies
- Easy to add/remove features

### 2. Modular Architecture

- Clear separation of concerns
- Dependency injection for loose coupling
- Easy to test individual components

### 3. Performance Optimization

- Lazy loading of features
- Efficient state management
- Image and data caching
- Background processing

## 🔮 Future Enhancements

### Planned Improvements

1. **Micro-Frontend Architecture**: Independent feature deployment
2. **Advanced Caching**: Redis-like caching strategy
3. **Real-time Updates**: WebSocket integration
4. **Advanced Analytics**: User behavior tracking
5. **A/B Testing**: Feature flag management

### Migration Path

The current architecture is designed to support these enhancements without major refactoring:

- Modular design allows gradual migration
- Clear interfaces enable easy replacement
- Dependency injection supports new implementations

---

**This architecture provides a solid foundation for scalable, maintainable Flutter applications.**

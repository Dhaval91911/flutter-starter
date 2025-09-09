# Setup Guide

This guide will help you set up and run the Starter Template Riverpod project on your local machine.

## 🚀 Prerequisites

### Required Software

- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: 3.0.0 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control
- **Xcode** (for iOS development on macOS)

### System Requirements

- **Operating System**: Windows 10+, macOS 10.15+, or Ubuntu 18.04+
- **RAM**: Minimum 8GB, recommended 16GB
- **Storage**: At least 10GB free space
- **Internet**: Stable connection for package downloads

## 🔧 Installation Steps

### 1. Install Flutter SDK

#### Windows

```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\flutter
# Add C:\flutter\bin to PATH environment variable
```

#### macOS

```bash
# Using Homebrew
brew install --cask flutter

# Or manual installation
# Download from https://flutter.dev/docs/get-started/install/macos
# Extract to ~/flutter
# Add ~/flutter/bin to PATH in ~/.zshrc or ~/.bash_profile
```

#### Linux (Ubuntu)

```bash
# Download Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.8.1-stable.tar.xz

# Extract
tar xf flutter_linux_3.8.1-stable.tar.xz

# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
```

### 2. Verify Flutter Installation

```bash
flutter doctor
```

This command will check your setup and report any issues. Resolve all issues before proceeding.

### 3. Install IDE

#### VS Code (Recommended)

```bash
# Install VS Code from https://code.visualstudio.com/
# Install Flutter extension
# Install Dart extension
```

#### Android Studio

```bash
# Install Android Studio from https://developer.android.com/studio
# Install Flutter plugin
# Install Dart plugin
```

### 4. Clone the Project

```bash
# Clone the repository
git clone https://github.com/your-username/starter_template_riverpod.git

# Navigate to project directory
cd starter_template_riverpod
```

## 📦 Project Setup

### 1. Install Dependencies

```bash
# Get Flutter packages
flutter pub get

# Install iOS dependencies (macOS only)
cd ios
pod install
cd ..
```

### 2. Environment Configuration

#### Create Environment Files

Create environment-specific configuration files:

```bash
# Development environment
cp lib/core/config/environment.dart lib/core/config/environment_dev.dart

# Staging environment
cp lib/core/config/environment.dart lib/core/config/environment_staging.dart

# Production environment
cp lib/core/config/environment.dart lib/core/config/production.dart
```

#### Update Environment Configuration

Edit `lib/core/config/environment.dart`:

```dart
enum Environment { dev, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.dev;

  static void setEnvironment(Environment env) => _environment = env;
  static Environment get environment => _environment;

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
}
```

### 3. Code Generation

```bash
# Generate all necessary files
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes (optional)
flutter packages pub run build_runner watch
```

### 4. Firebase Setup (Optional)

If you plan to use Firebase features:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
firebase init

# Follow the setup wizard
```

### 5. Asset Generation

The project uses `flutter_gen_runner` for asset generation:

```bash
# Generate assets (runs automatically with build_runner)
flutter packages pub run build_runner build

# Or use the modern approach
dart run build_runner build
```

## 🏃‍♂️ Running the Project

### 1. Start an Emulator/Simulator

#### Android

```bash
# List available emulators
flutter emulators

# Start an emulator
flutter emulators --launch <emulator_id>
```

#### iOS (macOS only)

```bash
# Open iOS Simulator
open -a Simulator
```

### 2. Run the App

```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor
flutter run --flavor dev

# Run with hot reload
flutter run --hot
```

### 3. Debug Mode

```bash
# Run in debug mode
flutter run --debug

# Run with verbose output
flutter run --verbose
```

## 🧪 Testing Setup

### 1. Run Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/features/people/people_notifier_test.dart
```

### 2. Generate Test Coverage Report

```bash
# Install lcov (macOS)
brew install lcov

# Install lcov (Ubuntu)
sudo apt-get install lcov

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html
```

## 🔧 Development Workflow

### 1. Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Fix linting issues
dart fix --apply
```

### 2. Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push to remote
git push origin feature/your-feature-name

# Create pull request
# Merge after review
```

### 3. Dependency Management

```bash
# Add new dependency
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

## 📱 Platform-Specific Setup

### Android Setup

#### 1. Android SDK

```bash
# Install Android SDK through Android Studio
# Set ANDROID_HOME environment variable
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

#### 2. Build Configuration

```bash
# Update android/app/build.gradle.kts
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### iOS Setup (macOS only)

#### 1. Xcode Installation

```bash
# Install Xcode from App Store
# Install Xcode Command Line Tools
xcode-select --install
```

#### 2. iOS Dependencies

```bash
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues

```bash
# Update Flutter
flutter upgrade

# Clean project
flutter clean
flutter pub get

# Check Flutter version
flutter --version
```

#### 2. Build Issues

```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter build apk --debug
```

#### 3. Dependency Issues

```bash
# Clear pub cache
flutter pub cache clean

# Get packages again
flutter pub get
```

#### 4. iOS Build Issues

```bash
# Clean iOS build
cd ios
rm -rf build
pod deintegrate
pod install
cd ..

# Rebuild
flutter clean
flutter pub get
```

### Performance Issues

#### 1. Slow Build Times

```bash
# Enable parallel execution
export FLUTTER_BUILD_PARALLEL=1

# Use incremental builds
flutter build apk --debug --target-platform android-arm64
```

#### 2. Memory Issues

```bash
# Increase Gradle memory
# Edit android/gradle.properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m
```

## 🔒 Security Considerations

### 1. API Keys

```dart
// Never commit API keys to version control
// Use environment variables or secure storage
class ApiConfig {
  static const String apiKey = String.fromEnvironment('API_KEY');
}
```

### 2. Build Variants

```bash
# Use different configurations for different environments
flutter build apk --flavor dev
flutter build apk --flavor staging
flutter build apk --flavor production
```

## 📚 Additional Resources

### Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Dart Documentation](https://dart.dev/guides)

### Community

- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Discord](https://discord.gg/flutter)

### Tools

- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector)
- [Flutter Performance](https://docs.flutter.dev/development/tools/devtools/performance)
- [Flutter DevTools](https://docs.flutter.dev/development/tools/devtools)

## 🤝 Getting Help

### 1. Check Documentation

- Review this setup guide
- Check the project README
- Review Flutter documentation

### 2. Community Support

- Create an issue on GitHub
- Ask questions on Stack Overflow
- Join Flutter Discord

### 3. Project Maintainers

- Contact: [your-email@example.com]
- GitHub: [your-username]

---

**Happy Flutter Development! 🚀✨**

If you encounter any issues during setup, please refer to the troubleshooting section or create an issue on the project repository.

import 'package:flutter_test/flutter_test.dart';
import 'package:starter_template_riverpod/core/config/environment.dart';

void main() {
  group('EnvironmentConfig Tests', () {
    tearDown(() {
      // Reset environment to default after each test
      EnvironmentConfig.setEnvironment(Environment.dev);
    });

    test('should default to development environment', () {
      expect(EnvironmentConfig.environment, equals(Environment.dev));
    });

    test('should set environment correctly', () {
      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.environment, equals(Environment.staging));

      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.environment, equals(Environment.production));
    });

    test('should return correct base URL for each environment', () {
      EnvironmentConfig.setEnvironment(Environment.dev);
      expect(EnvironmentConfig.baseUrl, equals('https://dummyjson.com'));

      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.baseUrl, equals('https://your-staging-url.com'));

      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.baseUrl, equals('https://your-production-url.com'));
    });

    test('should return correct socket base URL for each environment', () {
      EnvironmentConfig.setEnvironment(Environment.dev);
      expect(EnvironmentConfig.socketBaseUrl, equals('https://luuverr.com:1460/v1'));

      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.socketBaseUrl, equals('https://luuverr.com:1461/v1'));

      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.socketBaseUrl, equals('https://luuverr.com:1462/v1'));
    });

    test('should return correct environment flags', () {
      EnvironmentConfig.setEnvironment(Environment.dev);
      expect(EnvironmentConfig.isDevelopment, isTrue);
      expect(EnvironmentConfig.isStaging, isFalse);
      expect(EnvironmentConfig.isProduction, isFalse);

      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.isDevelopment, isFalse);
      expect(EnvironmentConfig.isStaging, isTrue);
      expect(EnvironmentConfig.isProduction, isFalse);

      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.isDevelopment, isFalse);
      expect(EnvironmentConfig.isStaging, isFalse);
      expect(EnvironmentConfig.isProduction, isTrue);
    });

    test('should return correct environment names', () {
      expect(EnvironmentConfig.environmentName, equals('Development'));

      EnvironmentConfig.setEnvironment(Environment.staging);
      expect(EnvironmentConfig.environmentName, equals('Staging'));

      EnvironmentConfig.setEnvironment(Environment.production);
      expect(EnvironmentConfig.environmentName, equals('Production'));
    });
  });
}

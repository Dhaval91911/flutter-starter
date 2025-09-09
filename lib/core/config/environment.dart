enum Environment { dev, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.dev;

  static void setEnvironment(Environment env) => _environment = env;
  static Environment get environment => _environment;

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'http://192.168.29.59:3000';
      case Environment.staging:
        return 'http://192.168.29.59:3000';
      case Environment.production:
        return 'http://192.168.29.59:3000';
    }
  }

  static String get socketBaseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://luuverr.com:1460/v1';
      case Environment.staging:
        return 'https://luuverr.com:1461/v1';
      case Environment.production:
        return 'https://luuverr.com:1462/v1';
    }
  }

  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;

  static String get environmentName {
    switch (_environment) {
      case Environment.dev:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  static String get appName {
    switch (_environment) {
      case Environment.dev:
        return 'Starter Template (Dev)';
      case Environment.staging:
        return 'Starter Template (Staging)';
      case Environment.production:
        return 'Starter Template';
    }
  }

  static bool get enableLogging {
    switch (_environment) {
      case Environment.dev:
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }

  static bool get enableAnalytics {
    switch (_environment) {
      case Environment.dev:
        return false;
      case Environment.staging:
      case Environment.production:
        return true;
    }
  }
}

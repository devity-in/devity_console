import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class
class Environment {
  /// Get environment file name based on build mode
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    } else {
      return '.env.development';
    }
  }

  /// API Configuration
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? '';
  static String get analyticsEndpoint => dotenv.env['ANALYTICS_ENDPOINT'] ?? '';

  /// App Configuration
  static String get environment => dotenv.env['ENVIRONMENT'] ?? '';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '';

  /// Feature Flags
  static bool get isAnalyticsEnabled =>
      dotenv.env['FEATURE_ANALYTICS']?.toLowerCase() == 'true';
  static bool get isCachingEnabled =>
      dotenv.env['FEATURE_CACHING']?.toLowerCase() == 'true';
  static bool get isRetryEnabled =>
      dotenv.env['FEATURE_RETRY']?.toLowerCase() == 'true';
  static bool get isDebounceEnabled =>
      dotenv.env['FEATURE_DEBOUNCE']?.toLowerCase() == 'true';

  /// Cache Configuration
  static Duration get defaultCacheDuration => Duration(
        minutes: int.parse(dotenv.env['CACHE_DURATION_MINUTES'] ?? '5'),
      );

  /// Retry Configuration
  static int get maxRetryAttempts =>
      int.parse(dotenv.env['MAX_RETRY_ATTEMPTS'] ?? '3');
  static Duration get retryDelay => Duration(
        seconds: int.parse(dotenv.env['RETRY_DELAY_SECONDS'] ?? '1'),
      );

  /// Debounce Configuration
  static Duration get debounceDuration => Duration(
        milliseconds: int.parse(dotenv.env['DEBOUNCE_DURATION_MS'] ?? '500'),
      );

  /// Initialize environment configuration
  static Future<void> init({String? fileName}) async {
    await dotenv.load(fileName: fileName ?? Environment.fileName);

    // Validate required environment variables
    _validateRequiredVariables();
  }

  /// Validate required environment variables
  static void _validateRequiredVariables() {
    final requiredVariables = [
      'API_BASE_URL',
      'API_VERSION',
      'APP_VERSION',
      'ENVIRONMENT',
    ];

    for (final variable in requiredVariables) {
      if (dotenv.env[variable] == null || dotenv.env[variable]!.isEmpty) {
        throw Exception('Required environment variable $variable is not set');
      }
    }
  }
}

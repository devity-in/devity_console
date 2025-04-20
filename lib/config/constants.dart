import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart'
    show BouncingScrollPhysics, Color, Colors, ScrollPhysics;

/// UI-related constants
class UIConstants {
  /// App scroll physics
  static const ScrollPhysics appScrollPhysics = BouncingScrollPhysics();

  /// App divider width
  static const double appDividerWidth = 0.5;

  /// App divider color
  static const Color appDividerColor = Colors.black;
}

/// Base class for application constants
abstract class AppConstants {
  /// Base URL for API requests
  String get baseUrl;

  /// API version
  String get apiVersion;

  /// App version
  String get appVersion;

  /// App name
  String get appName;

  /// Environment name
  String get environment;

  /// API endpoints
  Map<String, String> get endpoints;
}

/// Development environment constants
class DevelopmentConstants implements AppConstants {
  @override
  String get baseUrl => 'https://dev.devity.in';

  @override
  String get apiVersion => 'v1';

  @override
  String get appVersion => '1.0.0-dev';

  @override
  String get appName => 'Devity Console (Dev)';

  @override
  String get environment => 'Development';

  @override
  Map<String, String> get endpoints => {
        'login': '/auth/login',
        'refresh': '/auth/refresh',
        'profile': '/user/profile',
        // Add more endpoints as needed
      };
}

/// Staging environment constants
class StagingConstants implements AppConstants {
  @override
  String get baseUrl => 'https://uat.devity.in';

  @override
  String get apiVersion => 'v1';

  @override
  String get appVersion => '1.0.0-staging';

  @override
  String get appName => 'Devity Console (UAT)';

  @override
  String get environment => 'Staging';

  @override
  Map<String, String> get endpoints => {
        'login': '/auth/login',
        'refresh': '/auth/refresh',
        'profile': '/user/profile',
        // Add more endpoints as needed
      };
}

/// Production environment constants
class ProductionConstants implements AppConstants {
  @override
  String get baseUrl => 'https://api.devity.in';

  @override
  String get apiVersion => 'v1';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appName => 'Devity Console';

  @override
  String get environment => 'Production';

  @override
  Map<String, String> get endpoints => {
        'login': '/auth/login',
        'refresh': '/auth/refresh',
        'profile': '/user/profile',
        // Add more endpoints as needed
      };
}

/// Factory class to get the appropriate constants based on flavor
class ConstantsFactory {
  static AppConstants getConstants() {
    if (kDebugMode) {
      // In debug mode, check for flavor-specific constants
      const flavor = String.fromEnvironment(
        'flavor',
        defaultValue: 'development',
      );
      switch (flavor.toLowerCase()) {
        case 'dev':
          return DevelopmentConstants();
        case 'development':
          return DevelopmentConstants();
        case 'uat':
          return StagingConstants();
        case 'staging':
          return StagingConstants();
        case 'prod':
          return ProductionConstants();
        case 'production':
          return ProductionConstants();
        default:
          return DevelopmentConstants();
      }
    } else {
      // In release mode, always use production constants
      return ProductionConstants();
    }
  }
}

/// Global constants instance
final constants = ConstantsFactory.getConstants();

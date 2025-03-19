import 'package:flutter/material.dart' show BouncingScrollPhysics, Color, Colors, ScrollPhysics;

/// Constants class to define the app name and base url based on the app flavor.
class Constants {
  static String? get _appFlavor =>
      const String.fromEnvironment('FLUTTER_APP_FLAVOR') != ''
          ? const String.fromEnvironment('FLUTTER_APP_FLAVOR')
          : null;

  /// App name based on the app flavor
  static String get appName {
    switch (Constants._appFlavor) {
      case 'development':
        return 'Dev';
      case 'production':
        return 'Prod';
      case 'staging':
        return 'UAT';
      default:
        return 'Dev';
    }
  }

  /// Base url based on the app flavor
  static String get baseUrl {
    switch (Constants._appFlavor) {
      case 'development':
        return 'https://api.devity.in';
      case 'production':
        return 'https://api.devity.in';
      case 'staging':
        return 'https://uat.devity.in';
      default:
        return 'https://dev.devity.in';
    }
  }

  /// App scroll physics
  static ScrollPhysics get appScrollPhysics => const BouncingScrollPhysics();

  static double get appDividerWidth => 0.5;

  static Color get appDividerColor => Colors.black;

}

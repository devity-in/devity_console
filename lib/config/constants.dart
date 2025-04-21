import 'package:flutter/material.dart'
    show BouncingScrollPhysics, Color, Colors, ScrollPhysics;

/// UI-related constants
class UIConstants {
  /// Primary color
  static const Color primaryColor = Color(0xFF1C1536);

  /// App scroll physics
  static const ScrollPhysics appScrollPhysics = BouncingScrollPhysics();

  /// App divider width
  static const double appDividerWidth = 0.5;

  /// App divider color
  static const Color appDividerColor = Colors.black;
}

/// Base class for application constants
class AppConstants {
  static const appName = 'Devity Console';
}

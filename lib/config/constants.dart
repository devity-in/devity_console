import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart'
    show BouncingScrollPhysics, Color, Colors, ScrollPhysics;
import 'package:devity_console/config/environment.dart';

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
class AppConstants {
  static const appName = 'Devity Console';
}

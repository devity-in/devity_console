import 'package:flutter/material.dart';

/// Class to store attached global custom keys
class CustomKey {
  /// Navigation key connected to MaterialApp
  static final navigationKey = GlobalKey<NavigatorState>();

  /// Messenger key connected to MaterialApp
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}

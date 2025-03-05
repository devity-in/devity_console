import 'package:flutter/foundation.dart';

/// Common service to log messages
class LoggerService {

  /// Log message
  void log(String message) {
    // Log message to console, file, or a remote server
    debugPrint(message);
  }
}

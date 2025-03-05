import 'dart:async';
import 'dart:developer';

/// Common service to log messages
class LoggerService {
  /// Log message
  static void commonLog(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Log message to console, file, or a remote server
    log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

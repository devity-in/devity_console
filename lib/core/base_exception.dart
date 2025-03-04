/// Base exception for all exceptions
abstract class BaseException implements Exception {
  /// Exception message
  String get message;

  /// Exception code
  int get code;

  @override
  String toString() {
    return 'Exception: $message $code';
  }
}

/// Base exception for all parsed exceptions
abstract class BaseParsedException implements Exception {
  /// Exception message [Final message which is displayed to the user]
  String get message;
}

import 'dart:convert';

import 'package:devity_console/core/base_exception.dart';

/// Exceptions for the auth module
class AuthException extends BaseException {
  /// Auth exception constructor
  AuthException(this.message, {required this.code});

  /// Auth exception message
  final String message;

  /// Auth exception code
  final int code;
}

/// Parsed auth exception [Parses the exception message from the auth exception
/// to user friendly message]
class ParsedAuthException extends BaseParsedException {
  /// Parsed auth exception
  ParsedAuthException(String message) {
    final decodedMessage = json.decode(message) as Map<String, dynamic>;
    this.message = decodedMessage['detail'] as String;
  }
  @override
  late final String message;
}

import 'package:equatable/equatable.dart';

/// Base exception class for the application
abstract class AppException extends Equatable implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, code, stackTrace];
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's an authentication error
class AuthenticationException extends AppException {
  const AuthenticationException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's an authorization error
class AuthorizationException extends AppException {
  const AuthorizationException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's a validation error
class ValidationException extends AppException {
  const ValidationException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  const ServerException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  const CacheException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's a token error
class TokenException extends AppException {
  const TokenException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

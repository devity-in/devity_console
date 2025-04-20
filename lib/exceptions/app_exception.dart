import 'package:equatable/equatable.dart';

/// Base exception class for the application.
///
/// This class serves as the foundation for all custom exceptions in the application.
/// It implements Equatable for easy comparison and provides a consistent structure
/// for error handling across the app.
///
/// # Usage
///
/// ## Creating Custom Exceptions
///
/// ```dart
/// class MyCustomException extends AppException {
///   const MyCustomException({
///     required String message,
///     String? code,
///     StackTrace? stackTrace,
///   }) : super(
///           message: message,
///           code: code,
///           stackTrace: stackTrace,
///         );
/// }
/// ```
///
/// ## Throwing Exceptions
///
/// ```dart
/// if (invalidCondition) {
///   throw ValidationException(
///     message: 'Invalid input provided',
///     code: 'INVALID_INPUT',
///   );
/// }
/// ```
///
/// ## Handling Exceptions
///
/// ```dart
/// try {
///   // Some operation that might throw
/// } on AppException catch (e) {
///   // Handle specific exception types
///   if (e is ValidationException) {
///     // Handle validation error
///   } else if (e is NetworkException) {
///     // Handle network error
///   }
/// }
/// ```
///
/// # Properties
///
/// - `message`: A human-readable error message
/// - `code`: Optional error code for programmatic handling
/// - `stackTrace`: Optional stack trace for debugging
///
/// # Error Types
///
/// The application defines several standard exception types:
///
/// ## NetworkException
/// Thrown when there are network-related issues:
/// - Connection timeouts
/// - Network unreachable
/// - DNS resolution failures
///
/// ## AuthenticationException
/// Thrown when there are authentication issues:
/// - Invalid credentials
/// - Expired tokens
/// - Missing authentication
///
/// ## AuthorizationException
/// Thrown when there are authorization issues:
/// - Insufficient permissions
/// - Access denied
/// - Forbidden operations
///
/// ## ValidationException
/// Thrown when there are validation issues:
/// - Invalid input data
/// - Missing required fields
/// - Format validation failures
///
/// ## ServerException
/// Thrown when there are server-side issues:
/// - Internal server errors
/// - Service unavailable
/// - Bad gateway
///
/// # Error Handling Best Practices
///
/// 1. Always provide meaningful error messages
/// 2. Include error codes for programmatic handling
/// 3. Preserve stack traces for debugging
/// 4. Use specific exception types for different error scenarios
/// 5. Handle exceptions at the appropriate level
/// 6. Log exceptions for monitoring and debugging
///
/// # Integration with ErrorBoundary
///
/// AppException works seamlessly with the ErrorBoundary widget:
/// ```dart
/// ErrorBoundary(
///   child: MyWidget(),
///   onError: (error, stackTrace) {
///     if (error is AppException) {
///       // Handle specific exception types
///       LoggerService.commonLog(
///         error.message,
///         error: error,
///         stackTrace: error.stackTrace ?? stackTrace,
///       );
///     }
///   },
/// )
/// ```
abstract class AppException extends Equatable implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  /// Human-readable error message
  final String message;

  /// Optional error code for programmatic handling
  final String? code;

  /// Optional stack trace for debugging
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, code, stackTrace];
}

/// Exception thrown when there's a network error.
///
/// This exception is thrown when there are issues with network connectivity,
/// timeouts, or other network-related problems.
///
/// # Examples
///
/// ```dart
/// try {
///   await networkRequest();
/// } on DioException catch (e) {
///   throw NetworkException(
///     message: 'Failed to connect to server',
///     code: 'NETWORK_ERROR',
///     stackTrace: e.stackTrace,
///   );
/// }
/// ```
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's an authentication error.
///
/// This exception is thrown when there are issues with user authentication,
/// such as invalid credentials or expired tokens.
///
/// # Examples
///
/// ```dart
/// if (token.isExpired) {
///   throw AuthenticationException(
///     message: 'Session expired. Please log in again.',
///     code: 'SESSION_EXPIRED',
///   );
/// }
/// ```
class AuthenticationException extends AppException {
  const AuthenticationException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's an authorization error.
///
/// This exception is thrown when a user attempts to perform an action
/// they don't have permission for.
///
/// # Examples
///
/// ```dart
/// if (!user.hasPermission(Permission.ADMIN)) {
///   throw AuthorizationException(
///     message: 'Insufficient permissions',
///     code: 'FORBIDDEN',
///   );
/// }
/// ```
class AuthorizationException extends AppException {
  const AuthorizationException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's a validation error.
///
/// This exception is thrown when input data fails validation checks.
///
/// # Examples
///
/// ```dart
/// if (!isValidEmail(email)) {
///   throw ValidationException(
///     message: 'Invalid email format',
///     code: 'INVALID_EMAIL',
///   );
/// }
/// ```
class ValidationException extends AppException {
  const ValidationException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's a server error.
///
/// This exception is thrown when there are issues on the server side,
/// such as internal server errors or service unavailability.
///
/// # Examples
///
/// ```dart
/// if (response.statusCode == 500) {
///   throw ServerException(
///     message: 'Internal server error',
///     code: 'INTERNAL_ERROR',
///   );
/// }
/// ```
class ServerException extends AppException {
  const ServerException({
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) : super(message: message, code: code, stackTrace: stackTrace);
}

/// Exception thrown when there's a cache error.
///
/// This exception is thrown when there are issues with caching operations,
/// such as cache misses or cache corruption.
///
/// # Examples
///
/// ```dart
/// if (cache.isCorrupted) {
///   throw CacheException(
///     message: 'Cache is corrupted',
///     code: 'CACHE_CORRUPTED',
///   );
/// }
/// ```
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

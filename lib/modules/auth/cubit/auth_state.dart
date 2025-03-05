// auth_state.dart
import 'package:devity_console/modules/auth/models/token_response.dart';

/// Base class for the auth state
abstract class AuthState {}

/// Auth initial state
class AuthInitial extends AuthState {}

/// Authenticated state
class Authenticated extends AuthState {
  /// Authenticated constructor
  Authenticated(this.token);

  /// Token response
  final TokenResponse? token;
}

/// Unauthenticated state
class Unauthenticated extends AuthState {}

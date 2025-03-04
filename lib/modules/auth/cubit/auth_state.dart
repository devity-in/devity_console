// auth_state.dart
import 'package:devity_console/modules/auth/models/token_response.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final TokenResponse? token;

  Authenticated(this.token);
}

class Unauthenticated extends AuthState {}

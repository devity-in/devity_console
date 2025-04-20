import 'package:equatable/equatable.dart';
import 'package:devity_console/models/models.dart';

/// Base class for all login states.
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the login screen.
class LoginInitial extends LoginState {}

/// The state when the login screen is loading.
class LoginLoading extends LoginState {}

/// The state when the user is logged in successfully.
class LoginSuccess extends LoginState {
  /// The logged in user.
  final User user;

  /// Creates a new [LoginSuccess].
  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// The state when there was an error.
class LoginError extends LoginState {
  /// The error message.
  final String message;

  /// Creates a new [LoginError].
  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

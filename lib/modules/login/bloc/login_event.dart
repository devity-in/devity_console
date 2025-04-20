import 'package:equatable/equatable.dart';

/// Base class for all login events.
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event to login with email and password.
class LoginWithEmailAndPassword extends LoginEvent {
  /// The email to login with.
  final String email;

  /// The password to login with.
  final String password;

  /// Creates a new [LoginWithEmailAndPassword].
  const LoginWithEmailAndPassword({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to send password reset email.
class SendPasswordResetEmail extends LoginEvent {
  /// The email to send the reset link to.
  final String email;

  /// Creates a new [SendPasswordResetEmail].
  const SendPasswordResetEmail(this.email);

  @override
  List<Object?> get props => [email];
}

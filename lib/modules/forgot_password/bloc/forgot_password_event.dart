import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendPasswordResetEmail extends ForgotPasswordEvent {
  final String email;

  const SendPasswordResetEmail(this.email);

  @override
  List<Object?> get props => [email];
}

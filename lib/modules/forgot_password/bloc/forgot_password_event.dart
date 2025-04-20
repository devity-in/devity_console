import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendPasswordResetEmail extends ForgotPasswordEvent {
  const SendPasswordResetEmail(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

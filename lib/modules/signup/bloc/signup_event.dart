import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupWithEmailAndPassword extends SignupEvent {
  final String email;
  final String password;
  final String name;

  const SignupWithEmailAndPassword({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

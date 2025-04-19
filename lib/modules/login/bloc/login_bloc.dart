import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devity_console/repositories/repositories.dart';

import 'login_event.dart';
import 'login_state.dart';

/// [LoginBloc] is a business logic component that manages the state of the
/// login screen.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  /// The default constructor for the [LoginBloc].
  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
    on<RegisterWithEmailAndPassword>(_onRegisterWithEmailAndPassword);
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }

  Future<void> _onLoginWithEmailAndPassword(
    LoginWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.login(
        event.email,
        event.password,
      );
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> _onRegisterWithEmailAndPassword(
    RegisterWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.register(
        event.email,
        event.password,
        event.name,
      );
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmail event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}

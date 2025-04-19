import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devity_console/repositories/repositories.dart';

import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _authRepository;

  SignupBloc(this._authRepository) : super(SignupInitial()) {
    on<SignupWithEmailAndPassword>(_onSignupWithEmailAndPassword);
  }

  Future<void> _onSignupWithEmailAndPassword(
    SignupWithEmailAndPassword event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      final user = await _authRepository.register(
        event.email,
        event.password,
        event.name,
      );
      emit(SignupSuccess(user));
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }
}

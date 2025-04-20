import 'package:devity_console/repositories/auth_repository.dart';
import 'package:devity_console/repositories/analytics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _authRepository;
  final AnalyticsRepository _analyticsRepository;

  SignupBloc({
    required AuthRepository authRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _authRepository = authRepository,
        _analyticsRepository = analyticsRepository,
        super(SignupInitial()) {
    on<SignupWithEmailAndPassword>(_onSignupWithEmailAndPassword);
  }

  Future<void> _onSignupWithEmailAndPassword(
    SignupWithEmailAndPassword event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      final user = await _authRepository.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      // Track successful signup
      await _analyticsRepository.trackUserAuthentication(
        userId: user.id,
        isLogin: false,
        method: 'email',
      );

      emit(SignupSuccess(user));
    } catch (e) {
      // Track signup error
      await _analyticsRepository.trackError(
        errorMessage: e.toString(),
        errorCode: 'signup_failed',
      );
      emit(SignupError(e.toString()));
    }
  }
}

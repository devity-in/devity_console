import 'package:devity_console/modules/login/bloc/login_event.dart';
import 'package:devity_console/modules/login/bloc/login_state.dart';
import 'package:devity_console/repositories/analytics_repository.dart';
import 'package:devity_console/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [LoginBloc] is a business logic component that manages the state of the
/// login screen.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// The default constructor for the [LoginBloc].
  LoginBloc({
    required AuthRepository authRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _authRepository = authRepository,
        _analyticsRepository = analyticsRepository,
        super(LoginInitial()) {
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }
  final AuthRepository _authRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<void> _onLoginWithEmailAndPassword(
    LoginWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      // Track successful login
      await _analyticsRepository.trackUserAuthentication(
        userId: user.id,
        isLogin: true,
        method: 'email',
      );
      await _analyticsRepository.setUserProperties(
        userId: user.id,
        properties: {
          'email': user.email,
          'name': user.name,
        },
      );

      emit(LoginSuccess(user));
    } catch (e) {
      // Track login error
      await _analyticsRepository.trackError(
        errorMessage: e.toString(),
        errorCode: 'login_failed',
      );
      emit(LoginError(e.toString()));
    }
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmail event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await _authRepository.requestPasswordReset(event.email);

      // Track password reset request
      await _analyticsRepository.trackCustomEvent(
        eventName: 'password_reset_requested',
        parameters: {'email': event.email},
      );

      emit(LoginInitial());
    } catch (e) {
      // Track password reset error
      await _analyticsRepository.trackError(
        errorMessage: e.toString(),
        errorCode: 'password_reset_failed',
      );
      emit(LoginError(e.toString()));
    }
  }
}

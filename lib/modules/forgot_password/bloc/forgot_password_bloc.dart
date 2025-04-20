import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devity_console/repositories/repositories.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;
  final AnalyticsRepository _analyticsRepository;

  ForgotPasswordBloc({
    required AuthRepository authRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _authRepository = authRepository,
        _analyticsRepository = analyticsRepository,
        super(ForgotPasswordInitial()) {
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmail event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      await _authRepository.requestPasswordReset(event.email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
}

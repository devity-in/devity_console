import 'package:devity_console/modules/forgot_password/bloc/forgot_password_event.dart';
import 'package:devity_console/modules/forgot_password/bloc/forgot_password_state.dart';
import 'package:devity_console/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required AuthRepository authRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _authRepository = authRepository,
        _analyticsRepository = analyticsRepository,
        super(ForgotPasswordInitial()) {
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
  }
  final AuthRepository _authRepository;
  final AnalyticsRepository _analyticsRepository;

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

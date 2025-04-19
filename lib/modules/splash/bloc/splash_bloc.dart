import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devity_console/repositories/repositories.dart';

import 'splash_event.dart';
import 'splash_state.dart';

/// [SplashBloc] is a business logic component that manages the state of the
/// splash screen.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;

  /// The default constructor for the [SplashBloc].
  SplashBloc(this._authRepository) : super(SplashInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(SplashAuthenticated(user.id));
      } else {
        emit(SplashUnauthenticated());
      }
    } catch (e) {
      emit(SplashError(e.toString()));
    }
  }
}

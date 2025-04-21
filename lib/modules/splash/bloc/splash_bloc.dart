import 'package:devity_console/modules/splash/bloc/splash_event.dart';
import 'package:devity_console/modules/splash/bloc/splash_state.dart';
import 'package:devity_console/repositories/analytics_repository.dart';
import 'package:devity_console/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [SplashBloc] is a business logic component that manages the state of the
/// splash screen.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// The default constructor for the [SplashBloc].
  SplashBloc({
    AuthRepository? authRepository,
    AnalyticsRepository? analyticsRepository,
  })  : _authRepository = authRepository ?? AuthRepository(),
        _analyticsRepository = analyticsRepository ?? AnalyticsRepository(),
        super(SplashInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  /// The [AuthRepository] instance.
  final AuthRepository _authRepository;

  /// The [AnalyticsRepository] instance.
  final AnalyticsRepository _analyticsRepository;

  /// The [onCheckAuthStatus] event handler.
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    try {
      // final user = await _authRepository.getCurrentUser();
      // emit(SplashAuthenticated(user.id));
      emit(const SplashAuthenticated('123'));
    } catch (e) {
      emit(SplashError(e.toString()));
    }
  }
}

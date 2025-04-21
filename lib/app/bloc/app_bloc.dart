import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:devity_console/models/user.dart';
import 'package:devity_console/repositories/analytics_repository.dart';
import 'package:devity_console/repositories/auth_repository.dart';
import 'package:devity_console/repositories/preferences_repository.dart';
import 'package:flutter/material.dart' show Locale, ThemeMode, VoidCallback;
import 'package:shared_preferences/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

/// [AppBloc] is a business logic component that manages the state of the
/// application.
class AppBloc extends Bloc<AppEvent, AppState> {
  /// The default constructor for the [AppBloc].
  AppBloc({
    AuthRepository? authRepository,
    AnalyticsRepository? analyticsRepository,
    PreferencesRepository? preferencesRepository,
    Connectivity? connectivity,
  })  : _authRepository = authRepository ?? AuthRepository(),
        _analyticsRepository = analyticsRepository ?? AnalyticsRepository(),
        _preferencesRepository = preferencesRepository ??
            PreferencesRepository(
              SharedPreferences.getInstance(),
            ),
        _connectivity = connectivity ?? Connectivity(),
        super(const AppInitialState()) {
    on<AppStartedEvent>(_onStarted);
    on<AppThemeModeChangedEvent>(_onThemeModeChanged);
    on<AppLocaleChangedEvent>(_onLocaleChanged);
    on<AppConnectivityChangedEvent>(_onConnectivityChanged);
    on<AppRetryEvent>(_onRetry);

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      add(
        AppConnectivityChangedEvent(
          isOnline: result != ConnectivityResult.none,
        ),
      );
    });
  }
  final AuthRepository _authRepository;
  final AnalyticsRepository _analyticsRepository;
  final PreferencesRepository _preferencesRepository;
  final Connectivity _connectivity;

  Future<void> _onStarted(
    AppStartedEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppLoadingState());
    try {
      final user = await _authRepository.getCurrentUser();
      final themeMode = await _preferencesRepository.getThemeMode();
      final locale = await _preferencesRepository.getLocale();
      final connectivityResult = await _connectivity.checkConnectivity();

      emit(
        AppLoadedState(
          user: user,
          themeMode: themeMode,
          locale: locale,
          isOffline: connectivityResult == ConnectivityResult.none,
        ),
      );
    } catch (e) {
      emit(
        AppErrorState(
          message: e.toString(),
          recoveryAction: () => add(const AppStartedEvent()),
        ),
      );
    }
  }

  Future<void> _onThemeModeChanged(
    AppThemeModeChangedEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppLoadedState) {
      emit(
        AppThemeChangeLoadingState(currentThemeMode: currentState.themeMode),
      );
      try {
        await _preferencesRepository.saveThemeMode(event.themeMode);
        emit(
          AppLoadedState(
            themeMode: event.themeMode,
            locale: currentState.locale,
            user: currentState.user,
            isOffline: currentState.isOffline,
          ),
        );
      } catch (e) {
        emit(
          AppErrorState(
            message: 'Failed to change theme: $e',
            recoveryAction: () => add(
              AppThemeModeChangedEvent(themeMode: currentState.themeMode),
            ),
          ),
        );
      }
    }
  }

  Future<void> _onLocaleChanged(
    AppLocaleChangedEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppLoadedState) {
      emit(AppLocaleChangeLoadingState(currentLocale: currentState.locale));
      try {
        await _preferencesRepository.saveLocale(event.locale);
        emit(
          AppLoadedState(
            themeMode: currentState.themeMode,
            locale: event.locale,
            user: currentState.user,
            isOffline: currentState.isOffline,
          ),
        );
      } catch (e) {
        emit(
          AppErrorState(
            message: 'Failed to change locale: $e',
            recoveryAction: () =>
                add(AppLocaleChangedEvent(locale: currentState.locale)),
          ),
        );
      }
    }
  }

  Future<void> _onConnectivityChanged(
    AppConnectivityChangedEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppLoadedState) {
      emit(
        AppLoadedState(
          themeMode: currentState.themeMode,
          locale: currentState.locale,
          user: currentState.user,
          isOffline: !event.isOnline,
        ),
      );
    }
  }

  Future<void> _onRetry(
    AppRetryEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppErrorState && currentState.recoveryAction != null) {
      currentState.recoveryAction!();
    }
  }
}

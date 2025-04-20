import 'dart:io' show exit;

import 'package:bloc/bloc.dart';
import 'package:devity_console/repositories/analytics_repository.dart';
import 'package:devity_console/repositories/auth_repository.dart';
import 'package:devity_console/models/user.dart';
import 'package:flutter/material.dart' show ThemeMode, Locale;
part 'app_event.dart';
part 'app_state.dart';

/// [AppBloc] is a business logic component that manages the state of the
/// application.
class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  final AnalyticsRepository _analyticsRepository;

  /// The default constructor for the [AppBloc].
  AppBloc({
    AuthRepository? authRepository,
    AnalyticsRepository? analyticsRepository,
  })  : _authRepository = authRepository ?? AuthRepository(),
        _analyticsRepository = analyticsRepository ?? AnalyticsRepository(),
        super(const AppInitialState()) {
    on<AppStartedEvent>(_onStarted);
    on<AppThemeModeChangedEvent>(_onThemeModeChanged);
    on<AppLocaleChangedEvent>(_onLocaleChanged);
  }

  Future<void> _onStarted(
    AppStartedEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppLoadingState());
    try {
      final user = await _authRepository.getCurrentUser();
      emit(AppLoadedState(user: user));
    } catch (e) {
      emit(AppErrorState(message: e.toString()));
    }
  }

  Future<void> _onThemeModeChanged(
    AppThemeModeChangedEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppLoadedState) {
      emit(AppLoadedState(
        themeMode: event.themeMode,
        locale: currentState.locale,
        user: currentState.user,
      ));
    }
  }

  Future<void> _onLocaleChanged(
    AppLocaleChangedEvent event,
    Emitter<AppState> emit,
  ) async {
    final currentState = state;
    if (currentState is AppLoadedState) {
      emit(AppLoadedState(
        themeMode: currentState.themeMode,
        locale: event.locale,
        user: currentState.user,
      ));
    }
  }
}

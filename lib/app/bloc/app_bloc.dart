import 'dart:io' show exit;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show ThemeMode, Locale;

part 'app_event.dart';
part 'app_state.dart';

/// [AppBloc] is a business logic component that manages the state of the
/// application.
class AppBloc extends Bloc<AppEvent, AppState> {
  /// The default constructor for the [AppBloc].
  AppBloc() : super(const AppInitialState()) {
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
      // TODO: Load initial app state
      emit(const AppLoadedState());
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
      ));
    }
  }
}

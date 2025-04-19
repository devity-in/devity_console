part of 'app_bloc.dart';

/// Events for the [AppBloc]
sealed class AppEvent {
  const AppEvent();
}

/// Initial event when the app is started
class AppStartedEvent extends AppEvent {
  const AppStartedEvent();
}

/// Event to change theme mode
class AppThemeModeChangedEvent extends AppEvent {
  const AppThemeModeChangedEvent({
    required this.themeMode,
  });

  final ThemeMode themeMode;
}

/// Event to change locale
class AppLocaleChangedEvent extends AppEvent {
  const AppLocaleChangedEvent({
    required this.locale,
  });

  final Locale locale;
}

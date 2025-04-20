part of 'app_bloc.dart';

/// States for the [AppBloc]
sealed class AppState {
  const AppState();
}

/// Initial state
class AppInitialState extends AppState {
  const AppInitialState();
}

/// Loading state
class AppLoadingState extends AppState {
  const AppLoadingState();
}

/// Loaded state
class AppLoadedState extends AppState {
  const AppLoadedState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.user,
    this.isOffline = false,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final User? user;
  final bool isOffline;
}

/// Error state with recovery options
class AppErrorState extends AppState {
  const AppErrorState({
    required this.message,
    this.recoveryAction,
    this.canRetry = true,
  });

  final String message;
  final VoidCallback? recoveryAction;
  final bool canRetry;
}

/// Theme change loading state
class AppThemeChangeLoadingState extends AppState {
  const AppThemeChangeLoadingState({
    required this.currentThemeMode,
  });

  final ThemeMode currentThemeMode;
}

/// Locale change loading state
class AppLocaleChangeLoadingState extends AppState {
  const AppLocaleChangeLoadingState({
    required this.currentLocale,
  });

  final Locale currentLocale;
}

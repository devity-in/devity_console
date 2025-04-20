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
  });

  final ThemeMode themeMode;
  final Locale locale;
  final User? user;
}

/// Error state
class AppErrorState extends AppState {
  const AppErrorState({
    required this.message,
  });

  final String message;
}

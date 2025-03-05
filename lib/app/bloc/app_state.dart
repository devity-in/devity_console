part of 'app_bloc.dart';

/// [AppState] is the state class for [AppBloc].
@freezed
class AppState with _$AppState {
  /// Initial state of the app
  const factory AppState.initial() = _Initial;

  /// Loading state of the app
  const factory AppState.loading() = _Loading;

  /// Ready state of the app
  const factory AppState.ready() = _Ready;

  /// Error state of the app
  const factory AppState.error() = _Error;
}

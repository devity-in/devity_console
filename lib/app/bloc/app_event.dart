part of 'app_bloc.dart';

/// [AppEvent] is the event class for [AppBloc].
@freezed
class AppEvent with _$AppEvent {
  /// Event to restart the app
  const factory AppEvent.refresh() = _Refresh;

  /// Event to exit the app.
  /// This event will close the app. system.exit(0)
  const factory AppEvent.exit() = _Exit;
}

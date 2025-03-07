part of 'app_editor_action_bar_bloc.dart';

/// The [AppEditorActionBarEvent] is a class that describes the different events
/// that can be triggered by the AppEditorActionBar widget.
@freezed
class AppEditorActionBarEvent with _$AppEditorActionBarEvent {
  /// The event that is triggered when the AppEditorActionBar widget is started.
  const factory AppEditorActionBarEvent.started() = _Started;
}

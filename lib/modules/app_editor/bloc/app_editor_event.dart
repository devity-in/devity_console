part of 'app_editor_bloc.dart';

/// The [AppEditorEvent] is a class that describes the different events that can
/// be triggered by the AppEditor widget.
@freezed
class AppEditorEvent with _$AppEditorEvent {
  /// The event that is triggered when the AppEditor widget is started.
  const factory AppEditorEvent.started() = _Started;
}

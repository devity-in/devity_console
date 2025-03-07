part of 'app_editor_component_list_bloc.dart';

/// The [AppEditorComponentListEvent] is a class that describes the different
/// events that can be triggered by the AppEditorComponentList widget.
@freezed
class AppEditorComponentListEvent with _$AppEditorComponentListEvent {
  /// The event that is triggered when the AppEditorComponentList widget is
  /// started.
  const factory AppEditorComponentListEvent.started() = _Started;
}

part of 'app_editor_attribute_editor_bloc.dart';

/// The [AppEditorAttributeEditorEvent] is a class that describes the different
/// events that can be triggered by the AppEditorAttributeEditor widget.
@freezed
class AppEditorAttributeEditorEvent with _$AppEditorAttributeEditorEvent {
  /// The event that is triggered when the AppEditorAttributeEditor widget is
  /// started.
  const factory AppEditorAttributeEditorEvent.started() = _Started;
}

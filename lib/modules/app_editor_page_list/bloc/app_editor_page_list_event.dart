part of 'app_editor_page_list_bloc.dart';

/// The [AppEditorPageListEvent] is a class that describes the different events
/// that can be triggered by the AppEditorPageList widget.
@freezed
class AppEditorPageListEvent with _$AppEditorPageListEvent {
  /// The event that is triggered when the AppEditorPageList widget is started.
  const factory AppEditorPageListEvent.started() = _Started;
}

part of 'app_editor_page_list_bloc.dart';

/// [AppEditorPageListEvent] is a class that describes the different events
/// that can be triggered by the AppEditorPageList widget.
@freezed
abstract class AppEditorPageListEvent with _$AppEditorPageListEvent {
  /// The event that is triggered when the AppEditorPageList widget is started.
  const factory AppEditorPageListEvent.started() = _Started;

  /// The event that is triggered when a new page is added.
  const factory AppEditorPageListEvent.addPage({
    required String name,
    required String description,
  }) = _AddPage;

  /// The event that is triggered when a page is deleted.
  const factory AppEditorPageListEvent.deletePage({
    required String pageId,
  }) = _DeletePage;
}

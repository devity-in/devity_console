part of 'app_editor_page_editor_bloc.dart';

/// [AppEditorPageEditorEvent] is an event that is emitted by the
/// [AppEditorPageEditorBloc] when the user starts editing a page.
@freezed
class AppEditorPageEditorEvent with _$AppEditorPageEditorEvent {
  /// [AppEditorPageEditorEvent.started] is an event that is emitted when
  /// the user starts editing a page.
  const factory AppEditorPageEditorEvent.started() = _Started;
}

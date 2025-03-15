part of 'app_editor_navigation_drawer_bloc.dart';

/// [AppEditorNavigationDrawerEvent] is an event of the
/// [AppEditorNavigationDrawerBloc].
@freezed
class AppEditorNavigationDrawerEvent with _$AppEditorNavigationDrawerEvent {
  /// [AppEditorNavigationDrawerEvent.started] is an event that is
  /// emitted by the
  /// [AppEditorNavigationDrawerBloc] when the user starts editing a page.
  const factory AppEditorNavigationDrawerEvent.started() = _Started;
}

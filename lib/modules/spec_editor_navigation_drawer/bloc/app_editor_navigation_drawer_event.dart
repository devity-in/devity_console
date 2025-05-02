part of 'app_editor_navigation_drawer_bloc.dart';

/// [AppEditorNavigationDrawerEvent] is an event of the
/// [AppEditorNavigationDrawerBloc].
sealed class AppEditorNavigationDrawerEvent {
  const AppEditorNavigationDrawerEvent();
}

/// [AppEditorNavigationDrawerStartedEvent] is an event that is
/// emitted by the [AppEditorNavigationDrawerBloc] when the user starts editing a page.
class AppEditorNavigationDrawerStartedEvent
    extends AppEditorNavigationDrawerEvent {
  const AppEditorNavigationDrawerStartedEvent();
}

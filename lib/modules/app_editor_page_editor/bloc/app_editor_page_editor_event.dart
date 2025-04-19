part of 'app_editor_page_editor_bloc.dart';

/// Events for the [AppEditorPageEditorBloc]
sealed class AppEditorPageEditorEvent {
  const AppEditorPageEditorEvent();
}

/// Initial event when the page editor is started
class AppEditorPageEditorStartedEvent extends AppEditorPageEditorEvent {
  const AppEditorPageEditorStartedEvent();
}

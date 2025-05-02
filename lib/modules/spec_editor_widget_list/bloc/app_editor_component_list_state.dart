part of 'app_editor_component_list_bloc.dart';

/// The [AppEditorComponentListState] is a class that describes the different
/// states that the AppEditorComponentList widget can be in.
sealed class AppEditorComponentListState {
  const AppEditorComponentListState();
}

/// The initial state of the AppEditorComponentList widget.
class AppEditorComponentListInitialState extends AppEditorComponentListState {
  const AppEditorComponentListInitialState();
}

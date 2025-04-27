part of 'app_editor_bloc.dart';

/// Events for the [AppEditorBloc]
sealed class AppEditorEvent {
  const AppEditorEvent();
}

/// Initial event when the app editor is started
class AppEditorStartedEvent extends AppEditorEvent {
  const AppEditorStartedEvent();
}

/// Event to select a page
class AppEditorSelectPageEvent extends AppEditorEvent {
  const AppEditorSelectPageEvent({
    required this.id,
  });

  final String id;
}

/// Event to select a section
class AppEditorSelectSectionEvent extends AppEditorEvent {
  const AppEditorSelectSectionEvent({
    required this.sectionType,
  });

  final PageSectionType sectionType;
}

/// Event to select a layout
class AppEditorSelectLayoutEvent extends AppEditorEvent {
  const AppEditorSelectLayoutEvent({
    required this.sectionType,
    required this.layoutIndex,
  });

  final PageSectionType sectionType;
  final int layoutIndex;
}

/// Event to select a widget
class AppEditorSelectWidgetEvent extends AppEditorEvent {
  const AppEditorSelectWidgetEvent({
    required this.sectionType,
    required this.layoutIndex,
    required this.widgetIndex,
  });

  final PageSectionType sectionType;
  final int layoutIndex;
  final int widgetIndex;
}

/// Event to clear selection
class AppEditorClearSelectionEvent extends AppEditorEvent {
  const AppEditorClearSelectionEvent();
}

/// Event to update page attributes
class AppEditorPageAttributesUpdated extends AppEditorEvent {
  const AppEditorPageAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to update section attributes
class AppEditorSectionAttributesUpdated extends AppEditorEvent {
  const AppEditorSectionAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to update layout attributes
class AppEditorLayoutAttributesUpdated extends AppEditorEvent {
  const AppEditorLayoutAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to update widget attributes
class AppEditorWidgetAttributesUpdated extends AppEditorEvent {
  const AppEditorWidgetAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to save the editor state
class AppEditorSaveStateEvent extends AppEditorEvent {
  const AppEditorSaveStateEvent({
    required this.state,
  });

  final Map<String, dynamic> state;
}

/// Event to load the editor state
class AppEditorLoadStateEvent extends AppEditorEvent {
  const AppEditorLoadStateEvent();
}

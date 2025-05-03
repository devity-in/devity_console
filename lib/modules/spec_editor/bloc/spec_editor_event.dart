part of 'spec_editor_bloc.dart';

/// Events for the [SpecEditorBloc]
sealed class SpecEditorEvent {
  const SpecEditorEvent();
}

/// Initial event when the app editor is started
class SpecEditorStartedEvent extends SpecEditorEvent {
  const SpecEditorStartedEvent();
}

/// Event to select a page
class SpecEditorSelectPageEvent extends SpecEditorEvent {
  const SpecEditorSelectPageEvent({
    required this.id,
  });

  final String id;
}

/// Event to select a section
class SpecEditorSelectSectionEvent extends SpecEditorEvent {
  const SpecEditorSelectSectionEvent({
    required this.sectionType,
  });

  final PageSectionType sectionType;
}

/// Event to select a layout
class SpecEditorSelectLayoutEvent extends SpecEditorEvent {
  const SpecEditorSelectLayoutEvent({
    required this.sectionType,
    required this.layoutIndex,
  });

  final PageSectionType sectionType;
  final int layoutIndex;
}

/// Event to select a widget
class SpecEditorSelectWidgetEvent extends SpecEditorEvent {
  const SpecEditorSelectWidgetEvent({
    required this.sectionType,
    required this.layoutIndex,
    required this.widgetIndex,
  });

  final PageSectionType sectionType;
  final int layoutIndex;
  final int widgetIndex;
}

/// Event to clear selection
class SpecEditorClearSelectionEvent extends SpecEditorEvent {
  const SpecEditorClearSelectionEvent();
}

/// Event to update page attributes
class SpecEditorPageAttributesUpdated extends SpecEditorEvent {
  const SpecEditorPageAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to update section attributes
class SpecEditorSectionAttributesUpdated extends SpecEditorEvent {
  const SpecEditorSectionAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to update layout attributes
class SpecEditorLayoutAttributesUpdated extends SpecEditorEvent {
  const SpecEditorLayoutAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to update widget attributes
class SpecEditorWidgetAttributesUpdated extends SpecEditorEvent {
  const SpecEditorWidgetAttributesUpdated({
    required this.attributes,
  });

  final Map<String, dynamic> attributes;
}

/// Event to save the editor state
class SpecEditorSaveStateEvent extends SpecEditorEvent {
  const SpecEditorSaveStateEvent({
    required this.state,
  });

  final Map<String, dynamic> state;
}

/// Event to load the editor state
class SpecEditorLoadStateEvent extends SpecEditorEvent {
  const SpecEditorLoadStateEvent();
}

/// Event triggered when the user requests to save the current spec.
class SpecEditorSaveSpecRequested extends SpecEditorEvent {
  const SpecEditorSaveSpecRequested();
}

/// Event when a component (widget or layout) is dropped onto the canvas.
class SpecEditorComponentDropped extends SpecEditorEvent {
  // Data from the Draggable

  const SpecEditorComponentDropped({
    // required this.sectionType,
    // this.targetLayoutIndex,
    // this.targetWidgetIndex,
    required this.componentData,
  });
  // final PageSectionType sectionType; // Where it was dropped
  // final int? targetLayoutIndex; // Optional target layout index within section
  // final int? targetWidgetIndex; // Optional target widget index (for inserting between)
  final Map<String, dynamic> componentData;
}

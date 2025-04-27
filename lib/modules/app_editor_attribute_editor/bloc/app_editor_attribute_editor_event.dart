part of 'app_editor_attribute_editor_bloc.dart';

/// Event for loading attribute editor
class AppEditorAttributeEditorLoad extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorLoad]
  const AppEditorAttributeEditorLoad({required this.sections});

  /// The sections to load
  final List<PageSection> sections;

  @override
  List<Object?> get props => [sections];
}

/// Event for updating widget attributes
class AppEditorAttributeEditorWidgetAttributeUpdated
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorWidgetAttributeUpdated]
  const AppEditorAttributeEditorWidgetAttributeUpdated({
    required this.sectionType,
    required this.layoutIndex,
    required this.widgetIndex,
    required this.attributes,
  });

  /// The type of section containing the widget
  final String sectionType;

  /// The index of the layout containing the widget
  final int layoutIndex;

  /// The index of the widget to update
  final int widgetIndex;

  /// The new attributes for the widget
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props =>
      [sectionType, layoutIndex, widgetIndex, attributes];
}

/// Event for updating layout attributes
class AppEditorAttributeEditorLayoutAttributeUpdated
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorLayoutAttributeUpdated]
  const AppEditorAttributeEditorLayoutAttributeUpdated({
    required this.sectionType,
    required this.layoutIndex,
    required this.attributes,
  });

  /// The type of section containing the layout
  final String sectionType;

  /// The index of the layout to update
  final int layoutIndex;

  /// The new attributes for the layout
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props => [sectionType, layoutIndex, attributes];
}

/// Event for updating section attributes
class AppEditorAttributeEditorSectionAttributeUpdated
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorSectionAttributeUpdated]
  const AppEditorAttributeEditorSectionAttributeUpdated({
    required this.sectionType,
    required this.attributes,
  });

  /// The type of section to update
  final String sectionType;

  /// The new attributes for the section
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props => [sectionType, attributes];
}

part of 'app_editor_attribute_editor_bloc.dart';

/// Base class for attribute editor events
abstract class AppEditorAttributeEditorEvent extends Equatable {
  /// Creates a new instance of [AppEditorAttributeEditorEvent]
  const AppEditorAttributeEditorEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the attribute editor
class AppEditorAttributeEditorInitialized
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorInitialized]
  const AppEditorAttributeEditorInitialized();
}

/// Event when the selection changes
class AppEditorAttributeEditorSelectionChanged
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorSelectionChanged]
  const AppEditorAttributeEditorSelectionChanged({
    this.selectedSectionType,
    this.selectedLayoutIndex,
    this.selectedWidgetIndex,
    this.sectionAttributes,
    this.layoutAttributes,
    this.widgetAttributes,
    this.globalActions,
  });

  /// The selected section type
  final PageSectionType? selectedSectionType;

  /// The index of the selected layout
  final int? selectedLayoutIndex;

  /// The index of the selected widget
  final int? selectedWidgetIndex;

  /// The attributes for the selected section (if applicable)
  final Map<String, dynamic>? sectionAttributes;

  /// The attributes for the selected layout (if applicable)
  final Map<String, dynamic>? layoutAttributes;

  /// The attributes for the selected widget (if applicable)
  final Map<String, dynamic>? widgetAttributes;

  /// The map of global actions available in the spec.
  final Map<String, dynamic>? globalActions;

  @override
  List<Object?> get props => [
        selectedSectionType,
        selectedLayoutIndex,
        selectedWidgetIndex,
        sectionAttributes,
        layoutAttributes,
        widgetAttributes,
        globalActions,
      ];
}

/// Event to update section attributes
class AppEditorAttributeEditorSectionAttributeUpdated
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorSectionAttributeUpdated]
  const AppEditorAttributeEditorSectionAttributeUpdated({
    required this.attributes,
  });

  /// The updated attributes
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props => [attributes];
}

/// Event to update layout attributes
class AppEditorAttributeEditorLayoutAttributeUpdated
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorLayoutAttributeUpdated]
  const AppEditorAttributeEditorLayoutAttributeUpdated({
    required this.attributes,
  });

  /// The updated attributes
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props => [attributes];
}

/// Event to update widget attributes
class AppEditorAttributeEditorWidgetAttributeUpdated
    extends AppEditorAttributeEditorEvent {
  /// Creates a new instance of [AppEditorAttributeEditorWidgetAttributeUpdated]
  const AppEditorAttributeEditorWidgetAttributeUpdated({
    required this.attributes,
  });

  /// The updated attributes
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props => [attributes];
}

class SelectedElementAttributesUpdated extends AppEditorAttributeEditorEvent {
  // Assuming global actions are still needed

  const SelectedElementAttributesUpdated({
    required this.globalActions,
    this.attributes,
  });
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic> globalActions;

  @override
  List<Object?> get props => [attributes, globalActions];
}

class SelectedElementSingleAttributeUpdated
    extends AppEditorAttributeEditorEvent {
  const SelectedElementSingleAttributeUpdated({
    required this.attributeKey,
    required this.newValue,
    this.onCommit,
  });
  final String attributeKey;
  final dynamic newValue;
  final void Function(String elementId, String attributeKey, dynamic newValue)?
      onCommit;

  @override
  List<Object?> get props => [attributeKey, newValue, onCommit];
}

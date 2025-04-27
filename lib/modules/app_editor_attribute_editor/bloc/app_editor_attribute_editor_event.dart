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
  });

  /// The selected section type
  final PageSectionType? selectedSectionType;

  /// The index of the selected layout
  final int? selectedLayoutIndex;

  /// The index of the selected widget
  final int? selectedWidgetIndex;

  @override
  List<Object?> get props => [
        selectedSectionType,
        selectedLayoutIndex,
        selectedWidgetIndex,
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

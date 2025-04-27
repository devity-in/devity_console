part of 'app_editor_page_editor_bloc.dart';

/// Base class for all page editor events
abstract class AppEditorPageEditorEvent extends Equatable {
  const AppEditorPageEditorEvent();

  @override
  List<Object?> get props => [];
}

/// Event for initializing the page editor
class AppEditorPageEditorInitialized extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageEditorInitialized]
  const AppEditorPageEditorInitialized();
}

/// Event for updating the page layout
class AppEditorPageLayoutUpdated extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageLayoutUpdated]
  const AppEditorPageLayoutUpdated();
}

/// Event for dropping a widget into a section
class AppEditorPageWidgetDropped extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageWidgetDropped]
  const AppEditorPageWidgetDropped({
    required this.sectionType,
    required this.widgetData,
  });

  /// The type of section to drop the widget into
  final PageSectionType sectionType;

  /// The data for the widget to drop
  final dynamic widgetData;

  @override
  List<Object?> get props => [sectionType, widgetData];
}

/// Event for dropping a layout into a section
class AppEditorPageLayoutDropped extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageLayoutDropped]
  const AppEditorPageLayoutDropped({
    required this.sectionType,
    required this.layoutType,
  });

  /// The type of section to drop the layout into
  final PageSectionType sectionType;

  /// The type of layout to drop
  final LayoutType layoutType;

  @override
  List<Object?> get props => [sectionType, layoutType];
}

/// Event for reordering widgets within a layout
class AppEditorPageWidgetReordered extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageWidgetReordered]
  const AppEditorPageWidgetReordered({
    required this.sectionType,
    required this.layoutIndex,
    required this.oldIndex,
    required this.newIndex,
  });

  /// The type of section containing the layout
  final PageSectionType sectionType;

  /// The index of the layout containing the widgets
  final int layoutIndex;

  /// The old index of the widget
  final int oldIndex;

  /// The new index of the widget
  final int newIndex;

  @override
  List<Object?> get props => [sectionType, layoutIndex, oldIndex, newIndex];
}

/// Event for selecting a section
class AppEditorPageSectionSelected extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageSectionSelected]
  const AppEditorPageSectionSelected({required this.sectionType});

  /// The type of section to select
  final PageSectionType sectionType;

  @override
  List<Object?> get props => [sectionType];
}

/// Event for selecting a layout
class AppEditorPageLayoutSelected extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageLayoutSelected]
  const AppEditorPageLayoutSelected({
    required this.sectionType,
    required this.layoutIndex,
  });

  /// The type of section containing the layout
  final PageSectionType sectionType;

  /// The index of the layout to select
  final int layoutIndex;

  @override
  List<Object?> get props => [sectionType, layoutIndex];
}

/// Event for selecting a widget
class AppEditorPageWidgetSelected extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageWidgetSelected]
  const AppEditorPageWidgetSelected({
    required this.sectionType,
    required this.layoutIndex,
    required this.widgetIndex,
  });

  /// The type of section containing the widget
  final PageSectionType sectionType;

  /// The index of the layout containing the widget
  final int layoutIndex;

  /// The index of the widget to select
  final int widgetIndex;

  @override
  List<Object?> get props => [sectionType, layoutIndex, widgetIndex];
}

/// Event for clearing the current selection
class AppEditorPageSelectionCleared extends AppEditorPageEditorEvent {
  /// Creates a new instance of [AppEditorPageSelectionCleared]
  const AppEditorPageSelectionCleared();
}

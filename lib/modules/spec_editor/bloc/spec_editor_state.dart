part of 'spec_editor_bloc.dart';

/// Base state for the [SpecEditorBloc]
sealed class SpecEditorState {
  const SpecEditorState();
}

/// Initial state before loading
class SpecEditorInitialState extends SpecEditorState {
  const SpecEditorInitialState();
}

/// State while loading spec data
class SpecEditorLoadingState extends SpecEditorState {
  const SpecEditorLoadingState();
}

/// State when spec data is loaded and editor is ready
class SpecEditorLoadedState extends SpecEditorState {
  // Removed editorState as specData holds the main content now

  const SpecEditorLoadedState({
    this.specData = const {}, // Default to empty spec
    this.selectedPageId,
    this.selectedSectionType,
    this.selectedLayoutIndex,
    this.selectedWidgetIndex,
    this.pageAttributes = const {},
    this.sectionAttributes = const {},
    this.layoutAttributes = const {},
    this.widgetAttributes = const {},
  });
  final Map<String, dynamic> specData; // Holds the loaded spec content
  final String? selectedPageId;
  final PageSectionType? selectedSectionType;
  final int? selectedLayoutIndex;
  final int? selectedWidgetIndex;
  final Map<String, dynamic> pageAttributes;
  final Map<String, dynamic> sectionAttributes;
  final Map<String, dynamic> layoutAttributes;
  final Map<String, dynamic> widgetAttributes;

  // Helper method to create a copy with updated values
  SpecEditorLoadedState copyWith({
    Map<String, dynamic>? specData,
    String? selectedPageId,
    bool clearSelectedPageId = false,
    PageSectionType? selectedSectionType,
    bool clearSelectedSectionType = false,
    int? selectedLayoutIndex,
    bool clearSelectedLayoutIndex = false,
    int? selectedWidgetIndex,
    bool clearSelectedWidgetIndex = false,
    Map<String, dynamic>? pageAttributes,
    Map<String, dynamic>? sectionAttributes,
    Map<String, dynamic>? layoutAttributes,
    Map<String, dynamic>? widgetAttributes,
  }) {
    return SpecEditorLoadedState(
      specData: specData ?? this.specData,
      selectedPageId:
          clearSelectedPageId ? null : selectedPageId ?? this.selectedPageId,
      selectedSectionType: clearSelectedSectionType
          ? null
          : selectedSectionType ?? this.selectedSectionType,
      selectedLayoutIndex: clearSelectedLayoutIndex
          ? null
          : selectedLayoutIndex ?? this.selectedLayoutIndex,
      selectedWidgetIndex: clearSelectedWidgetIndex
          ? null
          : selectedWidgetIndex ?? this.selectedWidgetIndex,
      pageAttributes: pageAttributes ?? this.pageAttributes,
      sectionAttributes: sectionAttributes ?? this.sectionAttributes,
      layoutAttributes: layoutAttributes ?? this.layoutAttributes,
      widgetAttributes: widgetAttributes ?? this.widgetAttributes,
    );
  }
}

/// State when an error occurs
class SpecEditorErrorState extends SpecEditorState {
  const SpecEditorErrorState({required this.message});
  final String message;
}

/// Model for an app page
class AppPage {
  /// Creates a new [AppPage]
  const AppPage({
    required this.id,
    required this.name,
    required this.description,
  });

  /// The unique identifier of the page
  final String id;

  /// The name of the page
  final String name;

  /// The description of the page
  final String description;
}

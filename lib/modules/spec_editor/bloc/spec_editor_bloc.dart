import 'dart:async'; // Import for async

import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/page_section.dart';
import 'package:devity_console/repositories/spec_editor_repository.dart';

part 'spec_editor_event.dart';
part 'spec_editor_state.dart';

/// [SpecEditorBloc] is a business logic component that manages the state of the
/// SpecEditor widget.
class SpecEditorBloc extends Bloc<SpecEditorEvent, SpecEditorState> {
  /// The default constructor for the [SpecEditorBloc].
  SpecEditorBloc({
    required this.projectId,
  }) : super(const SpecEditorInitialState()) {
    repository = SpecEditorRepository();
    on<SpecEditorStartedEvent>(_onStarted);
    on<SpecEditorSelectPageEvent>(_onSelectPage);
    on<SpecEditorSelectSectionEvent>(_onSelectSection);
    on<SpecEditorSelectLayoutEvent>(_onSelectLayout);
    on<SpecEditorSelectWidgetEvent>(_onSelectWidget);
    on<SpecEditorClearSelectionEvent>(_onClearSelection);
    on<SpecEditorPageAttributesUpdated>(_onPageAttributesUpdated);
    on<SpecEditorSectionAttributesUpdated>(_onSectionAttributesUpdated);
    on<SpecEditorLayoutAttributesUpdated>(_onLayoutAttributesUpdated);
    on<SpecEditorWidgetAttributesUpdated>(_onWidgetAttributesUpdated);
    on<SpecEditorSaveStateEvent>(_onSaveState);
    on<SpecEditorLoadStateEvent>(_onLoadState);
  }

  late final SpecEditorRepository repository;
  final String projectId;

  Future<void> _onStarted(
    SpecEditorStartedEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    emit(const SpecEditorLoadingState());
    try {
      // TODO: Implement repository method getSpecForProject
      // This method should handle calling the backend API (e.g., GET /projects/{projectId}/spec)
      // and return the spec content Map<String, dynamic> or null if not found.
      final loadedSpecData = await repository.getSpecForProject(projectId);

      if (loadedSpecData != null) {
        // Spec loaded successfully
        emit(SpecEditorLoadedState(specData: loadedSpecData));
      } else {
        // Spec not found (e.g., new project), initialize with default
        print('No spec found for project $projectId, initializing default.');
        emit(SpecEditorLoadedState(specData: _createDefaultSpecData()));
      }
    } catch (e) {
      print('Error loading spec for project $projectId: $e');
      // Emit error state or a default state?
      // Emitting default state might be safer for UI
      emit(
        SpecEditorLoadedState(
          specData: _createDefaultSpecData(),
          // Optionally add an error message field to the state later
        ),
      );
      // Or: emit(SpecEditorErrorState(message: "Failed to load spec: ${e.toString()}"));
    }
  }

  // Helper to create a default empty spec structure
  Map<String, dynamic> _createDefaultSpecData() {
    // Based on SpecSchema, create a minimal valid spec
    // TODO: Define default entryPoint and screen structure more robustly
    const defaultPageId = 'page_default';
    return {
      'project_id': projectId, // Include projectId if needed by schema
      'specVersion': '1.0.0',
      'specId': 'new_spec_$projectId', // Generate a default specId
      'version': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'entryPoint': defaultPageId,
      'globalData': {},
      'screens': {
        defaultPageId: {
          'id': defaultPageId,
          'type': 'Screen',
          'backgroundColor': '#FFFFFF',
          'body': {
            // Default empty body (e.g., a Column)
            'type': 'Renderer',
            'rendererType': 'Column',
            'children': [],
          },
        },
      },
      'actions': {},
      'rules': {},
    };
  }

  Future<void> _onSelectPage(
    SpecEditorSelectPageEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      // Update only selectedPageId, keep existing specData
      emit(currentState.copyWith(selectedPageId: event.id));
    }
  }

  Future<void> _onSelectSection(
    SpecEditorSelectSectionEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      // TODO: Update attribute extraction logic for selected section
      // Needs to get attributes from the corresponding screen in specData
      // based on selectedPageId and sectionType.
      // final sectionAttributes = _getSectionAttributes(currentState.specData, ...);
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType,
          // sectionAttributes: sectionAttributes ?? {},
          clearSelectedLayoutIndex: true,
          clearSelectedWidgetIndex: true,
        ),
      );
    }
  }

  Future<void> _onSelectLayout(
    SpecEditorSelectLayoutEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      // TODO: Update attribute extraction logic for selected layout
      // Needs to get attributes from specData based on selectedPageId,
      // sectionType, and layoutIndex.
      // final layoutAttributes = _getLayoutAttributes(currentState.specData, ...);
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType, // Keep section selected
          selectedLayoutIndex: event.layoutIndex,
          // layoutAttributes: layoutAttributes ?? {},
          clearSelectedWidgetIndex: true,
        ),
      );
    }
  }

  Future<void> _onSelectWidget(
    SpecEditorSelectWidgetEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      // TODO: Update attribute extraction logic for selected widget
      // Needs to get attributes from specData based on selectedPageId,
      // sectionType, layoutIndex, and widgetIndex.
      // final widgetAttributes = _getWidgetAttributes(currentState.specData, ...);
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          selectedWidgetIndex: event.widgetIndex,
          // widgetAttributes: widgetAttributes ?? {},
        ),
      );
    }
  }

  Future<void> _onClearSelection(
    SpecEditorClearSelectionEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      emit(
        currentState.copyWith(
          clearSelectedSectionType: true,
          clearSelectedLayoutIndex: true,
          clearSelectedWidgetIndex: true,
          // Clear attributes as well?
          // pageAttributes: {},
          // sectionAttributes: {},
          // layoutAttributes: {},
          // widgetAttributes: {},
        ),
      );
    }
  }

  Future<void> _onPageAttributesUpdated(
    SpecEditorPageAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState &&
        currentState.selectedPageId != null) {
      // TODO: Implement logic to update page attributes in specData map
      // Example:
      // Map<String, dynamic> newSpecData = Map.from(currentState.specData);
      // Map<String, dynamic> screens = Map.from(newSpecData['screens'] ?? {});
      // Map<String, dynamic> page = Map.from(screens[currentState.selectedPageId] ?? {});
      // page.addAll(event.attributes); // Be careful about structure
      // screens[currentState.selectedPageId] = page;
      // newSpecData['screens'] = screens;
      // emit(currentState.copyWith(specData: newSpecData, pageAttributes: event.attributes));
      print('TODO: Implement _onPageAttributesUpdated to modify specData');
      emit(currentState.copyWith(
          pageAttributes: event.attributes)); // Placeholder update
    }
  }

  Future<void> _onSectionAttributesUpdated(
    SpecEditorSectionAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState &&
        currentState.selectedSectionType != null) {
      // TODO: Implement logic to update section attributes in specData map
      print('TODO: Implement _onSectionAttributesUpdated to modify specData');
      emit(currentState.copyWith(
          sectionAttributes: event.attributes)); // Placeholder update
    }
  }

  Future<void> _onLayoutAttributesUpdated(
    SpecEditorLayoutAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState &&
        currentState.selectedLayoutIndex != null) {
      // TODO: Implement logic to update layout attributes in specData map
      print('TODO: Implement _onLayoutAttributesUpdated to modify specData');
      emit(currentState.copyWith(
          layoutAttributes: event.attributes)); // Placeholder update
    }
  }

  Future<void> _onWidgetAttributesUpdated(
    SpecEditorWidgetAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState &&
        currentState.selectedWidgetIndex != null) {
      // TODO: Implement logic to update widget attributes in specData map
      print('TODO: Implement _onWidgetAttributesUpdated to modify specData');
      emit(currentState.copyWith(
          widgetAttributes: event.attributes)); // Placeholder update
    }
  }

  Future<void> _onSaveState(
    SpecEditorSaveStateEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    // TODO: Implement editor state saving if needed (e.g., to local storage)
    print('Save State Event received - implementation pending');
  }

  Future<void> _onLoadState(
    SpecEditorLoadStateEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    // TODO: Implement editor state loading if needed
    print('Load State Event received - implementation pending');
  }

  // TODO: Add handler for SpecEditorSaveSpecRequested
  // This handler should:
  // 1. Get current specData from state.
  // 2. Call repository.saveSpec(projectId, specData).
  // 3. Handle success/failure (e.g., emit loading/success/error state).
}

// --- Helper functions for attribute extraction (NEED REWORKING) ---
// These functions are placeholders and need to be updated to work
// with the new `specData` structure.

Map<String, dynamic>? _getSectionAttributes(
  Map<String, dynamic>? editorState, // Should be specData
  PageSectionType sectionType,
) {
  // TODO: Implement logic to extract section attributes from specData
  return editorState?[sectionType.name]?['attributes'] as Map<String, dynamic>?;
}

Map<String, dynamic>? _getLayoutAttributes(
  Map<String, dynamic>? editorState, // Should be specData
  PageSectionType sectionType,
  int layoutIndex,
) {
  // TODO: Implement logic to extract layout attributes from specData
  return editorState?[sectionType.name]?['layouts']?[layoutIndex]?['attributes']
      as Map<String, dynamic>?;
}

Map<String, dynamic>? _getWidgetAttributes(
  Map<String, dynamic>? editorState, // Should be specData
  PageSectionType sectionType,
  int layoutIndex,
  int widgetIndex,
) {
  // TODO: Implement logic to extract widget attributes from specData
  return editorState?[sectionType.name]?['layouts']?[layoutIndex]?['widgets']
      ?[widgetIndex]?['attributes'] as Map<String, dynamic>?;
}

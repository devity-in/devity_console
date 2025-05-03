import 'dart:async'; // Import for async
import 'dart:convert'; // Import for jsonEncode/Decode

import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/page_section.dart';
import 'package:devity_console/repositories/spec_editor_repository.dart';
import 'package:uuid/uuid.dart'; // Import for unique IDs

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
    on<SpecEditorSaveSpecRequested>(_onSaveSpecRequested);
    on<SpecEditorComponentDropped>(_onComponentDropped);
  }

  late final SpecEditorRepository repository;
  final String projectId;
  final _uuid = const Uuid(); // UUID generator

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
      print('Updating page attributes for ${currentState.selectedPageId}');
      try {
        final newSpecData = _deepCopyMap(currentState.specData);
        final screens = newSpecData['screens'] as Map<String, dynamic>? ?? {};
        final pageData =
            screens[currentState.selectedPageId] as Map<String, dynamic>?;

        if (pageData != null) {
          // Update attributes directly on the page/screen level if applicable
          // For now, assuming page-level attributes aren't directly edited this way,
          // but maybe things like backgroundColor are?
          // Let's assume we merge into the root of the page object for now.
          pageData.addAll(event.attributes);
          // TODO: Re-evaluate where page-level attributes should live (e.g., backgroundColor)

          screens[currentState.selectedPageId!] = pageData;
          newSpecData['screens'] = screens;
          emit(
            currentState.copyWith(
              specData: newSpecData,
              pageAttributes: event.attributes,
            ),
          );
        } else {
          print(
            'Error: Page ${currentState.selectedPageId} not found in specData during attribute update.',
          );
        }
      } catch (e, stackTrace) {
        print('Error applying page attribute update: $e\n$stackTrace');
      }
    }
  }

  Future<void> _onSectionAttributesUpdated(
    SpecEditorSectionAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    // TODO: Implement section attribute updates (where do section attributes live?)
    // Sections seem conceptual in the editor UI rather than direct spec nodes.
    // This handler might not be needed if sections don't have own attributes in the spec.
    print(
      'TODO: Implement _onSectionAttributesUpdated if sections have spec attributes.',
    );
    if (currentState is SpecEditorLoadedState) {
      emit(
        currentState.copyWith(
          sectionAttributes: event.attributes,
        ),
      ); // Placeholder update
    }
  }

  Future<void> _onLayoutAttributesUpdated(
    SpecEditorLayoutAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState &&
        currentState.selectedPageId != null &&
        currentState.selectedLayoutIndex != null) {
      print(
        'Updating layout attributes for page ${currentState.selectedPageId}, layout ${currentState.selectedLayoutIndex}',
      );
      try {
        final newSpecData = _deepCopyMap(currentState.specData);
        final screens = newSpecData['screens'] as Map<String, dynamic>? ?? {};
        final pageData =
            screens[currentState.selectedPageId] as Map<String, dynamic>?;
        final body = pageData?['body'] as Map<String, dynamic>?;
        final children = body?['children'] as List<dynamic>?;

        if (children != null &&
            currentState.selectedLayoutIndex! < children.length) {
          final layoutData = Map<String, dynamic>.from(
            children[currentState.selectedLayoutIndex!]
                    as Map<String, dynamic>? ??
                {},
          );
          final layoutAttributes = Map<String, dynamic>.from(
            layoutData['attributes'] as Map<String, dynamic>? ?? {},
          );
          layoutAttributes.addAll(event.attributes);
          layoutData['attributes'] = layoutAttributes;

          children[currentState.selectedLayoutIndex!] = layoutData;
          emit(
            currentState.copyWith(
              specData: newSpecData,
              layoutAttributes: event.attributes,
            ),
          );
        } else {
          print('Error: Layout not found in specData during attribute update.');
        }
      } catch (e, stackTrace) {
        print('Error applying layout attribute update: $e\n$stackTrace');
      }
    }
  }

  Future<void> _onWidgetAttributesUpdated(
    SpecEditorWidgetAttributesUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState &&
        currentState.selectedPageId != null &&
        currentState.selectedLayoutIndex != null &&
        currentState.selectedWidgetIndex != null) {
      print(
        'Updating widget attributes for page ${currentState.selectedPageId}, layout ${currentState.selectedLayoutIndex}, widget ${currentState.selectedWidgetIndex}',
      );
      try {
        final newSpecData = _deepCopyMap(currentState.specData);
        final screens = newSpecData['screens'] as Map<String, dynamic>? ?? {};
        final pageData =
            screens[currentState.selectedPageId] as Map<String, dynamic>?;
        final body = pageData?['body'] as Map<String, dynamic>?;
        final layoutChildren = body?['children'] as List<dynamic>?;

        if (layoutChildren != null &&
            currentState.selectedLayoutIndex! < layoutChildren.length) {
          final layoutData = Map<String, dynamic>.from(
            layoutChildren[currentState.selectedLayoutIndex!]
                    as Map<String, dynamic>? ??
                {},
          );
          final widgetChildren = layoutData['children'] as List<dynamic>?;

          if (widgetChildren != null &&
              currentState.selectedWidgetIndex! < widgetChildren.length) {
            final widgetData = Map<String, dynamic>.from(
              widgetChildren[currentState.selectedWidgetIndex!]
                      as Map<String, dynamic>? ??
                  {},
            );
            final widgetAttributes = Map<String, dynamic>.from(
              widgetData['attributes'] as Map<String, dynamic>? ?? {},
            );
            widgetAttributes.addAll(event.attributes);
            widgetData['attributes'] = widgetAttributes;

            widgetChildren[currentState.selectedWidgetIndex!] = widgetData;
            emit(
              currentState.copyWith(
                specData: newSpecData,
                widgetAttributes: event.attributes,
              ),
            );
          } else {
            print(
              'Error: Widget not found in layout children during attribute update.',
            );
          }
        } else {
          print(
            'Error: Layout not found in specData during widget attribute update.',
          );
        }
      } catch (e, stackTrace) {
        print('Error applying widget attribute update: $e\n$stackTrace');
      }
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

  Future<void> _onComponentDropped(
    SpecEditorComponentDropped event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState &&
        currentState.selectedPageId != null) {
      final componentType = event.componentData['componentType'] as String?;
      final type =
          event.componentData['type'] as String?; // 'Widget' or 'Renderer'

      if (componentType == null || type == null) {
        print('Error: Dropped component data missing type information.');
        return; // Or emit error state
      }

      try {
        // --- Create new component map ---
        final newComponent = <String, dynamic>{
          'id': '${componentType.toLowerCase()}_${_uuid.v4().substring(0, 8)}',
          'type': type,
        };

        if (type == 'Widget') {
          newComponent['widgetType'] = componentType;
          // Add default attributes based on widgetType
          switch (componentType) {
            case 'Text':
              newComponent['attributes'] = {'text': 'New Text'};
            case 'Button':
              newComponent['attributes'] = {
                'text': 'New Button',
                'enabled': true,
              };
            case 'Image':
              newComponent['attributes'] = {
                'url': 'placeholder.png',
              }; // Placeholder
            case 'TextField':
              newComponent['attributes'] = {'placeholder': 'Enter text...'};
            // Add other widget defaults
            default:
              newComponent['attributes'] = {};
          }
        } else if (type == 'Renderer') {
          newComponent['rendererType'] = componentType;
          // Add default attributes/children based on rendererType
          switch (componentType) {
            case 'Column':
            case 'Row':
            case 'Stack':
              newComponent['attributes'] = {};
              newComponent['children'] = [];
            // Add other renderer defaults (Padding, Scrollable might need attributes)
            default:
              newComponent['attributes'] = {};
              newComponent['children'] = []; // Default
          }
        }

        // --- Modify specData ---
        // Use helper for deep copy and type safety
        final newSpecData = _deepCopyMap(currentState.specData);
        final screens = newSpecData['screens'] as Map<String, dynamic>? ?? {};
        final currentPage =
            screens[currentState.selectedPageId] as Map<String, dynamic>?;

        if (currentPage == null) {
          print('Error: Current page not found in specData.');
          return;
        }

        // Get body, ensuring type safety
        final body = currentPage['body'] as Map<String, dynamic>?;
        if (body == null || body['type'] != 'Renderer') {
          print('Error: Current page body is not a valid renderer.');
          return;
        }

        // Get children list, ensuring type safety
        final children =
            List<dynamic>.from(body['children'] as List<dynamic>? ?? []);
        children.add(newComponent);
        body['children'] = children;

        // No need to reassign body to currentPage or currentPage to screens if modifying in place
        // newSpecData already holds the reference through the deep copy

        // --- Emit updated state ---
        emit(currentState.copyWith(specData: newSpecData));
      } catch (e, stackTrace) {
        print('Error handling component drop: $e\n$stackTrace');
      }
    }
  }

  Future<void> _onSaveSpecRequested(
    SpecEditorSaveSpecRequested event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      print('Save Spec Requested. Current Data: ${currentState.specData}');
      // TODO: Implement repository call
      // Example:
      // emit(currentState.copyWith(isSaving: true)); // Indicate loading
      // try {
      //   await repository.saveSpec(projectId, currentState.specData);
      //   emit(currentState.copyWith(isSaving: false, saveSuccess: true)); // Indicate success
      // } catch (e) {
      //   emit(currentState.copyWith(isSaving: false, saveError: e.toString())); // Indicate error
      // }
    }
  }

  // TODO: Add handler for SpecEditorSaveSpecRequested
  // This handler should:
  // 1. Get current specData from state.
  // 2. Call repository.saveSpec(projectId, specData).
  // 3. Handle success/failure (e.g., emit loading/success/error state).

  // --- Helper for deep copying ---
  Map<String, dynamic> _deepCopyMap(Map<String, dynamic> original) {
    return jsonDecode(jsonEncode(original)) as Map<String, dynamic>;
  }
}

// --- Attribute Getter Helpers (Still need rework for specData structure) ---

Map<String, dynamic>? _getSectionAttributes(
  Map<String, dynamic>? specData,
  PageSectionType sectionType,
) {
  // Placeholder - needs correct path through specData
  const screenId = 'page_default'; // Need actual selected page ID
  return specData?['screens']?[screenId]?['attributes']
      as Map<String, dynamic>?;
}

Map<String, dynamic>? _getLayoutAttributes(
  Map<String, dynamic>? specData,
  PageSectionType sectionType,
  int layoutIndex,
) {
  // Placeholder - needs correct path through specData
  const screenId = 'page_default'; // Need actual selected page ID
  return specData?['screens']?[screenId]?['body']?['children']?[layoutIndex]
      ?['attributes'] as Map<String, dynamic>?;
}

Map<String, dynamic>? _getWidgetAttributes(
  Map<String, dynamic>? specData,
  PageSectionType sectionType,
  int layoutIndex,
  int widgetIndex,
) {
  // Placeholder - needs correct path through specData
  const screenId = 'page_default'; // Need actual selected page ID
  return specData?['screens']?[screenId]?['body']?['children']?[layoutIndex]
      ?['children']?[widgetIndex]?['attributes'] as Map<String, dynamic>?;
}

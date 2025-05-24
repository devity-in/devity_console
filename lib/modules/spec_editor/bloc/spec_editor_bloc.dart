import 'dart:async'; // Import for async
import 'dart:convert'; // Import for jsonEncode/Decode

import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/page_section.dart';
import 'package:devity_console/repositories/spec_editor_repository.dart';
import 'package:devity_console/services/logger_service.dart'; // Import Logger
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart'; // Import for unique IDs

// Removed part directives
// part 'spec_editor_event.dart';
// part 'spec_editor_state.dart';

// --- Spec Editor Event Definitions ---

abstract class SpecEditorEvent extends Equatable {
  const SpecEditorEvent();
  @override
  List<Object?> get props => [];
}

class SpecEditorStartedEvent extends SpecEditorEvent {
  const SpecEditorStartedEvent();
}

class SpecEditorSelectPageEvent extends SpecEditorEvent {
  const SpecEditorSelectPageEvent({required this.id});
  final String id;
  @override
  List<Object?> get props => [id];
}

class SpecEditorSelectSectionEvent extends SpecEditorEvent {
  const SpecEditorSelectSectionEvent({required this.sectionType});
  final PageSectionType sectionType;
  @override
  List<Object?> get props => [sectionType];
}

class SpecEditorSelectLayoutEvent extends SpecEditorEvent {
  const SpecEditorSelectLayoutEvent({
    required this.sectionType,
    required this.layoutIndex,
  });
  final PageSectionType sectionType;
  final int layoutIndex;
  @override
  List<Object?> get props => [sectionType, layoutIndex];
}

class SpecEditorSelectWidgetEvent extends SpecEditorEvent {
  const SpecEditorSelectWidgetEvent({
    required this.sectionType,
    required this.layoutIndex,
    required this.widgetIndex,
  });
  final PageSectionType sectionType;
  final int layoutIndex;
  final int widgetIndex;
  @override
  List<Object?> get props => [sectionType, layoutIndex, widgetIndex];
}

class SpecEditorClearSelectionEvent extends SpecEditorEvent {}

class SpecEditorPageAttributesUpdated extends SpecEditorEvent {
  const SpecEditorPageAttributesUpdated({required this.attributes});
  final Map<String, dynamic> attributes;
  @override
  List<Object?> get props => [attributes];
}

class SpecEditorSectionAttributesUpdated extends SpecEditorEvent {
  const SpecEditorSectionAttributesUpdated({required this.attributes});
  final Map<String, dynamic> attributes;
  @override
  List<Object?> get props => [attributes];
}

class SpecEditorLayoutAttributesUpdated extends SpecEditorEvent {
  const SpecEditorLayoutAttributesUpdated({required this.attributes});
  final Map<String, dynamic> attributes;
  @override
  List<Object?> get props => [attributes];
}

class SpecEditorWidgetAttributesUpdated extends SpecEditorEvent {
  const SpecEditorWidgetAttributesUpdated({required this.attributes});
  final Map<String, dynamic> attributes;
  @override
  List<Object?> get props => [attributes];
}

class SpecEditorSaveStateEvent extends SpecEditorEvent {}

class SpecEditorLoadStateEvent extends SpecEditorEvent {}

class SpecEditorComponentDropped extends SpecEditorEvent {
  const SpecEditorComponentDropped({required this.componentData});
  final Map<String, dynamic> componentData;
  @override
  List<Object?> get props => [componentData];
}

class SpecEditorSaveSpecRequested extends SpecEditorEvent {}

class SpecEditorGlobalActionUpdated extends SpecEditorEvent {
  const SpecEditorGlobalActionUpdated({
    required this.actionId,
    this.actionData,
  });
  final String actionId;
  final Map<String, dynamic>? actionData;
  @override
  List<Object?> get props => [actionId, actionData];
}

// Event for updating a specific attribute of an element (widget/renderer)
class ElementAttributeChangedEvent extends SpecEditorEvent {
  const ElementAttributeChangedEvent({
    required this.elementId,
    required this.attributeKey,
    required this.newValue,
  });
  final String elementId;
  final String attributeKey;
  final dynamic newValue;

  @override
  List<Object?> get props => [elementId, attributeKey, newValue];
}

// --- Spec Editor State Definitions ---

abstract class SpecEditorState extends Equatable {
  const SpecEditorState();
  @override
  List<Object?> get props => [];
}

class SpecEditorInitialState extends SpecEditorState {
  const SpecEditorInitialState();
}

class SpecEditorLoadingState extends SpecEditorState {
  const SpecEditorLoadingState();
}

class SpecEditorLoadedState extends SpecEditorState {
  const SpecEditorLoadedState({
    required this.specData,
    this.selectedPageId,
    this.selectedSectionType,
    this.selectedLayoutIndex,
    this.selectedWidgetIndex,
    this.pageAttributes = const {},
    this.sectionAttributes = const {},
    this.layoutAttributes = const {},
    this.widgetAttributes = const {},
    this.isSaving = false,
  });
  final Map<String, dynamic> specData;
  final String? selectedPageId;
  final PageSectionType? selectedSectionType;
  final int? selectedLayoutIndex;
  final int? selectedWidgetIndex;
  final Map<String, dynamic> pageAttributes;
  final Map<String, dynamic> sectionAttributes;
  final Map<String, dynamic> layoutAttributes;
  final Map<String, dynamic> widgetAttributes;
  final bool isSaving;

  @override
  List<Object?> get props => [
        specData,
        selectedPageId,
        selectedSectionType,
        selectedLayoutIndex,
        selectedWidgetIndex,
        pageAttributes,
        sectionAttributes,
        layoutAttributes,
        widgetAttributes,
        isSaving,
      ];

  SpecEditorLoadedState copyWith({
    Map<String, dynamic>? specData,
    String? selectedPageId,
    PageSectionType? selectedSectionType,
    int? selectedLayoutIndex,
    int? selectedWidgetIndex,
    Map<String, dynamic>? pageAttributes,
    Map<String, dynamic>? sectionAttributes,
    Map<String, dynamic>? layoutAttributes,
    Map<String, dynamic>? widgetAttributes,
    bool? isSaving,
    bool clearSelectedPageId = false,
    bool clearSelectedSectionType = false,
    bool clearSelectedLayoutIndex = false,
    bool clearSelectedWidgetIndex = false,
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
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class SpecEditorErrorState extends SpecEditorState {
  const SpecEditorErrorState({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

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
    on<SpecEditorGlobalActionUpdated>(_onGlobalActionUpdated);
    on<ElementAttributeChangedEvent>(_onElementAttributeChanged);
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
      final loadedSpecData = await repository.getSpecForProject(projectId);
      LoggerService.commonLog(
        "Loaded Spec ID (UUID): ${loadedSpecData['id']}",
        name: 'SpecEditorBloc._onStarted',
      );
      emit(SpecEditorLoadedState(specData: loadedSpecData));
    } catch (e, stackTrace) {
      LoggerService.commonLog(
        'Error loading spec for project $projectId',
        name: 'SpecEditorBloc._onStarted',
        error: e,
        stackTrace: stackTrace,
      );
      emit(SpecEditorLoadedState(specData: _createDefaultSpecData()));
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
      final pageAttributes =
          _getPageAttributes(currentState.specData, event.id);
      emit(
        currentState.copyWith(
          selectedPageId: event.id,
          pageAttributes: pageAttributes,
          clearSelectedSectionType: true,
          clearSelectedLayoutIndex: true,
          clearSelectedWidgetIndex: true,
        ),
      );
    }
  }

  Future<void> _onSelectSection(
    SpecEditorSelectSectionEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      // Selecting a "section" in the UI maps to selecting the page attributes
      final pageAttributes = _getPageAttributes(
        currentState.specData,
        currentState.selectedPageId,
      );
      emit(
        currentState.copyWith(
          // Keep selectedPageId
          selectedSectionType:
              event.sectionType, // Keep track of UI section selection if needed
          pageAttributes: pageAttributes, // Show page attributes
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
      final layoutAttributes = _getLayoutAttributes(
        currentState.specData,
        currentState.selectedPageId,
        event.layoutIndex,
      );
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          layoutAttributes: layoutAttributes,
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
      final widgetAttributes = _getWidgetAttributes(
        currentState.specData,
        currentState.selectedPageId,
        event.layoutIndex,
        event.widgetIndex,
      );
      emit(
        currentState.copyWith(
          selectedSectionType: event.sectionType,
          selectedLayoutIndex: event.layoutIndex,
          selectedWidgetIndex: event.widgetIndex,
          widgetAttributes: widgetAttributes,
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
      LoggerService.commonLog(
        'Updating page attributes for ${currentState.selectedPageId}',
        name: 'SpecEditorBloc._onPageAttributesUpdated',
      );
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
          LoggerService.commonLog(
            'Error: Page ${currentState.selectedPageId} not found in specData during attribute update.',
            name: 'SpecEditorBloc._onPageAttributesUpdated',
          );
        }
      } catch (e, stackTrace) {
        LoggerService.commonLog(
          'Error applying page attribute update',
          name: 'SpecEditorBloc._onPageAttributesUpdated',
          error: e,
          stackTrace: stackTrace,
        );
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
    LoggerService.commonLog(
      'TODO: Implement _onSectionAttributesUpdated if sections have spec attributes.',
      name: 'SpecEditorBloc._onSectionAttributesUpdated',
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
      LoggerService.commonLog(
        'Updating layout attributes for page ${currentState.selectedPageId}, layout ${currentState.selectedLayoutIndex}',
        name: 'SpecEditorBloc._onLayoutAttributesUpdated',
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
          LoggerService.commonLog(
            'Error: Layout not found in specData during attribute update.',
            name: 'SpecEditorBloc._onLayoutAttributesUpdated',
          );
        }
      } catch (e, stackTrace) {
        LoggerService.commonLog(
          'Error applying layout attribute update',
          name: 'SpecEditorBloc._onLayoutAttributesUpdated',
          error: e,
          stackTrace: stackTrace,
        );
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
      LoggerService.commonLog(
        'Updating widget attributes for page ${currentState.selectedPageId}, layout ${currentState.selectedLayoutIndex}, widget ${currentState.selectedWidgetIndex}',
        name: 'SpecEditorBloc._onWidgetAttributesUpdated',
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
            LoggerService.commonLog(
              'Error: Widget not found in layout children during attribute update.',
              name: 'SpecEditorBloc._onWidgetAttributesUpdated',
            );
          }
        } else {
          LoggerService.commonLog(
            'Error: Layout not found in specData during widget attribute update.',
            name: 'SpecEditorBloc._onWidgetAttributesUpdated',
          );
        }
      } catch (e, stackTrace) {
        LoggerService.commonLog(
          'Error applying widget attribute update',
          name: 'SpecEditorBloc._onWidgetAttributesUpdated',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _onSaveState(
    SpecEditorSaveStateEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    LoggerService.commonLog(
      'Save State Event received - implementation pending',
      name: 'SpecEditorBloc._onSaveState',
    );
  }

  Future<void> _onLoadState(
    SpecEditorLoadStateEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    LoggerService.commonLog(
      'Load State Event received - implementation pending',
      name: 'SpecEditorBloc._onLoadState',
    );
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
        LoggerService.commonLog(
          'Error: Dropped component data missing type information.',
          name: 'SpecEditorBloc._onComponentDropped',
        );
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
          LoggerService.commonLog(
            'Error: Current page not found in specData.',
            name: 'SpecEditorBloc._onComponentDropped',
          );
          return;
        }

        // Get body, ensuring type safety
        final body = currentPage['body'] as Map<String, dynamic>?;
        if (body == null || body['type'] != 'Renderer') {
          LoggerService.commonLog(
            'Error: Current page body is not a valid renderer.',
            name: 'SpecEditorBloc._onComponentDropped',
          );
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
        LoggerService.commonLog(
          'Error handling component drop',
          name: 'SpecEditorBloc._onComponentDropped',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _onSaveSpecRequested(
    SpecEditorSaveSpecRequested event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      emit(currentState.copyWith(isSaving: true)); // Indicate saving state
      try {
        LoggerService.commonLog(
          'Save spec requested for project $projectId',
          name: 'SpecEditorBloc._onSaveSpecRequested',
        );
        // Call the repository method with correct positional arguments
        await repository.saveSpec(projectId, currentState.specData);
        LoggerService.commonLog(
          'Save spec successful for project $projectId',
          name: 'SpecEditorBloc._onSaveSpecRequested',
        );
        emit(currentState.copyWith(isSaving: false)); // Clear saving state
        // Optionally, emit a success message or state
      } catch (e, stackTrace) {
        LoggerService.commonLog(
          'Error saving spec for project $projectId',
          name: 'SpecEditorBloc._onSaveSpecRequested',
          error: e,
          stackTrace: stackTrace,
        );
        emit(currentState.copyWith(isSaving: false)); // Clear saving state
        // Optionally, emit an error state
        // emit(SpecEditorErrorState(message: 'Failed to save spec: $e'));
      }
    }
  }

  // Handler for updating global actions
  Future<void> _onGlobalActionUpdated(
    SpecEditorGlobalActionUpdated event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      try {
        final newSpecData = _deepCopyMap(currentState.specData);
        // Ensure 'actions' map exists
        final actionsMap = Map<String, dynamic>.from(
          newSpecData['actions'] as Map<String, dynamic>? ?? {},
        );

        if (event.actionData != null) {
          // Add or Update
          actionsMap[event.actionId] = event.actionData;
          LoggerService.commonLog(
            'Added/Updated global action: ${event.actionId}',
            name: 'SpecEditorBloc._onGlobalActionUpdated',
          );
        } else {
          // Delete
          if (actionsMap.containsKey(event.actionId)) {
            actionsMap.remove(event.actionId);
            LoggerService.commonLog(
              'Deleted global action: ${event.actionId}',
              name: 'SpecEditorBloc._onGlobalActionUpdated',
            );
          } else {
            LoggerService.commonLog(
              'Attempted to delete non-existent action: ${event.actionId}',
              name: 'SpecEditorBloc._onGlobalActionUpdated',
            );
          }
        }

        newSpecData['actions'] = actionsMap;
        emit(currentState.copyWith(specData: newSpecData));
      } catch (e, stackTrace) {
        LoggerService.commonLog(
          'Error updating global action ${event.actionId}',
          name: 'SpecEditorBloc._onGlobalActionUpdated',
          error: e,
          stackTrace: stackTrace,
        );
        // Optionally emit an error state or log further
      }
    }
  }

  // Recursive helper to find and update an element's attribute in the spec JSON
  bool _updateElementAttributeInJson(
    dynamic componentJson,
    String targetId,
    String attributeKey,
    dynamic newValue,
  ) {
    if (componentJson is! Map<String, dynamic>) return false;

    if (componentJson['id'] == targetId) {
      // Assuming attributes are stored directly or under a 'props' or 'attributes' key
      // This needs to match the actual structure of your component JSON
      // For simplicity, let's assume WidgetModels have attributes in a 'props' map,
      // and RendererModels might have them directly or also in 'props'.
      // If 'props' doesn't exist, create it.
      if (!componentJson.containsKey('props')) {
        componentJson['props'] = <String, dynamic>{};
      }
      final props = componentJson['props'] as Map<String, dynamic>;
      props[attributeKey] = newValue;
      // If the attributeKey is fundamental like 'text' for TextWidgetModel and it's at top level, handle that too.
      // This part needs to align with how ComponentModel.toJson() structures the properties.
      // Example: if 'text' is a top-level property for TextWidgetModel in its JSON:
      if (componentJson.containsKey(attributeKey) &&
          componentJson['type'] == 'Text') {
        // Be more specific based on type if needed
        componentJson[attributeKey] = newValue;
      } else {
        // Default to updating/creating in 'props'
        if (!componentJson.containsKey('props')) {
          componentJson['props'] = <String, dynamic>{};
        }
        final propsMap = componentJson['props'] as Map<String, dynamic>;
        propsMap[attributeKey] = newValue;
        componentJson['props'] =
            propsMap; // Re-assign if propsMap was a new map
      }
      return true;
    }

    if (componentJson.containsKey('children') &&
        componentJson['children'] is List) {
      final children = componentJson['children'] as List<dynamic>;
      for (var i = 0; i < children.length; i++) {
        if (_updateElementAttributeInJson(
          children[i],
          targetId,
          attributeKey,
          newValue,
        )) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _onElementAttributeChanged(
    ElementAttributeChangedEvent event,
    Emitter<SpecEditorState> emit,
  ) async {
    final currentState = state;
    if (currentState is SpecEditorLoadedState) {
      LoggerService.commonLog(
        'Attempting to update attribute: ${event.attributeKey} for element ${event.elementId} to ${event.newValue}',
        name: 'SpecEditorBloc._onElementAttributeChanged',
      );

      try {
        // It's crucial to deep copy the specData to avoid mutating the current state directly.
        final newSpecData = _deepCopyMap(currentState.specData);
        var updated = false;

        if (newSpecData['screens'] is Map) {
          final screens = newSpecData['screens'] as Map<String, dynamic>;
          for (final screenKey in screens.keys) {
            final screenJson = screens[screenKey] as Map<String, dynamic>?;
            if (screenJson == null) continue;

            if (screenJson.containsKey('appBar')) {
              if (_updateElementAttributeInJson(
                screenJson['appBar'],
                event.elementId,
                event.attributeKey,
                event.newValue,
              )) {
                updated = true;
                break;
              }
            }
            if (screenJson.containsKey('body')) {
              if (_updateElementAttributeInJson(
                screenJson['body'],
                event.elementId,
                event.attributeKey,
                event.newValue,
              )) {
                updated = true;
                break;
              }
            }
            if (screenJson.containsKey('bottomNavBar')) {
              if (_updateElementAttributeInJson(
                screenJson['bottomNavBar'],
                event.elementId,
                event.attributeKey,
                event.newValue,
              )) {
                updated = true;
                break;
              }
            }
          }
        }

        if (updated) {
          LoggerService.commonLog(
            'Successfully updated attribute ${event.attributeKey} for element ${event.elementId}. New specData: ${jsonEncode(newSpecData)}',
            name: 'SpecEditorBloc._onElementAttributeChanged',
          );
          // TODO: Re-parse DevitySpec from newSpecData before emitting if state holds parsedSpec
          // For now, just emitting with new JSON data.
          // final newParsedSpec = DevitySpec.fromJson(newSpecData);

          emit(currentState.copyWith(specData: newSpecData));
        } else {
          LoggerService.commonLog(
            'Element with ID ${event.elementId} not found in spec for attribute update.',
            name: 'SpecEditorBloc._onElementAttributeChanged',
          );
        }
      } catch (e, stackTrace) {
        LoggerService.commonLog(
          'Error applying element attribute update to JSON spec',
          name: 'SpecEditorBloc._onElementAttributeChanged',
          error: e,
          stackTrace: stackTrace,
        );
        // Optionally emit an error state or re-emit current state
      }
    }
  }

  // --- Helper for deep copying ---
  Map<String, dynamic> _deepCopyMap(Map<String, dynamic> original) {
    // Now it correctly deep casts to Map<String, dynamic> throughout
    return _deepCastStringDynamicMap(original);
  }

  // Helper function to deeply cast maps (copied from SpecEditorRepository)
  Map<String, dynamic> _deepCastStringDynamicMap(Map originalMap) {
    final newMap = <String, dynamic>{};
    originalMap.forEach((key, value) {
      final stringKey = key.toString(); // Ensure key is a string
      if (value is Map) {
        newMap[stringKey] = _deepCastStringDynamicMap(value);
      } else if (value is List) {
        newMap[stringKey] = _deepCastList(value);
      } else {
        newMap[stringKey] = value;
      }
    });
    return newMap;
  }

  List<dynamic> _deepCastList(List originalList) {
    final newList = <dynamic>[];
    for (final item in originalList) {
      if (item is Map) {
        newList.add(_deepCastStringDynamicMap(item));
      } else if (item is List) {
        newList.add(_deepCastList(item));
      } else {
        newList.add(item);
      }
    }
    return newList;
  }
}

// --- Attribute Getter Helpers ---

Map<String, dynamic> _getPageAttributes(
  Map<String, dynamic> specData,
  String? pageId,
) {
  if (pageId == null) return {};
  final screens = specData['screens'] as Map<String, dynamic>?;
  final pageData = screens?[pageId] as Map<String, dynamic>?;
  if (pageData == null) {
    LoggerService.commonLog(
      'Error: Page $pageId not found in specData when getting attributes.',
      name: 'SpecEditorBloc._getPageAttributes',
    );
    return {};
  }
  // Return relevant page attributes (e.g., excluding complex children structures)
  // For now, let's return common ones like backgroundColor. Adjust as needed.
  return {
    'backgroundColor': pageData['backgroundColor'],
    // Add other direct page attributes here if they exist
  };
}

Map<String, dynamic> _getLayoutAttributes(
  Map<String, dynamic> specData,
  String? pageId,
  int?
      layoutIndex, // This index might refer to the position within the page body's children
) {
  if (pageId == null || layoutIndex == null) return {};

  final screens = specData['screens'] as Map<String, dynamic>?;
  final pageData = screens?[pageId] as Map<String, dynamic>?;
  final body = pageData?['body'] as Map<String, dynamic>?;
  final children = body?['children'] as List<dynamic>?;

  if (children == null || layoutIndex < 0 || layoutIndex >= children.length) {
    LoggerService.commonLog(
      'Error: Invalid layoutIndex $layoutIndex or missing children for page $pageId.',
      name: 'SpecEditorBloc._getLayoutAttributes',
    );
    return {};
  }

  final layoutData = children[layoutIndex] as Map<String, dynamic>?;
  if (layoutData == null) {
    LoggerService.commonLog(
      'Error: Layout data at index $layoutIndex is null or not a map for page $pageId.',
      name: 'SpecEditorBloc._getLayoutAttributes',
    );
    return {};
  }

  // Return attributes, excluding children for simplicity in the attribute editor
  final attributes = Map<String, dynamic>.from(layoutData);
  attributes.remove('children');
  attributes.remove('id'); // Usually don't edit ID directly here
  // Add component type for display maybe?
  attributes['componentType'] = layoutData['type'];
  return attributes;
}

Map<String, dynamic> _getWidgetAttributes(
  Map<String, dynamic> specData,
  String? pageId,
  int? layoutIndex,
  int? widgetIndex,
) {
  if (pageId == null || layoutIndex == null || widgetIndex == null) return {};

  final screens = specData['screens'] as Map<String, dynamic>?;
  final pageData = screens?[pageId] as Map<String, dynamic>?;
  final body = pageData?['body'] as Map<String, dynamic>?;
  final layoutChildren = body?['children'] as List<dynamic>?;

  if (layoutChildren == null ||
      layoutIndex < 0 ||
      layoutIndex >= layoutChildren.length) {
    // Log error if layout index is invalid
    LoggerService.commonLog(
      'Error: Invalid layoutIndex $layoutIndex when getting widget attributes for page $pageId.',
      name: 'SpecEditorBloc._getWidgetAttributes',
    );
    return {};
  }

  final layoutData = layoutChildren[layoutIndex] as Map<String, dynamic>?;
  final widgetChildren = layoutData?['children'] as List<dynamic>?;

  if (widgetChildren == null ||
      widgetIndex < 0 ||
      widgetIndex >= widgetChildren.length) {
    // Log error if widget index is invalid
    LoggerService.commonLog(
      'Error: Invalid widgetIndex $widgetIndex for layout $layoutIndex on page $pageId.',
      name: 'SpecEditorBloc._getWidgetAttributes',
    );
    return {};
  }

  final widgetData = widgetChildren[widgetIndex] as Map<String, dynamic>?;
  if (widgetData == null) {
    LoggerService.commonLog(
      'Error: Widget data at index $widgetIndex is null or not a map for layout $layoutIndex, page $pageId.',
      name: 'SpecEditorBloc._getWidgetAttributes',
    );
    return {};
  }

  // Return attributes, maybe exclude complex fields like 'children' if widgets can have them
  final attributes = Map<String, dynamic>.from(widgetData);
  attributes.remove('children'); // If widgets could contain children
  attributes.remove('id'); // Usually don't edit ID directly here
  // Add component type for display
  attributes['componentType'] = widgetData['type'];
  return attributes;
}

import 'package:bloc/bloc.dart';
import 'package:devity_console/models/custom_widget.dart';
import 'package:devity_console/models/widget.dart'; // AppWidget
import 'package:devity_console/modules/spec_editor_page_editor/models/layout.dart'; // LayoutType
import 'package:devity_console/repositories/custom_widget_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'
    show IconData, Icons; // For default icons
import 'package:uuid/uuid.dart';

// --- Events ---
abstract class WidgetBuilderEvent extends Equatable {
  const WidgetBuilderEvent();
  @override
  List<Object?> get props => [];
}

class WidgetBuilderStarted extends WidgetBuilderEvent {}

class WidgetBuilderCreateNewTemplateClicked extends WidgetBuilderEvent {}

class WidgetBuilderEditTemplateClicked extends WidgetBuilderEvent {
  const WidgetBuilderEditTemplateClicked(this.templateId);
  final String templateId;
  @override
  List<Object?> get props => [templateId];
}

class WidgetBuilderSaveTemplateRequested extends WidgetBuilderEvent {
  // If editing, existingTemplateId might be needed, or use state.editingTemplateId
  const WidgetBuilderSaveTemplateRequested({
    required this.name,
    required this.description,
    required this.isPublic,
  });
  final String name;
  final String description;
  final bool isPublic;
  @override
  List<Object?> get props => [name, description, isPublic];
}

class WidgetBuilderDeleteTemplateClicked extends WidgetBuilderEvent {
  const WidgetBuilderDeleteTemplateClicked(this.templateId);
  final String templateId;
  @override
  List<Object?> get props => [templateId];
}

class WidgetBuilderAvailableWidgetDraggedToCanvas extends WidgetBuilderEvent {
  // The standard widget being added
  const WidgetBuilderAvailableWidgetDraggedToCanvas(this.widget);
  final AppWidget widget;
  @override
  List<Object?> get props => [widget];
}

class WidgetBuilderCanvasWidgetRemoved extends WidgetBuilderEvent {
  // Index of the widget on canvas to remove
  const WidgetBuilderCanvasWidgetRemoved(this.widgetIndex);
  final int widgetIndex;
  @override
  List<Object?> get props => [widgetIndex];
}

class WidgetBuilderCanvasLayoutChanged extends WidgetBuilderEvent {
  const WidgetBuilderCanvasLayoutChanged(this.layoutType);
  final LayoutType layoutType;
  @override
  List<Object?> get props => [layoutType];
}

class WidgetBuilderCanvasWidgetSelected extends WidgetBuilderEvent {
  // null to deselect
  const WidgetBuilderCanvasWidgetSelected(this.widgetIndex);
  final int? widgetIndex;
  @override
  List<Object?> get props => [widgetIndex];
}

class WidgetBuilderCanvasWidgetPropertiesChanged extends WidgetBuilderEvent {
  const WidgetBuilderCanvasWidgetPropertiesChanged(
      this.widgetIndex, this.newProperties);
  final int widgetIndex;
  final Map<String, dynamic> newProperties;
  @override
  List<Object?> get props => [widgetIndex, newProperties];
}

// --- States ---
abstract class WidgetBuilderState extends Equatable {
  const WidgetBuilderState();
  @override
  List<Object?> get props => [];
}

class WidgetBuilderInitial extends WidgetBuilderState {}

class WidgetBuilderLoading extends WidgetBuilderState {}

class WidgetBuilderLoaded extends WidgetBuilderState {
  const WidgetBuilderLoaded({
    this.availableStandardWidgets = const [],
    this.customWidgetTemplates = const [],
    this.editingTemplateId,
    this.currentCustomWidgetOnCanvasData,
    this.selectedWidgetIndexOnCanvas,
  });
  final List<AppWidget> availableStandardWidgets;
  final List<CustomWidget> customWidgetTemplates;
  final String? editingTemplateId; // ID of CustomWidget being edited
  final CustomWidget?
      currentCustomWidgetOnCanvasData; // The data for the canvas
  final int? selectedWidgetIndexOnCanvas;

  @override
  List<Object?> get props => [
        availableStandardWidgets,
        customWidgetTemplates,
        editingTemplateId,
        currentCustomWidgetOnCanvasData,
        selectedWidgetIndexOnCanvas,
      ];

  WidgetBuilderLoaded copyWith({
    List<AppWidget>? availableStandardWidgets,
    List<CustomWidget>? customWidgetTemplates,
    String? editingTemplateId,
    CustomWidget? currentCustomWidgetOnCanvasData,
    int? selectedWidgetIndexOnCanvas,
    bool clearEditingTemplateId = false,
    bool clearCurrentCustomWidget = false,
    bool clearSelectedWidgetIndex = false,
  }) {
    return WidgetBuilderLoaded(
      availableStandardWidgets:
          availableStandardWidgets ?? this.availableStandardWidgets,
      customWidgetTemplates:
          customWidgetTemplates ?? this.customWidgetTemplates,
      editingTemplateId: clearEditingTemplateId
          ? null
          : (editingTemplateId ?? this.editingTemplateId),
      currentCustomWidgetOnCanvasData: clearCurrentCustomWidget
          ? null
          : (currentCustomWidgetOnCanvasData ??
              this.currentCustomWidgetOnCanvasData),
      selectedWidgetIndexOnCanvas: clearSelectedWidgetIndex
          ? null
          : (selectedWidgetIndexOnCanvas ?? this.selectedWidgetIndexOnCanvas),
    );
  }
}

class WidgetBuilderError extends WidgetBuilderState {
  const WidgetBuilderError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class WidgetBuilderBloc extends Bloc<WidgetBuilderEvent, WidgetBuilderState> {
  WidgetBuilderBloc({required this.projectId, required this.repository})
      : super(WidgetBuilderInitial()) {
    on<WidgetBuilderStarted>(_onStarted);
    on<WidgetBuilderCreateNewTemplateClicked>(_onCreateNewTemplateClicked);
    on<WidgetBuilderEditTemplateClicked>(_onEditTemplateClicked);
    on<WidgetBuilderSaveTemplateRequested>(_onSaveTemplateRequested);
    on<WidgetBuilderDeleteTemplateClicked>(_onDeleteTemplateClicked);
    on<WidgetBuilderAvailableWidgetDraggedToCanvas>(
        _onAvailableWidgetDraggedToCanvas);
    on<WidgetBuilderCanvasWidgetRemoved>(_onCanvasWidgetRemoved);
    on<WidgetBuilderCanvasLayoutChanged>(_onCanvasLayoutChanged);
    on<WidgetBuilderCanvasWidgetSelected>(_onCanvasWidgetSelected);
    on<WidgetBuilderCanvasWidgetPropertiesChanged>(
        _onCanvasWidgetPropertiesChanged);
  }
  final String projectId;
  final CustomWidgetRepository repository;
  final Uuid _uuid = const Uuid();

  // Define the list of standard available widgets
  // This could also be loaded from a config or another repository
  final List<AppWidget> _standardWidgets = [
    const AppWidget(
        id: 'text',
        name: 'Text',
        type: 'text',
        icon: Icons.text_fields,
        description: 'Displays a string of text',
        properties: {'text': 'Sample Text'}),
    const AppWidget(
        id: 'button',
        name: 'Button',
        type: 'button',
        icon: Icons.touch_app,
        description: 'A button that can be pressed',
        properties: {'text': 'Button'}),
    const AppWidget(
        id: 'container',
        name: 'Container',
        type: 'container',
        icon: Icons.check_box_outline_blank,
        description: 'A container that can hold other widgets',
        properties: {'color': '#FFFFFF'}),
    // TODO: Add more standard widgets (Image, Row, Column, Stack, TextField etc.)
  ];

  Future<void> _onStarted(
    WidgetBuilderStarted event,
    Emitter<WidgetBuilderState> emit,
  ) async {
    emit(WidgetBuilderLoading());
    try {
      final customTemplates = await repository.loadCustomWidgets(projectId);
      emit(
        WidgetBuilderLoaded(
          availableStandardWidgets: _standardWidgets,
          customWidgetTemplates: customTemplates,
        ),
      );
    } catch (e) {
      emit(WidgetBuilderError('Failed to load widget templates: $e'));
    }
  }

  void _onCreateNewTemplateClicked(
    WidgetBuilderCreateNewTemplateClicked event,
    Emitter<WidgetBuilderState> emit,
  ) {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded) {
      emit(
        currentState.copyWith(
          clearEditingTemplateId: true,
          currentCustomWidgetOnCanvasData: CustomWidget(
            id: _uuid.v4(),
            name: 'New Custom Widget',
            type: 'custom',
            icon: Icons.widgets,
            description: '',
            isPublic: false,
            layout: LayoutType.vertical,
            components: [],
          ),
          clearSelectedWidgetIndex: true,
        ),
      );
    }
  }

  Future<void> _onEditTemplateClicked(
    WidgetBuilderEditTemplateClicked event,
    Emitter<WidgetBuilderState> emit,
  ) async {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded) {
      final templateToEdit = currentState.customWidgetTemplates.firstWhere(
        (t) => t.id == event.templateId,
        orElse: () =>
            null as CustomWidget, // Should not happen if UI is correct
      );
      emit(
        currentState.copyWith(
          editingTemplateId: templateToEdit.id,
          currentCustomWidgetOnCanvasData: templateToEdit,
          clearSelectedWidgetIndex: true,
        ),
      );
    }
  }

  Future<void> _onSaveTemplateRequested(
    WidgetBuilderSaveTemplateRequested event,
    Emitter<WidgetBuilderState> emit,
  ) async {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded &&
        currentState.currentCustomWidgetOnCanvasData != null) {
      emit(WidgetBuilderLoading()); // Or a specific saving state
      try {
        final widgetToSave =
            currentState.currentCustomWidgetOnCanvasData!.copyWith(
          name: event.name,
          description: event.description,
          isPublic: event.isPublic,
          id: currentState.editingTemplateId ??
              currentState.currentCustomWidgetOnCanvasData!.id,
        );

        await repository.saveCustomWidget(projectId, widgetToSave);
        final updatedTemplates = await repository.loadCustomWidgets(projectId);

        emit(
          currentState.copyWith(
            // Go back to loaded state
            customWidgetTemplates: updatedTemplates,
            editingTemplateId:
                widgetToSave.id, // Keep it selected for further edits
            currentCustomWidgetOnCanvasData:
                widgetToSave, // Pass the value directly
            // selectedWidgetIndexOnCanvas: null, // Optionally deselect
            // clearSelectedWidgetIndex: true, // If deselecting
          ),
        );
      } catch (e) {
        emit(WidgetBuilderError('Failed to save widget template: $e'));
        // Optionally, revert to previous loaded state if save fails and we want to preserve canvas
        // For now, just shows error. User might need to re-trigger edit/create.
      }
    }
  }

  Future<void> _onDeleteTemplateClicked(
    WidgetBuilderDeleteTemplateClicked event,
    Emitter<WidgetBuilderState> emit,
  ) async {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded) {
      emit(WidgetBuilderLoading()); // Or a specific deleting state
      try {
        await repository.deleteCustomWidget(projectId, event.templateId);
        final updatedTemplates = await repository.loadCustomWidgets(projectId);

        var newEditingId = currentState.editingTemplateId;
        var newCanvasData = currentState.currentCustomWidgetOnCanvasData;

        if (currentState.editingTemplateId == event.templateId) {
          newEditingId = null;
          newCanvasData = null;
        }

        emit(
          WidgetBuilderLoaded(
            // Go back to loaded state
            availableStandardWidgets: currentState.availableStandardWidgets,
            customWidgetTemplates: updatedTemplates,
            editingTemplateId: newEditingId,
            currentCustomWidgetOnCanvasData: newCanvasData,
          ),
        );
      } catch (e) {
        emit(WidgetBuilderError('Failed to delete widget template: $e'));
        // Revert to previous loaded state if delete fails
        emit(currentState); // Or a more specific error recovery
      }
    }
  }

  void _onAvailableWidgetDraggedToCanvas(
    WidgetBuilderAvailableWidgetDraggedToCanvas event,
    Emitter<WidgetBuilderState> emit,
  ) {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded &&
        currentState.currentCustomWidgetOnCanvasData != null) {
      // Create a new instance of the AppWidget for the canvas
      // Potentially with a new unique ID if these canvas instances need to be identified
      final newWidgetInstance = event.widget.copyWith(id: _uuid.v4());

      final updatedComponents = List<AppWidget>.from(
          currentState.currentCustomWidgetOnCanvasData!.components)
        ..add(newWidgetInstance);

      final updatedCanvasData =
          currentState.currentCustomWidgetOnCanvasData!.copyWith(
        components: updatedComponents,
      );
      emit(currentState.copyWith(
          currentCustomWidgetOnCanvasData: updatedCanvasData));
    }
  }

  void _onCanvasWidgetRemoved(
    WidgetBuilderCanvasWidgetRemoved event,
    Emitter<WidgetBuilderState> emit,
  ) {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded &&
        currentState.currentCustomWidgetOnCanvasData != null) {
      if (event.widgetIndex >= 0 &&
          event.widgetIndex <
              currentState.currentCustomWidgetOnCanvasData!.components.length) {
        final updatedComponents = List<AppWidget>.from(
            currentState.currentCustomWidgetOnCanvasData!.components)
          ..removeAt(event.widgetIndex);

        final updatedCanvasData =
            currentState.currentCustomWidgetOnCanvasData!.copyWith(
          components: updatedComponents,
        );
        emit(
          currentState.copyWith(
            currentCustomWidgetOnCanvasData: updatedCanvasData,
            clearSelectedWidgetIndex: true,
          ),
        );
      }
    }
  }

  void _onCanvasLayoutChanged(
    WidgetBuilderCanvasLayoutChanged event,
    Emitter<WidgetBuilderState> emit,
  ) {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded &&
        currentState.currentCustomWidgetOnCanvasData != null) {
      final updatedCanvasData =
          currentState.currentCustomWidgetOnCanvasData!.copyWith(
        layout: event.layoutType,
      );
      emit(currentState.copyWith(
          currentCustomWidgetOnCanvasData: updatedCanvasData));
    }
  }

  void _onCanvasWidgetSelected(
    WidgetBuilderCanvasWidgetSelected event,
    Emitter<WidgetBuilderState> emit,
  ) {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded) {
      emit(currentState.copyWith(
          selectedWidgetIndexOnCanvas: event.widgetIndex));
    }
  }

  void _onCanvasWidgetPropertiesChanged(
    WidgetBuilderCanvasWidgetPropertiesChanged event,
    Emitter<WidgetBuilderState> emit,
  ) {
    final currentState = state;
    if (currentState is WidgetBuilderLoaded &&
        currentState.currentCustomWidgetOnCanvasData != null &&
        event.widgetIndex >= 0 &&
        event.widgetIndex <
            currentState.currentCustomWidgetOnCanvasData!.components.length) {
      final updatedComponents = List<AppWidget>.from(
          currentState.currentCustomWidgetOnCanvasData!.components);
      final oldWidget = updatedComponents[event.widgetIndex];

      // Create new properties map, starting with old, then overlaying new ones
      final newProps = Map<String, dynamic>.from(oldWidget.properties)
        ..addAll(event.newProperties);

      updatedComponents[event.widgetIndex] =
          oldWidget.copyWith(properties: newProps);

      final updatedCanvasData =
          currentState.currentCustomWidgetOnCanvasData!.copyWith(
        components: updatedComponents,
      );
      emit(currentState.copyWith(
          currentCustomWidgetOnCanvasData: updatedCanvasData));
    }
  }
}

// Helper extension for AppWidget.copyWith (if not already present in model)
// This is a common pattern if the model itself doesn't have a full copyWith
extension AppWidgetCopyWith on AppWidget {
  AppWidget copyWith({
    String? id,
    String? name,
    String? type,
    IconData? icon,
    String? description,
    Map<String, dynamic>? properties,
  }) {
    return AppWidget(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      properties: properties ?? this.properties,
    );
  }
}

// Helper extension for CustomWidget.copyWith (if not already present in model)
extension CustomWidgetCopyWith on CustomWidget {
  CustomWidget copyWith({
    String? id,
    String? name,
    String? type,
    IconData? icon,
    String? description,
    bool? isPublic,
    LayoutType? layout,
    List<AppWidget>? components,
    Map<String, dynamic>? properties,
  }) {
    return CustomWidget(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type, // should remain 'custom' generally
      icon: icon ?? this.icon,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      layout: layout ?? this.layout,
      components: components ?? this.components,
      properties: properties ?? this.properties,
    );
  }
}

import 'package:devity_console/models/custom_widget.dart';
import 'package:devity_console/models/widget.dart';
import 'package:devity_console/modules/widget_builder/bloc/widget_builder_event.dart';
import 'package:devity_console/modules/widget_builder/bloc/widget_builder_state.dart';
import 'package:devity_console/repositories/custom_widget_repository.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/// The bloc that manages the state of the widget builder
class WidgetBuilderBloc extends Bloc<WidgetBuilderEvent, WidgetBuilderState> {
  /// Creates a new [WidgetBuilderBloc]
  WidgetBuilderBloc({
    required this.projectId,
    required this.repository,
  }) : super(const WidgetBuilderInitial()) {
    on<WidgetBuilderLoadWidgets>(_onLoadWidgets);
    on<WidgetBuilderLayoutSelected>(_onLayoutSelected);
    on<WidgetBuilderWidgetAdded>(_onWidgetAdded);
    on<WidgetBuilderWidgetRemoved>(_onWidgetRemoved);
    on<WidgetBuilderCustomWidgetCreated>(_onCustomWidgetCreated);
  }

  /// The ID of the current project
  final String projectId;

  /// Repository for managing custom widgets
  final CustomWidgetRepository repository;

  final List<AppWidget> _widgets = [
    const AppWidget(
      id: 'text',
      name: 'Text',
      type: 'text',
      icon: Icons.text_fields,
      description: 'A text widget that displays a string of text',
      properties: {
        'text': 'Sample Text',
        'style': {
          'fontSize': 14.0,
          'color': '#000000',
        },
      },
    ),
    const AppWidget(
      id: 'button',
      name: 'Button',
      type: 'button',
      icon: Icons.touch_app,
      description: 'A button widget that can be pressed',
      properties: {
        'text': 'Button',
        'style': {
          'backgroundColor': '#2196F3',
          'textColor': '#FFFFFF',
        },
      },
    ),
    const AppWidget(
      id: 'container',
      name: 'Container',
      type: 'container',
      icon: Icons.view_agenda,
      description: 'A container widget that can hold other widgets',
      properties: {
        'color': '#FFFFFF',
        'padding': 8.0,
      },
    ),
  ];

  Future<void> _onLoadWidgets(
    WidgetBuilderLoadWidgets event,
    Emitter<WidgetBuilderState> emit,
  ) async {
    emit(const WidgetBuilderLoading());
    try {
      final customWidgets = await repository.loadCustomWidgets(projectId);
      emit(
        WidgetBuilderLoaded(
          widgets: _widgets,
          customWidgets: customWidgets,
        ),
      );
    } catch (e) {
      emit(WidgetBuilderError(e.toString()));
    }
  }

  void _onLayoutSelected(
    WidgetBuilderLayoutSelected event,
    Emitter<WidgetBuilderState> emit,
  ) {
    if (state is! WidgetBuilderLoaded) return;
    final currentState = state as WidgetBuilderLoaded;
    emit(
      currentState.copyWith(
        selectedLayout: event.layout,
        selectedWidgets: const [],
      ),
    );
  }

  void _onWidgetAdded(
    WidgetBuilderWidgetAdded event,
    Emitter<WidgetBuilderState> emit,
  ) {
    if (state is! WidgetBuilderLoaded) return;
    final currentState = state as WidgetBuilderLoaded;
    if (currentState.selectedLayout == null) return;
    emit(
      currentState.copyWith(
        selectedWidgets: [...currentState.selectedWidgets, event.widget],
      ),
    );
  }

  void _onWidgetRemoved(
    WidgetBuilderWidgetRemoved event,
    Emitter<WidgetBuilderState> emit,
  ) {
    if (state is! WidgetBuilderLoaded) return;
    final currentState = state as WidgetBuilderLoaded;
    if (currentState.selectedLayout == null) return;
    final newWidgets = [...currentState.selectedWidgets]..removeAt(event.index);
    emit(currentState.copyWith(selectedWidgets: newWidgets));
  }

  Future<void> _onCustomWidgetCreated(
    WidgetBuilderCustomWidgetCreated event,
    Emitter<WidgetBuilderState> emit,
  ) async {
    if (state is! WidgetBuilderLoaded) return;
    final currentState = state as WidgetBuilderLoaded;
    if (currentState.selectedLayout == null) return;

    try {
      final customWidget = CustomWidget(
        id: const Uuid().v4(),
        name: event.name,
        type: 'custom',
        icon: Icons.widgets,
        description: event.description,
        isPublic: event.isPublic,
        layout: currentState.selectedLayout!,
        components: currentState.selectedWidgets,
      );

      await repository.saveCustomWidget(projectId, customWidget);
      final customWidgets = await repository.loadCustomWidgets(projectId);
      emit(
        currentState.copyWith(
          customWidgets: customWidgets,
          selectedWidgets: const [],
        ),
      );
    } catch (e) {
      emit(WidgetBuilderError(e.toString()));
    }
  }
}

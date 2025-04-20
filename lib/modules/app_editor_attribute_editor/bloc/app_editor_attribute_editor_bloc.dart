import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devity_console/models/attribute.dart';
import 'package:devity_console/models/project.dart';
import 'app_editor_attribute_editor_event.dart';
import 'app_editor_attribute_editor_state.dart';

/// Bloc for managing the app editor attribute editor
class AppEditorAttributeEditorBloc
    extends Bloc<AppEditorAttributeEditorEvent, AppEditorAttributeEditorState> {
  AppEditorAttributeEditorBloc() : super(AppEditorAttributeEditorInitial()) {
    on<AppEditorAttributeEditorInitializeEvent>(_onInitialize);
    on<AppEditorAttributeEditorUpdateEvent>(_onUpdate);
    on<AppEditorAttributeEditorDeleteEvent>(_onDelete);
    on<AppEditorAttributeEditorAddEvent>(_onAdd);
  }

  Future<void> _onInitialize(
    AppEditorAttributeEditorInitializeEvent event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) async {
    try {
      emit(AppEditorAttributeEditorLoading());
      // TODO: Load initial data
      emit(AppEditorAttributeEditorLoaded(
        attributes: [],
        project: Project(
            id: '',
            name: '',
            description: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
      ));
    } catch (e) {
      emit(AppEditorAttributeEditorError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    AppEditorAttributeEditorUpdateEvent event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) async {
    try {
      emit(AppEditorAttributeEditorLoading());
      // TODO: Update attribute
      emit(AppEditorAttributeEditorLoaded(
        attributes: [],
        project: Project(
            id: '',
            name: '',
            description: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
      ));
    } catch (e) {
      emit(AppEditorAttributeEditorError(e.toString()));
    }
  }

  Future<void> _onDelete(
    AppEditorAttributeEditorDeleteEvent event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) async {
    try {
      emit(AppEditorAttributeEditorLoading());
      // TODO: Delete attribute
      emit(AppEditorAttributeEditorLoaded(
        attributes: [],
        project: Project(
            id: '',
            name: '',
            description: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
      ));
    } catch (e) {
      emit(AppEditorAttributeEditorError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AppEditorAttributeEditorAddEvent event,
    Emitter<AppEditorAttributeEditorState> emit,
  ) async {
    try {
      emit(AppEditorAttributeEditorLoading());
      // TODO: Add attribute
      emit(AppEditorAttributeEditorLoaded(
        attributes: [],
        project: Project(
            id: '',
            name: '',
            description: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
      ));
    } catch (e) {
      emit(AppEditorAttributeEditorError(e.toString()));
    }
  }
}

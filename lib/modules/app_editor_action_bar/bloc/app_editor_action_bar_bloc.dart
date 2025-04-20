import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_editor_action_bar_event.dart';
import 'app_editor_action_bar_state.dart';

/// Bloc for managing the app editor action bar
class AppEditorActionBarBloc
    extends Bloc<AppEditorActionBarEvent, AppEditorActionBarState> {
  AppEditorActionBarBloc() : super(AppEditorActionBarInitial()) {
    on<AppEditorActionBarInitializeEvent>(_onInitialize);
    on<AppEditorActionBarSaveEvent>(_onSave);
    on<AppEditorActionBarSettingsEvent>(_onSettings);
    on<AppEditorActionBarBackEvent>(_onBack);
  }

  Future<void> _onInitialize(
    AppEditorActionBarInitializeEvent event,
    Emitter<AppEditorActionBarState> emit,
  ) async {
    try {
      emit(AppEditorActionBarLoading());
      // TODO: Load initial data
      emit(AppEditorActionBarLoaded(
        lastSaved: 'Never',
        isDirty: false,
      ));
    } catch (e) {
      emit(AppEditorActionBarError(e.toString()));
    }
  }

  Future<void> _onSave(
    AppEditorActionBarSaveEvent event,
    Emitter<AppEditorActionBarState> emit,
  ) async {
    try {
      emit(AppEditorActionBarLoading());
      // TODO: Save app
      emit(AppEditorActionBarLoaded(
        lastSaved: 'Just now',
        isDirty: false,
      ));
    } catch (e) {
      emit(AppEditorActionBarError(e.toString()));
    }
  }

  Future<void> _onSettings(
    AppEditorActionBarSettingsEvent event,
    Emitter<AppEditorActionBarState> emit,
  ) async {
    try {
      emit(AppEditorActionBarLoading());
      // TODO: Open settings
      emit(AppEditorActionBarLoaded(
        lastSaved: 'Never',
        isDirty: true,
      ));
    } catch (e) {
      emit(AppEditorActionBarError(e.toString()));
    }
  }

  Future<void> _onBack(
    AppEditorActionBarBackEvent event,
    Emitter<AppEditorActionBarState> emit,
  ) async {
    try {
      emit(AppEditorActionBarLoading());
      // TODO: Handle back navigation
      emit(AppEditorActionBarLoaded(
        lastSaved: 'Never',
        isDirty: true,
      ));
    } catch (e) {
      emit(AppEditorActionBarError(e.toString()));
    }
  }
}

import 'dart:convert';

import 'package:devity_console/modules/spec_editor/bloc/spec_editor_event.dart';
import 'package:devity_console/modules/spec_editor/bloc/spec_editor_state.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';
import 'package:devity_console/services/spec_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecEditorBloc extends Bloc<SpecEditorEvent, SpecEditorConcreteState> {
  final SpecService _specService;
  final JsonEncoder _encoder =
      const JsonEncoder.withIndent('  '); // For pretty printing

  SpecEditorBloc({SpecService? specService})
      : _specService = specService ??
            SpecService(
              networkService: NetworkService(
                errorHandler: ErrorHandlerService(),
              ),
            ),
        // Initialize with the concrete state
        super(const SpecEditorConcreteState(status: SpecEditorStatus.initial)) {
    on<SpecEditorLoadRequested>(_onLoadRequested);
    on<SpecEditorContentChanged>(_onContentChanged);
    on<SpecEditorSaveRequested>(_onSaveRequested);
  }

  Future<void> _onLoadRequested(
    SpecEditorLoadRequested event,
    Emitter<SpecEditorConcreteState> emit,
  ) async {
    emit(state.copyWith(
        status: SpecEditorStatus.loading,
        specId: event.specId,
        clearError: true));
    try {
      final specContentMap = await _specService.getSpecContent(event.specId);
      // Pretty print the JSON for the editor
      final formattedJson = _encoder.convert(specContentMap);
      emit(state.copyWith(
        status: SpecEditorStatus.loaded,
        currentContent: formattedJson,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SpecEditorStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onContentChanged(
    SpecEditorContentChanged event,
    Emitter<SpecEditorConcreteState> emit,
  ) {
    // Simply update the content in the state
    emit(state.copyWith(
        currentContent: event.newContent, status: SpecEditorStatus.loaded));
  }

  Future<void> _onSaveRequested(
    SpecEditorSaveRequested event,
    Emitter<SpecEditorConcreteState> emit,
  ) async {
    if (state.specId.isEmpty) {
      emit(state.copyWith(
          status: SpecEditorStatus.error,
          errorMessage: 'No Spec ID available to save.'));
      return;
    }

    emit(state.copyWith(status: SpecEditorStatus.saving, clearError: true));
    try {
      // Attempt to parse the current content back to a Map
      // Explicitly cast the decoded JSON
      final Map<String, dynamic> contentToSave =
          json.decode(state.currentContent) as Map<String, dynamic>;

      await _specService.updateSpecContent(state.specId, contentToSave);
      // If save is successful, remain in loaded state (or add a specific 'saved' status)
      emit(state.copyWith(status: SpecEditorStatus.loaded));
      // TODO: Show success feedback to the user (e.g., snackbar)
    } catch (e) {
      // Handle JSON parsing errors or API errors
      emit(state.copyWith(
        status: SpecEditorStatus.error,
        errorMessage: 'Failed to save: ${e.toString()}',
      ));
    }
  }
}

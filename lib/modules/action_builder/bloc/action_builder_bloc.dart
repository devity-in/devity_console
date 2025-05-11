import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:equatable/equatable.dart';

// -- Events --
abstract class ActionBuilderEvent extends Equatable {
  const ActionBuilderEvent();
  @override
  List<Object?> get props => []; // Allow nullable for Object comparison
}

// Removed LoadRequested, as loading is now driven by SpecEditorBloc
// class ActionBuilderLoadRequested extends ActionBuilderEvent {}

// Event to signal that SpecEditorBloc state has changed
class _SpecEditorStateUpdated extends ActionBuilderEvent {
  const _SpecEditorStateUpdated(this.specEditorState);
  final SpecEditorState specEditorState;
  @override
  List<Object> get props => [specEditorState];
}

// Event to add a new global action
class ActionBuilderAddAction extends ActionBuilderEvent {
  // Contains actionType and attributes

  const ActionBuilderAddAction({
    required this.actionId,
    required this.actionData,
  });
  final String actionId;
  final Map<String, dynamic> actionData;

  @override
  List<Object> get props => [actionId, actionData];
}

// Event to update an existing global action
class ActionBuilderUpdateAction extends ActionBuilderEvent {
  const ActionBuilderUpdateAction({
    required this.actionId,
    required this.actionData,
  });
  final String actionId;
  final Map<String, dynamic> actionData;

  @override
  List<Object> get props => [actionId, actionData];
}

// Event to delete a global action
class ActionBuilderDeleteAction extends ActionBuilderEvent {
  const ActionBuilderDeleteAction({required this.actionId});
  final String actionId;

  @override
  List<Object> get props => [actionId];
}

// -- States --
abstract class ActionBuilderState extends Equatable {
  const ActionBuilderState();
  @override
  List<Object> get props => [];
}

class ActionBuilderInitial extends ActionBuilderState {}

class ActionBuilderLoading extends ActionBuilderState {}

class ActionBuilderLoaded extends ActionBuilderState {
  const ActionBuilderLoaded({required this.actions});
  // TODO: Replace dynamic with a proper Action model if defined in console
  final Map<String, dynamic> actions;
  @override
  List<Object> get props => [actions];
}

class ActionBuilderError extends ActionBuilderState {
  const ActionBuilderError({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

// -- Bloc --
class ActionBuilderBloc extends Bloc<ActionBuilderEvent, ActionBuilderState> {
  ActionBuilderBloc({required SpecEditorBloc specEditorBloc})
      : _specEditorBloc = specEditorBloc,
        super(ActionBuilderInitial()) {
    on<_SpecEditorStateUpdated>(_onSpecEditorStateUpdated);
    // Register handlers for action modifications
    on<ActionBuilderAddAction>(_onAddAction);
    on<ActionBuilderUpdateAction>(_onUpdateAction);
    on<ActionBuilderDeleteAction>(_onDeleteAction);

    _processSpecEditorState(_specEditorBloc.state);
    _specEditorSubscription = _specEditorBloc.stream.listen((state) {
      add(_SpecEditorStateUpdated(state));
    });
  }
  final SpecEditorBloc _specEditorBloc;
  StreamSubscription? _specEditorSubscription;

  void _processSpecEditorState(SpecEditorState specState) {
    if (specState is SpecEditorLoadedState) {
      final actionsMap =
          specState.specData['actions'] as Map<String, dynamic>? ?? {};
      emit(ActionBuilderLoaded(actions: actionsMap));
    } else if (specState is SpecEditorLoadingState) {
      emit(ActionBuilderLoading());
    } else if (specState is SpecEditorErrorState) {
      emit(
        ActionBuilderError(
          message: 'Error loading spec data: ${specState.message}',
        ),
      );
    } else if (state is ActionBuilderInitial) {
      emit(ActionBuilderLoading());
    }
  }

  void _onSpecEditorStateUpdated(
    _SpecEditorStateUpdated event,
    Emitter<ActionBuilderState> emit,
  ) {
    _processSpecEditorState(event.specEditorState);
  }

  // Handler for adding an action
  void _onAddAction(
    ActionBuilderAddAction event,
    Emitter<ActionBuilderState> emit,
  ) {
    // Add event to SpecEditorBloc to perform the actual state update
    _specEditorBloc.add(
      SpecEditorGlobalActionUpdated(
        actionId: event.actionId,
        actionData: event.actionData,
      ),
    );
    // ActionBuilderBloc state will update automatically when SpecEditorBloc emits new state
  }

  // Handler for updating an action
  void _onUpdateAction(
    ActionBuilderUpdateAction event,
    Emitter<ActionBuilderState> emit,
  ) {
    _specEditorBloc.add(
      SpecEditorGlobalActionUpdated(
        actionId: event.actionId,
        actionData: event.actionData,
      ),
    );
  }

  // Handler for deleting an action
  void _onDeleteAction(
    ActionBuilderDeleteAction event,
    Emitter<ActionBuilderState> emit,
  ) {
    // Pass null for actionData to indicate deletion
    _specEditorBloc.add(
      SpecEditorGlobalActionUpdated(
        actionId: event.actionId,
      ),
    );
  }

  @override
  Future<void> close() {
    _specEditorSubscription?.cancel();
    return super.close();
  }
}

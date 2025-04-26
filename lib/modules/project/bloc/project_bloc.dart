import 'package:bloc/bloc.dart';
import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:flutter/material.dart' show Icons;

part 'project_event.dart';
part 'project_state.dart';

/// [ProjectBloc] is a business logic component that manages the state
/// of the Project widget.
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  /// The default constructor for the [ProjectBloc].
  ProjectBloc() : super(const InitialProjectState()) {
    on<ProjectStartedEvent>(_onStarted);
    on<ProjectItemSelectedEvent>(_onItemSelected);
  }

  Future<void> _onStarted(
    ProjectStartedEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectLoadingState());
    try {
      // TODO: Load initial project data
      emit(
        ProjectLoadedState(
          selectedItem: ProjectNavigationDrawerItem(
            id: 'widget-builder',
            title: 'Widget Builder',
            route: '/widget-builder',
            icon: Icons.widgets_outlined,
            projectId: event.projectId,
          ),
        ),
      );
    } catch (e) {
      emit(ProjectErrorState(message: e.toString()));
    }
  }

  Future<void> _onItemSelected(
    ProjectItemSelectedEvent event,
    Emitter<ProjectState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProjectLoadedState) {
      emit(ProjectLoadedState(selectedItem: event.item));
    }
  }
}

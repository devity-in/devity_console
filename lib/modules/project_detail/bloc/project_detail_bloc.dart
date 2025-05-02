import 'package:bloc/bloc.dart';
import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:flutter/material.dart' show Icons;

part 'project_detail_event.dart';
part 'project_detail_state.dart';

/// [ProjectDetailBloc] is a business logic component that manages the state
/// of the Project widget.
class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  /// The default constructor for the [ProjectDetailBloc].
  ProjectDetailBloc() : super(const InitialProjectDetailState()) {
    on<ProjectDetailStartedEvent>(_onStarted);
    on<ProjectDetailItemSelectedEvent>(_onItemSelected);
  }

  Future<void> _onStarted(
    ProjectDetailStartedEvent event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(const ProjectDetailLoadingState());
    try {
      // TODO: Load initial project data
      emit(
        ProjectDetailLoadedState(
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
      emit(ProjectDetailErrorState(message: e.toString()));
    }
  }

  Future<void> _onItemSelected(
    ProjectDetailItemSelectedEvent event,
    Emitter<ProjectDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProjectDetailLoadedState) {
      emit(ProjectDetailLoadedState(selectedItem: event.item));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devity_console/models/project.dart';
import 'package:devity_console/services/project_service.dart';

import 'project_list_event.dart';
import 'project_list_state.dart';

/// [ProjectListBloc] is a business logic component that manages the state of the
/// project list.
class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final ProjectService _projectService;

  /// The default constructor for the [ProjectListBloc].
  ProjectListBloc(this._projectService) : super(ProjectListInitial()) {
    on<ProjectListStartedEvent>(_onStarted);
    on<ProjectListReloadEvent>(_onReload);
    on<ProjectListCreateEvent>(_onCreate);
    on<ProjectListDeleteEvent>(_onDelete);
  }

  Future<void> _onStarted(
    ProjectListStartedEvent event,
    Emitter<ProjectListState> emit,
  ) async {
    emit(ProjectListLoading());
    try {
      final projects = await _projectService.getProjects();
      emit(ProjectListLoaded(projects));
    } catch (e) {
      emit(ProjectListError(e.toString()));
    }
  }

  Future<void> _onReload(
    ProjectListReloadEvent event,
    Emitter<ProjectListState> emit,
  ) async {
    emit(ProjectListLoading());
    try {
      final projects = await _projectService.getProjects();
      emit(ProjectListLoaded(projects));
    } catch (e) {
      emit(ProjectListError(e.toString()));
    }
  }

  Future<void> _onCreate(
    ProjectListCreateEvent event,
    Emitter<ProjectListState> emit,
  ) async {
    try {
      final project = await _projectService.createProject(
        name: event.name,
        description: event.description,
      );
      final currentState = state;
      if (currentState is ProjectListLoaded) {
        emit(ProjectListLoaded([...currentState.projects, project]));
      }
    } catch (e) {
      emit(ProjectListError(e.toString()));
    }
  }

  Future<void> _onDelete(
    ProjectListDeleteEvent event,
    Emitter<ProjectListState> emit,
  ) async {
    try {
      // TODO: Implement delete project
      final currentState = state;
      if (currentState is ProjectListLoaded) {
        final updatedProjects = currentState.projects
            .where((project) => project.id != event.projectId)
            .toList();
        emit(ProjectListLoaded(updatedProjects));
      }
    } catch (e) {
      emit(ProjectListError(e.toString()));
    }
  }
}

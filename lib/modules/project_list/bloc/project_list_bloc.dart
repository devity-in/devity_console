import 'package:devity_console/modules/project_list/bloc/project_list_event.dart';
import 'package:devity_console/modules/project_list/bloc/project_list_state.dart';
import 'package:devity_console/repositories/analytics_repository.dart';
import 'package:devity_console/services/project_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ProjectListBloc] is a business logic component that manages the state of the
/// project list.
class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  /// The [ProjectService] instance.
  /// The default constructor for the [ProjectListBloc].

  ProjectListBloc({
    ProjectService? projectService,
    AnalyticsRepository? analyticsRepository,
  })  : _projectService = projectService ?? ProjectService(),
        _analyticsRepository = analyticsRepository ?? AnalyticsRepository(),
        super(ProjectListInitial()) {
    on<ProjectListStartedEvent>(_onStarted);
    on<ProjectListReloadEvent>(_onReload);
    on<ProjectListCreateEvent>(_onCreate);
    on<ProjectListDeleteEvent>(_onDelete);
  }

  /// The [ProjectService] instance.
  final ProjectService _projectService;

  /// The [AnalyticsRepository] instance.
  final AnalyticsRepository _analyticsRepository;

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

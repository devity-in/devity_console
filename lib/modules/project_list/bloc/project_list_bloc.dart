import 'dart:async';

import 'package:devity_console/models/project_model.dart';
import 'package:devity_console/modules/project_list/bloc/project_list_event.dart';
import 'package:devity_console/modules/project_list/bloc/project_list_state.dart';
import 'package:devity_console/repositories/analytics_repository.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';
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
  })  : _projectService = projectService ??
            ProjectService(
              networkService: NetworkService(
                errorHandler: ErrorHandlerService(),
              ),
            ),
        _analyticsRepository = analyticsRepository ?? AnalyticsRepository(),
        super(ProjectListInitial()) {
    on<ProjectListStartedEvent>(_onStarted);
    on<ProjectListReloadEvent>(_onReload);
    on<ProjectListCreateEvent>(_onCreate);
    on<ProjectListDeleteEvent>(_onDelete);
    on<ProjectListSearchEvent>(_onSearch);
  }

  /// The [ProjectService] instance.
  final ProjectService _projectService;

  /// The [AnalyticsRepository] instance.
  final AnalyticsRepository _analyticsRepository;

  /// List of all projects
  List<ProjectModel> _allProjects = [];

  Future<void> _onStarted(
    ProjectListStartedEvent event,
    Emitter<ProjectListState> emit,
  ) async {
    unawaited(
      _analyticsRepository.trackScreenView(
        screenName: 'project_list',
        parameters: {
          'event': 'project_list_started',
        },
      ),
    );
    emit(ProjectListLoading());
    try {
      print("ProjectListBloc: Fetching projects...");
      _allProjects = await _projectService.getProjects();
      print(
          "ProjectListBloc: Projects fetched successfully (count: ${_allProjects.length})");
      print("ProjectListBloc: Emitting ProjectListLoaded state...");
      emit(ProjectListLoaded(_allProjects));
      print("ProjectListBloc: ProjectListLoaded state emitted.");
    } catch (e, s) {
      print("ProjectListBloc: Error fetching projects: $e\n$s");
      emit(ProjectListError(e.toString()));
    }
  }

  Future<void> _onReload(
    ProjectListReloadEvent event,
    Emitter<ProjectListState> emit,
  ) async {
    emit(ProjectListLoading());
    try {
      print("ProjectListBloc: Reloading projects...");
      _allProjects = await _projectService.getProjects();
      print(
          "ProjectListBloc: Projects reloaded successfully (count: ${_allProjects.length})");
      print("ProjectListBloc: Emitting ProjectListLoaded state...");
      emit(ProjectListLoaded(_allProjects));
      print("ProjectListBloc: ProjectListLoaded state emitted.");
    } catch (e, s) {
      print("ProjectListBloc: Error reloading projects: $e\n$s");
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
      _allProjects = [..._allProjects, project];
      emit(ProjectListLoaded(_allProjects));
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
      _allProjects = _allProjects
          .where((project) => project.id != event.projectId)
          .toList();
      emit(ProjectListLoaded(_allProjects));
    } catch (e) {
      emit(ProjectListError(e.toString()));
    }
  }

  void _onSearch(
    ProjectListSearchEvent event,
    Emitter<ProjectListState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(ProjectListLoaded(_allProjects));
      return;
    }

    final query = event.query.toLowerCase();
    final filteredProjects = _allProjects.where((project) {
      final nameMatch = project.name.toLowerCase().contains(query);
      final descriptionMatch =
          project.description?.toLowerCase().contains(query) ?? false;
      return nameMatch || descriptionMatch;
    }).toList();

    emit(ProjectListLoaded(filteredProjects));
  }
}

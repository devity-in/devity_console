import 'package:equatable/equatable.dart';

/// Base class for all project list events.
abstract class ProjectListEvent extends Equatable {
  const ProjectListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start loading the project list.
class ProjectListStartedEvent extends ProjectListEvent {}

/// Event to reload the project list.
class ProjectListReloadEvent extends ProjectListEvent {}

/// Event to create a new project.
class ProjectListCreateEvent extends ProjectListEvent {
  /// Creates a new [ProjectListCreateEvent].
  const ProjectListCreateEvent({
    required this.name,
    this.description,
  });

  /// The name of the project to create.
  final String name;
  final String? description;

  @override
  List<Object?> get props => [name, description];
}

/// Event to delete a project.
class ProjectListDeleteEvent extends ProjectListEvent {
  /// Creates a new [ProjectListDeleteEvent].
  const ProjectListDeleteEvent({required this.projectId});

  /// The ID of the project to delete.
  final String projectId;

  @override
  List<Object?> get props => [projectId];
}

/// Event to search projects
class ProjectListSearchEvent extends ProjectListEvent {
  /// Creates a new [ProjectListSearchEvent]
  const ProjectListSearchEvent(this.query);

  /// The search query
  final String query;

  @override
  List<Object?> get props => [query];
}

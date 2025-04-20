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
  /// The name of the project to create.
  final String name;
  final String? description;

  /// Creates a new [ProjectListCreateEvent].
  const ProjectListCreateEvent({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

/// Event to delete a project.
class ProjectListDeleteEvent extends ProjectListEvent {
  /// The ID of the project to delete.
  final String projectId;

  /// Creates a new [ProjectListDeleteEvent].
  const ProjectListDeleteEvent({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

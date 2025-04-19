import 'package:equatable/equatable.dart';
import 'package:devity_console/models/project.dart';

/// Base class for all project list states.
abstract class ProjectListState extends Equatable {
  const ProjectListState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the project list.
class ProjectListInitial extends ProjectListState {}

/// The state when the project list is loading.
class ProjectListLoading extends ProjectListState {}

/// The state when the project list has been loaded successfully.
class ProjectListLoaded extends ProjectListState {
  /// The list of projects.
  final List<Project> projects;

  /// Creates a new [ProjectListLoaded].
  const ProjectListLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

/// The state when there was an error loading the project list.
class ProjectListError extends ProjectListState {
  /// The error message.
  final String message;

  /// Creates a new [ProjectListError].
  const ProjectListError(this.message);

  @override
  List<Object?> get props => [message];
}

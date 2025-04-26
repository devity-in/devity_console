part of 'project_bloc.dart';

/// [ProjectEvent] is a class that describes the events that can be
/// triggered in the [ProjectBloc].
sealed class ProjectEvent {
  const ProjectEvent();
}

/// The event that is triggered when the [ProjectBloc] is started.
class ProjectStartedEvent extends ProjectEvent {
  /// Creates a [ProjectStartedEvent].
  const ProjectStartedEvent({required this.projectId});

  /// The ID of the project.
  final String projectId;
}

/// The event that is triggered when an item is selected in the project.
class ProjectItemSelectedEvent extends ProjectEvent {
  /// Creates a [ProjectItemSelectedEvent].
  const ProjectItemSelectedEvent({required this.item});

  /// The selected item.
  final ProjectNavigationDrawerItem item;
}

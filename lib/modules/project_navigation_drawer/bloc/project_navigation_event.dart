part of 'project_navigation_bloc.dart';

/// [ProjectNavigationEvent] is a class that describes the events that can be
/// triggered in the [ProjectNavigationBloc].
sealed class ProjectNavigationEvent {
  const ProjectNavigationEvent();
}

/// The event that is triggered when the [ProjectNavigationBloc] is started.
class ProjectNavigationStartedEvent extends ProjectNavigationEvent {
  /// Creates a [ProjectNavigationStartedEvent].
  const ProjectNavigationStartedEvent({required this.projectId});

  /// The ID of the project.
  final String projectId;
}

/// The event that is triggered when the [ProjectNavigationBloc] is reloaded.
class ProjectNavigationReloadEvent extends ProjectNavigationEvent {
  /// Creates a [ProjectNavigationReloadEvent].
  const ProjectNavigationReloadEvent({required this.projectId});

  /// The ID of the project.
  final String projectId;
}

/// The event that is triggered when the navigation drawer is toggled.
class ProjectNavigationToggleExpandedEvent extends ProjectNavigationEvent {
  /// Creates a [ProjectNavigationToggleExpandedEvent].
  const ProjectNavigationToggleExpandedEvent();
}

/// Event when a navigation item is selected.
class ProjectNavigationItemSelectedEvent extends ProjectNavigationEvent {
  /// Creates a new instance of [ProjectNavigationItemSelectedEvent].
  const ProjectNavigationItemSelectedEvent({
    required this.item,
  });

  /// The selected navigation item.
  final ProjectNavigationDrawerItem item;

  @override
  List<Object?> get props => [item];
}

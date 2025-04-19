part of 'project_navigation_bloc.dart';

/// Events for the [ProjectNavigationBloc]
sealed class ProjectNavigationEvent {
  const ProjectNavigationEvent();
}

/// Initial event when the navigation drawer is started
class ProjectNavigationStartedEvent extends ProjectNavigationEvent {
  const ProjectNavigationStartedEvent();
}

/// Event to reload the navigation drawer
class ProjectNavigationReloadEvent extends ProjectNavigationEvent {
  const ProjectNavigationReloadEvent();
}

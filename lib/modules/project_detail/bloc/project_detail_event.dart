part of 'project_detail_bloc.dart';

/// [ProjectDetailEvent] is a class that describes the events that can be
/// triggered in the [ProjectDetailBloc].
sealed class ProjectDetailEvent {
  const ProjectDetailEvent();
}

/// The event that is triggered when the [ProjectDetailBloc] is started.
class ProjectDetailStartedEvent extends ProjectDetailEvent {
  /// Creates a [ProjectDetailStartedEvent].
  const ProjectDetailStartedEvent({required this.projectId});

  /// The ID of the project.
  final String projectId;
}

/// The event that is triggered when an item is selected in the project.
class ProjectDetailItemSelectedEvent extends ProjectDetailEvent {
  /// Creates a [ProjectDetailItemSelectedEvent].
  const ProjectDetailItemSelectedEvent({required this.item});

  /// The selected item.
  final ProjectNavigationDrawerItem item;
}

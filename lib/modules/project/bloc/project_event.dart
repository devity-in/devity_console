part of 'project_bloc.dart';

/// [ProjectEvent] is a class that describes the events that can be
/// triggered in the [ProjectBloc].
sealed class ProjectEvent {
  const ProjectEvent();
}

/// The event that is triggered when the [ProjectBloc] is started.
class ProjectStartedEvent extends ProjectEvent {
  const ProjectStartedEvent();
}

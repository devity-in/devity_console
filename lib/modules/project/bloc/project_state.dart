part of 'project_bloc.dart';

/// [ProjectState] is a class that describes the state of the [ProjectBloc].
sealed class ProjectState {
  const ProjectState();
}

/// The initial state of the [ProjectBloc].
class InitialProjectState extends ProjectState {
  const InitialProjectState();
}

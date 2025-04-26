part of 'project_bloc.dart';

/// [ProjectState] is a class that describes the state of the [ProjectBloc].
sealed class ProjectState {
  const ProjectState();
}

/// The initial state of the [ProjectBloc].
class InitialProjectState extends ProjectState {
  const InitialProjectState();
}

/// The loading state of the [ProjectBloc].
class ProjectLoadingState extends ProjectState {
  const ProjectLoadingState();
}

/// The error state of the [ProjectBloc].
class ProjectErrorState extends ProjectState {
  const ProjectErrorState({required this.message});

  /// The error message.
  final String message;
}

/// The state of the [ProjectBloc] when the project is loaded.
class ProjectLoadedState extends ProjectState {
  const ProjectLoadedState({required this.selectedItem});

  /// The selected item of the project.
  final ProjectNavigationDrawerItem selectedItem;
}

part of 'project_detail_bloc.dart';

/// [ProjectDetailState] is a class that describes the state of the [ProjectDetailBloc].
sealed class ProjectDetailState {
  const ProjectDetailState();
}

/// The initial state of the [ProjectDetailBloc].
class InitialProjectDetailState extends ProjectDetailState {
  const InitialProjectDetailState();
}

/// The loading state of the [ProjectDetailBloc].
class ProjectDetailLoadingState extends ProjectDetailState {
  const ProjectDetailLoadingState();
}

/// The error state of the [ProjectDetailBloc].
class ProjectDetailErrorState extends ProjectDetailState {
  const ProjectDetailErrorState({required this.message});

  /// The error message.
  final String message;
}

/// The state of the [ProjectDetailBloc] when the project is loaded.
class ProjectDetailLoadedState extends ProjectDetailState {
  const ProjectDetailLoadedState({required this.selectedItem});

  /// The selected item of the project.
  final ProjectNavigationDrawerItem selectedItem;
}

part of 'project_navigation_bloc.dart';

/// States for the [ProjectNavigationBloc]
sealed class ProjectNavigationState {
  const ProjectNavigationState();
}

/// Initial state
class ProjectNavigationInitialState extends ProjectNavigationState {
  const ProjectNavigationInitialState();
}

/// Loading state
class ProjectNavigationLoadingState extends ProjectNavigationState {
  const ProjectNavigationLoadingState();
}

/// Loaded state with navigation items
class ProjectNavigationLoadedState extends ProjectNavigationState {
  const ProjectNavigationLoadedState({
    required this.items,
    this.selectedItem,
  });

  final List<ProjectNavigationDrawerItem> items;
  final ProjectNavigationDrawerItem? selectedItem;
}

/// Error state
class ProjectNavigationErrorState extends ProjectNavigationState {
  const ProjectNavigationErrorState({
    required this.message,
  });

  final String message;
}

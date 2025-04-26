part of 'project_navigation_bloc.dart';

/// [ProjectNavigationState] is a class that describes the state of the
/// [ProjectNavigationBloc].
sealed class ProjectNavigationState {
  const ProjectNavigationState();
}

/// The initial state of the [ProjectNavigationBloc].
class ProjectNavigationInitialState extends ProjectNavigationState {
  const ProjectNavigationInitialState();
}

/// The loading state of the [ProjectNavigationBloc].
class ProjectNavigationLoadingState extends ProjectNavigationState {
  const ProjectNavigationLoadingState();
}

/// The error state of the [ProjectNavigationBloc].
class ProjectNavigationErrorState extends ProjectNavigationState {
  const ProjectNavigationErrorState({required this.message});

  /// The error message.
  final String message;
}

/// The loaded state of the [ProjectNavigationBloc].
class ProjectNavigationLoadedState extends ProjectNavigationState {
  /// Creates a new instance of [ProjectNavigationLoadedState].
  const ProjectNavigationLoadedState({
    required this.items,
    required this.isExpanded,
    required this.selectedItem,
  });

  /// The list of navigation items.
  final List<ProjectNavigationDrawerItem> items;

  /// Whether the navigation drawer is expanded.
  final bool isExpanded;

  /// The currently selected navigation item.
  final ProjectNavigationDrawerItem selectedItem;

  @override
  List<Object?> get props => [items, isExpanded, selectedItem];
}

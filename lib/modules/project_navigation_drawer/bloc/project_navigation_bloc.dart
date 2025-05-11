import 'package:bloc/bloc.dart';
import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:flutter/material.dart' show Icons;

part 'project_navigation_event.dart';
part 'project_navigation_state.dart';

/// [ProjectNavigationBloc] is a business logic component that manages the state
/// of the ProjectNavigation widget.
class ProjectNavigationBloc
    extends Bloc<ProjectNavigationEvent, ProjectNavigationState> {
  /// The default constructor for the [ProjectNavigationBloc].
  ProjectNavigationBloc() : super(const ProjectNavigationInitialState()) {
    on<ProjectNavigationStartedEvent>(_onStarted);
    on<ProjectNavigationReloadEvent>(_onReload);
    on<ProjectNavigationToggleExpandedEvent>(_onToggleExpanded);
    on<ProjectNavigationItemSelectedEvent>(_onItemSelected);
  }

  bool _isExpanded = false;
  static const _projectNavigationDrawerItems = [
    ProjectNavigationDrawerItem(
      id: 'widget-builder',
      title: 'Widget Builder',
      route: '/widget-builder',
      icon: Icons.widgets_outlined,
      projectId: '',
    ),
    ProjectNavigationDrawerItem(
      id: 'data-factory',
      title: 'Data Factory',
      route: '/data-factory',
      icon: Icons.data_object_outlined,
      projectId: '',
    ),
    ProjectNavigationDrawerItem(
      id: 'app-editor',
      title: 'App Editor',
      route: '/app-editor',
      icon: Icons.edit_outlined,
      projectId: '',
    ),
    ProjectNavigationDrawerItem(
      id: 'action-builder',
      title: 'Action Builder',
      route: '/action-builder',
      icon: Icons.play_arrow_outlined,
      projectId: '',
    ),
    ProjectNavigationDrawerItem(
      id: 'media-factory',
      title: 'Media Factory',
      route: '/media-factory',
      icon: Icons.image_outlined,
      projectId: '',
    ),
    ProjectNavigationDrawerItem(
      id: 'marketing-campaigns',
      title: 'Marketing Campaigns',
      route: '/marketing-campaigns',
      icon: Icons.campaign_outlined,
      projectId: '',
    ),
    ProjectNavigationDrawerItem(
      id: 'project-settings',
      title: 'Project Settings',
      route: '/settings',
      icon: Icons.settings_outlined,
      projectId: '',
    ),
  ];

  Future<void> _onStarted(
    ProjectNavigationStartedEvent event,
    Emitter<ProjectNavigationState> emit,
  ) async {
    emit(const ProjectNavigationLoadingState());
    try {
      // Update project ID for all items
      final items = _projectNavigationDrawerItems.map((item) {
        return ProjectNavigationDrawerItem(
          id: item.id,
          title: item.title,
          route: item.route,
          icon: item.icon,
          projectId: event.projectId,
        );
      }).toList();

      emit(
        ProjectNavigationLoadedState(
          items: items,
          isExpanded: _isExpanded,
          selectedItem: items.first,
        ),
      );
    } catch (e) {
      emit(ProjectNavigationErrorState(message: e.toString()));
    }
  }

  Future<void> _onReload(
    ProjectNavigationReloadEvent event,
    Emitter<ProjectNavigationState> emit,
  ) async {
    emit(const ProjectNavigationLoadingState());
    try {
      final currentState = state;
      if (currentState is ProjectNavigationLoadedState) {
        // Update project ID for all items
        final items = _projectNavigationDrawerItems.map((item) {
          return ProjectNavigationDrawerItem(
            id: item.id,
            title: item.title,
            route: item.route,
            icon: item.icon,
            projectId: event.projectId,
          );
        }).toList();

        emit(
          ProjectNavigationLoadedState(
            items: items,
            isExpanded: currentState.isExpanded,
            selectedItem: currentState.selectedItem,
          ),
        );
      }
    } catch (e) {
      emit(ProjectNavigationErrorState(message: e.toString()));
    }
  }

  Future<void> _onToggleExpanded(
    ProjectNavigationToggleExpandedEvent event,
    Emitter<ProjectNavigationState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProjectNavigationLoadedState) {
      _isExpanded = !_isExpanded;
      emit(
        ProjectNavigationLoadedState(
          items: currentState.items,
          isExpanded: _isExpanded,
          selectedItem: currentState.selectedItem,
        ),
      );
    }
  }

  Future<void> _onItemSelected(
    ProjectNavigationItemSelectedEvent event,
    Emitter<ProjectNavigationState> emit,
  ) async {
    if (state is ProjectNavigationLoadedState) {
      final currentState = state as ProjectNavigationLoadedState;
      emit(
        ProjectNavigationLoadedState(
          items: currentState.items,
          isExpanded: currentState.isExpanded,
          selectedItem: event.item,
        ),
      );
    }
  }

  @override
  Stream<ProjectNavigationState> mapEventToState(
    ProjectNavigationEvent event,
  ) async* {
    if (event is ProjectNavigationStartedEvent) {
      yield const ProjectNavigationLoadingState();
      try {
        // Update project ID for all items
        final items = _projectNavigationDrawerItems.map((item) {
          return ProjectNavigationDrawerItem(
            id: item.id,
            title: item.title,
            route: item.route,
            icon: item.icon,
            projectId: event.projectId,
          );
        }).toList();

        yield ProjectNavigationLoadedState(
          items: items,
          isExpanded: _isExpanded,
          selectedItem: items.first,
        );
      } catch (e) {
        yield ProjectNavigationErrorState(message: e.toString());
      }
    } else if (event is ProjectNavigationToggleExpandedEvent) {
      if (state is ProjectNavigationLoadedState) {
        final currentState = state as ProjectNavigationLoadedState;
        _isExpanded = !_isExpanded;
        yield ProjectNavigationLoadedState(
          items: currentState.items,
          isExpanded: _isExpanded,
          selectedItem: currentState.selectedItem,
        );
      }
    } else if (event is ProjectNavigationItemSelectedEvent) {
      if (state is ProjectNavigationLoadedState) {
        final currentState = state as ProjectNavigationLoadedState;
        yield ProjectNavigationLoadedState(
          items: currentState.items,
          isExpanded: currentState.isExpanded,
          selectedItem: event.item,
        );
      }
    } else if (event is ProjectNavigationReloadEvent) {
      yield const ProjectNavigationLoadingState();
      try {
        final currentState = state;
        if (currentState is ProjectNavigationLoadedState) {
          // Update project ID for all items
          final items = _projectNavigationDrawerItems.map((item) {
            return ProjectNavigationDrawerItem(
              id: item.id,
              title: item.title,
              route: item.route,
              icon: item.icon,
              projectId: event.projectId,
            );
          }).toList();

          yield ProjectNavigationLoadedState(
            items: items,
            isExpanded: currentState.isExpanded,
            selectedItem: currentState.selectedItem,
          );
        }
      } catch (e) {
        yield ProjectNavigationErrorState(message: e.toString());
      }
    }
  }
}

import 'package:devity_console/models/project_navigation_drawer_item.dart';
import 'package:devity_console/modules/app_editor/app_editor.dart';
import 'package:devity_console/modules/project/bloc/project_bloc.dart';
import 'package:devity_console/modules/project_navigation_drawer/project_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ProjectPage] is a StatelessWidget that displays a project.
/// It will have project navigation view i.e ProjectDrawer
/// to navigate within project.
/// It will have different views based on navigation selection.
class ProjectPage extends StatelessWidget {
  /// Creates a [ProjectPage].
  const ProjectPage({
    required this.projectId,
    super.key,
  });

  /// The ID of the project to display.
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return ProjectView(
      projectId: projectId,
    );
  }
}

/// [ProjectView] is a StatelessWidget that displays the project view.
class ProjectView extends StatelessWidget {
  /// Creates a new instance of [ProjectView].
  const ProjectView({
    required this.projectId,
    super.key,
  });

  /// The ID of the project.
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoadedState) {
          return Row(
            children: [
              ProjectNavigationDrawer(
                projectId: projectId,
                onItemSelected: (item) {
                  context
                      .read<ProjectBloc>()
                      .add(ProjectItemSelectedEvent(item: item));
                },
              ),
              Expanded(
                child: _buildSelectedView(
                  context,
                  state.selectedItem,
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSelectedView(
    BuildContext context,
    ProjectNavigationDrawerItem selectedItem,
  ) {
    return Builder(
      builder: (context) {
        switch (selectedItem.route) {
          case '/overview':
            return const Center(child: Text('Project Overview'));
          case '/widget-builder':
            return const Center(child: Text('Widget Builder'));
          case '/data-factory':
            return const Center(child: Text('Data Factory'));
          case '/app-editor':
            return AppEditor(projectId: projectId);
          case '/media-factory':
            return const Center(child: Text('Media Factory'));
          case '/marketing-campaigns':
            return const Center(child: Text('Marketing Campaigns'));
          case '/settings':
            return const Center(child: Text('Project Settings'));
          default:
            return const Center(child: Text('Unknown View'));
        }
      },
    );
  }
}

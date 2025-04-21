import 'package:devity_console/modules/project_list/bloc/project_list_bloc.dart';
import 'package:devity_console/modules/project_list/bloc/project_list_event.dart';
import 'package:devity_console/modules/project_list/bloc/project_list_state.dart';
import 'package:devity_console/modules/project_list/widgets/add_project.dart';
import 'package:devity_console/modules/project_list/widgets/project_list_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectListScreen extends StatelessWidget {
  /// The default constructor for the [ProjectListScreen].
  const ProjectListScreen({super.key});

  /// The name of the route for the [ProjectListScreen].
  static const routeName = '/projects';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectListBloc()..add(ProjectListStartedEvent()),
      child: const ProjectListView(),
    );
  }
}

/// [ProjectListView] is a StatelessWidget that displays a list of projects.
class ProjectListView extends StatelessWidget {
  /// Creates a [ProjectListView].
  const ProjectListView({super.key});

  void _showAddProjectDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AddProjectDialog(
        onCancel: () {
          Navigator.of(context).pop();
        },
        onSave: (Map<String, String> data) {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: BlocBuilder<ProjectListBloc, ProjectListState>(
        builder: (context, state) {
          if (state is ProjectListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectListLoaded) {
            if (state.projects.isEmpty) {
              return ProjectListEmptyState(
                onAddProject: () => _showAddProjectDialog(context),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ProjectListSearchBar(
                          onSearchChanged: (query) {
                            // TODO: Implement search functionality
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      ProjectListAddButton(
                        onPressed: () => _showAddProjectDialog(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ProjectListGrid(
                    projects: state.projects,
                    onProjectTap: (project) {
                      // TODO: Navigate to project details
                    },
                  ),
                ),
              ],
            );
          } else if (state is ProjectListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      context
                          .read<ProjectListBloc>()
                          .add(ProjectListReloadEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return ProjectListEmptyState(
            onAddProject: () => _showAddProjectDialog(context),
          );
        },
      ),
    );
  }
}

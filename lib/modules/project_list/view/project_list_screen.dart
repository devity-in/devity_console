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
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AddProjectDialog(
                              title: 'Add New Project',
                              description:
                                  'Please enter the details for your new project',
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                              onSave: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
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
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No projects found'));
        },
      ),
    );
  }
}

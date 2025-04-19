import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/project_list_bloc.dart';
import '../bloc/project_list_event.dart';
import '../bloc/project_list_state.dart';

/// [ProjectListView] is a StatelessWidget that displays a list of projects.
class ProjectListView extends StatelessWidget {
  /// Creates a [ProjectListView].
  const ProjectListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Show create project dialog
            },
          ),
        ],
      ),
      body: BlocBuilder<ProjectListBloc, ProjectListState>(
        builder: (context, state) {
          if (state is ProjectListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectListLoaded) {
            return ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text(project.description ?? ''),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to project details
                  },
                );
              },
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

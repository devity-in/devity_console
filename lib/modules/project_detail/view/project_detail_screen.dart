import 'package:devity_console/models/spec_summary_model.dart';
import 'package:devity_console/modules/spec_list/bloc/spec_list_bloc.dart';
import 'package:devity_console/modules/spec_list/bloc/spec_list_event.dart';
import 'package:devity_console/modules/spec_list/bloc/spec_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// TODO: Fetch and display project details as well

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  // TODO: Define proper route name and path
  static const routeName = '/project/:projectId'; // Example path structure

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create SpecListBloc and immediately request loading specs for this project
      create: (context) =>
          SpecListBloc()..add(SpecListLoadRequested(projectId: projectId)),
      child: ProjectDetailView(projectId: projectId),
    );
  }
}

class ProjectDetailView extends StatelessWidget {
  final String projectId;
  const ProjectDetailView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    // TODO: Add UI for project details (name, description etc.)
    return Scaffold(
      appBar: AppBar(
        // TODO: Show project name in title
        title: Text('Project Details (ID: $projectId)'),
        actions: [
          // TODO: Add "New Spec" button later
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Spec',
            onPressed: () {
              // TODO: Implement create spec flow
              print('New Spec button pressed for project $projectId');
            },
          ),
        ],
      ),
      body: BlocBuilder<SpecListBloc, SpecListState>(
        builder: (context, state) {
          if (state is SpecListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SpecListLoaded) {
            if (state.specs.isEmpty) {
              return const Center(
                  child: Text('This project has no specs yet.'));
            }
            // Display the list of specs
            return _SpecListView(specs: state.specs);
          } else if (state is SpecListError) {
            return Center(
              child: Text(
                'Error loading specs: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // Initial state or unknown state
          return const Center(child: Text('Loading project specs...'));
        },
      ),
    );
  }
}

// Simple private widget to display the list
class _SpecListView extends StatelessWidget {
  final List<SpecSummaryModel> specs;

  const _SpecListView({required this.specs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final spec = specs[index];
        return ListTile(
          leading: const Icon(Icons.description_outlined),
          // TODO: Display a more meaningful name/version later
          title: Text('Spec ID: ${spec.id}'),
          subtitle: Text('Updated: ${spec.updatedAt.toLocal().toString()}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to Spec Editor screen
            print('Tapped on Spec: ${spec.id}');
            context.push(
                '/project/${spec.projectId}/spec/${spec.id}'); // Example route
          },
        );
      },
    );
  }
}

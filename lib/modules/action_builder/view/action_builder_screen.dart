import 'package:devity_console/modules/action_builder/bloc/action_builder_bloc.dart';
import 'package:devity_console/modules/action_builder/widgets/add_edit_action_dialog.dart';
import 'package:devity_console/modules/spec_editor/bloc/spec_editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionBuilderScreen extends StatelessWidget {
  const ActionBuilderScreen({required this.projectId, super.key});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionBuilderBloc(
        specEditorBloc: context.read<SpecEditorBloc>(),
      ),
      child: BlocBuilder<ActionBuilderBloc, ActionBuilderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Action Builder'),
              automaticallyImplyLeading: false,
            ),
            body: _buildBody(context, state),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddActionDialog(context),
              tooltip: 'Add Action',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddActionDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddEditActionDialog(),
    );

    if (result != null && context.mounted) {
      final actionId = result['id'] as String?;
      final actionData = result['action'] as Map<String, dynamic>?;
      if (actionId != null && actionData != null) {
        print('Adding Action - ID: $actionId, Action: $actionData');
        // Add the event to the bloc
        context.read<ActionBuilderBloc>().add(
              ActionBuilderAddAction(
                actionId: actionId,
                actionData: actionData,
              ),
            );
      } else {
        print('Error: Add dialog returned invalid data');
        // Optionally show a user-facing error
      }
    }
  }

  Future<void> _showEditActionDialog(
    BuildContext context,
    String actionId,
    Map<String, dynamic> actionData,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddEditActionDialog(
        existingActionId: actionId,
        existingActionData: actionData,
      ),
    );

    if (result != null && context.mounted) {
      final updatedActionId =
          result['id'] as String?; // Should match original actionId
      final updatedActionData = result['action'] as Map<String, dynamic>?;
      // Use the original actionId for the update event
      if (updatedActionData != null) {
        print('Updating Action - ID: $actionId, Action: $updatedActionData');
        // Add the event to the bloc
        context.read<ActionBuilderBloc>().add(
              ActionBuilderUpdateAction(
                actionId: actionId,
                actionData: updatedActionData,
              ),
            );
      } else {
        print('Error: Edit dialog returned invalid data');
        // Optionally show a user-facing error
      }
    }
  }

  Widget _buildBody(BuildContext context, ActionBuilderState state) {
    if (state is ActionBuilderLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ActionBuilderLoaded) {
      if (state.actions.isEmpty) {
        return const Center(
          child: Text('No actions defined yet. Click + to add one.'),
        );
      }
      final actionEntries = state.actions.entries.toList();
      return ListView.builder(
        itemCount: actionEntries.length,
        itemBuilder: (context, index) {
          final actionId = actionEntries[index].key;
          final actionData =
              actionEntries[index].value as Map<String, dynamic>? ?? {};
          final actionType = actionData['actionType'] as String? ?? 'Unknown';

          return ListTile(
            leading: Icon(_getActionIcon(actionType)),
            title: Text(actionId),
            subtitle: Text('Type: $actionType'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit Action',
                  onPressed: () =>
                      _showEditActionDialog(context, actionId, actionData),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete Action',
                  onPressed: () {
                    // Show confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text(
                              'Are you sure you want to delete action "$actionId"?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Close the dialog
                                // Dispatch the delete event to the bloc
                                context.read<ActionBuilderBloc>().add(
                                      ActionBuilderDeleteAction(
                                          actionId: actionId),
                                    );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            onTap: () => _showEditActionDialog(context, actionId, actionData),
          );
        },
      );
    } else if (state is ActionBuilderError) {
      return Center(
        child: Text(
          'Error loading actions: ${state.message}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return const Center(
        child: Text('Initializing Action Builder...'),
      );
    }
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType) {
      case 'Navigate':
        return Icons.navigation_outlined;
      case 'ShowAlert':
        return Icons.warning_amber_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

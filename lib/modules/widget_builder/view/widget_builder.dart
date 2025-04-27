import 'package:devity_console/modules/widget_builder/bloc/widget_builder_bloc.dart';
import 'package:devity_console/modules/widget_builder/bloc/widget_builder_event.dart';
import 'package:devity_console/modules/widget_builder/bloc/widget_builder_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that provides a UI for managing and previewing widgets
class WidgetBuilder extends StatefulWidget {
  /// Creates a new [WidgetBuilder]
  const WidgetBuilder({super.key});

  @override
  State<WidgetBuilder> createState() => _WidgetBuilderState();
}

class _WidgetBuilderState extends State<WidgetBuilder> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<WidgetBuilderBloc>().add(const WidgetBuilderLoadWidgets());
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WidgetBuilderBloc, WidgetBuilderState>(
      builder: (context, state) {
        if (state is WidgetBuilderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is! WidgetBuilderLoaded) {
          return const Center(child: Text('Error loading widgets'));
        }

        final filteredWidgets = state.widgets.where((widget) {
          final query = _searchQuery.toLowerCase();
          return widget.name.toLowerCase().contains(query) ||
              widget.description.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Widget Builder'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateCustomWidgetDialog(context),
              ),
            ],
          ),
          body: Row(
            children: [
              // Widget list
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search widgets',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: _onSearch,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredWidgets.length,
                          itemBuilder: (context, index) {
                            final widget = filteredWidgets[index];
                            return ListTile(
                              leading: Icon(widget.icon),
                              title: Text(widget.name),
                              subtitle: Text(widget.description),
                              onTap: state.selectedLayout != null
                                  ? () => context
                                      .read<WidgetBuilderBloc>()
                                      .add(WidgetBuilderWidgetAdded(widget))
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Preview
              Expanded(
                flex: 2,
                child: Card(
                  child: state.selectedWidgets.isNotEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Selected Widgets',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.selectedWidgets.length,
                                itemBuilder: (context, index) {
                                  final widget = state.selectedWidgets[index];
                                  return ListTile(
                                    leading: Icon(widget.icon),
                                    title: Text(widget.name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          context.read<WidgetBuilderBloc>().add(
                                                WidgetBuilderWidgetRemoved(
                                                  index,
                                                ),
                                              ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: Text('Select a widget to preview'),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCreateCustomWidgetDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateCustomWidgetDialog(),
    );

    if (result != null) {
      context.read<WidgetBuilderBloc>().add(
            WidgetBuilderCustomWidgetCreated(
              name: result['name'] as String,
              description: result['description'] as String,
              isPublic: result['isPublic'] as bool,
            ),
          );
    }
  }
}

class CreateCustomWidgetDialog extends StatefulWidget {
  const CreateCustomWidgetDialog({super.key});

  @override
  State<CreateCustomWidgetDialog> createState() =>
      _CreateCustomWidgetDialogState();
}

class _CreateCustomWidgetDialogState extends State<CreateCustomWidgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WidgetBuilderBloc>().state;
    if (state is! WidgetBuilderLoaded) return const SizedBox.shrink();

    return AlertDialog(
      title: const Text('Create Custom Widget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SwitchListTile(
              title: const Text('Public Widget'),
              subtitle:
                  const Text('Make this widget available to other projects'),
              value: _isPublic,
              onChanged: (value) => setState(() => _isPublic = value),
            ),
            const SizedBox(height: 16),
            Text(
              'Layout: ${state.selectedLayout.toString().split('.').last}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Components (${state.selectedWidgets.length}):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ...state.selectedWidgets.map(
              (widget) => ListTile(
                leading: Icon(widget.icon),
                title: Text(widget.name),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                {
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'isPublic': _isPublic,
                },
              );
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

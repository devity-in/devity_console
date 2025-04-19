import 'package:devity_console/modules/app_editor_page_list/bloc/app_editor_page_list_bloc.dart'
    as editor_page;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [AppEditorPageList] is a StatelessWidget that displays
/// the app editor page list.
class AppEditorPageList extends StatelessWidget {
  /// Creates a new instance of [AppEditorPageList].
  const AppEditorPageList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => editor_page.AppEditorPageListBloc()
        ..add(const editor_page.AppEditorPageListStartedEvent()),
      child: BlocBuilder<editor_page.AppEditorPageListBloc,
          editor_page.AppEditorPageListState>(
        builder: (context, state) {
          if (state is editor_page.AppEditorPageListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is editor_page.AppEditorPageListLoadedState) {
            return Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _buildPageList(context, state.pages),
                ),
              ],
            );
          }
          if (state is editor_page.AppEditorPageListErrorState) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Pages',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showAddPageDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Page'),
          ),
        ],
      ),
    );
  }

  Widget _buildPageList(BuildContext context, List<editor_page.Page> pages) {
    if (pages.isEmpty) {
      return const Center(
        child: Text(
          'No pages yet. Click the "Add Page" button to create one.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: pages.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final page = pages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(page.name),
            subtitle: Text(page.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<editor_page.AppEditorPageListBloc>().add(
                      editor_page.AppEditorPageListDeletePageEvent(
                        pageId: page.id,
                      ),
                    );
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddPageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddPageDialog(),
    );
  }
}

class _AddPageDialog extends StatefulWidget {
  const _AddPageDialog();

  @override
  State<_AddPageDialog> createState() => _AddPageDialogState();
}

class _AddPageDialogState extends State<_AddPageDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Page'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Page Name',
                hintText: 'Enter page name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a page name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter page description',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<editor_page.AppEditorPageListBloc>().add(
                    editor_page.AppEditorPageListAddPageEvent(
                      name: _nameController.text,
                      description: _descriptionController.text,
                    ),
                  );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// [AppEditorComponentList] is a StatelessWidget that displays
/// the app editor component list.
///
class AppEditorComponentList extends StatelessWidget {
  /// Creates a new instance of [AppEditorComponentList].
  const AppEditorComponentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Widgets'),
        ...['text', 'button', 'image', 'icon', 'input', 'list', 'grid'].map(
          (e) => ListTile(
            title: Text(e),
          ),
        ),
        const Text('Layouts'),
        ...['row', 'column', 'stack'].map(
          (e) => ListTile(
            title: Text(e),
          ),
        ),
      ],
    );
  }
}

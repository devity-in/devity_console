import 'package:flutter/material.dart';

/// [AppEditorWidgetList] is a StatelessWidget that displays
/// the app editor widget list.
///
class AppEditorWidgetList extends StatelessWidget {
  /// Creates a new instance of [AppEditorWidgetList].
  const AppEditorWidgetList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          'Widgets',
          Icons.widgets_outlined,
        ),
        ..._buildAvailableWidgets(),
        const SizedBox(height: 16),
        _buildSectionHeader('Layouts', Icons.view_compact_outlined),
        ..._buildLayouts(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAvailableWidgets() {
    final widgets = [
      const _WidgetItem(
        name: 'Text',
        icon: Icons.text_fields,
        description: 'Display text with various styles',
        componentType: 'Text',
      ),
      const _WidgetItem(
        name: 'Button',
        icon: Icons.smart_button,
        description: 'Interactive button with different styles',
        componentType: 'Button',
      ),
      const _WidgetItem(
        name: 'Image',
        icon: Icons.image,
        description: 'Display images from various sources',
        componentType: 'Image',
      ),
      const _WidgetItem(
        name: 'Checkbox',
        icon: Icons.check_box,
        description: 'Selectable checkbox with different styles',
        componentType: 'Checkbox',
      ),
      const _WidgetItem(
        name: 'Text Field',
        icon: Icons.input,
        description: 'Input field for text entry',
        componentType: 'TextField',
      ),
      const _WidgetItem(
        name: 'Carousel',
        icon: Icons.view_carousel,
        description: 'Scrollable carousel of items',
        componentType: 'Carousel',
      ),
    ];

    return widgets.map((item) => item.build()).toList();
  }

  List<Widget> _buildLayouts() {
    final layouts = [
      const _WidgetItem(
        name: 'Column',
        icon: Icons.view_stream_outlined,
        description: 'Arrange widgets vertically',
        componentType: 'Column',
      ),
      const _WidgetItem(
        name: 'Row',
        icon: Icons.view_column_outlined,
        description: 'Arrange widgets horizontally',
        componentType: 'Row',
      ),
      const _WidgetItem(
        name: 'Stack',
        icon: Icons.layers_outlined,
        description: 'Stack widgets on top of one another',
        componentType: 'Stack',
      ),
    ];

    return layouts.map((item) => item.build()).toList();
  }
}

class _WidgetItem {
  const _WidgetItem({
    required this.name,
    required this.icon,
    required this.description,
    required this.componentType,
  });

  final String name;
  final IconData icon;
  final String description;
  final String componentType;

  Widget build() {
    return Draggable<Map<String, dynamic>>(
      data: {
        'name': name,
        'icon': icon,
        'description': description,
        'componentType': componentType,
        'type': (componentType == 'Column' ||
                componentType == 'Row' ||
                componentType == 'Stack')
            ? 'Renderer'
            : 'Widget',
      },
      feedback: Material(
        elevation: 4,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(name),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildListTile(),
      ),
      child: _buildListTile(),
    );
  }

  Widget _buildListTile() {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      dense: true,
    );
  }
}

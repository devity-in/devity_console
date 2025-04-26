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
        _buildSectionHeader('Layouts', Icons.grid_view),
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
      ),
      const _WidgetItem(
        name: 'Button',
        icon: Icons.smart_button,
        description: 'Interactive button with different styles',
      ),
      const _WidgetItem(
        name: 'Image',
        icon: Icons.image,
        description: 'Display images from various sources',
      ),
      const _WidgetItem(
        name: 'Checkbox',
        icon: Icons.check_box,
        description: 'Selectable checkbox with different styles',
      ),
      const _WidgetItem(
        name: 'Text Field',
        icon: Icons.input,
        description: 'Input field for text entry',
      ),
      const _WidgetItem(
        name: 'Carousel',
        icon: Icons.view_carousel,
        description: 'Scrollable carousel of items',
      ),
    ];

    return widgets.map((item) => item.build()).toList();
  }

  List<Widget> _buildLayouts() {
    final layouts = [
      const _WidgetItem(
        name: 'ZStack',
        icon: Icons.layers,
        description: 'Stack widgets on top of one another',
      ),
      const _WidgetItem(
        name: 'Carousel',
        icon: Icons.view_carousel,
        description: 'Display widgets in a scrollable carousel',
      ),
      const _WidgetItem(
        name: 'Grid',
        icon: Icons.grid_4x4,
        description: 'Organize widgets in a grid pattern',
      ),
      const _WidgetItem(
        name: 'Vertical',
        icon: Icons.vertical_align_center,
        description: 'Stack widgets vertically with spacing',
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
  });

  final String name;
  final IconData icon;
  final String description;

  Widget build() {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      dense: true,
      onTap: () {
        // TODO: Handle component selection
      },
    );
  }
}

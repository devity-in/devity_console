import 'package:flutter/material.dart';

/// A widget that organizes its children in a grid pattern.
class DevityGridLayout extends StatelessWidget {
  /// Creates a [DevityGridLayout] for component view.
  const DevityGridLayout.component({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 10.0,
    this.crossAxisSpacing = 10.0,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(0),
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityGridLayout] for preview view.
  const DevityGridLayout.preview({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 10.0,
    this.crossAxisSpacing = 10.0,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(0),
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
  }) : _viewType = ViewType.preview;

  /// The widgets to display in the grid.
  final List<Widget> children;

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The spacing between the children in the main axis.
  final double mainAxisSpacing;

  /// The spacing between the children in the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry padding;

  /// The axis along which the grid view scrolls.
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  final bool reverse;

  /// Whether this is the primary scroll view associated with the parent.
  final bool? primary;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the scrollDirection should be
  /// determined by the contents being viewed.
  final bool shrinkWrap;

  /// The type of view to display.
  final ViewType _viewType;

  @override
  Widget build(BuildContext context) {
    switch (_viewType) {
      case ViewType.component:
        return _buildComponentView(context);
      case ViewType.preview:
        return _buildPreviewView(context);
    }
  }

  Widget _buildComponentView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view, size: 16),
              const SizedBox(width: 8),
              Text(
                'Grid Layout',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildPreviewView(BuildContext context) {
    return _buildGrid();
  }

  Widget _buildGrid() {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      padding: padding,
      scrollDirection: scrollDirection,
      reverse: reverse,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}

/// Enum to track which view type to display.
enum ViewType {
  /// Component view used in the component list and editor
  component,

  /// Preview view used in the preview area
  preview,
}

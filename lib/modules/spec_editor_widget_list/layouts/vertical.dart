import 'package:flutter/material.dart';

/// A widget that stacks its children vertically.
class DevityVerticalLayout extends StatelessWidget {
  /// Creates a [DevityVerticalLayout] for component view.
  const DevityVerticalLayout.component({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
    this.padding = const EdgeInsets.all(0),
  }) : _viewType = ViewType.component;

  /// Creates a [DevityVerticalLayout] for preview view.
  const DevityVerticalLayout.preview({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
    this.padding = const EdgeInsets.all(0),
  }) : _viewType = ViewType.preview;

  /// The widgets to stack vertically.
  final List<Widget> children;

  /// How the children should be placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  final MainAxisSize mainAxisSize;

  /// How the children should be placed along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Determines the order to lay children out horizontally.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically.
  final VerticalDirection verticalDirection;

  /// If aligning items according to their baseline, which baseline to use.
  final TextBaseline? textBaseline;

  /// The amount of space to place between children.
  final double spacing;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry padding;

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
              const Icon(Icons.vertical_align_center, size: 16),
              const SizedBox(width: 8),
              Text(
                'Vertical Layout',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildVerticalLayout(),
        ],
      ),
    );
  }

  Widget _buildPreviewView(BuildContext context) {
    return _buildVerticalLayout();
  }

  Widget _buildVerticalLayout() {
    final spacedChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1 && spacing > 0) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: spacedChildren,
      ),
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

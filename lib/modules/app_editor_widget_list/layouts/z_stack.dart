import 'package:flutter/material.dart';

/// A widget that stacks its children on top of one another.
class DevityZStackLayout extends StatelessWidget {
  /// Creates a [DevityZStackLayout] for component view.
  const DevityZStackLayout.component({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityZStackLayout] for preview view.
  const DevityZStackLayout.preview({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
  }) : _viewType = ViewType.preview;

  /// The widgets to stack on top of each other.
  final List<Widget> children;

  /// How to align the non-positioned and partially-positioned children in the stack.
  final AlignmentGeometry alignment;

  /// How to size the non-positioned children in the stack.
  final StackFit fit;

  /// The clipping behavior when a child overflows the stack's bounds.
  final Clip clipBehavior;

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
              const Icon(Icons.layers, size: 16),
              const SizedBox(width: 8),
              Text(
                'ZStack Layout',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStack(),
        ],
      ),
    );
  }

  Widget _buildPreviewView(BuildContext context) {
    return _buildStack();
  }

  Widget _buildStack() {
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
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

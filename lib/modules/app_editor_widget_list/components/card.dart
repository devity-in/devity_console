import 'package:flutter/material.dart';

/// This [DevityCardWidget] is a equivalent to [Card] widget.
class DevityCardWidget extends StatelessWidget {
  /// Creates a [DevityCardWidget] for component view.
  /// This view is used in the component list and editor.
  const DevityCardWidget.component({
    super.key,
    required this.child,
    this.color,
    this.elevation,
    this.shape,
    this.margin,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityCardWidget] for preview view.
  /// This view is used in the preview area.
  const DevityCardWidget.preview({
    super.key,
    required this.child,
    this.color,
    this.elevation,
    this.shape,
    this.margin,
  }) : _viewType = ViewType.preview;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color to paint the card.
  final Color? color;

  /// The z-coordinate at which to place this card.
  final double? elevation;

  /// The shape of the card's [Material].
  final ShapeBorder? shape;

  /// The empty space that surrounds the card.
  final EdgeInsetsGeometry? margin;

  /// The type of view to display.
  final ViewType _viewType;

  @override
  Widget build(BuildContext context) {
    switch (_viewType) {
      case ViewType.component:
        return _buildComponentView();
      case ViewType.preview:
        return _buildPreviewView();
    }
  }

  Widget _buildComponentView() {
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
              const Icon(Icons.card_giftcard, size: 16),
              const SizedBox(width: 8),
              Text(
                'Card Component',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            color: color,
            elevation: elevation,
            shape: shape,
            margin: margin,
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewView() {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      child: child,
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

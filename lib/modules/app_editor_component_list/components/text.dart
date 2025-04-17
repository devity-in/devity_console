import 'package:flutter/material.dart';

/// This [DevityTextWidget] is a equivalent to [Text] widget.
class DevityTextWidget extends StatelessWidget {
  /// Creates a [DevityTextWidget] for component view.
  /// This view is used in the component list and editor.
  const DevityTextWidget.component({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityTextWidget] for preview view.
  /// This view is used in the preview area.
  const DevityTextWidget.preview({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _viewType = ViewType.preview;

  /// The text to display.
  final String text;

  /// The style to apply to the text.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// An optional maximum number of lines for the text to span.
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

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
              const Icon(Icons.text_fields, size: 16),
              const SizedBox(width: 8),
              Text(
                'Text Component',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewView() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
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

import 'package:flutter/material.dart';

/// This [DevityButtonWidget] is a equivalent to various button widgets.
class DevityButtonWidget extends StatelessWidget {
  /// Creates a [DevityButtonWidget] for component view.
  /// This view is used in the component list and editor.
  const DevityButtonWidget.component({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.type = ButtonType.elevated,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityButtonWidget] for preview view.
  /// This view is used in the preview area.
  const DevityButtonWidget.preview({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.type = ButtonType.elevated,
  }) : _viewType = ViewType.preview;

  /// The text to display on the button.
  final String text;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// The style to apply to the button.
  final ButtonStyle? style;

  /// The icon to display on the button.
  final IconData? icon;

  /// The type of button to display.
  final ButtonType type;

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
              const Icon(Icons.touch_app, size: 16),
              const SizedBox(width: 8),
              Text(
                '${type.name.capitalize()} Button Component',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildPreviewView() {
    return _buildButton();
  }

  Widget _buildButton() {
    final child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(text),
            ],
          )
        : Text(text);

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case ButtonType.icon:
        return IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          style: style,
        );
      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case ButtonType.filledTonal:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: style,
          child: child,
        );
    }
  }
}

/// Enum to track which view type to display.
enum ViewType {
  /// Component view used in the component list and editor
  component,

  /// Preview view used in the preview area
  preview,
}

/// Enum to track which type of button to display.
enum ButtonType {
  /// Elevated button
  elevated,

  /// Text button
  text,

  /// Outlined button
  outlined,

  /// Icon button
  icon,

  /// Filled button
  filled,

  /// Filled tonal button
  filledTonal,
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

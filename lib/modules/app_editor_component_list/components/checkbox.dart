import 'package:flutter/material.dart';

/// This [DevityCheckboxWidget] is a equivalent to [Checkbox] widget.
class DevityCheckboxWidget extends StatelessWidget {
  /// Creates a [DevityCheckboxWidget] for component view.
  /// This view is used in the component list and editor.
  const DevityCheckboxWidget.component({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.type = CheckboxType.standard,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityCheckboxWidget] for preview view.
  /// This view is used in the preview area.
  const DevityCheckboxWidget.preview({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.type = CheckboxType.standard,
  }) : _viewType = ViewType.preview;

  /// Whether this checkbox is checked.
  final bool? value;

  /// Called when the value of the checkbox should change.
  final ValueChanged<bool?>? onChanged;

  /// If true the checkbox's value can be true, false, or null.
  final bool tristate;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  /// The color to use when this checkbox is checked.
  final Color? activeColor;

  /// The color to use for the checkbox's background fill.
  final MaterialStateProperty<Color?>? fillColor;

  /// The color to use for the check icon when this checkbox is checked.
  final Color? checkColor;

  /// The color for the checkbox's Material when it has the input focus.
  final Color? focusColor;

  /// The color for the checkbox's Material when a pointer is hovering over it.
  final Color? hoverColor;

  /// The color for the checkbox's Material when it is pressed.
  final MaterialStateProperty<Color?>? overlayColor;

  /// The splash radius of the circular Material ink response.
  final double? splashRadius;

  /// Configures the minimum size of the tap target.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Defines how compact the checkbox's layout will be.
  final VisualDensity? visualDensity;

  /// An optional focus node to use as the focus node for this widget.
  final FocusNode? focusNode;

  /// Whether this checkbox should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The shape to use for the checkbox's Material.
  final OutlinedBorder? shape;

  /// The color and width of the checkbox's border.
  final BorderSide? side;

  /// Whether the checkbox is in an error state.
  final bool isError;

  /// The type of checkbox to display.
  final CheckboxType type;

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
              const Icon(Icons.check_box, size: 16),
              const SizedBox(width: 8),
              Text(
                '${type.name.capitalize()} Checkbox Component',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildCheckbox(context),
        ],
      ),
    );
  }

  Widget _buildPreviewView(BuildContext context) {
    return _buildCheckbox(context);
  }

  Widget _buildCheckbox(BuildContext context) {
    final checkbox = switch (type) {
      CheckboxType.standard => Checkbox(
          value: value,
          onChanged: onChanged,
          tristate: tristate,
          mouseCursor: mouseCursor,
          activeColor: activeColor,
          fillColor: fillColor,
          checkColor: checkColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor,
          splashRadius: splashRadius,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
          shape: shape,
          side: side,
          isError: isError,
        ),
      CheckboxType.filled => Checkbox(
          value: value,
          onChanged: onChanged,
          tristate: tristate,
          mouseCursor: mouseCursor,
          activeColor: activeColor ?? Theme.of(context).colorScheme.primary,
          fillColor: fillColor,
          checkColor: checkColor ?? Colors.white,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor,
          splashRadius: splashRadius,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
          shape: shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
          side: side,
          isError: isError,
        ),
      CheckboxType.outlined => Checkbox(
          value: value,
          onChanged: onChanged,
          tristate: tristate,
          mouseCursor: mouseCursor,
          activeColor: activeColor,
          fillColor: fillColor,
          checkColor: checkColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          overlayColor: overlayColor,
          splashRadius: splashRadius,
          materialTapTargetSize: materialTapTargetSize,
          visualDensity: visualDensity,
          focusNode: focusNode,
          autofocus: autofocus,
          shape: shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
          side: side ??
              BorderSide(
                color: isError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
          isError: isError,
        ),
    };

    return checkbox;
  }
}

/// Enum to track which view type to display.
enum ViewType {
  /// Component view used in the component list and editor
  component,

  /// Preview view used in the preview area
  preview,
}

/// Enum to track which type of checkbox to display.
enum CheckboxType {
  /// Standard checkbox
  standard,

  /// Filled checkbox
  filled,

  /// Outlined checkbox
  outlined,
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

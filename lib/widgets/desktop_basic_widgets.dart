import 'package:devity_console/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Desktop text editor widget
class DesktopTextEditor extends StatelessWidget {
  /// Desktop text editor constructor
  const DesktopTextEditor({
    required this.title,
    super.key,
    this.textEditingController,
    this.keyboardType,
    this.maxLines,
    this.suffixIconWidget,
    this.obscureText = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  /// title - Title of the text editor
  final String title;

  /// textEditingController - Controller for the text editor
  final int? maxLines;

  /// keyboardType - Keyboard type for the text editor
  final Widget? suffixIconWidget;

  /// obscureText - Whether the text should be obscured
  final bool obscureText;

  /// focusNode - Focus node for the text editor
  final TextEditingController? textEditingController;

  /// onChanged - Function to be called when the text is changed
  final TextInputType? keyboardType;

  /// onSubmitted - Function to be called when the text is submitted
  final FocusNode? focusNode;

  /// onChanged - Function to be called when the text is changed
  final void Function(String)? onChanged;

  /// onSubmitted - Function to be called when the text is submitted
  final void Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle().copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: textEditingController,
              focusNode: focusNode,
              keyboardType: keyboardType ?? TextInputType.text,
              maxLines: maxLines ?? 1,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: suffixIconWidget,
              ),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop popup menu button widget
class DesktopPopupMenuButton extends StatelessWidget {
  /// Desktop popup menu button constructor
  const DesktopPopupMenuButton({
    required this.title,
    required this.controller,
    required this.options,
    super.key,
    this.maxLines,
  });

  /// title - Title of the popup menu button
  final String title;

  /// controller - Controller for the popup menu button
  final TextEditingController controller;

  /// options - Options for the popup menu button
  final List<dynamic> options;

  /// maxLines - Maximum lines for the popup menu button
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle().copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              if (options.isEmpty) {
                // return const <PopupMenuEntry>[
                //   PopupMenuItem(
                //     child: Text("No options available"),
                //   ),
                // ];
                const message = 'No options available';
                snackbarService.showNegativeSnackbar(message);
              }
              return options
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e as String? ?? ''),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) => controller.text = value.toString(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: controller,
                enabled: false,
                maxLines: maxLines ?? 1,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop date picker widget
class DesktopDatePicker extends StatelessWidget {
  /// Desktop date picker constructor
  const DesktopDatePicker({
    required this.title,
    required this.onChanged,
    super.key,
    this.initialDate,
  });

  /// title - Title of the date picker
  final String title;

  /// initialDate - Initial date for the date picker
  final DateTime? initialDate;

  /// onChanged - Function to be called when the date is changed
  final void Function(DateTime?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle().copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  initialDate != null
                      ? DateFormat('dd MMM yyyy').format(initialDate!)
                      : 'Never expires',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 3650),
                      ),
                    );
                    if (picked != null && onChanged != null) {
                      onChanged!(picked);
                    } else if (onChanged != null) {
                      onChanged?.call(null);
                    }
                  },
                  child: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:devity_console/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MobileTextEditor extends StatelessWidget {
  const MobileTextEditor({
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
  final String title;
  final int? maxLines;
  final Widget? suffixIconWidget;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
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

class MobilePopupMenuButton extends StatelessWidget {
  const MobilePopupMenuButton({
    required this.title,
    required this.controller,
    required this.options,
    super.key,
    this.maxLines,
  });
  final String title;
  final TextEditingController controller;
  final List<dynamic> options;
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

class MobileDatePicker extends StatelessWidget {
  const MobileDatePicker({
    required this.title,
    required this.onChanged,
    super.key,
    this.initialDate,
  });
  final String title;
  final DateTime? initialDate;
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
                      onChanged!(null);
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

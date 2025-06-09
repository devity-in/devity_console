import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DefaultAddWidget extends StatelessWidget {
  const DefaultAddWidget({
    required this.onAddWidget,
    super.key,
  });

  /// onAddWidget - Callback function to add a widget
  final Function(Map<String, dynamic>) onAddWidget;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.grey,
      radius: const Radius.circular(10),
      padding: const EdgeInsets.all(10),
      child: DragTarget(
        onAcceptWithDetails: (details) {
          if (details.data == null) {
            return;
          }
          if (details.data is Map<String, dynamic>) {
            onAddWidget(details.data! as Map<String, dynamic>);
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: double.infinity,
            height: 100,
            color: Colors.transparent,
            child: const Center(
              child: Text('Add Widget / Layout'),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WidgetBuilderScreen extends StatelessWidget {
  const WidgetBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Builder'),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          // Panel 1: Widget Templates List
          Container(
            width: 250, // Fixed width for the list panel
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                'Widget Templates List',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // Panel 2: Canvas / Visual Editor
          const Expanded(
            flex: 2, // Give more space to the canvas
            child: ColoredBox(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Canvas / Visual Editor',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // Panel 3: Properties Editor
          Container(
            width: 300, // Fixed width for the properties panel
            color: Colors.grey[300],
            child: const Center(
              child: Text('Properties Editor', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

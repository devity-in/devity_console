import 'package:devity_console/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomButton displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onPressed: () {},
            text: 'Test Button',
          ),
        ),
      ),
    );

    // Verify that the button text is displayed
    expect(find.text('Test Button'), findsOneWidget);

    // Verify that the button is tappable
    await tester.tap(find.byType(CustomButton));
    await tester.pump();
  });

  testWidgets('CustomButton handles onPressed callback',
      (WidgetTester tester) async {
    var wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onPressed: () => wasPressed = true,
            text: 'Test Button',
          ),
        ),
      ),
    );

    // Tap the button
    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    // Verify that the callback was called
    expect(wasPressed, true);
  });
}

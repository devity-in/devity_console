import 'package:devity_console/main_development.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('App launches and shows initial screen',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the app has launched
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Navigation works correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Find and tap a navigation button
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify navigation drawer is open
      expect(find.byType(Drawer), findsOneWidget);
    });
  });
}

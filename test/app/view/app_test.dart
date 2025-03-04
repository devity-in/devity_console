import 'package:devity_console/app/app.dart';
import 'package:devity_console/modules/auth/view/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders Auth', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(Auth), findsOneWidget);
    });
  });
}

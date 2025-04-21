import 'package:devity_console/app/app.dart';
import 'package:devity_console/bootstrap.dart';
import 'package:devity_console/config/environment.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  // Set the path url strategy
  setPathUrlStrategy();
  // Initialize environment configuration
  await Environment.init(fileName: '.env.production');
  await bootstrap(() => const App());
}

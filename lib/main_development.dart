import 'package:devity_console/app/app.dart';
import 'package:devity_console/bootstrap.dart';
import 'package:devity_console/config/environment.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  // Set the path url strategy
  setPathUrlStrategy();

  // Initialize environment configuration
  print("MAIN_DEV: Attempting to load ${Environment.fileName}");
  try {
    await Environment.init(fileName: '.env.development');
    print("MAIN_DEV: Environment.init completed.");
    // Check the value loaded into the Environment class
    print("MAIN_DEV: API_BASE_URL from Environment: ${Environment.apiBaseUrl}");
  } catch (e) {
    print("MAIN_DEV: Error initializing environment: $e");
  }

  await bootstrap(() => const App());
}

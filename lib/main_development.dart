import 'package:devity_console/app/app.dart';
import 'package:devity_console/bootstrap.dart';
import 'package:devity_console/config/environment.dart';

void main() async {
  // Initialize environment configuration
  await Environment.init(fileName: '.env.development');
  await bootstrap(() => const App());
}

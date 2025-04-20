import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    } else {
      return '.env.development';
    }
  }

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? '';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? '';

  static Future<void> init({String? fileName}) async {
    await dotenv.load(fileName: fileName ?? Environment.fileName);
  }
}

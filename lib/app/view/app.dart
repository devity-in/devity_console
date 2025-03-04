import 'package:devity_console/config/custom_key.dart';
import 'package:devity_console/config/themes.dart';
import 'package:devity_console/l10n/l10n.dart';
import 'package:devity_console/modules/auth/view/auth.dart';
import 'package:flutter/material.dart';

/// The main application widget
class App extends StatelessWidget {
  /// The main application widget constructor
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentThemeMode,
      navigatorKey: CustomKey.navigationKey,
      scaffoldMessengerKey: CustomKey.scaffoldMessengerKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Auth(),
    );
  }
}

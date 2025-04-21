import 'package:devity_console/app/bloc/app_bloc.dart';
import 'package:devity_console/config/router.dart';
import 'package:devity_console/config/themes.dart';
import 'package:devity_console/l10n/gen/app_localizations.dart';
import 'package:devity_console/widgets/error_boundary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

/// The main application widget
class App extends StatelessWidget {
  /// The main application widget constructor
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Sizer(
        builder: (context, orientation, screenType) {
          return BlocProvider<AppBloc>(
            create: (context) => AppBloc(),
            child: ErrorBoundary(
              onError: (error, stackTrace) {
                // Log the error to analytics or error reporting service
                debugPrint('App error: $error\n$stackTrace');
              },
              child: MaterialApp.router(
                routerConfig: router,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: currentThemeMode,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                // Enable state restoration
                restorationScopeId: 'app',
              ),
            ),
          );
        },
      ),
    );
  }
}

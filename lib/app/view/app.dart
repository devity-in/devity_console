import 'package:devity_console/app/bloc/app_bloc.dart';
import 'package:devity_console/config/custom_key.dart';
import 'package:devity_console/config/themes.dart';
import 'package:devity_console/l10n/l10n.dart';
import 'package:devity_console/modules/project/project_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// The main application widget
class App extends StatelessWidget {
  /// The main application widget constructor
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return BlocProvider<AppBloc>(
          create: (context) => AppBloc(),
          child: MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: currentThemeMode,
            navigatorKey: CustomKey.navigationKey,
            scaffoldMessengerKey: CustomKey.scaffoldMessengerKey,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ProjectView(),
          ),
        );
      },
    );
  }
}

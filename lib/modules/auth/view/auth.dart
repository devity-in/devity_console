import 'package:devity_console/modules/auth/cubit/cubit.dart';
import 'package:devity_console/modules/auth/view/login.dart';
import 'package:devity_console/modules/splash/view/splash.dart';
import 'package:flutter/material.dart';

/// Auth page
class Auth extends StatelessWidget {
  /// Auth page constructor, It does not have any parameters
  const Auth({super.key});

  /// This the route name for this page, this is used to navigate to this page
  static const String routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit()..appStarted(),
      child: const AuthWrapper(),
    );
  }
}

/// Auth wrapper widget
class AuthWrapper extends StatelessWidget {
  /// Auth wrapper constructor
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {}
        if (state is Unauthenticated) {}
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          return const MobileSplash();
        } else if (state is Authenticated) {
          return const SizedBox();
        } else if (state is Unauthenticated) {
          return const DesktopLogin();
        }
        return Container();
      },
    );
  }
}

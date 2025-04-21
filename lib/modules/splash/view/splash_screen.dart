import 'package:devity_console/modules/splash/bloc/splash_bloc.dart';
import 'package:devity_console/modules/splash/bloc/splash_event.dart';
import 'package:devity_console/modules/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(CheckAuthStatus()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/project');
          });
        } else if (state is SplashUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/auth/login');
          });
        } else if (state is SplashError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: constraints.maxWidth * 0.5,
                height: constraints.maxHeight * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }
}

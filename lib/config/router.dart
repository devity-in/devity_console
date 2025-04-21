import 'package:devity_console/app/bloc/app_bloc.dart';
import 'package:devity_console/modules/forgot_password/forgot_password.dart';
import 'package:devity_console/modules/login/login.dart';
import 'package:devity_console/modules/project_list/view/project_list_screen.dart';
import 'package:devity_console/modules/signup/signup.dart';
import 'package:devity_console/modules/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The router configuration for the application
final router = GoRouter(
  // Enable state restoration for web
  restorationScopeId: 'app_router',
  initialLocation: '/splash',
  debugLogDiagnostics: true,

  routes: [
    // Splash route
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Auth routes group
    GoRoute(
      path: '/auth',
      name: 'auth',
      pageBuilder: (context, state) => MaterialPage(
        key: ValueKey(state.matchedLocation),
        child: const LoginScreen(),
      ),
      routes: [
        // Login route
        GoRoute(
          path: LoginScreen.routeName,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        // Signup route
        GoRoute(
          path: SignupScreen.routeName,
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // Forgot Password route
        GoRoute(
          path: ForgotPasswordScreen.routeName,
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
      ],
    ),

    // Project route
    GoRoute(
      path: ProjectListScreen.routeName,
      name: 'projects',
      builder: (context, state) => const ProjectListScreen(),
    ),
  ],
  // Error page for invalid routes
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
  // Global redirect logic for protected routes
  redirect: (context, state) async {
    // Get app bloc from context
    final appBloc = context.read<AppBloc>();
    final appState = appBloc.state;

    // Check if app is loaded and user is authenticated
    final isAuthenticated = appState is AppLoadedState && appState.user != null;

    // Define public routes that don't require authentication
    final isPublicRoute = [
      '/splash',
      '/auth/login',
      '/auth/signup',
      '/auth/forgot-password',
      '/projects', // TODO: Remove this after testing
    ].contains(state.matchedLocation);

    // Redirect logic
    if (!isAuthenticated && !isPublicRoute) {
      // Store the intended destination for after login
      final redirectPath = state.matchedLocation;
      return '/auth/login?redirect=$redirectPath';
    }
    if (isAuthenticated && isPublicRoute) {
      return '/projects';
    }

    // Handle post-login redirect
    if (isAuthenticated && state.uri.queryParameters.containsKey('redirect')) {
      return state.uri.queryParameters['redirect'];
    }

    return null;
  },
);

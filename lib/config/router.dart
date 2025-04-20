import 'package:devity_console/modules/project/view/project_view.dart';
import 'package:devity_console/modules/app_editor/view/app_editor.dart';
import 'package:devity_console/modules/app_editor_navigation_drawer/view/app_editor_navigation_drawer.dart';
import 'package:devity_console/modules/login/login.dart';
import 'package:devity_console/modules/signup/signup.dart';
import 'package:devity_console/modules/splash/splash.dart';
import 'package:devity_console/modules/forgot_password/forgot_password.dart';
import 'package:devity_console/app/bloc/app_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The router configuration for the application
final router = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  // Enable state restoration for web
  restorationScopeId: 'app_router',
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
      redirect: (context, state) => '/auth/login',
      routes: [
        // Login route
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        // Signup route
        GoRoute(
          path: 'signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // Forgot Password route
        GoRoute(
          path: 'forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
      ],
    ),

    // Main app shell with navigation drawer
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: Row(
          children: [
            const AppEditorNavigationDrawer(),
            Expanded(child: child),
          ],
        ),
      ),
      routes: [
        // Project routes
        GoRoute(
          path: '/project',
          name: 'project',
          builder: (context, state) => const ProjectView(),
        ),

        // Project detail route with parameter
        GoRoute(
          path: '/project/:id',
          name: 'project-detail',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            // TODO: Pass project ID to ProjectView when implemented
            return const ProjectView();
          },
        ),

        // App Editor routes
        GoRoute(
          path: '/app-editor',
          name: 'app-editor',
          builder: (context, state) => const AppEditor(),
        ),

        // App Editor with query parameters
        GoRoute(
          path: '/app-editor/edit',
          name: 'app-editor-edit',
          builder: (context, state) {
            // TODO: Pass mode and id to AppEditor when implemented
            return const AppEditor();
          },
        ),
      ],
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
    ].contains(state.matchedLocation);

    // Redirect logic
    if (!isAuthenticated && !isPublicRoute) {
      // Store the intended destination for after login
      final redirectPath = state.matchedLocation;
      return '/auth/login?redirect=$redirectPath';
    }

    if (isAuthenticated && isPublicRoute) {
      return '/project';
    }

    // Handle post-login redirect
    if (isAuthenticated && state.uri.queryParameters.containsKey('redirect')) {
      return state.uri.queryParameters['redirect'];
    }

    return null;
  },
);

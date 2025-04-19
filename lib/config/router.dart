import 'package:devity_console/modules/project/view/project_view.dart';
import 'package:devity_console/modules/app_editor/view/app_editor.dart';
import 'package:devity_console/modules/app_editor_navigation_drawer/view/app_editor_navigation_drawer.dart';
import 'package:devity_console/modules/login/login.dart';
import 'package:devity_console/modules/signup/signup.dart';
import 'package:devity_console/modules/splash/splash.dart';
import 'package:devity_console/modules/forgot_password/forgot_password.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// The router configuration for the application
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash route
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Login route
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Signup route
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),

    // Forgot Password route
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
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

        // App Editor routes
        GoRoute(
          path: '/app-editor',
          name: 'app-editor',
          builder: (context, state) => const AppEditor(),
        ),
      ],
    ),
  ],
);

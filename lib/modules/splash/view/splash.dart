import 'package:flutter/material.dart';

/// Splash page
class DesktopSplash extends StatefulWidget {
  /// Splash page constructor
  const DesktopSplash({super.key});

  /// Route name [DesktopSplash.routeName] for this page
  static const String routeName = '/';

  @override
  State<DesktopSplash> createState() => _DesktopSplashState();
}

class _DesktopSplashState extends State<DesktopSplash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
      ),
    );
  }
}

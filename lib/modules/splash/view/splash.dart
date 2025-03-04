import 'package:flutter/material.dart';

/// Splash page
class MobileSplash extends StatefulWidget {
  /// Splash page constructor
  const MobileSplash({super.key});

  /// Route name [MobileSplash.routeName] for this page
  static const String routeName = '/';

  @override
  State<MobileSplash> createState() => _MobileSplashState();
}

class _MobileSplashState extends State<MobileSplash> {
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

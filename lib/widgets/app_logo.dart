import 'package:flutter/material.dart';

/// Circular app logo
class CircularAppLogo extends StatelessWidget {
  /// Circular app logo constructor
  const CircularAppLogo({
    super.key,
    this.size = 40,
  });

  /// Size of the logo
  final int size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.toDouble(),
      height: size.toDouble(),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(
            'assets/images/launcher_icon.png',
          ),
        ),
      ),
    );
  }
}

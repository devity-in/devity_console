import 'package:flutter/material.dart';

class CircularAppLogo extends StatelessWidget {
  const CircularAppLogo({
    super.key,
    this.size = 40,
  });

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

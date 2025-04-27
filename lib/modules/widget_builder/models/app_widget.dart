import 'package:flutter/material.dart';

class AppWidget {
  const AppWidget({
    required this.name,
    required this.description,
    required this.icon,
    required this.preview,
  });
  final String name;
  final String description;
  final IconData icon;
  final Widget Function() preview;
}

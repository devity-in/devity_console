import 'package:flutter/material.dart';

class ProjectSettingsScreen extends StatelessWidget {
  const ProjectSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Settings'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Project Settings Screen - Content Coming Soon!'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProjectOverviewScreen extends StatelessWidget {
  const ProjectOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Overview'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Project Overview Screen - Content Coming Soon!'),
      ),
    );
  }
}

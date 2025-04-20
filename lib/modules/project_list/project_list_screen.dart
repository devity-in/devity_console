import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devity_console/services/project_service.dart';

import 'bloc/project_list_bloc.dart';
import 'bloc/project_list_event.dart';
import 'view/project_list_view.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectListBloc(context.read<ProjectService>())
        ..add(ProjectListStartedEvent()),
      child: const ProjectListView(),
    );
  }
}

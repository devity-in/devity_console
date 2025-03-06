import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_navigation_event.dart';
part 'project_navigation_state.dart';
part 'project_navigation_bloc.freezed.dart';

class ProjectNavigationBloc extends Bloc<ProjectNavigationEvent, ProjectNavigationState> {
  ProjectNavigationBloc() : super(_Initial()) {
    on<ProjectNavigationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

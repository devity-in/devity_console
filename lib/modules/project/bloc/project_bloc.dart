import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_event.dart';
part 'project_state.dart';
part 'project_bloc.freezed.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(_Initial()) {
    on<ProjectEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

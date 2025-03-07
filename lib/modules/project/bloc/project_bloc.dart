import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_event.dart';
part 'project_state.dart';
part 'project_bloc.freezed.dart';

/// [ProjectBloc] is a business logic component that manages the state
/// of the Project widget.
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  /// The default constructor for the [ProjectBloc].
  ProjectBloc() : super(const _Initial()) {
    on<ProjectEvent>((event, emit) {
      // TODO(abhishekthakur0): implement event handler
    });
  }
}

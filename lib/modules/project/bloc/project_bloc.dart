import 'package:bloc/bloc.dart';

part 'project_event.dart';
part 'project_state.dart';

/// [ProjectBloc] is a business logic component that manages the state
/// of the Project widget.
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  /// The default constructor for the [ProjectBloc].
  ProjectBloc() : super(const InitialProjectState()) {
    on<ProjectEvent>((event, emit) {
      switch (event) {
        case ProjectStartedEvent():
          // TODO(abhishekthakur0): implement started event handler
          break;
      }
    });
  }
}

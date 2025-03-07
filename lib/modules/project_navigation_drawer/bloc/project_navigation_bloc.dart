import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_navigation_event.dart';
part 'project_navigation_state.dart';
part 'project_navigation_bloc.freezed.dart';

/// [ProjectNavigationBloc] is a business logic component that manages the state
/// of the ProjectNavigation widget.
class ProjectNavigationBloc
    extends Bloc<ProjectNavigationEvent, ProjectNavigationState> {
  /// The default constructor for the [ProjectNavigationBloc].
  ProjectNavigationBloc() : super(const _Initial()) {
    on<ProjectNavigationEvent>((event, emit) {
      // TODO(abhishekthakur0): implement event handler
    });
  }
}

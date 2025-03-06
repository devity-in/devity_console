import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';
part 'project_list_bloc.freezed.dart';

/// [ProjectListBloc] is a BLoC that manages the state of the project list.
class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  /// Creates a [ProjectListBloc] with [_Initial] state.
  ProjectListBloc() : super(const _Initial()) {
    on<ProjectListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

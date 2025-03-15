import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_navigation_drawer_event.dart';
part 'app_editor_navigation_drawer_state.dart';
part 'app_editor_navigation_drawer_bloc.freezed.dart';

/// [AppEditorNavigationDrawerBloc] is a business logic component that
/// manages the state of the AppEditorNavigationDrawer widget.
class AppEditorNavigationDrawerBloc extends Bloc<AppEditorNavigationDrawerEvent,
    AppEditorNavigationDrawerState> {

  /// Creates a new instance of [AppEditorNavigationDrawerBloc].
  AppEditorNavigationDrawerBloc() : super(const _Initial()) {
    on<AppEditorNavigationDrawerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_navigation_drawer_event.dart';
part 'app_editor_navigation_drawer_state.dart';
part 'app_editor_navigation_drawer_bloc.freezed.dart';

class AppEditorNavigationDrawerBloc extends Bloc<AppEditorNavigationDrawerEvent, AppEditorNavigationDrawerState> {
  AppEditorNavigationDrawerBloc() : super(_Initial()) {
    on<AppEditorNavigationDrawerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

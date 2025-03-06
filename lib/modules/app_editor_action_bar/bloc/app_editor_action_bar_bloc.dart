import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_action_bar_event.dart';
part 'app_editor_action_bar_state.dart';
part 'app_editor_action_bar_bloc.freezed.dart';

class AppEditorActionBarBloc extends Bloc<AppEditorActionBarEvent, AppEditorActionBarState> {
  AppEditorActionBarBloc() : super(_Initial()) {
    on<AppEditorActionBarEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

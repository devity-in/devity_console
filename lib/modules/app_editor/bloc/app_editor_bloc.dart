import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_event.dart';
part 'app_editor_state.dart';
part 'app_editor_bloc.freezed.dart';

class AppEditorBloc extends Bloc<AppEditorEvent, AppEditorState> {
  AppEditorBloc() : super(_Initial()) {
    on<AppEditorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

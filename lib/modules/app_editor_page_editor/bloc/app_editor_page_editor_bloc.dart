import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_page_editor_event.dart';
part 'app_editor_page_editor_state.dart';
part 'app_editor_page_editor_bloc.freezed.dart';

class AppEditorPageEditorBloc extends Bloc<AppEditorPageEditorEvent, AppEditorPageEditorState> {
  AppEditorPageEditorBloc() : super(_Initial()) {
    on<AppEditorPageEditorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_page_list_event.dart';
part 'app_editor_page_list_state.dart';
part 'app_editor_page_list_bloc.freezed.dart';

class AppEditorPageListBloc extends Bloc<AppEditorPageListEvent, AppEditorPageListState> {
  AppEditorPageListBloc() : super(_Initial()) {
    on<AppEditorPageListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_component_list_event.dart';
part 'app_editor_component_list_state.dart';
part 'app_editor_component_list_bloc.freezed.dart';

class AppEditorComponentListBloc extends Bloc<AppEditorComponentListEvent, AppEditorComponentListState> {
  AppEditorComponentListBloc() : super(_Initial()) {
    on<AppEditorComponentListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

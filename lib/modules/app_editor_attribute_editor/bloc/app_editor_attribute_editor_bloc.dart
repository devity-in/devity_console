import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_attribute_editor_event.dart';
part 'app_editor_attribute_editor_state.dart';
part 'app_editor_attribute_editor_bloc.freezed.dart';

class AppEditorAttributeEditorBloc extends Bloc<AppEditorAttributeEditorEvent, AppEditorAttributeEditorState> {
  AppEditorAttributeEditorBloc() : super(_Initial()) {
    on<AppEditorAttributeEditorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

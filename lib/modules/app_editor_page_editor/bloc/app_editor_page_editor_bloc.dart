import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_page_editor_event.dart';
part 'app_editor_page_editor_state.dart';
part 'app_editor_page_editor_bloc.freezed.dart';

/// [AppEditorPageEditorBloc] is a business logic component that manages the
/// state of the AppEditorPageEditor widget.
class AppEditorPageEditorBloc
    extends Bloc<AppEditorPageEditorEvent, AppEditorPageEditorState> {
  /// [AppEditorPageEditorBloc] constructor
  AppEditorPageEditorBloc() : super(const _Initial()) {
    on<AppEditorPageEditorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

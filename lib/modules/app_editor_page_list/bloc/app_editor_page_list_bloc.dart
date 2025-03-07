import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_page_list_event.dart';
part 'app_editor_page_list_state.dart';
part 'app_editor_page_list_bloc.freezed.dart';

/// [AppEditorPageListBloc] is a business logic component that manages the
/// state of the AppEditorPageList widget.
///
class AppEditorPageListBloc
    extends Bloc<AppEditorPageListEvent, AppEditorPageListState> {
  /// The default constructor for the [AppEditorPageListBloc].
  AppEditorPageListBloc() : super(const _Initial()) {
    on<AppEditorPageListEvent>((event, emit) {
      // TODO(abhishekthakur0): implement event handler
    });
  }
}

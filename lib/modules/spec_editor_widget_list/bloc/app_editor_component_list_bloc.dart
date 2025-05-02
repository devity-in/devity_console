import 'package:bloc/bloc.dart';

part 'app_editor_component_list_event.dart';
part 'app_editor_component_list_state.dart';
part 'app_editor_component_list_bloc.freezed.dart';

/// [AppEditorComponentListBloc] is a business logic component that manages the
/// state of the AppEditorComponentList widget.
class AppEditorComponentListBloc
    extends Bloc<AppEditorComponentListEvent, AppEditorComponentListState> {
  /// The default constructor for the [AppEditorComponentListBloc].
  AppEditorComponentListBloc() : super(const _Initial()) {
    on<AppEditorComponentListEvent>((event, emit) {
      // TODO(abhishekthakur0): implement event handler
    });
  }
}

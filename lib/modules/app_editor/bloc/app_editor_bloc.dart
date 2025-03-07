import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_event.dart';
part 'app_editor_state.dart';
part 'app_editor_bloc.freezed.dart';

/// [AppEditorBloc] is a business logic component that manages the state of the
/// AppEditor widget.
class AppEditorBloc extends Bloc<AppEditorEvent, AppEditorState> {
  /// The default constructor for the [AppEditorBloc].
  AppEditorBloc() : super(const _Initial()) {
    on<AppEditorEvent>((event, emit) {
      // TODO(abhishekthakur0): implement event handler
    });
  }
}

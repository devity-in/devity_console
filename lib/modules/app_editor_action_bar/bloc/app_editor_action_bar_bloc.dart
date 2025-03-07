import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_action_bar_event.dart';
part 'app_editor_action_bar_state.dart';
part 'app_editor_action_bar_bloc.freezed.dart';

/// [AppEditorActionBarBloc] is a business logic component that manages the
/// state of the AppEditorActionBar widget.
class AppEditorActionBarBloc
    extends Bloc<AppEditorActionBarEvent, AppEditorActionBarState> {
  /// The default constructor for the [AppEditorActionBarBloc].
  AppEditorActionBarBloc() : super(const _Initial()) {
    on<AppEditorActionBarEvent>((event, emit) {
      // TODO(abhishekthakur0): implement event handler
    });
  }
}

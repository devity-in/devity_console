import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_editor_attribute_editor_event.dart';
part 'app_editor_attribute_editor_state.dart';
part 'app_editor_attribute_editor_bloc.freezed.dart';

/// [AppEditorAttributeEditorBloc] is a business logic component that manages
///  the
/// state of the AppEditorAttributeEditor widget.
class AppEditorAttributeEditorBloc
    extends Bloc<AppEditorAttributeEditorEvent, AppEditorAttributeEditorState> {
  /// The default constructor for the [AppEditorAttributeEditorBloc].
  AppEditorAttributeEditorBloc() : super(const _Initial()) {
    on<AppEditorAttributeEditorEvent>((event, emit) {
      // TODO(abhishekthakur0): implement event handler
    });
  }
}

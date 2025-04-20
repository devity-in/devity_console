import 'package:equatable/equatable.dart';

/// Events for the [AppEditorAttributeEditorBloc]
abstract class AppEditorAttributeEditorEvent extends Equatable {
  const AppEditorAttributeEditorEvent();

  @override
  List<Object> get props => [];
}

/// Event to initialize the editor
class AppEditorAttributeEditorInitializeEvent
    extends AppEditorAttributeEditorEvent {
  const AppEditorAttributeEditorInitializeEvent();
}

/// Event to update an attribute
class AppEditorAttributeEditorUpdateEvent
    extends AppEditorAttributeEditorEvent {
  const AppEditorAttributeEditorUpdateEvent({
    required this.attribute,
  });

  final Map<String, dynamic> attribute;

  @override
  List<Object> get props => [attribute];
}

/// Event to delete an attribute
class AppEditorAttributeEditorDeleteEvent
    extends AppEditorAttributeEditorEvent {
  const AppEditorAttributeEditorDeleteEvent({
    required this.attributeId,
  });

  final String attributeId;

  @override
  List<Object> get props => [attributeId];
}

/// Event to add a new attribute
class AppEditorAttributeEditorAddEvent extends AppEditorAttributeEditorEvent {
  const AppEditorAttributeEditorAddEvent({
    required this.attribute,
  });

  final Map<String, dynamic> attribute;

  @override
  List<Object> get props => [attribute];
}

import 'package:equatable/equatable.dart';
import 'package:devity_console/models/attribute.dart';
import 'package:devity_console/models/project.dart';

abstract class AppEditorAttributeEditorState extends Equatable {
  const AppEditorAttributeEditorState();

  @override
  List<Object> get props => [];
}

class AppEditorAttributeEditorInitial extends AppEditorAttributeEditorState {}

class AppEditorAttributeEditorLoading extends AppEditorAttributeEditorState {}

class AppEditorAttributeEditorLoaded extends AppEditorAttributeEditorState {
  final List<Attribute> attributes;
  final Project project;

  const AppEditorAttributeEditorLoaded({
    required this.attributes,
    required this.project,
  });

  @override
  List<Object> get props => [attributes, project];
}

class AppEditorAttributeEditorError extends AppEditorAttributeEditorState {
  final String message;

  const AppEditorAttributeEditorError(this.message);

  @override
  List<Object> get props => [message];
}

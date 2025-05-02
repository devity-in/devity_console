import 'package:equatable/equatable.dart';

abstract class SpecEditorEvent extends Equatable {
  const SpecEditorEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the content for a specific spec.
class SpecEditorLoadRequested extends SpecEditorEvent {
  final String specId;

  const SpecEditorLoadRequested({required this.specId});

  @override
  List<Object> get props => [specId];
}

/// Event triggered when the content in the editor changes.
class SpecEditorContentChanged extends SpecEditorEvent {
  final String newContent;

  const SpecEditorContentChanged({required this.newContent});

  @override
  List<Object> get props => [newContent];
}

/// Event to trigger saving the current content.
class SpecEditorSaveRequested extends SpecEditorEvent {}

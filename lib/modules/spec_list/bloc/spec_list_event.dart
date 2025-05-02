import 'package:equatable/equatable.dart';

abstract class SpecListEvent extends Equatable {
  const SpecListEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when the spec list needs to be loaded for a project.
class SpecListLoadRequested extends SpecListEvent {
  final String projectId;

  const SpecListLoadRequested({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

// TODO: Add events for creating, deleting, selecting specs later?

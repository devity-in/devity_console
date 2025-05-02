import 'package:devity_console/models/spec_summary_model.dart';
import 'package:equatable/equatable.dart';

abstract class SpecListState extends Equatable {
  const SpecListState();

  @override
  List<Object> get props => [];
}

class SpecListInitial extends SpecListState {}

class SpecListLoading extends SpecListState {}

class SpecListLoaded extends SpecListState {
  final List<SpecSummaryModel> specs;

  const SpecListLoaded(this.specs);

  @override
  List<Object> get props => [specs];
}

class SpecListError extends SpecListState {
  final String message;

  const SpecListError(this.message);

  @override
  List<Object> get props => [message];
}

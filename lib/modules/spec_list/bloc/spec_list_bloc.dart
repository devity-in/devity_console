import 'package:devity_console/modules/spec_list/bloc/spec_list_event.dart';
import 'package:devity_console/modules/spec_list/bloc/spec_list_state.dart';
import 'package:devity_console/services/error_handler_service.dart';
import 'package:devity_console/services/network_service.dart';
import 'package:devity_console/services/spec_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecListBloc extends Bloc<SpecListEvent, SpecListState> {
  final SpecService _specService;

  SpecListBloc({SpecService? specService})
      : _specService = specService ??
            SpecService(
              networkService: NetworkService(
                errorHandler: ErrorHandlerService(),
              ),
            ),
        super(SpecListInitial()) {
    on<SpecListLoadRequested>(_onLoadRequested);
    // TODO: Register handlers for other events later
  }

  Future<void> _onLoadRequested(
    SpecListLoadRequested event,
    Emitter<SpecListState> emit,
  ) async {
    emit(SpecListLoading());
    try {
      final specs = await _specService.getSpecSummaries(event.projectId);
      emit(SpecListLoaded(specs));
    } catch (e) {
      emit(SpecListError(e.toString()));
    }
  }
}

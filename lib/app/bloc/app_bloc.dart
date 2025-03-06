import 'dart:io' show exit;

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.dart';
part 'app_state.dart';
part 'app_bloc.freezed.dart';

/// [AppBloc] is the most top level bloc in the app.
/// It is responsible for handling app level events.
class AppBloc extends Bloc<AppEvent, AppState> {
  /// Constructor for [AppBloc]
  AppBloc() : super(const _Initial()) {
    on<AppEvent>((event, emit) {
      switch (event) {
        case _Refresh():

          // Handle refresh event
          emit(const _Loading());
          emit(const _Ready());

        case _Exit():
          // Handle exit event
          exit(0);
      }
    });
  }
}

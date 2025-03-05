import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devity_console/services/logger_service.dart';
import 'package:flutter/widgets.dart';

/// Implementation of [BlocObserver] that logs all [Bloc] transitions.
class AppBlocObserver extends BlocObserver {
  /// Default constructor
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    LoggerService.commonLog('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    LoggerService.commonLog(
        'onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Bootstrap the application
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    LoggerService.commonLog(details.exceptionAsString(),
        stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(await builder());
}

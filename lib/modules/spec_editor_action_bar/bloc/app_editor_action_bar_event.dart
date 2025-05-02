import 'package:equatable/equatable.dart';

/// Events for the [AppEditorActionBarBloc]
abstract class AppEditorActionBarEvent extends Equatable {
  const AppEditorActionBarEvent();

  @override
  List<Object> get props => [];
}

/// Event to initialize the action bar
class AppEditorActionBarInitializeEvent extends AppEditorActionBarEvent {
  const AppEditorActionBarInitializeEvent();
}

/// Event to save the app
class AppEditorActionBarSaveEvent extends AppEditorActionBarEvent {
  const AppEditorActionBarSaveEvent();
}

/// Event to open settings
class AppEditorActionBarSettingsEvent extends AppEditorActionBarEvent {
  const AppEditorActionBarSettingsEvent();
}

/// Event to navigate back
class AppEditorActionBarBackEvent extends AppEditorActionBarEvent {
  const AppEditorActionBarBackEvent();
}

import 'package:devity_console/models/custom_widget.dart';
import 'package:devity_console/models/widget.dart';
import 'package:devity_console/modules/app_editor_page_editor/models/layout.dart';
import 'package:devity_console/modules/widget_builder/bloc/widget_builder_bloc.dart'
    show WidgetBuilderBloc;
import 'package:equatable/equatable.dart';

/// The state of the [WidgetBuilderBloc]
abstract class WidgetBuilderState extends Equatable {
  /// Creates a new [WidgetBuilderState]
  const WidgetBuilderState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the [WidgetBuilderBloc]
class WidgetBuilderInitial extends WidgetBuilderState {
  /// Creates a new [WidgetBuilderInitial]
  const WidgetBuilderInitial();
}

/// The state when the [WidgetBuilderBloc] is loading
class WidgetBuilderLoading extends WidgetBuilderState {
  /// Creates a new [WidgetBuilderLoading]
  const WidgetBuilderLoading();
}

/// The state when the [WidgetBuilderBloc] has loaded widgets
class WidgetBuilderLoaded extends WidgetBuilderState {
  /// Creates a new [WidgetBuilderLoaded]
  const WidgetBuilderLoaded({
    required this.widgets,
    required this.customWidgets,
    this.selectedLayout,
    this.selectedWidgets = const [],
  });

  /// The list of available widgets
  final List<AppWidget> widgets;

  /// The list of custom widgets
  final List<CustomWidget> customWidgets;

  /// The currently selected layout
  final LayoutType? selectedLayout;

  /// The list of selected widgets
  final List<AppWidget> selectedWidgets;

  @override
  List<Object?> get props => [
        widgets,
        customWidgets,
        selectedLayout,
        selectedWidgets,
      ];

  /// Creates a copy of this state with the given fields replaced with the new values
  WidgetBuilderLoaded copyWith({
    List<AppWidget>? widgets,
    List<CustomWidget>? customWidgets,
    LayoutType? selectedLayout,
    List<AppWidget>? selectedWidgets,
  }) {
    return WidgetBuilderLoaded(
      widgets: widgets ?? this.widgets,
      customWidgets: customWidgets ?? this.customWidgets,
      selectedLayout: selectedLayout ?? this.selectedLayout,
      selectedWidgets: selectedWidgets ?? this.selectedWidgets,
    );
  }
}

/// The state when the [WidgetBuilderBloc] has encountered an error
class WidgetBuilderError extends WidgetBuilderState {
  /// Creates a new [WidgetBuilderError]
  const WidgetBuilderError(this.message);

  /// The error message
  final String message;

  @override
  List<Object?> get props => [message];
}

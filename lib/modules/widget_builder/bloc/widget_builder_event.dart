import 'package:devity_console/models/widget.dart';
import 'package:devity_console/modules/spec_editor_page_editor/models/layout.dart';
import 'package:devity_console/modules/widget_builder/bloc/widget_builder_bloc.dart'
    show WidgetBuilderBloc;
import 'package:equatable/equatable.dart';



/// The events that can be dispatched to the [WidgetBuilderBloc]
abstract class WidgetBuilderEvent extends Equatable {
  /// Creates a new [WidgetBuilderEvent]
  const WidgetBuilderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load widgets
class WidgetBuilderLoadWidgets extends WidgetBuilderEvent {
  /// Creates a new [WidgetBuilderLoadWidgets]
  const WidgetBuilderLoadWidgets();
}

/// Event to select a layout
class WidgetBuilderLayoutSelected extends WidgetBuilderEvent {
  /// Creates a new [WidgetBuilderLayoutSelected]
  const WidgetBuilderLayoutSelected(this.layout);

  /// The selected layout
  final LayoutType layout;

  @override
  List<Object?> get props => [layout];
}

/// Event to add a widget to the selected layout
class WidgetBuilderWidgetAdded extends WidgetBuilderEvent {
  /// Creates a new [WidgetBuilderWidgetAdded]
  const WidgetBuilderWidgetAdded(this.widget);

  /// The widget to add
  final AppWidget widget;

  @override
  List<Object?> get props => [widget];
}

/// Event to remove a widget from the selected layout
class WidgetBuilderWidgetRemoved extends WidgetBuilderEvent {
  /// Creates a new [WidgetBuilderWidgetRemoved]
  const WidgetBuilderWidgetRemoved(this.index);

  /// The index of the widget to remove
  final int index;

  @override
  List<Object?> get props => [index];
}

/// Event to create a custom widget
class WidgetBuilderCustomWidgetCreated extends WidgetBuilderEvent {
  /// Creates a new [WidgetBuilderCustomWidgetCreated]
  const WidgetBuilderCustomWidgetCreated({
    required this.name,
    required this.description,
    required this.isPublic,
  });

  /// The name of the custom widget
  final String name;

  /// The description of the custom widget
  final String description;

  /// Whether the custom widget is public
  final bool isPublic;

  @override
  List<Object?> get props => [name, description, isPublic];
}

import 'package:equatable/equatable.dart';

/// Represents a layout in the page editor
class Layout extends Equatable {
  /// Creates a new instance of [Layout]
  const Layout({
    required this.type,
    this.widgets = const [],
    this.attributes = const {},
  });

  /// The type of layout
  final LayoutType type;

  /// The widgets in this layout
  final List<dynamic> widgets;

  /// The attributes of this layout
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props => [type, widgets, attributes];

  /// Creates a copy of this layout with the given fields replaced with the new values
  Layout copyWith({
    LayoutType? type,
    List<dynamic>? widgets,
    Map<String, dynamic>? attributes,
  }) {
    return Layout(
      type: type ?? this.type,
      widgets: widgets ?? this.widgets,
      attributes: attributes ?? this.attributes,
    );
  }
}

/// Types of layouts in the page editor
enum LayoutType {
  /// Stack widgets on top of one another
  zStack,

  /// Display widgets in a scrollable carousel
  carousel,

  /// Organize widgets in a grid pattern
  grid,

  /// Stack widgets vertically with spacing
  vertical,
}

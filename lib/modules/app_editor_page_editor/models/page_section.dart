import 'package:devity_console/modules/app_editor_page_editor/models/layout.dart';
import 'package:equatable/equatable.dart';

/// Represents a section in the page editor
class PageSection extends Equatable {
  /// Creates a new instance of [PageSection]
  const PageSection({
    required this.type,
    this.widgets = const [],
    this.layouts = const [],
    this.attributes = const {},
  });

  /// The type of section
  final PageSectionType type;

  /// The widgets in this section
  final List<dynamic> widgets;

  /// The layouts in this section
  final List<Layout> layouts;

  /// The attributes of this section
  final Map<String, dynamic> attributes;

  @override
  List<Object?> get props => [type, widgets, layouts, attributes];

  /// Creates a copy of this section with the given fields replaced with the new values
  PageSection copyWith({
    PageSectionType? type,
    List<dynamic>? widgets,
    List<Layout>? layouts,
    Map<String, dynamic>? attributes,
  }) {
    return PageSection(
      type: type ?? this.type,
      widgets: widgets ?? this.widgets,
      layouts: layouts ?? this.layouts,
      attributes: attributes ?? this.attributes,
    );
  }
}

/// Types of sections in the page editor
enum PageSectionType {
  /// Top navigation bar section
  topNavigationBar,

  /// Top sticky section
  topSticky,

  /// Scrollable section
  scrollable,

  /// Bottom sticky section
  bottomSticky,

  /// Bottom navigation bar section
  bottomNavigationBar,
}

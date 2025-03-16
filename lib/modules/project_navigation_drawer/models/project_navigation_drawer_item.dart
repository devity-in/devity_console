import 'package:flutter/widgets.dart' show IconData;
import 'package:freezed_annotation/freezed_annotation.dart';
part 'project_navigation_drawer_item.freezed.dart';

/// [ProjectNavigationDrawerItem] is a class that represents a
/// project navigation drawer item.
@freezed
abstract class ProjectNavigationDrawerItem with _$ProjectNavigationDrawerItem {
  /// Creates a new instance of [ProjectNavigationDrawerItem].
  const factory ProjectNavigationDrawerItem({
    required String title,
    required String route,
    required IconData? icon,
  }) = _ProjectNavigationDrawerItem;

  /// Creates an empty instance of [ProjectNavigationDrawerItem].
  factory ProjectNavigationDrawerItem.empty() =>
      const ProjectNavigationDrawerItem(
        title: '',
        route: '',
        icon: null,
      );
}

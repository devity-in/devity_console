// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_navigation_drawer_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectNavigationDrawerItem {
  String get title;
  String get route;
  IconData? get icon;

  /// Create a copy of ProjectNavigationDrawerItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectNavigationDrawerItemCopyWith<ProjectNavigationDrawerItem>
      get copyWith => _$ProjectNavigationDrawerItemCopyWithImpl<
              ProjectNavigationDrawerItem>(
          this as ProjectNavigationDrawerItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectNavigationDrawerItem &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, route, icon);

  @override
  String toString() {
    return 'ProjectNavigationDrawerItem(title: $title, route: $route, icon: $icon)';
  }
}

/// @nodoc
abstract mixin class $ProjectNavigationDrawerItemCopyWith<$Res> {
  factory $ProjectNavigationDrawerItemCopyWith(
          ProjectNavigationDrawerItem value,
          $Res Function(ProjectNavigationDrawerItem) _then) =
      _$ProjectNavigationDrawerItemCopyWithImpl;
  @useResult
  $Res call({String title, String route, IconData? icon});
}

/// @nodoc
class _$ProjectNavigationDrawerItemCopyWithImpl<$Res>
    implements $ProjectNavigationDrawerItemCopyWith<$Res> {
  _$ProjectNavigationDrawerItemCopyWithImpl(this._self, this._then);

  final ProjectNavigationDrawerItem _self;
  final $Res Function(ProjectNavigationDrawerItem) _then;

  /// Create a copy of ProjectNavigationDrawerItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? route = null,
    Object? icon = freezed,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      route: null == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData?,
    ));
  }
}

/// @nodoc

class _ProjectNavigationDrawerItem implements ProjectNavigationDrawerItem {
  const _ProjectNavigationDrawerItem(
      {required this.title, required this.route, required this.icon});

  @override
  final String title;
  @override
  final String route;
  @override
  final IconData? icon;

  /// Create a copy of ProjectNavigationDrawerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProjectNavigationDrawerItemCopyWith<_ProjectNavigationDrawerItem>
      get copyWith => __$ProjectNavigationDrawerItemCopyWithImpl<
          _ProjectNavigationDrawerItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProjectNavigationDrawerItem &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, route, icon);

  @override
  String toString() {
    return 'ProjectNavigationDrawerItem(title: $title, route: $route, icon: $icon)';
  }
}

/// @nodoc
abstract mixin class _$ProjectNavigationDrawerItemCopyWith<$Res>
    implements $ProjectNavigationDrawerItemCopyWith<$Res> {
  factory _$ProjectNavigationDrawerItemCopyWith(
          _ProjectNavigationDrawerItem value,
          $Res Function(_ProjectNavigationDrawerItem) _then) =
      __$ProjectNavigationDrawerItemCopyWithImpl;
  @override
  @useResult
  $Res call({String title, String route, IconData? icon});
}

/// @nodoc
class __$ProjectNavigationDrawerItemCopyWithImpl<$Res>
    implements _$ProjectNavigationDrawerItemCopyWith<$Res> {
  __$ProjectNavigationDrawerItemCopyWithImpl(this._self, this._then);

  final _ProjectNavigationDrawerItem _self;
  final $Res Function(_ProjectNavigationDrawerItem) _then;

  /// Create a copy of ProjectNavigationDrawerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? route = null,
    Object? icon = freezed,
  }) {
    return _then(_ProjectNavigationDrawerItem(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      route: null == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData?,
    ));
  }
}

// dart format on

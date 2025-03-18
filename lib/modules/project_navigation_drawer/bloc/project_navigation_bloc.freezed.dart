// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_navigation_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectNavigationEvent implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'ProjectNavigationEvent'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectNavigationEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProjectNavigationEvent()';
  }
}

/// @nodoc
class $ProjectNavigationEventCopyWith<$Res> {
  $ProjectNavigationEventCopyWith(
      ProjectNavigationEvent _, $Res Function(ProjectNavigationEvent) __);
}

/// @nodoc

class _Started with DiagnosticableTreeMixin implements ProjectNavigationEvent {
  const _Started();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ProjectNavigationEvent.started'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Started);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProjectNavigationEvent.started()';
  }
}

/// @nodoc

class _Reload with DiagnosticableTreeMixin implements ProjectNavigationEvent {
  const _Reload();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ProjectNavigationEvent.reload'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Reload);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProjectNavigationEvent.reload()';
  }
}

/// @nodoc
mixin _$ProjectNavigationState implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'ProjectNavigationState'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectNavigationState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProjectNavigationState()';
  }
}

/// @nodoc
class $ProjectNavigationStateCopyWith<$Res> {
  $ProjectNavigationStateCopyWith(
      ProjectNavigationState _, $Res Function(ProjectNavigationState) __);
}

/// @nodoc

class _Initial with DiagnosticableTreeMixin implements ProjectNavigationState {
  const _Initial();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ProjectNavigationState.initial'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProjectNavigationState.initial()';
  }
}

/// @nodoc

class Loaded with DiagnosticableTreeMixin implements ProjectNavigationState {
  const Loaded(final List<ProjectNavigationDrawerItem> items, this.selectedItem,
      {this.isExpanded = false})
      : _items = items;

  final List<ProjectNavigationDrawerItem> _items;
  List<ProjectNavigationDrawerItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final ProjectNavigationDrawerItem? selectedItem;
  @JsonKey()
  final bool isExpanded;

  /// Create a copy of ProjectNavigationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoadedCopyWith<Loaded> get copyWith =>
      _$LoadedCopyWithImpl<Loaded>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ProjectNavigationState.loaded'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('selectedItem', selectedItem))
      ..add(DiagnosticsProperty('isExpanded', isExpanded));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Loaded &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.selectedItem, selectedItem) ||
                other.selectedItem == selectedItem) &&
            (identical(other.isExpanded, isExpanded) ||
                other.isExpanded == isExpanded));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), selectedItem, isExpanded);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProjectNavigationState.loaded(items: $items, selectedItem: $selectedItem, isExpanded: $isExpanded)';
  }
}

/// @nodoc
abstract mixin class $LoadedCopyWith<$Res>
    implements $ProjectNavigationStateCopyWith<$Res> {
  factory $LoadedCopyWith(Loaded value, $Res Function(Loaded) _then) =
      _$LoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<ProjectNavigationDrawerItem> items,
      ProjectNavigationDrawerItem? selectedItem,
      bool isExpanded});

  $ProjectNavigationDrawerItemCopyWith<$Res>? get selectedItem;
}

/// @nodoc
class _$LoadedCopyWithImpl<$Res> implements $LoadedCopyWith<$Res> {
  _$LoadedCopyWithImpl(this._self, this._then);

  final Loaded _self;
  final $Res Function(Loaded) _then;

  /// Create a copy of ProjectNavigationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? selectedItem = freezed,
    Object? isExpanded = null,
  }) {
    return _then(Loaded(
      null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ProjectNavigationDrawerItem>,
      freezed == selectedItem
          ? _self.selectedItem
          : selectedItem // ignore: cast_nullable_to_non_nullable
              as ProjectNavigationDrawerItem?,
      isExpanded: null == isExpanded
          ? _self.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of ProjectNavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectNavigationDrawerItemCopyWith<$Res>? get selectedItem {
    if (_self.selectedItem == null) {
      return null;
    }

    return $ProjectNavigationDrawerItemCopyWith<$Res>(_self.selectedItem!,
        (value) {
      return _then(_self.copyWith(selectedItem: value));
    });
  }
}

// dart format on

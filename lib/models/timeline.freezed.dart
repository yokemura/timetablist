// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Timeline {

 String get id; String get name;@TimelineTimeConverter() TimelineTime get startTime; List<Slot> get slots;
/// Create a copy of Timeline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineCopyWith<Timeline> get copyWith => _$TimelineCopyWithImpl<Timeline>(this as Timeline, _$identity);

  /// Serializes this Timeline to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Timeline&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&const DeepCollectionEquality().equals(other.slots, slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startTime,const DeepCollectionEquality().hash(slots));

@override
String toString() {
  return 'Timeline(id: $id, name: $name, startTime: $startTime, slots: $slots)';
}


}

/// @nodoc
abstract mixin class $TimelineCopyWith<$Res>  {
  factory $TimelineCopyWith(Timeline value, $Res Function(Timeline) _then) = _$TimelineCopyWithImpl;
@useResult
$Res call({
 String id, String name,@TimelineTimeConverter() TimelineTime startTime, List<Slot> slots
});




}
/// @nodoc
class _$TimelineCopyWithImpl<$Res>
    implements $TimelineCopyWith<$Res> {
  _$TimelineCopyWithImpl(this._self, this._then);

  final Timeline _self;
  final $Res Function(Timeline) _then;

/// Create a copy of Timeline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? startTime = null,Object? slots = null,}) {
  return _then(Timeline(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimelineTime,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}

}


/// Adds pattern-matching-related methods to [Timeline].
extension TimelinePatterns on Timeline {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Timeline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Timeline() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Timeline value)  $default,){
final _that = this;
switch (_that) {
case _Timeline():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Timeline value)?  $default,){
final _that = this;
switch (_that) {
case _Timeline() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @TimelineTimeConverter()  TimelineTime startTime,  List<Slot> slots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Timeline() when $default != null:
return $default(_that.id,_that.name,_that.startTime,_that.slots);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @TimelineTimeConverter()  TimelineTime startTime,  List<Slot> slots)  $default,) {final _that = this;
switch (_that) {
case _Timeline():
return $default(_that.id,_that.name,_that.startTime,_that.slots);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @TimelineTimeConverter()  TimelineTime startTime,  List<Slot> slots)?  $default,) {final _that = this;
switch (_that) {
case _Timeline() when $default != null:
return $default(_that.id,_that.name,_that.startTime,_that.slots);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Timeline extends Timeline {
  const _Timeline({required this.id, required this.name, @TimelineTimeConverter() required this.startTime, required  List<Slot> slots}): _slots = slots,super._();
  factory _Timeline.fromJson(Map<String, dynamic> json) => _$TimelineFromJson(json);

@override final  String id;
@override final  String name;
@override@TimelineTimeConverter() final  TimelineTime startTime;
 final  List<Slot> _slots;
@override List<Slot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


/// Create a copy of Timeline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineCopyWith<_Timeline> get copyWith => __$TimelineCopyWithImpl<_Timeline>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Timeline&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&const DeepCollectionEquality().equals(other._slots, _slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,startTime,const DeepCollectionEquality().hash(_slots));

@override
String toString() {
  return 'Timeline(id: $id, name: $name, startTime: $startTime, slots: $slots)';
}


}

/// @nodoc
abstract mixin class _$TimelineCopyWith<$Res> implements $TimelineCopyWith<$Res> {
  factory _$TimelineCopyWith(_Timeline value, $Res Function(_Timeline) _then) = __$TimelineCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@TimelineTimeConverter() TimelineTime startTime, List<Slot> slots
});




}
/// @nodoc
class __$TimelineCopyWithImpl<$Res>
    implements _$TimelineCopyWith<$Res> {
  __$TimelineCopyWithImpl(this._self, this._then);

  final _Timeline _self;
  final $Res Function(_Timeline) _then;

/// Create a copy of Timeline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? startTime = null,Object? slots = null,}) {
  return _then(_Timeline(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimelineTime,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}


}

// dart format on

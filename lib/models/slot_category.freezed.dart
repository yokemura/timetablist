// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slot_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SlotCategory {

 String get id; String get name; int get durationMinutes; bool get isPerformanceSlot;
/// Create a copy of SlotCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotCategoryCopyWith<SlotCategory> get copyWith => _$SlotCategoryCopyWithImpl<SlotCategory>(this as SlotCategory, _$identity);

  /// Serializes this SlotCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.isPerformanceSlot, isPerformanceSlot) || other.isPerformanceSlot == isPerformanceSlot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,durationMinutes,isPerformanceSlot);

@override
String toString() {
  return 'SlotCategory(id: $id, name: $name, durationMinutes: $durationMinutes, isPerformanceSlot: $isPerformanceSlot)';
}


}

/// @nodoc
abstract mixin class $SlotCategoryCopyWith<$Res>  {
  factory $SlotCategoryCopyWith(SlotCategory value, $Res Function(SlotCategory) _then) = _$SlotCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, int durationMinutes, bool isPerformanceSlot
});




}
/// @nodoc
class _$SlotCategoryCopyWithImpl<$Res>
    implements $SlotCategoryCopyWith<$Res> {
  _$SlotCategoryCopyWithImpl(this._self, this._then);

  final SlotCategory _self;
  final $Res Function(SlotCategory) _then;

/// Create a copy of SlotCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? isPerformanceSlot = null,}) {
  return _then(SlotCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,isPerformanceSlot: null == isPerformanceSlot ? _self.isPerformanceSlot : isPerformanceSlot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotCategory].
extension SlotCategoryPatterns on SlotCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotCategory value)  $default,){
final _that = this;
switch (_that) {
case _SlotCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotCategory value)?  $default,){
final _that = this;
switch (_that) {
case _SlotCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int durationMinutes,  bool isPerformanceSlot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotCategory() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.isPerformanceSlot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int durationMinutes,  bool isPerformanceSlot)  $default,) {final _that = this;
switch (_that) {
case _SlotCategory():
return $default(_that.id,_that.name,_that.durationMinutes,_that.isPerformanceSlot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int durationMinutes,  bool isPerformanceSlot)?  $default,) {final _that = this;
switch (_that) {
case _SlotCategory() when $default != null:
return $default(_that.id,_that.name,_that.durationMinutes,_that.isPerformanceSlot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotCategory implements SlotCategory {
  const _SlotCategory({required this.id, required this.name, required this.durationMinutes, required this.isPerformanceSlot});
  factory _SlotCategory.fromJson(Map<String, dynamic> json) => _$SlotCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  int durationMinutes;
@override final  bool isPerformanceSlot;

/// Create a copy of SlotCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotCategoryCopyWith<_SlotCategory> get copyWith => __$SlotCategoryCopyWithImpl<_SlotCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.isPerformanceSlot, isPerformanceSlot) || other.isPerformanceSlot == isPerformanceSlot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,durationMinutes,isPerformanceSlot);

@override
String toString() {
  return 'SlotCategory(id: $id, name: $name, durationMinutes: $durationMinutes, isPerformanceSlot: $isPerformanceSlot)';
}


}

/// @nodoc
abstract mixin class _$SlotCategoryCopyWith<$Res> implements $SlotCategoryCopyWith<$Res> {
  factory _$SlotCategoryCopyWith(_SlotCategory value, $Res Function(_SlotCategory) _then) = __$SlotCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int durationMinutes, bool isPerformanceSlot
});




}
/// @nodoc
class __$SlotCategoryCopyWithImpl<$Res>
    implements _$SlotCategoryCopyWith<$Res> {
  __$SlotCategoryCopyWithImpl(this._self, this._then);

  final _SlotCategory _self;
  final $Res Function(_SlotCategory) _then;

/// Create a copy of SlotCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? durationMinutes = null,Object? isPerformanceSlot = null,}) {
  return _then(_SlotCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,isPerformanceSlot: null == isPerformanceSlot ? _self.isPerformanceSlot : isPerformanceSlot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

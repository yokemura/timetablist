// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Slot {

 String get id; String get categoryId; String? get participantId;
/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotCopyWith<Slot> get copyWith => _$SlotCopyWithImpl<Slot>(this as Slot, _$identity);

  /// Serializes this Slot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Slot&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.participantId, participantId) || other.participantId == participantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,participantId);

@override
String toString() {
  return 'Slot(id: $id, categoryId: $categoryId, participantId: $participantId)';
}


}

/// @nodoc
abstract mixin class $SlotCopyWith<$Res>  {
  factory $SlotCopyWith(Slot value, $Res Function(Slot) _then) = _$SlotCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String? participantId
});




}
/// @nodoc
class _$SlotCopyWithImpl<$Res>
    implements $SlotCopyWith<$Res> {
  _$SlotCopyWithImpl(this._self, this._then);

  final Slot _self;
  final $Res Function(Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? participantId = freezed,}) {
  return _then(Slot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,participantId: freezed == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Slot].
extension SlotPatterns on Slot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Slot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Slot value)  $default,){
final _that = this;
switch (_that) {
case _Slot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Slot value)?  $default,){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String? participantId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.id,_that.categoryId,_that.participantId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String? participantId)  $default,) {final _that = this;
switch (_that) {
case _Slot():
return $default(_that.id,_that.categoryId,_that.participantId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String? participantId)?  $default,) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.id,_that.categoryId,_that.participantId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Slot implements Slot {
  const _Slot({required this.id, required this.categoryId, this.participantId});
  factory _Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String? participantId;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotCopyWith<_Slot> get copyWith => __$SlotCopyWithImpl<_Slot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Slot&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.participantId, participantId) || other.participantId == participantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,participantId);

@override
String toString() {
  return 'Slot(id: $id, categoryId: $categoryId, participantId: $participantId)';
}


}

/// @nodoc
abstract mixin class _$SlotCopyWith<$Res> implements $SlotCopyWith<$Res> {
  factory _$SlotCopyWith(_Slot value, $Res Function(_Slot) _then) = __$SlotCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String? participantId
});




}
/// @nodoc
class __$SlotCopyWithImpl<$Res>
    implements _$SlotCopyWith<$Res> {
  __$SlotCopyWithImpl(this._self, this._then);

  final _Slot _self;
  final $Res Function(_Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? participantId = freezed,}) {
  return _then(_Slot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,participantId: freezed == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

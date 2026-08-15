// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantRequirements {

 int? get minDurationMinutes; int? get maxDurationMinutes;@TimelineTimeConverter() TimelineTime? get finishBy;@TimelineTimeConverter() TimelineTime? get startAfter;/// Inclusive 1-based performance-slot index (〜番目以降).
 int? get preferredOrderFrom;/// Exclusive 1-based performance-slot index (〜番目より前).
 int? get preferredOrderBefore;
/// Create a copy of ParticipantRequirements
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantRequirementsCopyWith<ParticipantRequirements> get copyWith => _$ParticipantRequirementsCopyWithImpl<ParticipantRequirements>(this as ParticipantRequirements, _$identity);

  /// Serializes this ParticipantRequirements to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantRequirements&&(identical(other.minDurationMinutes, minDurationMinutes) || other.minDurationMinutes == minDurationMinutes)&&(identical(other.maxDurationMinutes, maxDurationMinutes) || other.maxDurationMinutes == maxDurationMinutes)&&(identical(other.finishBy, finishBy) || other.finishBy == finishBy)&&(identical(other.startAfter, startAfter) || other.startAfter == startAfter)&&(identical(other.preferredOrderFrom, preferredOrderFrom) || other.preferredOrderFrom == preferredOrderFrom)&&(identical(other.preferredOrderBefore, preferredOrderBefore) || other.preferredOrderBefore == preferredOrderBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minDurationMinutes,maxDurationMinutes,finishBy,startAfter,preferredOrderFrom,preferredOrderBefore);

@override
String toString() {
  return 'ParticipantRequirements(minDurationMinutes: $minDurationMinutes, maxDurationMinutes: $maxDurationMinutes, finishBy: $finishBy, startAfter: $startAfter, preferredOrderFrom: $preferredOrderFrom, preferredOrderBefore: $preferredOrderBefore)';
}


}

/// @nodoc
abstract mixin class $ParticipantRequirementsCopyWith<$Res>  {
  factory $ParticipantRequirementsCopyWith(ParticipantRequirements value, $Res Function(ParticipantRequirements) _then) = _$ParticipantRequirementsCopyWithImpl;
@useResult
$Res call({
 int? minDurationMinutes, int? maxDurationMinutes,@TimelineTimeConverter() TimelineTime? finishBy,@TimelineTimeConverter() TimelineTime? startAfter, int? preferredOrderFrom, int? preferredOrderBefore
});




}
/// @nodoc
class _$ParticipantRequirementsCopyWithImpl<$Res>
    implements $ParticipantRequirementsCopyWith<$Res> {
  _$ParticipantRequirementsCopyWithImpl(this._self, this._then);

  final ParticipantRequirements _self;
  final $Res Function(ParticipantRequirements) _then;

/// Create a copy of ParticipantRequirements
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minDurationMinutes = freezed,Object? maxDurationMinutes = freezed,Object? finishBy = freezed,Object? startAfter = freezed,Object? preferredOrderFrom = freezed,Object? preferredOrderBefore = freezed,}) {
  return _then(ParticipantRequirements(
minDurationMinutes: freezed == minDurationMinutes ? _self.minDurationMinutes : minDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxDurationMinutes: freezed == maxDurationMinutes ? _self.maxDurationMinutes : maxDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,finishBy: freezed == finishBy ? _self.finishBy : finishBy // ignore: cast_nullable_to_non_nullable
as TimelineTime?,startAfter: freezed == startAfter ? _self.startAfter : startAfter // ignore: cast_nullable_to_non_nullable
as TimelineTime?,preferredOrderFrom: freezed == preferredOrderFrom ? _self.preferredOrderFrom : preferredOrderFrom // ignore: cast_nullable_to_non_nullable
as int?,preferredOrderBefore: freezed == preferredOrderBefore ? _self.preferredOrderBefore : preferredOrderBefore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantRequirements].
extension ParticipantRequirementsPatterns on ParticipantRequirements {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParticipantRequirements value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParticipantRequirements() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParticipantRequirements value)  $default,){
final _that = this;
switch (_that) {
case _ParticipantRequirements():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParticipantRequirements value)?  $default,){
final _that = this;
switch (_that) {
case _ParticipantRequirements() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? minDurationMinutes,  int? maxDurationMinutes, @TimelineTimeConverter()  TimelineTime? finishBy, @TimelineTimeConverter()  TimelineTime? startAfter,  int? preferredOrderFrom,  int? preferredOrderBefore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParticipantRequirements() when $default != null:
return $default(_that.minDurationMinutes,_that.maxDurationMinutes,_that.finishBy,_that.startAfter,_that.preferredOrderFrom,_that.preferredOrderBefore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? minDurationMinutes,  int? maxDurationMinutes, @TimelineTimeConverter()  TimelineTime? finishBy, @TimelineTimeConverter()  TimelineTime? startAfter,  int? preferredOrderFrom,  int? preferredOrderBefore)  $default,) {final _that = this;
switch (_that) {
case _ParticipantRequirements():
return $default(_that.minDurationMinutes,_that.maxDurationMinutes,_that.finishBy,_that.startAfter,_that.preferredOrderFrom,_that.preferredOrderBefore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? minDurationMinutes,  int? maxDurationMinutes, @TimelineTimeConverter()  TimelineTime? finishBy, @TimelineTimeConverter()  TimelineTime? startAfter,  int? preferredOrderFrom,  int? preferredOrderBefore)?  $default,) {final _that = this;
switch (_that) {
case _ParticipantRequirements() when $default != null:
return $default(_that.minDurationMinutes,_that.maxDurationMinutes,_that.finishBy,_that.startAfter,_that.preferredOrderFrom,_that.preferredOrderBefore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParticipantRequirements implements ParticipantRequirements {
  const _ParticipantRequirements({this.minDurationMinutes, this.maxDurationMinutes, @TimelineTimeConverter() this.finishBy, @TimelineTimeConverter() this.startAfter, this.preferredOrderFrom, this.preferredOrderBefore});
  factory _ParticipantRequirements.fromJson(Map<String, dynamic> json) => _$ParticipantRequirementsFromJson(json);

@override final  int? minDurationMinutes;
@override final  int? maxDurationMinutes;
@override@TimelineTimeConverter() final  TimelineTime? finishBy;
@override@TimelineTimeConverter() final  TimelineTime? startAfter;
/// Inclusive 1-based performance-slot index (〜番目以降).
@override final  int? preferredOrderFrom;
/// Exclusive 1-based performance-slot index (〜番目より前).
@override final  int? preferredOrderBefore;

/// Create a copy of ParticipantRequirements
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantRequirementsCopyWith<_ParticipantRequirements> get copyWith => __$ParticipantRequirementsCopyWithImpl<_ParticipantRequirements>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantRequirementsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipantRequirements&&(identical(other.minDurationMinutes, minDurationMinutes) || other.minDurationMinutes == minDurationMinutes)&&(identical(other.maxDurationMinutes, maxDurationMinutes) || other.maxDurationMinutes == maxDurationMinutes)&&(identical(other.finishBy, finishBy) || other.finishBy == finishBy)&&(identical(other.startAfter, startAfter) || other.startAfter == startAfter)&&(identical(other.preferredOrderFrom, preferredOrderFrom) || other.preferredOrderFrom == preferredOrderFrom)&&(identical(other.preferredOrderBefore, preferredOrderBefore) || other.preferredOrderBefore == preferredOrderBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minDurationMinutes,maxDurationMinutes,finishBy,startAfter,preferredOrderFrom,preferredOrderBefore);

@override
String toString() {
  return 'ParticipantRequirements(minDurationMinutes: $minDurationMinutes, maxDurationMinutes: $maxDurationMinutes, finishBy: $finishBy, startAfter: $startAfter, preferredOrderFrom: $preferredOrderFrom, preferredOrderBefore: $preferredOrderBefore)';
}


}

/// @nodoc
abstract mixin class _$ParticipantRequirementsCopyWith<$Res> implements $ParticipantRequirementsCopyWith<$Res> {
  factory _$ParticipantRequirementsCopyWith(_ParticipantRequirements value, $Res Function(_ParticipantRequirements) _then) = __$ParticipantRequirementsCopyWithImpl;
@override @useResult
$Res call({
 int? minDurationMinutes, int? maxDurationMinutes,@TimelineTimeConverter() TimelineTime? finishBy,@TimelineTimeConverter() TimelineTime? startAfter, int? preferredOrderFrom, int? preferredOrderBefore
});




}
/// @nodoc
class __$ParticipantRequirementsCopyWithImpl<$Res>
    implements _$ParticipantRequirementsCopyWith<$Res> {
  __$ParticipantRequirementsCopyWithImpl(this._self, this._then);

  final _ParticipantRequirements _self;
  final $Res Function(_ParticipantRequirements) _then;

/// Create a copy of ParticipantRequirements
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minDurationMinutes = freezed,Object? maxDurationMinutes = freezed,Object? finishBy = freezed,Object? startAfter = freezed,Object? preferredOrderFrom = freezed,Object? preferredOrderBefore = freezed,}) {
  return _then(_ParticipantRequirements(
minDurationMinutes: freezed == minDurationMinutes ? _self.minDurationMinutes : minDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxDurationMinutes: freezed == maxDurationMinutes ? _self.maxDurationMinutes : maxDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,finishBy: freezed == finishBy ? _self.finishBy : finishBy // ignore: cast_nullable_to_non_nullable
as TimelineTime?,startAfter: freezed == startAfter ? _self.startAfter : startAfter // ignore: cast_nullable_to_non_nullable
as TimelineTime?,preferredOrderFrom: freezed == preferredOrderFrom ? _self.preferredOrderFrom : preferredOrderFrom // ignore: cast_nullable_to_non_nullable
as int?,preferredOrderBefore: freezed == preferredOrderBefore ? _self.preferredOrderBefore : preferredOrderBefore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Participant {

 String get id; String get name; ParticipantRequirements get requirements;
/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantCopyWith<Participant> get copyWith => _$ParticipantCopyWithImpl<Participant>(this as Participant, _$identity);

  /// Serializes this Participant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Participant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.requirements, requirements) || other.requirements == requirements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,requirements);

@override
String toString() {
  return 'Participant(id: $id, name: $name, requirements: $requirements)';
}


}

/// @nodoc
abstract mixin class $ParticipantCopyWith<$Res>  {
  factory $ParticipantCopyWith(Participant value, $Res Function(Participant) _then) = _$ParticipantCopyWithImpl;
@useResult
$Res call({
 String id, String name, ParticipantRequirements requirements
});


$ParticipantRequirementsCopyWith<$Res> get requirements;

}
/// @nodoc
class _$ParticipantCopyWithImpl<$Res>
    implements $ParticipantCopyWith<$Res> {
  _$ParticipantCopyWithImpl(this._self, this._then);

  final Participant _self;
  final $Res Function(Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? requirements = null,}) {
  return _then(Participant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as ParticipantRequirements,
  ));
}
/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantRequirementsCopyWith<$Res> get requirements {
  
  return $ParticipantRequirementsCopyWith<$Res>(_self.requirements, (value) {
    return _then(_self.copyWith(requirements: value));
  });
}
}


/// Adds pattern-matching-related methods to [Participant].
extension ParticipantPatterns on Participant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Participant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Participant value)  $default,){
final _that = this;
switch (_that) {
case _Participant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Participant value)?  $default,){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ParticipantRequirements requirements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.id,_that.name,_that.requirements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ParticipantRequirements requirements)  $default,) {final _that = this;
switch (_that) {
case _Participant():
return $default(_that.id,_that.name,_that.requirements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ParticipantRequirements requirements)?  $default,) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.id,_that.name,_that.requirements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Participant implements Participant {
  const _Participant({required this.id, required this.name, this.requirements = const ParticipantRequirements()});
  factory _Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  ParticipantRequirements requirements;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantCopyWith<_Participant> get copyWith => __$ParticipantCopyWithImpl<_Participant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Participant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.requirements, requirements) || other.requirements == requirements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,requirements);

@override
String toString() {
  return 'Participant(id: $id, name: $name, requirements: $requirements)';
}


}

/// @nodoc
abstract mixin class _$ParticipantCopyWith<$Res> implements $ParticipantCopyWith<$Res> {
  factory _$ParticipantCopyWith(_Participant value, $Res Function(_Participant) _then) = __$ParticipantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ParticipantRequirements requirements
});


@override $ParticipantRequirementsCopyWith<$Res> get requirements;

}
/// @nodoc
class __$ParticipantCopyWithImpl<$Res>
    implements _$ParticipantCopyWith<$Res> {
  __$ParticipantCopyWithImpl(this._self, this._then);

  final _Participant _self;
  final $Res Function(_Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? requirements = null,}) {
  return _then(_Participant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as ParticipantRequirements,
  ));
}

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantRequirementsCopyWith<$Res> get requirements {
  
  return $ParticipantRequirementsCopyWith<$Res>(_self.requirements, (value) {
    return _then(_self.copyWith(requirements: value));
  });
}
}

// dart format on

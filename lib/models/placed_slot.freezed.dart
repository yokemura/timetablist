// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'placed_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlacedSlot {

 Slot get slot; SlotCategory get category; Participant? get participant; TimelineTime get startTime; TimelineTime get endTime; int get index;/// 1-based order among performance slots only; null when not a performance slot.
 int? get performanceOrder;
/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacedSlotCopyWith<PlacedSlot> get copyWith => _$PlacedSlotCopyWithImpl<PlacedSlot>(this as PlacedSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacedSlot&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.category, category) || other.category == category)&&(identical(other.participant, participant) || other.participant == participant)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.index, index) || other.index == index)&&(identical(other.performanceOrder, performanceOrder) || other.performanceOrder == performanceOrder));
}


@override
int get hashCode => Object.hash(runtimeType,slot,category,participant,startTime,endTime,index,performanceOrder);

@override
String toString() {
  return 'PlacedSlot(slot: $slot, category: $category, participant: $participant, startTime: $startTime, endTime: $endTime, index: $index, performanceOrder: $performanceOrder)';
}


}

/// @nodoc
abstract mixin class $PlacedSlotCopyWith<$Res>  {
  factory $PlacedSlotCopyWith(PlacedSlot value, $Res Function(PlacedSlot) _then) = _$PlacedSlotCopyWithImpl;
@useResult
$Res call({
 Slot slot, SlotCategory category, Participant? participant, TimelineTime startTime, TimelineTime endTime, int index, int? performanceOrder
});


$SlotCopyWith<$Res> get slot;$SlotCategoryCopyWith<$Res> get category;$ParticipantCopyWith<$Res>? get participant;

}
/// @nodoc
class _$PlacedSlotCopyWithImpl<$Res>
    implements $PlacedSlotCopyWith<$Res> {
  _$PlacedSlotCopyWithImpl(this._self, this._then);

  final PlacedSlot _self;
  final $Res Function(PlacedSlot) _then;

/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slot = null,Object? category = null,Object? participant = freezed,Object? startTime = null,Object? endTime = null,Object? index = null,Object? performanceOrder = freezed,}) {
  return _then(PlacedSlot(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as Slot,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SlotCategory,participant: freezed == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as Participant?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimelineTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimelineTime,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,performanceOrder: freezed == performanceOrder ? _self.performanceOrder : performanceOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotCopyWith<$Res> get slot {
  
  return $SlotCopyWith<$Res>(_self.slot, (value) {
    return _then(_self.copyWith(slot: value));
  });
}/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotCategoryCopyWith<$Res> get category {
  
  return $SlotCategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantCopyWith<$Res>? get participant {
    if (_self.participant == null) {
    return null;
  }

  return $ParticipantCopyWith<$Res>(_self.participant!, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlacedSlot].
extension PlacedSlotPatterns on PlacedSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacedSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacedSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacedSlot value)  $default,){
final _that = this;
switch (_that) {
case _PlacedSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacedSlot value)?  $default,){
final _that = this;
switch (_that) {
case _PlacedSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Slot slot,  SlotCategory category,  Participant? participant,  TimelineTime startTime,  TimelineTime endTime,  int index,  int? performanceOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacedSlot() when $default != null:
return $default(_that.slot,_that.category,_that.participant,_that.startTime,_that.endTime,_that.index,_that.performanceOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Slot slot,  SlotCategory category,  Participant? participant,  TimelineTime startTime,  TimelineTime endTime,  int index,  int? performanceOrder)  $default,) {final _that = this;
switch (_that) {
case _PlacedSlot():
return $default(_that.slot,_that.category,_that.participant,_that.startTime,_that.endTime,_that.index,_that.performanceOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Slot slot,  SlotCategory category,  Participant? participant,  TimelineTime startTime,  TimelineTime endTime,  int index,  int? performanceOrder)?  $default,) {final _that = this;
switch (_that) {
case _PlacedSlot() when $default != null:
return $default(_that.slot,_that.category,_that.participant,_that.startTime,_that.endTime,_that.index,_that.performanceOrder);case _:
  return null;

}
}

}

/// @nodoc


class _PlacedSlot extends PlacedSlot {
  const _PlacedSlot({required this.slot, required this.category, required this.participant, required this.startTime, required this.endTime, required this.index, this.performanceOrder}): super._();
  

@override final  Slot slot;
@override final  SlotCategory category;
@override final  Participant? participant;
@override final  TimelineTime startTime;
@override final  TimelineTime endTime;
@override final  int index;
/// 1-based order among performance slots only; null when not a performance slot.
@override final  int? performanceOrder;

/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacedSlotCopyWith<_PlacedSlot> get copyWith => __$PlacedSlotCopyWithImpl<_PlacedSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacedSlot&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.category, category) || other.category == category)&&(identical(other.participant, participant) || other.participant == participant)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.index, index) || other.index == index)&&(identical(other.performanceOrder, performanceOrder) || other.performanceOrder == performanceOrder));
}


@override
int get hashCode => Object.hash(runtimeType,slot,category,participant,startTime,endTime,index,performanceOrder);

@override
String toString() {
  return 'PlacedSlot(slot: $slot, category: $category, participant: $participant, startTime: $startTime, endTime: $endTime, index: $index, performanceOrder: $performanceOrder)';
}


}

/// @nodoc
abstract mixin class _$PlacedSlotCopyWith<$Res> implements $PlacedSlotCopyWith<$Res> {
  factory _$PlacedSlotCopyWith(_PlacedSlot value, $Res Function(_PlacedSlot) _then) = __$PlacedSlotCopyWithImpl;
@override @useResult
$Res call({
 Slot slot, SlotCategory category, Participant? participant, TimelineTime startTime, TimelineTime endTime, int index, int? performanceOrder
});


@override $SlotCopyWith<$Res> get slot;@override $SlotCategoryCopyWith<$Res> get category;@override $ParticipantCopyWith<$Res>? get participant;

}
/// @nodoc
class __$PlacedSlotCopyWithImpl<$Res>
    implements _$PlacedSlotCopyWith<$Res> {
  __$PlacedSlotCopyWithImpl(this._self, this._then);

  final _PlacedSlot _self;
  final $Res Function(_PlacedSlot) _then;

/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slot = null,Object? category = null,Object? participant = freezed,Object? startTime = null,Object? endTime = null,Object? index = null,Object? performanceOrder = freezed,}) {
  return _then(_PlacedSlot(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as Slot,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SlotCategory,participant: freezed == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as Participant?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimelineTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimelineTime,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,performanceOrder: freezed == performanceOrder ? _self.performanceOrder : performanceOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotCopyWith<$Res> get slot {
  
  return $SlotCopyWith<$Res>(_self.slot, (value) {
    return _then(_self.copyWith(slot: value));
  });
}/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlotCategoryCopyWith<$Res> get category {
  
  return $SlotCategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of PlacedSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParticipantCopyWith<$Res>? get participant {
    if (_self.participant == null) {
    return null;
  }

  return $ParticipantCopyWith<$Res>(_self.participant!, (value) {
    return _then(_self.copyWith(participant: value));
  });
}
}

// dart format on

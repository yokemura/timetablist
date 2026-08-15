// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Selection {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Selection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Selection()';
}


}

/// @nodoc
class $SelectionCopyWith<$Res>  {
$SelectionCopyWith(Selection _, $Res Function(Selection) __);
}


/// Adds pattern-matching-related methods to [Selection].
extension SelectionPatterns on Selection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentSelection value)?  document,TResult Function( TimelineSelection value)?  timeline,TResult Function( SlotCategorySelection value)?  slotCategory,TResult Function( SlotSelection value)?  slot,TResult Function( ParticipantSelection value)?  participant,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentSelection() when document != null:
return document(_that);case TimelineSelection() when timeline != null:
return timeline(_that);case SlotCategorySelection() when slotCategory != null:
return slotCategory(_that);case SlotSelection() when slot != null:
return slot(_that);case ParticipantSelection() when participant != null:
return participant(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentSelection value)  document,required TResult Function( TimelineSelection value)  timeline,required TResult Function( SlotCategorySelection value)  slotCategory,required TResult Function( SlotSelection value)  slot,required TResult Function( ParticipantSelection value)  participant,}){
final _that = this;
switch (_that) {
case DocumentSelection():
return document(_that);case TimelineSelection():
return timeline(_that);case SlotCategorySelection():
return slotCategory(_that);case SlotSelection():
return slot(_that);case ParticipantSelection():
return participant(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentSelection value)?  document,TResult? Function( TimelineSelection value)?  timeline,TResult? Function( SlotCategorySelection value)?  slotCategory,TResult? Function( SlotSelection value)?  slot,TResult? Function( ParticipantSelection value)?  participant,}){
final _that = this;
switch (_that) {
case DocumentSelection() when document != null:
return document(_that);case TimelineSelection() when timeline != null:
return timeline(_that);case SlotCategorySelection() when slotCategory != null:
return slotCategory(_that);case SlotSelection() when slot != null:
return slot(_that);case ParticipantSelection() when participant != null:
return participant(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  document,TResult Function( String timelineId)?  timeline,TResult Function( String slotCategoryId)?  slotCategory,TResult Function( String timelineId,  String slotId)?  slot,TResult Function( String participantId)?  participant,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentSelection() when document != null:
return document();case TimelineSelection() when timeline != null:
return timeline(_that.timelineId);case SlotCategorySelection() when slotCategory != null:
return slotCategory(_that.slotCategoryId);case SlotSelection() when slot != null:
return slot(_that.timelineId,_that.slotId);case ParticipantSelection() when participant != null:
return participant(_that.participantId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  document,required TResult Function( String timelineId)  timeline,required TResult Function( String slotCategoryId)  slotCategory,required TResult Function( String timelineId,  String slotId)  slot,required TResult Function( String participantId)  participant,}) {final _that = this;
switch (_that) {
case DocumentSelection():
return document();case TimelineSelection():
return timeline(_that.timelineId);case SlotCategorySelection():
return slotCategory(_that.slotCategoryId);case SlotSelection():
return slot(_that.timelineId,_that.slotId);case ParticipantSelection():
return participant(_that.participantId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  document,TResult? Function( String timelineId)?  timeline,TResult? Function( String slotCategoryId)?  slotCategory,TResult? Function( String timelineId,  String slotId)?  slot,TResult? Function( String participantId)?  participant,}) {final _that = this;
switch (_that) {
case DocumentSelection() when document != null:
return document();case TimelineSelection() when timeline != null:
return timeline(_that.timelineId);case SlotCategorySelection() when slotCategory != null:
return slotCategory(_that.slotCategoryId);case SlotSelection() when slot != null:
return slot(_that.timelineId,_that.slotId);case ParticipantSelection() when participant != null:
return participant(_that.participantId);case _:
  return null;

}
}

}

/// @nodoc


class DocumentSelection implements Selection {
  const DocumentSelection();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentSelection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Selection.document()';
}


}




/// @nodoc


class TimelineSelection implements Selection {
  const TimelineSelection({required this.timelineId});
  

 final  String timelineId;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineSelectionCopyWith<TimelineSelection> get copyWith => _$TimelineSelectionCopyWithImpl<TimelineSelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineSelection&&(identical(other.timelineId, timelineId) || other.timelineId == timelineId));
}


@override
int get hashCode => Object.hash(runtimeType,timelineId);

@override
String toString() {
  return 'Selection.timeline(timelineId: $timelineId)';
}


}

/// @nodoc
abstract mixin class $TimelineSelectionCopyWith<$Res> implements $SelectionCopyWith<$Res> {
  factory $TimelineSelectionCopyWith(TimelineSelection value, $Res Function(TimelineSelection) _then) = _$TimelineSelectionCopyWithImpl;
@useResult
$Res call({
 String timelineId
});




}
/// @nodoc
class _$TimelineSelectionCopyWithImpl<$Res>
    implements $TimelineSelectionCopyWith<$Res> {
  _$TimelineSelectionCopyWithImpl(this._self, this._then);

  final TimelineSelection _self;
  final $Res Function(TimelineSelection) _then;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? timelineId = null,}) {
  return _then(TimelineSelection(
timelineId: null == timelineId ? _self.timelineId : timelineId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SlotCategorySelection implements Selection {
  const SlotCategorySelection({required this.slotCategoryId});
  

 final  String slotCategoryId;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotCategorySelectionCopyWith<SlotCategorySelection> get copyWith => _$SlotCategorySelectionCopyWithImpl<SlotCategorySelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotCategorySelection&&(identical(other.slotCategoryId, slotCategoryId) || other.slotCategoryId == slotCategoryId));
}


@override
int get hashCode => Object.hash(runtimeType,slotCategoryId);

@override
String toString() {
  return 'Selection.slotCategory(slotCategoryId: $slotCategoryId)';
}


}

/// @nodoc
abstract mixin class $SlotCategorySelectionCopyWith<$Res> implements $SelectionCopyWith<$Res> {
  factory $SlotCategorySelectionCopyWith(SlotCategorySelection value, $Res Function(SlotCategorySelection) _then) = _$SlotCategorySelectionCopyWithImpl;
@useResult
$Res call({
 String slotCategoryId
});




}
/// @nodoc
class _$SlotCategorySelectionCopyWithImpl<$Res>
    implements $SlotCategorySelectionCopyWith<$Res> {
  _$SlotCategorySelectionCopyWithImpl(this._self, this._then);

  final SlotCategorySelection _self;
  final $Res Function(SlotCategorySelection) _then;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? slotCategoryId = null,}) {
  return _then(SlotCategorySelection(
slotCategoryId: null == slotCategoryId ? _self.slotCategoryId : slotCategoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SlotSelection implements Selection {
  const SlotSelection({required this.timelineId, required this.slotId});
  

 final  String timelineId;
 final  String slotId;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotSelectionCopyWith<SlotSelection> get copyWith => _$SlotSelectionCopyWithImpl<SlotSelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotSelection&&(identical(other.timelineId, timelineId) || other.timelineId == timelineId)&&(identical(other.slotId, slotId) || other.slotId == slotId));
}


@override
int get hashCode => Object.hash(runtimeType,timelineId,slotId);

@override
String toString() {
  return 'Selection.slot(timelineId: $timelineId, slotId: $slotId)';
}


}

/// @nodoc
abstract mixin class $SlotSelectionCopyWith<$Res> implements $SelectionCopyWith<$Res> {
  factory $SlotSelectionCopyWith(SlotSelection value, $Res Function(SlotSelection) _then) = _$SlotSelectionCopyWithImpl;
@useResult
$Res call({
 String timelineId, String slotId
});




}
/// @nodoc
class _$SlotSelectionCopyWithImpl<$Res>
    implements $SlotSelectionCopyWith<$Res> {
  _$SlotSelectionCopyWithImpl(this._self, this._then);

  final SlotSelection _self;
  final $Res Function(SlotSelection) _then;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? timelineId = null,Object? slotId = null,}) {
  return _then(SlotSelection(
timelineId: null == timelineId ? _self.timelineId : timelineId // ignore: cast_nullable_to_non_nullable
as String,slotId: null == slotId ? _self.slotId : slotId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ParticipantSelection implements Selection {
  const ParticipantSelection({required this.participantId});
  

 final  String participantId;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSelectionCopyWith<ParticipantSelection> get copyWith => _$ParticipantSelectionCopyWithImpl<ParticipantSelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSelection&&(identical(other.participantId, participantId) || other.participantId == participantId));
}


@override
int get hashCode => Object.hash(runtimeType,participantId);

@override
String toString() {
  return 'Selection.participant(participantId: $participantId)';
}


}

/// @nodoc
abstract mixin class $ParticipantSelectionCopyWith<$Res> implements $SelectionCopyWith<$Res> {
  factory $ParticipantSelectionCopyWith(ParticipantSelection value, $Res Function(ParticipantSelection) _then) = _$ParticipantSelectionCopyWithImpl;
@useResult
$Res call({
 String participantId
});




}
/// @nodoc
class _$ParticipantSelectionCopyWithImpl<$Res>
    implements $ParticipantSelectionCopyWith<$Res> {
  _$ParticipantSelectionCopyWithImpl(this._self, this._then);

  final ParticipantSelection _self;
  final $Res Function(ParticipantSelection) _then;

/// Create a copy of Selection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? participantId = null,}) {
  return _then(ParticipantSelection(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

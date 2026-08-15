// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Document {

 String get name; List<Timeline> get timelines; List<SlotCategory> get slotCategories; List<Participant> get participants;
/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentCopyWith<Document> get copyWith => _$DocumentCopyWithImpl<Document>(this as Document, _$identity);

  /// Serializes this Document to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Document&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.timelines, timelines)&&const DeepCollectionEquality().equals(other.slotCategories, slotCategories)&&const DeepCollectionEquality().equals(other.participants, participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(timelines),const DeepCollectionEquality().hash(slotCategories),const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'Document(name: $name, timelines: $timelines, slotCategories: $slotCategories, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $DocumentCopyWith<$Res>  {
  factory $DocumentCopyWith(Document value, $Res Function(Document) _then) = _$DocumentCopyWithImpl;
@useResult
$Res call({
 String name, List<Timeline> timelines, List<SlotCategory> slotCategories, List<Participant> participants
});




}
/// @nodoc
class _$DocumentCopyWithImpl<$Res>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._self, this._then);

  final Document _self;
  final $Res Function(Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? timelines = null,Object? slotCategories = null,Object? participants = null,}) {
  return _then(Document(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timelines: null == timelines ? _self.timelines : timelines // ignore: cast_nullable_to_non_nullable
as List<Timeline>,slotCategories: null == slotCategories ? _self.slotCategories : slotCategories // ignore: cast_nullable_to_non_nullable
as List<SlotCategory>,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,
  ));
}

}


/// Adds pattern-matching-related methods to [Document].
extension DocumentPatterns on Document {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Document value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Document value)  $default,){
final _that = this;
switch (_that) {
case _Document():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Document value)?  $default,){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<Timeline> timelines,  List<SlotCategory> slotCategories,  List<Participant> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.name,_that.timelines,_that.slotCategories,_that.participants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<Timeline> timelines,  List<SlotCategory> slotCategories,  List<Participant> participants)  $default,) {final _that = this;
switch (_that) {
case _Document():
return $default(_that.name,_that.timelines,_that.slotCategories,_that.participants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<Timeline> timelines,  List<SlotCategory> slotCategories,  List<Participant> participants)?  $default,) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.name,_that.timelines,_that.slotCategories,_that.participants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Document extends Document {
  const _Document({required this.name,  List<Timeline> timelines = const [],  List<SlotCategory> slotCategories = const [],  List<Participant> participants = const []}): _timelines = timelines,_slotCategories = slotCategories,_participants = participants,super._();
  factory _Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

@override final  String name;
 final  List<Timeline> _timelines;
@override@JsonKey() List<Timeline> get timelines {
  if (_timelines is EqualUnmodifiableListView) return _timelines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timelines);
}

 final  List<SlotCategory> _slotCategories;
@override@JsonKey() List<SlotCategory> get slotCategories {
  if (_slotCategories is EqualUnmodifiableListView) return _slotCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slotCategories);
}

 final  List<Participant> _participants;
@override@JsonKey() List<Participant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentCopyWith<_Document> get copyWith => __$DocumentCopyWithImpl<_Document>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Document&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._timelines, _timelines)&&const DeepCollectionEquality().equals(other._slotCategories, _slotCategories)&&const DeepCollectionEquality().equals(other._participants, _participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_timelines),const DeepCollectionEquality().hash(_slotCategories),const DeepCollectionEquality().hash(_participants));

@override
String toString() {
  return 'Document(name: $name, timelines: $timelines, slotCategories: $slotCategories, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$DocumentCopyWith<$Res> implements $DocumentCopyWith<$Res> {
  factory _$DocumentCopyWith(_Document value, $Res Function(_Document) _then) = __$DocumentCopyWithImpl;
@override @useResult
$Res call({
 String name, List<Timeline> timelines, List<SlotCategory> slotCategories, List<Participant> participants
});




}
/// @nodoc
class __$DocumentCopyWithImpl<$Res>
    implements _$DocumentCopyWith<$Res> {
  __$DocumentCopyWithImpl(this._self, this._then);

  final _Document _self;
  final $Res Function(_Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? timelines = null,Object? slotCategories = null,Object? participants = null,}) {
  return _then(_Document(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timelines: null == timelines ? _self._timelines : timelines // ignore: cast_nullable_to_non_nullable
as List<Timeline>,slotCategories: null == slotCategories ? _self._slotCategories : slotCategories // ignore: cast_nullable_to_non_nullable
as List<SlotCategory>,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<Participant>,
  ));
}


}

// dart format on

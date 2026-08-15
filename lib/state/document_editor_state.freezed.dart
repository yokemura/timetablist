// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentEditorState {

 Document get document; List<Document> get undoStack; List<Document> get redoStack;
/// Create a copy of DocumentEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentEditorStateCopyWith<DocumentEditorState> get copyWith => _$DocumentEditorStateCopyWithImpl<DocumentEditorState>(this as DocumentEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentEditorState&&(identical(other.document, document) || other.document == document)&&const DeepCollectionEquality().equals(other.undoStack, undoStack)&&const DeepCollectionEquality().equals(other.redoStack, redoStack));
}


@override
int get hashCode => Object.hash(runtimeType,document,const DeepCollectionEquality().hash(undoStack),const DeepCollectionEquality().hash(redoStack));

@override
String toString() {
  return 'DocumentEditorState(document: $document, undoStack: $undoStack, redoStack: $redoStack)';
}


}

/// @nodoc
abstract mixin class $DocumentEditorStateCopyWith<$Res>  {
  factory $DocumentEditorStateCopyWith(DocumentEditorState value, $Res Function(DocumentEditorState) _then) = _$DocumentEditorStateCopyWithImpl;
@useResult
$Res call({
 Document document, List<Document> undoStack, List<Document> redoStack
});


$DocumentCopyWith<$Res> get document;

}
/// @nodoc
class _$DocumentEditorStateCopyWithImpl<$Res>
    implements $DocumentEditorStateCopyWith<$Res> {
  _$DocumentEditorStateCopyWithImpl(this._self, this._then);

  final DocumentEditorState _self;
  final $Res Function(DocumentEditorState) _then;

/// Create a copy of DocumentEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? document = null,Object? undoStack = null,Object? redoStack = null,}) {
  return _then(DocumentEditorState(
document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as Document,undoStack: null == undoStack ? _self.undoStack : undoStack // ignore: cast_nullable_to_non_nullable
as List<Document>,redoStack: null == redoStack ? _self.redoStack : redoStack // ignore: cast_nullable_to_non_nullable
as List<Document>,
  ));
}
/// Create a copy of DocumentEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DocumentCopyWith<$Res> get document {
  
  return $DocumentCopyWith<$Res>(_self.document, (value) {
    return _then(_self.copyWith(document: value));
  });
}
}


/// Adds pattern-matching-related methods to [DocumentEditorState].
extension DocumentEditorStatePatterns on DocumentEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentEditorState value)  $default,){
final _that = this;
switch (_that) {
case _DocumentEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Document document,  List<Document> undoStack,  List<Document> redoStack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentEditorState() when $default != null:
return $default(_that.document,_that.undoStack,_that.redoStack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Document document,  List<Document> undoStack,  List<Document> redoStack)  $default,) {final _that = this;
switch (_that) {
case _DocumentEditorState():
return $default(_that.document,_that.undoStack,_that.redoStack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Document document,  List<Document> undoStack,  List<Document> redoStack)?  $default,) {final _that = this;
switch (_that) {
case _DocumentEditorState() when $default != null:
return $default(_that.document,_that.undoStack,_that.redoStack);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentEditorState extends DocumentEditorState {
  const _DocumentEditorState({required this.document,  List<Document> undoStack = const [],  List<Document> redoStack = const []}): _undoStack = undoStack,_redoStack = redoStack,super._();
  

@override final  Document document;
 final  List<Document> _undoStack;
@override@JsonKey() List<Document> get undoStack {
  if (_undoStack is EqualUnmodifiableListView) return _undoStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_undoStack);
}

 final  List<Document> _redoStack;
@override@JsonKey() List<Document> get redoStack {
  if (_redoStack is EqualUnmodifiableListView) return _redoStack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redoStack);
}


/// Create a copy of DocumentEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentEditorStateCopyWith<_DocumentEditorState> get copyWith => __$DocumentEditorStateCopyWithImpl<_DocumentEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentEditorState&&(identical(other.document, document) || other.document == document)&&const DeepCollectionEquality().equals(other._undoStack, _undoStack)&&const DeepCollectionEquality().equals(other._redoStack, _redoStack));
}


@override
int get hashCode => Object.hash(runtimeType,document,const DeepCollectionEquality().hash(_undoStack),const DeepCollectionEquality().hash(_redoStack));

@override
String toString() {
  return 'DocumentEditorState(document: $document, undoStack: $undoStack, redoStack: $redoStack)';
}


}

/// @nodoc
abstract mixin class _$DocumentEditorStateCopyWith<$Res> implements $DocumentEditorStateCopyWith<$Res> {
  factory _$DocumentEditorStateCopyWith(_DocumentEditorState value, $Res Function(_DocumentEditorState) _then) = __$DocumentEditorStateCopyWithImpl;
@override @useResult
$Res call({
 Document document, List<Document> undoStack, List<Document> redoStack
});


@override $DocumentCopyWith<$Res> get document;

}
/// @nodoc
class __$DocumentEditorStateCopyWithImpl<$Res>
    implements _$DocumentEditorStateCopyWith<$Res> {
  __$DocumentEditorStateCopyWithImpl(this._self, this._then);

  final _DocumentEditorState _self;
  final $Res Function(_DocumentEditorState) _then;

/// Create a copy of DocumentEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? document = null,Object? undoStack = null,Object? redoStack = null,}) {
  return _then(_DocumentEditorState(
document: null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as Document,undoStack: null == undoStack ? _self._undoStack : undoStack // ignore: cast_nullable_to_non_nullable
as List<Document>,redoStack: null == redoStack ? _self._redoStack : redoStack // ignore: cast_nullable_to_non_nullable
as List<Document>,
  ));
}

/// Create a copy of DocumentEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DocumentCopyWith<$Res> get document {
  
  return $DocumentCopyWith<$Res>(_self.document, (value) {
    return _then(_self.copyWith(document: value));
  });
}
}

// dart format on

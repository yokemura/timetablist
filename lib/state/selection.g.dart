// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectionNotifier)
final selectionProvider = SelectionNotifierProvider._();

final class SelectionNotifierProvider
    extends $NotifierProvider<SelectionNotifier, Selection> {
  SelectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectionNotifierHash();

  @$internal
  @override
  SelectionNotifier create() => SelectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Selection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Selection>(value),
    );
  }
}

String _$selectionNotifierHash() => r'7b70ef386a26ac11ed38ab384b5873a804176569';

abstract class _$SelectionNotifier extends $Notifier<Selection> {
  Selection build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Selection, Selection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Selection, Selection>,
              Selection,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// [SelectionNotifier]'s value, falling back to the document selection when
/// the selected object no longer exists (deleted, undone away, imported over).

@ProviderFor(effectiveSelection)
final effectiveSelectionProvider = EffectiveSelectionProvider._();

/// [SelectionNotifier]'s value, falling back to the document selection when
/// the selected object no longer exists (deleted, undone away, imported over).

final class EffectiveSelectionProvider
    extends $FunctionalProvider<Selection, Selection, Selection>
    with $Provider<Selection> {
  /// [SelectionNotifier]'s value, falling back to the document selection when
  /// the selected object no longer exists (deleted, undone away, imported over).
  EffectiveSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveSelectionHash();

  @$internal
  @override
  $ProviderElement<Selection> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Selection create(Ref ref) {
    return effectiveSelection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Selection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Selection>(value),
    );
  }
}

String _$effectiveSelectionHash() =>
    r'd653f771e0de1ebeaac82e9469dc13ad962492ab';

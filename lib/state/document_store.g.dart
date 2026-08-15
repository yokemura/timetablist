// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentStore)
final documentStoreProvider = DocumentStoreProvider._();

final class DocumentStoreProvider
    extends $FunctionalProvider<DocumentStore, DocumentStore, DocumentStore>
    with $Provider<DocumentStore> {
  DocumentStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentStoreHash();

  @$internal
  @override
  $ProviderElement<DocumentStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentStore create(Ref ref) {
    return documentStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentStore>(value),
    );
  }
}

String _$documentStoreHash() => r'e7656ed4847b6a08db0bb767559f45bde6b52d71';

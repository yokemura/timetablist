// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_file.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Platform file UI used by the menu's export/import. Tests override this.

@ProviderFor(documentFilePort)
final documentFilePortProvider = DocumentFilePortProvider._();

/// Platform file UI used by the menu's export/import. Tests override this.

final class DocumentFilePortProvider
    extends
        $FunctionalProvider<
          DocumentFilePort,
          DocumentFilePort,
          DocumentFilePort
        >
    with $Provider<DocumentFilePort> {
  /// Platform file UI used by the menu's export/import. Tests override this.
  DocumentFilePortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentFilePortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentFilePortHash();

  @$internal
  @override
  $ProviderElement<DocumentFilePort> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentFilePort create(Ref ref) {
    return documentFilePort(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentFilePort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentFilePort>(value),
    );
  }
}

String _$documentFilePortHash() => r'1c84809bfe011147c3b6fdeadfa0cb7cdd472bab';

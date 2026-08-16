// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_editor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Document the app starts with. Overridden at startup with the document
/// restored from [DocumentStore] (or a new empty one).

@ProviderFor(initialDocument)
final initialDocumentProvider = InitialDocumentProvider._();

/// Document the app starts with. Overridden at startup with the document
/// restored from [DocumentStore] (or a new empty one).

final class InitialDocumentProvider
    extends $FunctionalProvider<Document, Document, Document>
    with $Provider<Document> {
  /// Document the app starts with. Overridden at startup with the document
  /// restored from [DocumentStore] (or a new empty one).
  InitialDocumentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialDocumentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialDocumentHash();

  @$internal
  @override
  $ProviderElement<Document> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Document create(Ref ref) {
    return initialDocument(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Document value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Document>(value),
    );
  }
}

String _$initialDocumentHash() => r'76d4da31e37f25cc4d02ef3251ef1b664de3e2a4';

/// Convenience view of the current document.

@ProviderFor(document)
final documentProvider = DocumentProvider._();

/// Convenience view of the current document.

final class DocumentProvider
    extends $FunctionalProvider<Document, Document, Document>
    with $Provider<Document> {
  /// Convenience view of the current document.
  DocumentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentHash();

  @$internal
  @override
  $ProviderElement<Document> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Document create(Ref ref) {
    return document(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Document value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Document>(value),
    );
  }
}

String _$documentHash() => r'5d160497e235671aa44cceba63b8b6eaedc6b843';

/// Applies all document mutations.
///
/// Every public mutation is one undoable change and triggers an autosave, per
/// the spec: changes are committed only when an interaction completes.

@ProviderFor(DocumentEditor)
final documentEditorProvider = DocumentEditorProvider._();

/// Applies all document mutations.
///
/// Every public mutation is one undoable change and triggers an autosave, per
/// the spec: changes are committed only when an interaction completes.
final class DocumentEditorProvider
    extends $NotifierProvider<DocumentEditor, DocumentEditorState> {
  /// Applies all document mutations.
  ///
  /// Every public mutation is one undoable change and triggers an autosave, per
  /// the spec: changes are committed only when an interaction completes.
  DocumentEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentEditorHash();

  @$internal
  @override
  DocumentEditor create() => DocumentEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentEditorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentEditorState>(value),
    );
  }
}

String _$documentEditorHash() => r'd457d82319ea3db4756fc1206a4ccbe8151c53ee';

/// Applies all document mutations.
///
/// Every public mutation is one undoable change and triggers an autosave, per
/// the spec: changes are committed only when an interaction completes.

abstract class _$DocumentEditor extends $Notifier<DocumentEditorState> {
  DocumentEditorState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DocumentEditorState, DocumentEditorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DocumentEditorState, DocumentEditorState>,
              DocumentEditorState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

import 'document_file_port_stub.dart'
    if (dart.library.js_interop) 'document_file_port_web.dart';

/// Exports/imports the document as a JSON file via the platform's file UI.
abstract interface class DocumentFilePort {
  /// Offers [json] to the user as a download named [fileName].
  Future<void> exportJson({required String fileName, required String json});

  /// Lets the user pick a JSON file; returns its text, or null on cancel.
  Future<String?> importJson();
}

DocumentFilePort createDocumentFilePort() => createPlatformDocumentFilePort();

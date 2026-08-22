import 'document_file_port_stub.dart'
    if (dart.library.js_interop) 'document_file_port_web.dart';

/// Saves/loads document files via the platform's file UI.
abstract interface class DocumentFilePort {
  /// Offers [contents] to the user as a download named [fileName].
  Future<void> saveFile({
    required String fileName,
    required String contents,
    required String mimeType,
  });

  /// Lets the user pick a JSON file; returns its text, or null on cancel.
  Future<String?> importJson();
}

DocumentFilePort createDocumentFilePort() => createPlatformDocumentFilePort();

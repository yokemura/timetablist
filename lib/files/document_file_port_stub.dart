import 'document_file_port.dart';

/// Non-web placeholder; the app ships as a web app and tests inject fakes.
class UnsupportedDocumentFilePort implements DocumentFilePort {
  @override
  Future<void> saveFile({
    required String fileName,
    required String contents,
    required String mimeType,
  }) => throw UnsupportedError('File save is only available on the web');

  @override
  Future<String?> importJson() =>
      throw UnsupportedError('File load is only available on the web');
}

DocumentFilePort createPlatformDocumentFilePort() =>
    UnsupportedDocumentFilePort();

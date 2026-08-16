import 'document_file_port.dart';

/// Non-web placeholder; the app ships as a web app and tests inject fakes.
class UnsupportedDocumentFilePort implements DocumentFilePort {
  @override
  Future<void> exportJson({required String fileName, required String json}) =>
      throw UnsupportedError('File export is only available on the web');

  @override
  Future<String?> importJson() =>
      throw UnsupportedError('File import is only available on the web');
}

DocumentFilePort createPlatformDocumentFilePort() =>
    UnsupportedDocumentFilePort();

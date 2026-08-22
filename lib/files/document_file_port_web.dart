import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'document_file_port.dart';

/// Browser implementation: save triggers a download, import opens the
/// standard file picker.
class WebDocumentFilePort implements DocumentFilePort {
  @override
  Future<void> saveFile({
    required String fileName,
    required String contents,
    required String mimeType,
  }) async {
    final blob = web.Blob(
      [contents.toJS].toJS,
      web.BlobPropertyBag(type: mimeType),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName;
    web.document.body!.appendChild(anchor);
    anchor.click();
    anchor.remove();
    web.URL.revokeObjectURL(url);
  }

  @override
  Future<String?> importJson() {
    final completer = Completer<String?>();
    final input = web.HTMLInputElement()
      ..type = 'file'
      ..accept = '.json,application/json';

    void complete(String? result) {
      if (!completer.isCompleted) completer.complete(result);
    }

    input.addEventListener(
      'change',
      (web.Event _) {
        final file = input.files?.item(0);
        if (file == null) {
          complete(null);
          return;
        }
        file.text().toDart.then(
          (text) => complete(text.toDart),
          onError: (Object _) => complete(null),
        );
      }.toJS,
    );
    // Fired by modern browsers when the picker is dismissed.
    input.addEventListener('cancel', ((web.Event _) => complete(null)).toJS);
    input.click();
    return completer.future;
  }
}

DocumentFilePort createPlatformDocumentFilePort() => WebDocumentFilePort();

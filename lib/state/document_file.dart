import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../files/document_file_port.dart';

part 'document_file.g.dart';

/// Platform file UI used by the menu's export/import. Tests override this.
@Riverpod(keepAlive: true)
DocumentFilePort documentFilePort(Ref ref) => createDocumentFilePort();

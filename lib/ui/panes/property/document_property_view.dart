import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/s.dart';
import '../../../state/state.dart';
import '../../widgets/commit_text_field.dart';
import 'property_scaffold.dart';

class DocumentPropertyView extends ConsumerWidget {
  const DocumentPropertyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);

    return PropertyScaffold(
      children: [
        CommitTextField(
          value: document.name,
          label: s.fieldDocumentName,
          onCommit: (name) =>
              ref.read(documentEditorProvider.notifier).renameDocument(name),
        ),
      ],
    );
  }
}

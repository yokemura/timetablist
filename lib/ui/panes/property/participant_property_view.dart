import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/s.dart';
import '../../../state/state.dart';
import '../../dialogs/app_dialogs.dart';
import '../../widgets/commit_text_field.dart';
import 'property_scaffold.dart';

class ParticipantPropertyView extends ConsumerWidget {
  const ParticipantPropertyView({required this.participantId, super.key});

  final String participantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final participant = document.participantById(participantId);
    if (participant == null) return const SizedBox.shrink();

    final editor = ref.read(documentEditorProvider.notifier);

    return PropertyScaffold(
      children: [
        CommitTextField(
          value: participant.name,
          label: s.fieldName,
          validator: (name) {
            if (document.isParticipantNameTaken(name, exceptId: participant.id)) {
              return s.errorDuplicateParticipantName;
            }
            return null;
          },
          onCommit: (name) {
            try {
              editor.updateParticipant(participant.copyWith(name: name));
            } on ArgumentError catch (error) {
              showErrorDialog(context, editorErrorMessage(s, error));
            }
          },
        ),
        FilledButton.tonal(
          onPressed: () async {
            final confirmed = await showConfirmDialog(
              context,
              message: s.confirmDeleteParticipant,
            );
            if (confirmed != true || !context.mounted) return;
            editor.deleteParticipant(participant.id);
            ref.read(selectionProvider.notifier).reset();
          },
          child: Text(s.actionDelete),
        ),
      ],
    );
  }
}

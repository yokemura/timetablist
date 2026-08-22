import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../state/state.dart';
import '../dialogs/participant_create_dialog.dart';
import '../timeline/drag_data.dart';
import '../widgets/drag_ghosts.dart';
import '../widgets/participant_list_item.dart';

/// Bottom-left pane: scrollable participant list plus a creation button.
///
/// Assigned participants stay in the list, so one participant can occupy
/// multiple slots. Shows nothing but the button while the list is empty.
class ParticipantPane extends ConsumerWidget {
  const ParticipantPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final selection = ref.watch(effectiveSelectionProvider);
    final participants = document.participants;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              // Clicking empty space selects the document.
              onTap: () => ref.read(selectionProvider.notifier).reset(),
              child: ListView.builder(
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final participant = participants[index];
                  final item = ParticipantListItem(
                    participant: participant,
                    selected:
                        selection ==
                        Selection.participant(participantId: participant.id),
                    onTap: () => ref
                        .read(selectionProvider.notifier)
                        .select(
                          Selection.participant(participantId: participant.id),
                        ),
                  );
                  return Draggable<ParticipantDragData>(
                    data: ParticipantDragData(participant: participant),
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    feedback: ParticipantDragGhost(participant: participant),
                    child: item,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: FilledButton.tonalIcon(
              onPressed: () => showParticipantCreateDialog(context),
              icon: const Icon(Icons.add),
              label: Text(s.createParticipantButton),
            ),
          ),
        ],
      ),
    );
  }
}

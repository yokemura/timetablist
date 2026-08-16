import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../state/state.dart';
import '../sheets/participant_create_sheet.dart';
import '../timeline/drag_data.dart';
import '../widgets/drag_ghosts.dart';
import '../widgets/participant_list_item.dart';

/// Bottom-left pane: scrollable participant list plus a creation button.
///
/// Only unassigned participants appear here; assigning one to a slot removes
/// it from the pane and unassigning returns it. Shows nothing but the button
/// while the list is empty.
class ParticipantPane extends ConsumerWidget {
  const ParticipantPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final selection = ref.watch(effectiveSelectionProvider);
    final participants = document.unassignedParticipants();

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
                    // The participant leaves the pane while dragging.
                    childWhenDragging: const SizedBox.shrink(),
                    child: item,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: FilledButton.tonalIcon(
              onPressed: () => showParticipantCreateSheet(context),
              icon: const Icon(Icons.add),
              label: Text(s.createParticipantButton),
            ),
          ),
        ],
      ),
    );
  }
}

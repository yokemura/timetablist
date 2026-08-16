import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../timeline/time_layout.dart';
import 'placed_participant_view.dart';

/// A slot on a timeline. Square corners and no outer padding so it does not
/// look draggable; a participant inside has padding and rounded corners.
class PlacedSlotView extends StatelessWidget {
  const PlacedSlotView({
    required this.placed,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final PlacedSlot placed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final participant = placed.participant;
    final hasMismatch =
        participant != null && placed.requirementViolations().isNotEmpty;

    return Material(
      color: selected ? scheme.secondaryContainer : scheme.surfaceContainerHighest,
      shape: Border(
        bottom: BorderSide(color: scheme.outlineVariant),
        left: BorderSide(color: scheme.outlineVariant),
        right: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                placed.category.name,
                style: theme.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (participant != null)
              Padding(
                padding: const EdgeInsets.all(TimeLayout.participantPadding),
                child: PlacedParticipantView(
                  participant: participant,
                  hasMismatch: hasMismatch,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

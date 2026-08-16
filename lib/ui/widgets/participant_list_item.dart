import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import 'requirement_summary.dart';

/// Participant list item: name and the explicitly set requirements.
/// Click to select; also acts as a drag source (wired up in a later step).
class ParticipantListItem extends StatelessWidget {
  const ParticipantListItem({
    required this.participant,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Participant participant;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final summaries = requirementSummaries(s, participant.requirements);
    return Material(
      color: selected
          ? theme.colorScheme.secondaryContainer
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                participant.name,
                style: theme.textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
              if (summaries.isNotEmpty)
                Text(
                  summaries.join(s.reqSummarySeparator),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

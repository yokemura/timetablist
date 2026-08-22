import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../timeline/time_layout.dart';
import 'placed_participant_view.dart';
import 'timeline_lane.dart';

/// Drag feedback for a slot category: looks like a placed slot, with the
/// height following the category duration on the default time scale.
class SlotCategoryDragGhost extends StatelessWidget {
  const SlotCategoryDragGhost({required this.category, super.key});

  final SlotCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final height = TimeLayout.slotMinHeight(
      durationMinutes: category.durationMinutes,
      hasParticipant: false,
      hasWarning: false,
    );
    final isPerformance = category.isPerformanceSlot;
    final fill = isPerformance
        ? scheme.primaryContainer
        : scheme.secondaryContainer;
    final titleColor = isPerformance
        ? scheme.onPrimaryContainer
        : scheme.onSecondaryContainer;
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 0.8,
        child: Container(
          width: TimelineLane.width,
          height: height,
          decoration: BoxDecoration(
            color: fill,
            border: Border.all(color: scheme.outlineVariant),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          alignment: Alignment.topLeft,
          child: Text(
            category.name,
            style: theme.textTheme.labelSmall?.copyWith(color: titleColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// Drag feedback for a participant: looks like the placed participant block.
class ParticipantDragGhost extends StatelessWidget {
  const ParticipantDragGhost({required this.participant, super.key});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 0.8,
        child: SizedBox(
          width: TimelineLane.width - TimeLayout.participantPadding * 2,
          child: PlacedParticipantView(participant: participant),
        ),
      ),
    );
  }
}

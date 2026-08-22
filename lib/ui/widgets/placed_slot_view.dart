import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../timeline/drag_data.dart';
import '../timeline/time_layout.dart';
import 'drag_ghosts.dart';
import 'placed_participant_view.dart';

/// e.g. `16:00〜17:00 転換(20分)` (Japanese) / `16:00-17:00 Changeover (20 min)`.
String placedSlotTitle(PlacedSlot placed, S s) => s.placedSlotLabel(
  placed.startTime.toDisplayString(),
  placed.endTime.toDisplayString(),
  placed.category.name,
  placed.durationMinutes,
);

/// A slot on a timeline. Square corners and no outer padding so it does not
/// look draggable; a participant inside has padding and rounded corners.
///
/// When [timelineId] is set, the participant block becomes a drag source, and
/// when [onParticipantDropped] is set, performance slots accept participant
/// drops.
class PlacedSlotView extends StatelessWidget {
  const PlacedSlotView({
    required this.placed,
    required this.selected,
    required this.onTap,
    this.timelineId,
    this.onParticipantDropped,
    super.key,
  });

  final PlacedSlot placed;
  final bool selected;
  final VoidCallback onTap;
  final String? timelineId;
  final ValueChanged<ParticipantDragData>? onParticipantDropped;

  @override
  Widget build(BuildContext context) {
    if (placed.category.isPerformanceSlot && onParticipantDropped != null) {
      return DragTarget<ParticipantDragData>(
        onAcceptWithDetails: (details) => onParticipantDropped!(details.data),
        builder: (context, candidates, rejected) =>
            _buildSlot(context, highlighted: candidates.isNotEmpty),
      );
    }
    return _buildSlot(context, highlighted: false);
  }

  Widget _buildSlot(BuildContext context, {required bool highlighted}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final participant = placed.participant;

    Widget? participantChild;
    if (participant != null) {
      participantChild = PlacedParticipantView(participant: participant);
      final timelineId = this.timelineId;
      if (timelineId != null) {
        participantChild = Draggable<ParticipantDragData>(
          data: ParticipantDragData(
            participant: participant,
            fromTimelineId: timelineId,
            fromSlotId: placed.slot.id,
          ),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: ParticipantDragGhost(participant: participant),
          // The participant leaves the slot while dragging, per the spec.
          childWhenDragging: const SizedBox.shrink(),
          child: participantChild,
        );
      }
    }

    final isPerformance = placed.category.isPerformanceSlot;
    final Color fill;
    if (highlighted) {
      fill = scheme.tertiaryContainer;
    } else if (isPerformance) {
      fill = scheme.primaryContainer;
    } else {
      fill = scheme.secondaryContainer;
    }

    final Color titleColor;
    if (highlighted) {
      titleColor = scheme.onTertiaryContainer;
    } else if (isPerformance) {
      titleColor = scheme.onPrimaryContainer;
    } else {
      titleColor = scheme.onSecondaryContainer;
    }

    final selectedOutline = selected && !highlighted;
    final borderColor = selectedOutline
        ? scheme.primary
        : scheme.outlineVariant;
    final borderWidth = selectedOutline ? 2.0 : 1.0;

    return Material(
      color: fill,
      shape: Border(
        bottom: BorderSide(color: borderColor, width: borderWidth),
        left: BorderSide(color: borderColor, width: borderWidth),
        right: BorderSide(color: borderColor, width: borderWidth),
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
                placedSlotTitle(placed, S.of(context)),
                style: theme.textTheme.labelSmall?.copyWith(color: titleColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (participantChild != null)
              Padding(
                padding: const EdgeInsets.all(TimeLayout.participantPadding),
                child: participantChild,
              ),
          ],
        ),
      ),
    );
  }
}

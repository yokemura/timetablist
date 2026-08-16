import '../../models/models.dart';

/// Payload of a slot category dragged from the slot category pane.
class SlotCategoryDragData {
  const SlotCategoryDragData(this.category);

  final SlotCategory category;
}

/// Payload of a participant dragged from the participant pane or out of a
/// placed slot. [fromTimelineId] / [fromSlotId] are null when dragged from
/// the pane.
class ParticipantDragData {
  const ParticipantDragData({
    required this.participant,
    this.fromTimelineId,
    this.fromSlotId,
  });

  final Participant participant;
  final String? fromTimelineId;
  final String? fromSlotId;
}

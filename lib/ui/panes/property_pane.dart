import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/state.dart';
import 'property/document_property_view.dart';
import 'property/participant_property_view.dart';
import 'property/slot_category_property_view.dart';
import 'property/slot_property_view.dart';
import 'property/timeline_property_view.dart';

/// Right pane: properties of the selected object.
class PropertyPane extends ConsumerWidget {
  const PropertyPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(effectiveSelectionProvider);

    final body = switch (selection) {
      DocumentSelection() => const DocumentPropertyView(),
      TimelineSelection(:final timelineId) =>
        TimelinePropertyView(timelineId: timelineId),
      SlotCategorySelection(:final slotCategoryId) =>
        SlotCategoryPropertyView(categoryId: slotCategoryId),
      SlotSelection(:final timelineId, :final slotId) =>
        SlotPropertyView(
          key: ValueKey('$timelineId:$slotId'),
          timelineId: timelineId,
          slotId: slotId,
        ),
      ParticipantSelection(:final participantId) =>
        ParticipantPropertyView(participantId: participantId),
    };

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: body,
    );
  }
}

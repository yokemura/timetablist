import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/s.dart';
import '../../../models/models.dart';
import '../../../state/state.dart';
import '../../dialogs/app_dialogs.dart';
import '../../widgets/commit_text_field.dart';
import '../../widgets/commit_time_field.dart';
import 'property_scaffold.dart';

class TimelinePropertyView extends ConsumerWidget {
  const TimelinePropertyView({required this.timelineId, super.key});

  final String timelineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final timeline = document.timelineById(timelineId);
    if (timeline == null) return const SizedBox.shrink();

    final editor = ref.read(documentEditorProvider.notifier);
    final endTime = document.endTimeOf(timeline);
    final firstCategory =
        document.slotCategoryById(timeline.slots.first.categoryId)!;
    final lastCategory =
        document.slotCategoryById(timeline.slots.last.categoryId)!;

    Future<void> handleStartCommit(TimelineTime newStart) async {
      if (newStart == timeline.startTime) return;
      final deltaMinutes = timeline.startTime.difference(newStart).inMinutes;
      final canAdjustFirst =
          firstCategory.durationMinutes + deltaMinutes > 0;
      final choice = await showTimelineStartAdjustmentDialog(
        context,
        canAdjustFirstSlot: canAdjustFirst,
      );
      if (choice == null || !context.mounted) return;

      try {
        switch (choice) {
          case TimelineTimeAdjustment.adjustEndpointSlot:
            editor.adjustTimelineStartViaFirstSlot(
              timelineId,
              newStart,
              derivedCategoryName:
                  document.nextAvailableSlotCategoryName(firstCategory.name),
            );
          case TimelineTimeAdjustment.moveAllSlots:
            editor.shiftTimelineStartTime(timelineId, newStart);
        }
      } on ArgumentError catch (error) {
        if (!context.mounted) return;
        await showErrorDialog(context, editorErrorMessage(s, error));
      }
    }

    Future<void> handleEndCommit(TimelineTime newEnd) async {
      if (newEnd == endTime) return;
      final deltaMinutes = newEnd.difference(endTime).inMinutes;
      final canAdjustLast = lastCategory.durationMinutes + deltaMinutes > 0;
      final choice = await showTimelineEndAdjustmentDialog(
        context,
        canAdjustLastSlot: canAdjustLast,
      );
      if (choice == null || !context.mounted) return;

      try {
        switch (choice) {
          case TimelineTimeAdjustment.adjustEndpointSlot:
            editor.adjustTimelineEndViaLastSlot(
              timelineId,
              newEnd,
              derivedCategoryName:
                  document.nextAvailableSlotCategoryName(lastCategory.name),
            );
          case TimelineTimeAdjustment.moveAllSlots:
            editor.shiftTimelineEndTime(timelineId, newEnd);
        }
      } on ArgumentError catch (error) {
        if (!context.mounted) return;
        await showErrorDialog(context, editorErrorMessage(s, error));
      }
    }

    return PropertyScaffold(
      children: [
        CommitTextField(
          value: timeline.name,
          label: s.fieldTimelineName,
          onCommit: (name) => editor.renameTimeline(timelineId, name),
        ),
        CommitTimeField(
          value: timeline.startTime,
          label: s.fieldStartTime,
          onCommit: handleStartCommit,
        ),
        CommitTimeField(
          value: endTime,
          label: s.fieldEndTime,
          onCommit: handleEndCommit,
        ),
        FilledButton.tonal(
          onPressed: () {
            editor.duplicateTimeline(
              timelineId,
              name: document.nextAvailableTimelineName(timeline.name),
            );
          },
          child: Text(s.actionDuplicate),
        ),
        FilledButton.tonal(
          onPressed: () async {
            final confirmed = await showConfirmDialog(
              context,
              message: s.confirmDeleteTimeline,
            );
            if (confirmed != true || !context.mounted) return;
            editor.deleteTimeline(timelineId);
            ref.read(selectionProvider.notifier).reset();
          },
          child: Text(s.actionDelete),
        ),
      ],
    );
  }
}

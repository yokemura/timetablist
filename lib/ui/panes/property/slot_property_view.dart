import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/s.dart';
import '../../../models/models.dart';
import '../../../state/state.dart';
import '../../dialogs/app_dialogs.dart';
import '../../dialogs/slot_category_create_dialog.dart';
import '../../widgets/commit_int_field.dart';
import '../../widgets/slot_category_picker.dart';
import 'property_scaffold.dart';

class SlotPropertyView extends ConsumerStatefulWidget {
  const SlotPropertyView({
    required this.timelineId,
    required this.slotId,
    super.key,
  });

  final String timelineId;
  final String slotId;

  @override
  ConsumerState<SlotPropertyView> createState() => _SlotPropertyViewState();
}

class _SlotPropertyViewState extends ConsumerState<SlotPropertyView> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final timeline = document.timelineById(widget.timelineId);
    if (timeline == null) return const SizedBox.shrink();

    Slot? slot;
    for (final candidate in timeline.slots) {
      if (candidate.id == widget.slotId) {
        slot = candidate;
        break;
      }
    }
    if (slot == null) return const SizedBox.shrink();
    final resolvedSlot = slot;

    final category = document.slotCategoryById(resolvedSlot.categoryId)!;
    final editor = ref.read(documentEditorProvider.notifier);

    Future<bool> confirmIfRemovingPerformance(SlotCategory nextCategory) async {
      if (category.isPerformanceSlot &&
          !nextCategory.isPerformanceSlot &&
          resolvedSlot.participantId != null) {
        final confirmed = await showRemovePerformanceAttributeDialog(context);
        return confirmed == true && context.mounted;
      }
      return true;
    }

    Future<void> applyExistingCategory(String categoryId) async {
      if (categoryId == category.id) return;
      final nextCategory = document.slotCategoryById(categoryId)!;
      if (!await confirmIfRemovingPerformance(nextCategory)) return;
      try {
        editor.changeSlotCategory(
          timelineId: widget.timelineId,
          slotId: widget.slotId,
          categoryId: categoryId,
        );
      } on ArgumentError catch (error) {
        if (!context.mounted) return;
        await showErrorDialog(context, editorErrorMessage(s, error));
      }
    }

    Future<void> applyNewCategory() async {
      final result = await showSlotCategoryCreateDialog(context);
      if (result == null || !context.mounted) return;
      final newCategory = SlotCategory(
        id: generateEntityId(),
        name: result.name,
        durationMinutes: result.durationMinutes,
        isPerformanceSlot: result.isPerformanceSlot,
      );
      if (!await confirmIfRemovingPerformance(newCategory)) return;
      try {
        editor.changeSlotCategoryWithNew(
          timelineId: widget.timelineId,
          slotId: widget.slotId,
          newCategory: newCategory,
        );
      } on ArgumentError catch (error) {
        if (!context.mounted) return;
        await showErrorDialog(context, editorErrorMessage(s, error));
      }
    }

    Future<void> applyDurationChange(int minutes) async {
      if (minutes == category.durationMinutes) return;
      final usedOnlyHere = editor.slotCategoryUsageCount(category.id) == 1;

      try {
        if (usedOnlyHere) {
          editor.updateSlotCategoryDuration(category.id, minutes);
          return;
        }

        final choice = await showSlotDurationAdjustmentDialog(context);
        if (choice == null || !context.mounted) return;
        switch (choice) {
          case SlotDurationAdjustment.thisSlotOnly:
            editor.setSlotDurationForSlotOnly(
              timelineId: widget.timelineId,
              slotId: widget.slotId,
              newDurationMinutes: minutes,
              derivedCategoryName:
                  document.nextAvailableSlotCategoryName(category.name),
            );
          case SlotDurationAdjustment.allSameType:
            editor.updateSlotCategoryDuration(category.id, minutes);
        }
      } on ArgumentError catch (error) {
        if (!context.mounted) return;
        await showErrorDialog(context, editorErrorMessage(s, error));
      }
    }

    return PropertyScaffold(
      children: [
        PropertySectionTitle(s.fieldSlotCategory),
        DropdownButtonFormField<String>(
          value: category.id,
          isExpanded: true,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
          items: [
            for (final candidate in document.slotCategories)
              DropdownMenuItem(
                value: candidate.id,
                child: Text(candidate.name, overflow: TextOverflow.ellipsis),
              ),
            DropdownMenuItem(
              value: SlotCategoryPicker.newSentinel,
              child: Text(s.slotCategoryPickerCreateNew),
            ),
          ],
          onChanged: (value) async {
            if (value == null) return;
            if (value == SlotCategoryPicker.newSentinel) {
              await applyNewCategory();
            } else {
              await applyExistingCategory(value);
            }
            if (mounted) setState(() {});
          },
        ),
        CommitIntField(
          value: category.durationMinutes,
          label: s.fieldDurationMinutes,
          min: 1,
          max: TimelineLimits.maxSlotDurationMinutes,
          onCommit: applyDurationChange,
        ),
        ReadOnlyCheckbox(
          label: s.performanceAttributeLabel,
          value: category.isPerformanceSlot,
        ),
        if (category.isPerformanceSlot)
          DropdownButtonFormField<String?>(
            value: resolvedSlot.participantId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: s.fieldParticipant,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(s.fieldParticipantNone),
              ),
              for (final candidate in document.participants)
                DropdownMenuItem(
                  value: candidate.id,
                  child: Text(candidate.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (participantId) {
              editor.assignParticipant(
                timelineId: widget.timelineId,
                slotId: widget.slotId,
                participantId: participantId,
              );
            },
          ),
        FilledButton(
          onPressed: () async {
            final confirmed = await showConfirmDialog(
              context,
              message: s.confirmDeleteSlot,
            );
            if (confirmed != true || !context.mounted) return;
            editor.removeSlot(
              timelineId: widget.timelineId,
              slotId: widget.slotId,
            );
            ref.read(selectionProvider.notifier).reset();
          },
          child: Text(s.actionDelete),
        ),
      ],
    );
  }
}

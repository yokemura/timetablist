import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/s.dart';
import '../../../models/models.dart';
import '../../../state/state.dart';
import '../../dialogs/app_dialogs.dart';
import '../../timeline/timeline_draft.dart';
import '../../widgets/commit_int_field.dart';
import '../../widgets/commit_text_field.dart';
import '../../widgets/slot_category_picker.dart';
import 'property_scaffold.dart';
import 'requirement_violation_list.dart';
import 'requirements_property_section.dart';

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
  CategoryDraft? _categoryDraft;
  String? _pendingCategoryId;

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
    final placed = document.placedSlotsOf(timeline).firstWhere(
          (candidate) => candidate.slot.id == widget.slotId,
        );
    final participant = placed.participant;
    final editor = ref.read(documentEditorProvider.notifier);

    _categoryDraft ??= CategoryDraft(
      existing: category,
      isPerformanceSlot: category.isPerformanceSlot,
    );
    _pendingCategoryId ??= category.id;

    final categoryDraft = _categoryDraft!;
    final canApplyCategory = categoryDraft.isNew
        ? categoryDraft.name.isNotEmpty &&
            categoryDraft.durationMinutes != null &&
            !document.isSlotCategoryNameTaken(categoryDraft.name)
        : _pendingCategoryId != category.id;

    Future<void> applyCategoryChange() async {
      if (categoryDraft.isNew) {
        final duration = categoryDraft.durationMinutes;
        if (duration == null) return;
        final newCategory = SlotCategory(
          id: generateEntityId(),
          name: categoryDraft.name,
          durationMinutes: duration,
          isPerformanceSlot: categoryDraft.isPerformanceSlot,
        );
        if (category.isPerformanceSlot &&
            !newCategory.isPerformanceSlot &&
            resolvedSlot.participantId != null) {
          final confirmed = await showRemovePerformanceAttributeDialog(context);
          if (confirmed != true || !context.mounted) return;
        }
        try {
          editor.changeSlotCategoryWithNew(
            timelineId: widget.timelineId,
            slotId: widget.slotId,
            newCategory: newCategory,
          );
          setState(() {
            _categoryDraft = CategoryDraft(
              existing: newCategory,
              isPerformanceSlot: newCategory.isPerformanceSlot,
            );
            _pendingCategoryId = newCategory.id;
          });
        } on ArgumentError catch (error) {
          if (!context.mounted) return;
          await showErrorDialog(context, editorErrorMessage(s, error));
        }
        return;
      }

      final nextCategoryId = _pendingCategoryId!;
      if (nextCategoryId == category.id) return;
      final nextCategory = document.slotCategoryById(nextCategoryId)!;
      if (category.isPerformanceSlot &&
          !nextCategory.isPerformanceSlot &&
          resolvedSlot.participantId != null) {
        final confirmed = await showRemovePerformanceAttributeDialog(context);
        if (confirmed != true || !context.mounted) return;
      }
      try {
        editor.changeSlotCategory(
          timelineId: widget.timelineId,
          slotId: widget.slotId,
          categoryId: nextCategoryId,
        );
        setState(() {
          _categoryDraft = CategoryDraft(
            existing: nextCategory,
            isPerformanceSlot: nextCategory.isPerformanceSlot,
          );
        });
      } on ArgumentError catch (error) {
        if (!context.mounted) return;
        await showErrorDialog(context, editorErrorMessage(s, error));
      }
    }

    Future<void> applyDurationChange(int minutes) async {
      if (minutes == category.durationMinutes) return;
      final choice = await showSlotDurationAdjustmentDialog(context);
      if (choice == null || !context.mounted) return;

      try {
        switch (choice) {
          case SlotDurationAdjustment.thisSlotOnly:
            editor.setSlotDurationForSlotOnly(
              timelineId: widget.timelineId,
              slotId: widget.slotId,
              newDurationMinutes: minutes,
              derivedCategoryName: s.categoryNameWithDuration(
                category.name,
                minutes,
              ),
            );
          case SlotDurationAdjustment.allSameType:
            editor.updateSlotCategoryDuration(category.id, minutes);
        }
      } on ArgumentError catch (error) {
        if (!context.mounted) return;
        await showErrorDialog(context, editorErrorMessage(s, error));
      }
    }

    final participantCandidates = <Participant>[
      ...document.unassignedParticipants(),
      if (participant != null) participant,
    ];

    return PropertyScaffold(
      children: [
        PropertySectionTitle(s.fieldSlotCategory),
        if (document.slotCategories.isEmpty)
          SlotCategoryPicker(
            draft: categoryDraft.copyWith(clearExisting: true),
            candidates: const [],
            takenNames: document.slotCategories.map((c) => c.name).toSet(),
            onChanged: (draft) => setState(() => _categoryDraft = draft),
          )
        else ...[
          DropdownButtonFormField<String>(
            value: categoryDraft.isNew
                ? SlotCategoryPicker.newSentinel
                : _pendingCategoryId,
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
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                if (value == SlotCategoryPicker.newSentinel) {
                  _categoryDraft = CategoryDraft(
                    newName: category.name,
                    isPerformanceSlot: category.isPerformanceSlot,
                  );
                  _pendingCategoryId = value;
                } else {
                  _pendingCategoryId = value;
                  _categoryDraft = CategoryDraft(
                    existing: document.slotCategoryById(value),
                    isPerformanceSlot:
                        document.slotCategoryById(value)!.isPerformanceSlot,
                  );
                }
              });
            },
          ),
          if (categoryDraft.isNew) ...[
            const SizedBox(height: 8),
            SlotCategoryPicker(
              draft: categoryDraft,
              candidates: const [],
              takenNames: document.slotCategories.map((c) => c.name).toSet(),
              onChanged: (draft) => setState(() => _categoryDraft = draft),
            ),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: canApplyCategory ? applyCategoryChange : null,
              child: Text(s.actionOk),
            ),
          ),
        ],
        PropertySectionTitle(s.sectionSlotCategoryDetails),
        ReadOnlyField(label: s.fieldName, value: category.name),
        CommitIntField(
          value: category.durationMinutes,
          label: s.fieldDurationMinutes,
          min: 1,
          max: TimelineLimits.maxSlotDurationMinutes,
          onCommit: applyDurationChange,
        ),
        ReadOnlyField(
          label: s.fieldPerformanceAttribute,
          value: category.isPerformanceSlot
              ? s.performanceAttributeLabel
              : '—',
        ),
        if (category.isPerformanceSlot) ...[
          PropertySectionTitle(s.fieldParticipant),
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
              for (final candidate in participantCandidates)
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
        ],
        if (participant != null) ...[
          PropertySectionTitle(s.sectionParticipantDetails),
          CommitTextField(
            value: participant.name,
            label: s.fieldName,
            validator: (name) {
              if (document.isParticipantNameTaken(
                name,
                exceptId: participant.id,
              )) {
                return s.errorDuplicateParticipantName;
              }
              return null;
            },
            onCommit: (name) {
              try {
                editor.updateParticipant(participant.copyWith(name: name));
              } on ArgumentError catch (error) {
                showErrorDialog(context, editorErrorMessage(s, error));
              }
            },
          ),
          RequirementsPropertySection(participant: participant),
          RequirementViolationList(violations: placed.requirementViolations()),
        ],
        FilledButton.tonal(
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

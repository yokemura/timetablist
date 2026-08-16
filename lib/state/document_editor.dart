import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/models.dart';
import 'document_editor_state.dart';
import 'document_store.dart';

part 'document_editor.g.dart';

/// Document the app starts with. Overridden at startup with the document
/// restored from [DocumentStore] (or a new empty one).
@Riverpod(keepAlive: true)
Document initialDocument(Ref ref) =>
    throw UnimplementedError('Override initialDocumentProvider at startup');

/// Convenience view of the current document.
@Riverpod(keepAlive: true)
Document document(Ref ref) => ref.watch(documentEditorProvider).document;

/// Applies all document mutations.
///
/// Every public mutation is one undoable change and triggers an autosave, per
/// the spec: changes are committed only when an interaction completes.
@Riverpod(keepAlive: true)
class DocumentEditor extends _$DocumentEditor {
  /// Undo history is in-memory only; cap it so it cannot grow forever.
  static const maxHistoryLength = 100;

  @override
  DocumentEditorState build() =>
      DocumentEditorState(document: ref.watch(initialDocumentProvider));

  Document get _document => state.document;

  // --- Document ---

  void renameDocument(String name) => _commit(_document.copyWith(name: name));

  /// Replaces everything with [document] (import). Clears undo history.
  void replaceDocument(Document document) {
    state = DocumentEditorState(document: document);
    _persist(document);
  }

  /// Resets to an empty document (menu "clear"). Undoable.
  void clearDocument({required String documentName}) =>
      _commit(Document.empty(name: documentName));

  // --- Slot categories ---

  SlotCategory createSlotCategory({
    required String name,
    required int durationMinutes,
    required bool isPerformanceSlot,
  }) {
    if (_document.isSlotCategoryNameTaken(name)) {
      throw ArgumentError.value(name, 'name', 'Slot category name is taken');
    }
    final category = SlotCategory(
      id: generateEntityId(),
      name: name,
      durationMinutes: durationMinutes,
      isPerformanceSlot: isPerformanceSlot,
    );
    _commit(
      _document.copyWith(
        slotCategories: [..._document.slotCategories, category],
      ),
    );
    return category;
  }

  void updateSlotCategory(SlotCategory updated) {
    _requireSlotCategory(updated.id);
    if (_document.isSlotCategoryNameTaken(updated.name, exceptId: updated.id)) {
      throw ArgumentError.value(
        updated.name,
        'name',
        'Slot category name is taken',
      );
    }
    final next = _document.copyWith(
      slotCategories: [
        for (final category in _document.slotCategories)
          if (category.id == updated.id) updated else category,
      ],
    );
    _validateTimelineBounds(next);
    _commit(next);
  }

  /// Updates only the duration of a slot category used by placed slots.
  void updateSlotCategoryDuration(String id, int durationMinutes) {
    _requireDuration(durationMinutes);
    final category = _requireSlotCategory(id);
    updateSlotCategory(category.copyWith(durationMinutes: durationMinutes));
  }

  int slotCategoryUsageCount(String categoryId) {
    var count = 0;
    for (final timeline in _document.timelines) {
      for (final slot in timeline.slots) {
        if (slot.categoryId == categoryId) count += 1;
      }
    }
    return count;
  }

  /// Deletes the category, every slot using it, and timelines left empty.
  /// Participants assigned to removed slots become unassigned automatically.
  void deleteSlotCategory(String id) {
    _requireSlotCategory(id);
    final timelines = <Timeline>[];
    for (final timeline in _document.timelines) {
      final remaining = timeline.slots
          .where((slot) => slot.categoryId != id)
          .toList();
      if (remaining.isEmpty) continue;
      timelines.add(timeline.copyWith(slots: remaining));
    }
    _commit(
      _document.copyWith(
        slotCategories: _document.slotCategories
            .where((category) => category.id != id)
            .toList(),
        timelines: timelines,
      ),
    );
  }

  // --- Participants ---

  Participant createParticipant({
    required String name,
    ParticipantRequirements requirements = const ParticipantRequirements(),
  }) {
    if (_document.isParticipantNameTaken(name)) {
      throw ArgumentError.value(name, 'name', 'Participant name is taken');
    }
    final participant = Participant(
      id: generateEntityId(),
      name: name,
      requirements: requirements,
    );
    _commit(
      _document.copyWith(
        participants: [..._document.participants, participant],
      ),
    );
    return participant;
  }

  void updateParticipant(Participant updated) {
    _requireParticipant(updated.id);
    if (_document.isParticipantNameTaken(updated.name, exceptId: updated.id)) {
      throw ArgumentError.value(
        updated.name,
        'name',
        'Participant name is taken',
      );
    }
    _commit(
      _document.copyWith(
        participants: [
          for (final participant in _document.participants)
            if (participant.id == updated.id) updated else participant,
        ],
      ),
    );
  }

  /// Deletes the participant. Slots that referenced it become unassigned;
  /// the slots themselves are kept.
  void deleteParticipant(String id) {
    _requireParticipant(id);
    _commit(
      _document.copyWith(
        participants: _document.participants
            .where((participant) => participant.id != id)
            .toList(),
        timelines: [
          for (final timeline in _document.timelines)
            timeline.copyWith(
              slots: [
                for (final slot in timeline.slots)
                  if (slot.participantId == id)
                    slot.copyWith(participantId: null)
                  else
                    slot,
              ],
            ),
        ],
      ),
    );
  }

  // --- Timelines ---

  void addTimeline(Timeline timeline) =>
      addTimelineWithCategories(timeline: timeline);

  /// Adds [timeline] and any [newCategories] it references in one undoable
  /// change (used by the create-timeline sheet).
  void addTimelineWithCategories({
    required Timeline timeline,
    List<SlotCategory> newCategories = const [],
  }) {
    if (timeline.slots.isEmpty) {
      throw ArgumentError.value(
        timeline,
        'timeline',
        'A timeline must contain at least one slot',
      );
    }
    final names = <String>{};
    for (final category in newCategories) {
      if (_document.isSlotCategoryNameTaken(category.name) ||
          !names.add(category.name)) {
        throw ArgumentError.value(
          category.name,
          'name',
          'Slot category name is taken',
        );
      }
    }
    final next = _document.copyWith(
      slotCategories: [..._document.slotCategories, ...newCategories],
      timelines: [..._document.timelines, timeline],
    );
    if (!next.endTimeOf(timeline).isWithinMax) {
      throw ArgumentError.value(
        timeline,
        'timeline',
        'End time exceeds the timeline maximum',
      );
    }
    _commit(next);
  }

  void renameTimeline(String id, String name) =>
      _commit(_updateTimeline(id, (timeline) => timeline.copyWith(name: name)));

  void setTimelineStartTime(String id, TimelineTime startTime) {
    final next = _updateTimeline(
      id,
      (timeline) => timeline.copyWith(startTime: startTime),
    );
    _validateTimelineBounds(next);
    _commit(next);
  }

  /// Shifts every slot by changing the timeline start time.
  void shiftTimelineStartTime(String id, TimelineTime newStart) {
    if (newStart.minutesFromMidnight < TimelineTime.midnight.minutesFromMidnight) {
      throw ArgumentError('Start time cannot be before 0:00');
    }
    setTimelineStartTime(id, newStart);
  }

  /// Shifts every slot so the timeline end becomes [newEnd].
  void shiftTimelineEndTime(String id, TimelineTime newEnd) {
    final timeline = _requireTimeline(id);
    final oldEnd = _document.endTimeOf(timeline);
    final deltaMinutes = newEnd.difference(oldEnd).inMinutes;
    final newStartMinutes = timeline.startTime.minutesFromMidnight + deltaMinutes;
    if (newStartMinutes < TimelineTime.midnight.minutesFromMidnight) {
      throw ArgumentError('Start time cannot be before 0:00');
    }
    shiftTimelineStartTime(id, TimelineTime(newStartMinutes));
  }

  /// Absorbs a start-time change by resizing (or forking) the first slot's type.
  void adjustTimelineStartViaFirstSlot(
    String id,
    TimelineTime newStart, {
    required String derivedCategoryName,
  }) {
    final timeline = _requireTimeline(id);
    final oldStart = timeline.startTime;
    if (newStart == oldStart) return;

    final deltaMinutes = oldStart.difference(newStart).inMinutes;
    final firstSlot = timeline.slots.first;
    final category = _requireSlotCategory(firstSlot.categoryId);
    final newDuration = category.durationMinutes + deltaMinutes;
    if (newDuration <= 0) {
      throw ArgumentError.value(
        newStart,
        'newStart',
        'First slot duration would be zero or negative',
      );
    }

    Document next;
    if (slotCategoryUsageCount(category.id) == 1) {
      next = _document.copyWith(
        slotCategories: [
          for (final c in _document.slotCategories)
            if (c.id == category.id)
              c.copyWith(durationMinutes: newDuration)
            else
              c,
        ],
        timelines: [
          for (final t in _document.timelines)
            if (t.id == id) t.copyWith(startTime: newStart) else t,
        ],
      );
    } else {
      if (_document.isSlotCategoryNameTaken(derivedCategoryName)) {
        throw ArgumentError.value(
          derivedCategoryName,
          'derivedCategoryName',
          'Slot category name is taken',
        );
      }
      final forked = SlotCategory(
        id: generateEntityId(),
        name: derivedCategoryName,
        durationMinutes: newDuration,
        isPerformanceSlot: category.isPerformanceSlot,
      );
      next = _document.copyWith(
        slotCategories: [..._document.slotCategories, forked],
        timelines: [
          for (final t in _document.timelines)
            if (t.id == id)
              t.copyWith(
                startTime: newStart,
                slots: [
                  firstSlot.copyWith(categoryId: forked.id),
                  ...timeline.slots.skip(1),
                ],
              )
            else
              t,
        ],
      );
    }
    _validateTimelineBounds(next);
    _commit(next);
  }

  /// Absorbs an end-time change by resizing (or forking) the last slot's type.
  void adjustTimelineEndViaLastSlot(
    String id,
    TimelineTime newEnd, {
    required String derivedCategoryName,
  }) {
    final timeline = _requireTimeline(id);
    final oldEnd = _document.endTimeOf(timeline);
    if (newEnd == oldEnd) return;

    final deltaMinutes = newEnd.difference(oldEnd).inMinutes;
    final lastSlot = timeline.slots.last;
    final category = _requireSlotCategory(lastSlot.categoryId);
    final newDuration = category.durationMinutes + deltaMinutes;
    if (newDuration <= 0) {
      throw ArgumentError.value(
        newEnd,
        'newEnd',
        'Last slot duration would be zero or negative',
      );
    }

    Document next;
    if (slotCategoryUsageCount(category.id) == 1) {
      next = _document.copyWith(
        slotCategories: [
          for (final c in _document.slotCategories)
            if (c.id == category.id)
              c.copyWith(durationMinutes: newDuration)
            else
              c,
        ],
      );
    } else {
      if (_document.isSlotCategoryNameTaken(derivedCategoryName)) {
        throw ArgumentError.value(
          derivedCategoryName,
          'derivedCategoryName',
          'Slot category name is taken',
        );
      }
      final forked = SlotCategory(
        id: generateEntityId(),
        name: derivedCategoryName,
        durationMinutes: newDuration,
        isPerformanceSlot: category.isPerformanceSlot,
      );
      next = _document.copyWith(
        slotCategories: [..._document.slotCategories, forked],
        timelines: [
          for (final t in _document.timelines)
            if (t.id == id)
              t.copyWith(
                slots: [
                  ...timeline.slots.sublist(0, timeline.slots.length - 1),
                  lastSlot.copyWith(categoryId: forked.id),
                ],
              )
            else
              t,
        ],
      );
    }
    _validateTimelineBounds(next);
    _commit(next);
  }

  /// Deletes the timeline. Assigned participants return to the pane
  /// (they simply become unassigned); slot categories are kept.
  void deleteTimeline(String id) {
    _requireTimeline(id);
    _commit(
      _document.copyWith(
        timelines: _document.timelines
            .where((timeline) => timeline.id != id)
            .toList(),
      ),
    );
  }

  /// Duplicates a timeline with fresh slot IDs. Categories are shared (not
  /// copied) and participants are not copied. [name] is the already-computed
  /// copy name (e.g. `(コピー)元の名前`).
  Timeline duplicateTimeline(String id, {required String name}) {
    final source = _requireTimeline(id);
    final copy = Timeline(
      id: generateEntityId(),
      name: name,
      startTime: source.startTime,
      slots: [
        for (final slot in source.slots)
          Slot(id: generateEntityId(), categoryId: slot.categoryId),
      ],
    );
    _commit(_document.copyWith(timelines: [..._document.timelines, copy]));
    return copy;
  }

  // --- Slots ---

  Slot insertSlot({
    required String timelineId,
    required int index,
    required String categoryId,
  }) {
    _requireSlotCategory(categoryId);
    final timeline = _requireTimeline(timelineId);
    if (index < 0 || index > timeline.slots.length) {
      throw RangeError.range(index, 0, timeline.slots.length, 'index');
    }
    final slot = Slot(id: generateEntityId(), categoryId: categoryId);
    final next = _updateTimeline(
      timelineId,
      (timeline) =>
          timeline.copyWith(slots: [...timeline.slots]..insert(index, slot)),
    );
    _validateTimelineBounds(next);
    _commit(next);
    return slot;
  }

  /// Drops a slot before the timeline start: the start moves to
  /// [newStartTime], the new slot goes first, and an auto-created changeover
  /// category (named [gapCategoryName]) fills the gap up to the old start.
  Slot insertSlotWithLeadingGap({
    required String timelineId,
    required String categoryId,
    required TimelineTime newStartTime,
    required String gapCategoryName,
  }) {
    final timeline = _requireTimeline(timelineId);
    final category = _requireSlotCategory(categoryId);
    final gapMinutes =
        timeline.startTime.difference(newStartTime).inMinutes -
        category.durationMinutes;
    if (gapMinutes <= 0) {
      throw ArgumentError.value(
        newStartTime,
        'newStartTime',
        'No gap remains before the timeline start',
      );
    }
    if (_document.isSlotCategoryNameTaken(gapCategoryName)) {
      throw ArgumentError.value(
        gapCategoryName,
        'gapCategoryName',
        'Slot category name is taken',
      );
    }
    final gapCategory = SlotCategory(
      id: generateEntityId(),
      name: gapCategoryName,
      durationMinutes: gapMinutes,
      isPerformanceSlot: false,
    );
    final slot = Slot(id: generateEntityId(), categoryId: categoryId);
    final gapSlot = Slot(id: generateEntityId(), categoryId: gapCategory.id);
    final next = _document.copyWith(
      slotCategories: [..._document.slotCategories, gapCategory],
      timelines: [
        for (final t in _document.timelines)
          if (t.id == timelineId)
            t.copyWith(
              startTime: newStartTime,
              slots: [slot, gapSlot, ...t.slots],
            )
          else
            t,
      ],
    );
    _validateTimelineBounds(next);
    _commit(next);
    return slot;
  }

  /// Drops a slot after the timeline end: an auto-created changeover category
  /// (named [gapCategoryName]) fills the gap from the old end to
  /// [slotStartTime], then the new slot goes last.
  Slot insertSlotWithTrailingGap({
    required String timelineId,
    required String categoryId,
    required TimelineTime slotStartTime,
    required String gapCategoryName,
  }) {
    final timeline = _requireTimeline(timelineId);
    _requireSlotCategory(categoryId);
    final gapMinutes =
        slotStartTime.difference(_document.endTimeOf(timeline)).inMinutes;
    if (gapMinutes <= 0) {
      throw ArgumentError.value(
        slotStartTime,
        'slotStartTime',
        'No gap remains after the timeline end',
      );
    }
    if (_document.isSlotCategoryNameTaken(gapCategoryName)) {
      throw ArgumentError.value(
        gapCategoryName,
        'gapCategoryName',
        'Slot category name is taken',
      );
    }
    final gapCategory = SlotCategory(
      id: generateEntityId(),
      name: gapCategoryName,
      durationMinutes: gapMinutes,
      isPerformanceSlot: false,
    );
    final slot = Slot(id: generateEntityId(), categoryId: categoryId);
    final gapSlot = Slot(id: generateEntityId(), categoryId: gapCategory.id);
    final next = _document.copyWith(
      slotCategories: [..._document.slotCategories, gapCategory],
      timelines: [
        for (final t in _document.timelines)
          if (t.id == timelineId)
            t.copyWith(slots: [...t.slots, gapSlot, slot])
          else
            t,
      ],
    );
    _validateTimelineBounds(next);
    _commit(next);
    return slot;
  }

  /// Removes the slot; if the timeline becomes empty it is deleted too.
  void removeSlot({required String timelineId, required String slotId}) {
    final timeline = _requireTimeline(timelineId);
    _requireSlot(timeline, slotId);
    final remaining = timeline.slots
        .where((slot) => slot.id != slotId)
        .toList();
    final timelines = remaining.isEmpty
        ? _document.timelines.where((t) => t.id != timelineId).toList()
        : [
            for (final t in _document.timelines)
              if (t.id == timelineId) t.copyWith(slots: remaining) else t,
          ];
    _commit(_document.copyWith(timelines: timelines));
  }

  /// Changes the slot's category. If the new category is not a performance
  /// slot, the assigned participant (if any) returns to the pane.
  void changeSlotCategory({
    required String timelineId,
    required String slotId,
    required String categoryId,
  }) {
    final category = _requireSlotCategory(categoryId);
    final timeline = _requireTimeline(timelineId);
    _requireSlot(timeline, slotId);
    final next = _updateTimeline(
      timelineId,
      (timeline) => timeline.copyWith(
        slots: [
          for (final slot in timeline.slots)
            if (slot.id == slotId)
              slot.copyWith(
                categoryId: categoryId,
                participantId: category.isPerformanceSlot
                    ? slot.participantId
                    : null,
              )
            else
              slot,
        ],
      ),
    );
    _validateTimelineBounds(next);
    _commit(next);
  }

  /// Creates [newCategory] and assigns it to [slotId] in one undoable change.
  void changeSlotCategoryWithNew({
    required String timelineId,
    required String slotId,
    required SlotCategory newCategory,
  }) {
    if (_document.isSlotCategoryNameTaken(newCategory.name)) {
      throw ArgumentError.value(
        newCategory.name,
        'name',
        'Slot category name is taken',
      );
    }
    final timeline = _requireTimeline(timelineId);
    _requireSlot(timeline, slotId);
    final next = _document.copyWith(
      slotCategories: [..._document.slotCategories, newCategory],
      timelines: [
        for (final t in _document.timelines)
          if (t.id == timelineId)
            t.copyWith(
              slots: [
                for (final slot in t.slots)
                  if (slot.id == slotId)
                    slot.copyWith(
                      categoryId: newCategory.id,
                      participantId: newCategory.isPerformanceSlot
                          ? slot.participantId
                          : null,
                    )
                  else
                    slot,
              ],
            )
          else
            t,
      ],
    );
    _validateTimelineBounds(next);
    _commit(next);
  }

  /// Gives [slotId] its own slot category with [newDurationMinutes].
  void setSlotDurationForSlotOnly({
    required String timelineId,
    required String slotId,
    required int newDurationMinutes,
    required String derivedCategoryName,
  }) {
    _requireDuration(newDurationMinutes);
    if (_document.isSlotCategoryNameTaken(derivedCategoryName)) {
      throw ArgumentError.value(
        derivedCategoryName,
        'derivedCategoryName',
        'Slot category name is taken',
      );
    }
    final timeline = _requireTimeline(timelineId);
    final slot = _requireSlot(timeline, slotId);
    final category = _requireSlotCategory(slot.categoryId);
    final forked = SlotCategory(
      id: generateEntityId(),
      name: derivedCategoryName,
      durationMinutes: newDurationMinutes,
      isPerformanceSlot: category.isPerformanceSlot,
    );
    final next = _document.copyWith(
      slotCategories: [..._document.slotCategories, forked],
      timelines: [
        for (final t in _document.timelines)
          if (t.id == timelineId)
            t.copyWith(
              slots: [
                for (final s in t.slots)
                  if (s.id == slotId) s.copyWith(categoryId: forked.id) else s,
              ],
            )
          else
            t,
      ],
    );
    _validateTimelineBounds(next);
    _commit(next);
  }

  /// Assigns [participantId] to the slot (null to unassign). A participant
  /// can occupy only one slot, so any previous placement is cleared.
  void assignParticipant({
    required String timelineId,
    required String slotId,
    required String? participantId,
  }) {
    final timeline = _requireTimeline(timelineId);
    final slot = _requireSlot(timeline, slotId);
    if (participantId != null) {
      _requireParticipant(participantId);
      final category = _requireSlotCategory(slot.categoryId);
      if (!category.isPerformanceSlot) {
        throw StateError(
          'Participants can only be assigned to performance slots',
        );
      }
    }
    _commit(
      _document.copyWith(
        timelines: [
          for (final t in _document.timelines)
            t.copyWith(
              slots: [
                for (final s in t.slots)
                  if (t.id == timelineId && s.id == slotId)
                    s.copyWith(participantId: participantId)
                  else if (participantId != null &&
                      s.participantId == participantId)
                    s.copyWith(participantId: null)
                  else
                    s,
              ],
            ),
        ],
      ),
    );
  }

  // --- Undo / redo ---

  void undo() {
    final current = state;
    if (!current.canUndo) return;
    final previous = current.undoStack.last;
    state = current.copyWith(
      document: previous,
      undoStack: current.undoStack.sublist(0, current.undoStack.length - 1),
      redoStack: [...current.redoStack, current.document],
    );
    _persist(previous);
  }

  void redo() {
    final current = state;
    if (!current.canRedo) return;
    final next = current.redoStack.last;
    state = current.copyWith(
      document: next,
      undoStack: [...current.undoStack, current.document],
      redoStack: current.redoStack.sublist(0, current.redoStack.length - 1),
    );
    _persist(next);
  }

  // --- Internals ---

  void _requireDuration(int durationMinutes) {
    if (durationMinutes < 1 ||
        durationMinutes > TimelineLimits.maxSlotDurationMinutes) {
      throw ArgumentError.value(
        durationMinutes,
        'durationMinutes',
        'Duration out of range',
      );
    }
  }

  void _validateTimelineBounds(Document document) {
    for (final timeline in document.timelines) {
      if (!document.endTimeOf(timeline).isWithinMax) {
        throw ArgumentError(
          'End time exceeds the timeline maximum',
        );
      }
    }
  }

  void _commit(Document next) {
    final current = state;
    if (next == current.document) return;
    final undoStack = [...current.undoStack, current.document];
    if (undoStack.length > maxHistoryLength) {
      undoStack.removeAt(0);
    }
    state = current.copyWith(
      document: next,
      undoStack: undoStack,
      redoStack: const [],
    );
    _persist(next);
  }

  void _persist(Document document) {
    unawaited(
      ref.read(documentStoreProvider).save(document).catchError((Object error) {
        debugPrint('Failed to save document: $error');
      }),
    );
  }

  Document _updateTimeline(String id, Timeline Function(Timeline) update) {
    _requireTimeline(id);
    return _document.copyWith(
      timelines: [
        for (final timeline in _document.timelines)
          if (timeline.id == id) update(timeline) else timeline,
      ],
    );
  }

  SlotCategory _requireSlotCategory(String id) {
    final category = _document.slotCategoryById(id);
    if (category == null) {
      throw ArgumentError.value(id, 'id', 'Unknown slot category');
    }
    return category;
  }

  Participant _requireParticipant(String id) {
    final participant = _document.participantById(id);
    if (participant == null) {
      throw ArgumentError.value(id, 'id', 'Unknown participant');
    }
    return participant;
  }

  Timeline _requireTimeline(String id) {
    final timeline = _document.timelineById(id);
    if (timeline == null) {
      throw ArgumentError.value(id, 'id', 'Unknown timeline');
    }
    return timeline;
  }

  Slot _requireSlot(Timeline timeline, String slotId) {
    for (final slot in timeline.slots) {
      if (slot.id == slotId) return slot;
    }
    throw ArgumentError.value(slotId, 'slotId', 'Unknown slot');
  }
}

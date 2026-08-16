import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';

import '../support/recording_document_store.dart';

({ProviderContainer container, RecordingDocumentStore store}) createHarness({
  Document? initialDocument,
}) {
  final store = RecordingDocumentStore();
  final container = ProviderContainer(
    overrides: [
      initialDocumentProvider.overrideWithValue(
        initialDocument ?? Document.empty(name: 'タイムテーブル'),
      ),
      documentStoreProvider.overrideWithValue(store),
    ],
  );
  addTearDown(container.dispose);
  return (container: container, store: store);
}

/// Document with one timeline (performance / changeover / performance) and
/// two participants, Alice assigned to the first performance slot.
Document sampleDocument() {
  return Document(
    name: 'タイムテーブル',
    slotCategories: const [
      SlotCategory(
        id: 'perf',
        name: '出演枠',
        durationMinutes: 30,
        isPerformanceSlot: true,
      ),
      SlotCategory(
        id: 'gap',
        name: '転換',
        durationMinutes: 10,
        isPerformanceSlot: false,
      ),
    ],
    participants: const [
      Participant(id: 'alice', name: 'Alice'),
      Participant(id: 'bob', name: 'Bob'),
    ],
    timelines: [
      Timeline(
        id: 'day1',
        name: '１日目',
        startTime: TimelineTime.fromHoursAndMinutes(hour: 10, minute: 0),
        slots: const [
          Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
          Slot(id: 's2', categoryId: 'gap'),
          Slot(id: 's3', categoryId: 'perf'),
        ],
      ),
    ],
  );
}

void main() {
  group('DocumentEditor slot categories', () {
    test('creates categories and rejects duplicate names', () {
      final (:container, :store) = createHarness();
      final editor = container.read(documentEditorProvider.notifier);

      final created = editor.createSlotCategory(
        name: '出演枠',
        durationMinutes: 30,
        isPerformanceSlot: true,
      );
      expect(
        container.read(documentProvider).slotCategoryById(created.id),
        created,
      );
      expect(
        () => editor.createSlotCategory(
          name: '出演枠',
          durationMinutes: 15,
          isPerformanceSlot: false,
        ),
        throwsArgumentError,
      );
    });

    test('updates a category in place', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      editor.updateSlotCategory(
        const SlotCategory(
          id: 'perf',
          name: '演奏',
          durationMinutes: 45,
          isPerformanceSlot: true,
        ),
      );

      final document = container.read(documentProvider);
      expect(document.slotCategoryById('perf')?.name, '演奏');
      expect(document.slotCategoryById('perf')?.durationMinutes, 45);
    });

    test('delete cascades to slots and removes emptied timelines', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      editor.deleteSlotCategory('perf');

      final document = container.read(documentProvider);
      expect(document.slotCategoryById('perf'), isNull);
      final timeline = document.timelineById('day1');
      expect(timeline, isNotNull);
      expect(timeline!.slots.map((slot) => slot.id), ['s2']);
      // Alice, previously assigned to a removed slot, returns to the pane.
      expect(
        document.unassignedParticipants().map((p) => p.id),
        containsAll(['alice', 'bob']),
      );

      // Deleting the remaining category empties the timeline → it is removed.
      editor.deleteSlotCategory('gap');
      expect(container.read(documentProvider).timelines, isEmpty);
    });
  });

  group('DocumentEditor participants', () {
    test('creates participants and rejects duplicate names', () {
      final (:container, :store) = createHarness();
      final editor = container.read(documentEditorProvider.notifier);

      editor.createParticipant(name: 'Alice');
      expect(
        () => editor.createParticipant(name: 'Alice'),
        throwsArgumentError,
      );
    });

    test('delete unassigns from slots but keeps the slots', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      editor.deleteParticipant('alice');

      final document = container.read(documentProvider);
      expect(document.participantById('alice'), isNull);
      final slots = document.timelineById('day1')!.slots;
      expect(slots, hasLength(3));
      expect(slots.every((slot) => slot.participantId == null), isTrue);
    });

    test('assign moves a participant out of their previous slot', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      editor.assignParticipant(
        timelineId: 'day1',
        slotId: 's3',
        participantId: 'alice',
      );

      final slots = container.read(documentProvider).timelineById('day1')!.slots;
      expect(slots[0].participantId, isNull);
      expect(slots[2].participantId, 'alice');
    });

    test('assign rejects non-performance slots, unassign works', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      expect(
        () => editor.assignParticipant(
          timelineId: 'day1',
          slotId: 's2',
          participantId: 'bob',
        ),
        throwsStateError,
      );

      editor.assignParticipant(
        timelineId: 'day1',
        slotId: 's1',
        participantId: null,
      );
      final slots = container.read(documentProvider).timelineById('day1')!.slots;
      expect(slots[0].participantId, isNull);
    });
  });

  group('DocumentEditor timelines and slots', () {
    test('addTimelineWithCategories commits categories and timeline together',
        () {
      final (:container, :store) = createHarness();
      final editor = container.read(documentEditorProvider.notifier);
      const category = SlotCategory(
        id: 'perf',
        name: '出演枠',
        durationMinutes: 30,
        isPerformanceSlot: true,
      );

      editor.addTimelineWithCategories(
        newCategories: const [category],
        timeline: Timeline(
          id: 'day1',
          name: 'タイムライン1',
          startTime: TimelineTime.parse('10:00'),
          slots: const [Slot(id: 's1', categoryId: 'perf')],
        ),
      );

      final document = container.read(documentProvider);
      expect(document.slotCategories, [category]);
      expect(document.timelines, hasLength(1));
      expect(document.endTimeOf(document.timelines.single).toDisplayString(), '10:30');

      editor.undo();
      expect(container.read(documentProvider).timelines, isEmpty);
      expect(container.read(documentProvider).slotCategories, isEmpty);
    });

    test('duplicates a timeline with fresh IDs and no participants', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      final copy = editor.duplicateTimeline('day1', name: '(コピー)１日目');

      final document = container.read(documentProvider);
      expect(document.timelines, hasLength(2));
      final stored = document.timelineById(copy.id)!;
      expect(stored.name, '(コピー)１日目');
      expect(stored.startTime, document.timelineById('day1')!.startTime);
      expect(
        stored.slots.map((slot) => slot.categoryId),
        ['perf', 'gap', 'perf'],
      );
      expect(stored.slots.every((slot) => slot.participantId == null), isTrue);
      final originalIds =
          document.timelineById('day1')!.slots.map((s) => s.id).toSet();
      expect(
        stored.slots.map((s) => s.id).toSet().intersection(originalIds),
        isEmpty,
      );
    });

    test('inserts a slot at the given index', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      final slot = editor.insertSlot(
        timelineId: 'day1',
        index: 1,
        categoryId: 'gap',
      );

      final slots = container.read(documentProvider).timelineById('day1')!.slots;
      expect(slots.map((s) => s.id), ['s1', slot.id, 's2', 's3']);
    });

    test('removing the last slot deletes the timeline', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      editor.removeSlot(timelineId: 'day1', slotId: 's1');
      editor.removeSlot(timelineId: 'day1', slotId: 's2');
      expect(container.read(documentProvider).timelines, hasLength(1));

      editor.removeSlot(timelineId: 'day1', slotId: 's3');
      expect(container.read(documentProvider).timelines, isEmpty);
    });

    test('changing to a non-performance category clears the participant', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      editor.changeSlotCategory(
        timelineId: 'day1',
        slotId: 's1',
        categoryId: 'gap',
      );

      final slot =
          container.read(documentProvider).timelineById('day1')!.slots[0];
      expect(slot.categoryId, 'gap');
      expect(slot.participantId, isNull);
    });
  });

  group('DocumentEditor undo/redo and persistence', () {
    test('every change autosaves; undo/redo restore and autosave too',
        () async {
      final (:container, :store) = createHarness();
      final editor = container.read(documentEditorProvider.notifier);

      expect(container.read(documentEditorProvider).canUndo, isFalse);

      editor.renameDocument('ライブA');
      editor.createParticipant(name: 'Alice');
      await null; // Let queued save futures complete.
      expect(store.saved, hasLength(2));

      final state = container.read(documentEditorProvider);
      expect(state.canUndo, isTrue);
      expect(state.canRedo, isFalse);

      editor.undo();
      expect(container.read(documentProvider).participants, isEmpty);
      expect(container.read(documentProvider).name, 'ライブA');
      expect(container.read(documentEditorProvider).canRedo, isTrue);

      editor.undo();
      expect(container.read(documentProvider).name, 'タイムテーブル');
      expect(container.read(documentEditorProvider).canUndo, isFalse);

      editor.redo();
      editor.redo();
      expect(container.read(documentProvider).name, 'ライブA');
      expect(container.read(documentProvider).participants, hasLength(1));

      await null;
      expect(store.saved, hasLength(6));
    });

    test('a new change clears the redo stack', () {
      final (:container, :store) = createHarness();
      final editor = container.read(documentEditorProvider.notifier);

      editor.renameDocument('A');
      editor.undo();
      expect(container.read(documentEditorProvider).canRedo, isTrue);

      editor.renameDocument('B');
      expect(container.read(documentEditorProvider).canRedo, isFalse);
      expect(container.read(documentProvider).name, 'B');
    });

    test('no-op changes are not recorded in history', () {
      final (:container, :store) = createHarness();
      final editor = container.read(documentEditorProvider.notifier);

      editor.renameDocument('タイムテーブル'); // Same name as before.
      expect(container.read(documentEditorProvider).canUndo, isFalse);
    });

    test('replaceDocument (import) clears undo history', () {
      final (:container, :store) = createHarness();
      final editor = container.read(documentEditorProvider.notifier);

      editor.renameDocument('編集済み');
      editor.replaceDocument(Document.empty(name: 'インポート'));

      final state = container.read(documentEditorProvider);
      expect(state.document.name, 'インポート');
      expect(state.canUndo, isFalse);
      expect(state.canRedo, isFalse);
    });

    test('clearDocument resets everything and is undoable', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);

      editor.clearDocument(documentName: 'タイムテーブル');
      final cleared = container.read(documentProvider);
      expect(cleared.timelines, isEmpty);
      expect(cleared.slotCategories, isEmpty);
      expect(cleared.participants, isEmpty);

      editor.undo();
      expect(container.read(documentProvider), sampleDocument());
    });
  });

  group('Selection', () {
    test('defaults to the document and can be changed', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      expect(
        container.read(selectionProvider),
        const Selection.document(),
      );

      final selection = container.read(selectionProvider.notifier);
      selection.select(const Selection.participant(participantId: 'alice'));
      expect(
        container.read(effectiveSelectionProvider),
        const Selection.participant(participantId: 'alice'),
      );

      selection.reset();
      expect(
        container.read(selectionProvider),
        const Selection.document(),
      );
    });

    test('effectiveSelection falls back when the object is gone', () {
      final (:container, :store) = createHarness(
        initialDocument: sampleDocument(),
      );
      final editor = container.read(documentEditorProvider.notifier);
      final selection = container.read(selectionProvider.notifier);

      selection.select(
        const Selection.slot(timelineId: 'day1', slotId: 's2'),
      );
      expect(
        container.read(effectiveSelectionProvider),
        const Selection.slot(timelineId: 'day1', slotId: 's2'),
      );

      editor.removeSlot(timelineId: 'day1', slotId: 's2');
      expect(
        container.read(effectiveSelectionProvider),
        const Selection.document(),
      );
    });
  });
}

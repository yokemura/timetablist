import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'document_editor.dart';

part 'selection.freezed.dart';
part 'selection.g.dart';

/// Object whose properties are shown in the property pane.
@freezed
sealed class Selection with _$Selection {
  /// Nothing specific selected: the pane shows document properties.
  const factory Selection.document() = DocumentSelection;

  const factory Selection.timeline({required String timelineId}) =
      TimelineSelection;

  const factory Selection.slotCategory({required String slotCategoryId}) =
      SlotCategorySelection;

  const factory Selection.slot({
    required String timelineId,
    required String slotId,
  }) = SlotSelection;

  const factory Selection.participant({required String participantId}) =
      ParticipantSelection;
}

@Riverpod(keepAlive: true)
class SelectionNotifier extends _$SelectionNotifier {
  @override
  Selection build() => const Selection.document();

  void select(Selection selection) => state = selection;

  void reset() => state = const Selection.document();
}

/// [SelectionNotifier]'s value, falling back to the document selection when
/// the selected object no longer exists (deleted, undone away, imported over).
@Riverpod(keepAlive: true)
Selection effectiveSelection(Ref ref) {
  final selection = ref.watch(selectionProvider);
  final document = ref.watch(documentProvider);
  final exists = switch (selection) {
    DocumentSelection() => true,
    TimelineSelection(:final timelineId) =>
      document.timelineById(timelineId) != null,
    SlotCategorySelection(:final slotCategoryId) =>
      document.slotCategoryById(slotCategoryId) != null,
    SlotSelection(:final timelineId, :final slotId) =>
      document
              .timelineById(timelineId)
              ?.slots
              .any((slot) => slot.id == slotId) ??
          false,
    ParticipantSelection(:final participantId) =>
      document.participantById(participantId) != null,
  };
  return exists ? selection : const Selection.document();
}

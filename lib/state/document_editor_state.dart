import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/models.dart';

part 'document_editor_state.freezed.dart';

/// Working document plus in-memory undo/redo history.
@freezed
abstract class DocumentEditorState with _$DocumentEditorState {
  const DocumentEditorState._();

  const factory DocumentEditorState({
    required Document document,
    @Default([]) List<Document> undoStack,
    @Default([]) List<Document> redoStack,
  }) = _DocumentEditorState;

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;
}

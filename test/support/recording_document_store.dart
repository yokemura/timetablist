import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';

/// In-memory store that records every autosave.
class RecordingDocumentStore implements DocumentStore {
  final List<Document> saved = [];

  @override
  Future<Document?> load() async => null;

  @override
  Future<void> save(Document document) async => saved.add(document);
}

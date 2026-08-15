import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

part 'document_store.g.dart';

/// Persists the working document so edits survive reloads.
abstract interface class DocumentStore {
  /// Returns the saved document, or null if nothing has been saved yet.
  Future<Document?> load();

  Future<void> save(Document document);
}

/// [DocumentStore] backed by `shared_preferences` (localStorage on web).
class SharedPreferencesDocumentStore implements DocumentStore {
  SharedPreferencesDocumentStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _key = 'document';

  final SharedPreferencesAsync _preferences;

  @override
  Future<Document?> load() async {
    final raw = await _preferences.getString(_key);
    if (raw == null) return null;
    return Document.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(Document document) =>
      _preferences.setString(_key, jsonEncode(document.toJson()));
}

@Riverpod(keepAlive: true)
DocumentStore documentStore(Ref ref) => SharedPreferencesDocumentStore();

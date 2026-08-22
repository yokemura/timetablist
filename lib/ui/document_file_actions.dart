import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/s.dart';
import '../models/models.dart';
import '../state/state.dart';
import 'dialogs/app_dialogs.dart';

/// Loads a JSON document via the platform file UI.
///
/// From the menu, [confirmReplace] is true: overwrite confirmation, then file
/// picker. From the startup empty-document dialog, confirmation is skipped.
Future<void> loadDocumentFromFile(
  BuildContext context,
  WidgetRef ref, {
  required bool confirmReplace,
}) async {
  final s = S.of(context);
  if (confirmReplace) {
    final confirmed = await showConfirmDialog(
      context,
      message: s.confirmImportReplace,
      confirmLabel: s.actionOk,
    );
    if (confirmed != true || !context.mounted) return;
  }

  final text = await ref.read(documentFilePortProvider).importJson();
  if (text == null || !context.mounted) return;

  final Document imported;
  try {
    imported = Document.fromJson(jsonDecode(text) as Map<String, dynamic>);
  } catch (_) {
    await showErrorDialog(context, s.errorImportFailed);
    return;
  }

  ref.read(documentEditorProvider.notifier).replaceDocument(imported);
}

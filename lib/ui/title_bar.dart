import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/s.dart';
import '../models/models.dart';
import '../state/state.dart';
import 'dialogs/app_dialogs.dart';
import 'dialogs/initial_timeline_dialog.dart';

enum MenuAction { export, import, clear, undo, redo }

/// Top title bar: brand link on the left, app menu on the right.
class TitleBar extends ConsumerWidget {
  const TitleBar({super.key});

  static const height = 40.0;

  static final _brandSiteUri = Uri.parse('https://ymck.net/');

  Future<void> _export(WidgetRef ref) {
    final document = ref.read(documentProvider);
    final name = document.name.trim();
    return ref.read(documentFilePortProvider).exportJson(
          fileName: '${name.isEmpty ? 'timetable' : name}.json',
          json: const JsonEncoder.withIndent('  ').convert(document.toJson()),
        );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final s = S.of(context);
    final text = await ref.read(documentFilePortProvider).importJson();
    if (text == null || !context.mounted) return;

    final Document imported;
    try {
      imported = Document.fromJson(jsonDecode(text) as Map<String, dynamic>);
    } catch (_) {
      await showErrorDialog(context, s.errorImportFailed);
      return;
    }

    final confirmed = await showConfirmDialog(
      context,
      message: s.confirmImportReplace,
      confirmLabel: s.actionOk,
    );
    if (confirmed != true || !context.mounted) return;
    ref.read(documentEditorProvider.notifier).replaceDocument(imported);
  }

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final s = S.of(context);
    final confirmed = await showConfirmDialog(
      context,
      message: s.confirmClearDocument,
      confirmLabel: s.actionOk,
    );
    if (confirmed != true || !context.mounted) return;
    ref
        .read(documentEditorProvider.notifier)
        .clearDocument(documentName: s.defaultDocumentName);
    if (!context.mounted) return;
    await showInitialTimelineDialog(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final editorState = ref.watch(documentEditorProvider);

    return Material(
      color: theme.colorScheme.surfaceContainer,
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            const SizedBox(width: 4),
            InkWell(
              onTap: () => unawaited(launchUrl(_brandSiteUri)),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  'Timetablist by YMCK',
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
            const Spacer(),
            PopupMenuButton<MenuAction>(
              icon: const Icon(Icons.menu),
              tooltip: s.menuTooltip,
              position: PopupMenuPosition.under,
              onSelected: (action) {
                final editor = ref.read(documentEditorProvider.notifier);
                switch (action) {
                  case MenuAction.undo:
                    editor.undo();
                  case MenuAction.redo:
                    editor.redo();
                  case MenuAction.export:
                    unawaited(_export(ref));
                  case MenuAction.import:
                    unawaited(_import(context, ref));
                  case MenuAction.clear:
                    unawaited(_clear(context, ref));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: MenuAction.export,
                  child: Text(s.menuExport),
                ),
                PopupMenuItem(
                  value: MenuAction.import,
                  child: Text(s.menuImport),
                ),
                PopupMenuItem(
                  value: MenuAction.clear,
                  child: Text(s.menuNew),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: MenuAction.undo,
                  enabled: editorState.canUndo,
                  child: Text(s.menuUndo),
                ),
                PopupMenuItem(
                  value: MenuAction.redo,
                  enabled: editorState.canRedo,
                  child: Text(s.menuRedo),
                ),
              ],
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

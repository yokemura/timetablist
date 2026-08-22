import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../files/document_csv.dart';
import '../files/download_file_name.dart';
import '../l10n/generated/s.dart';
import '../state/state.dart';
import 'dialogs/app_dialogs.dart';
import 'dialogs/initial_timeline_dialog.dart';
import 'document_file_actions.dart';

enum MenuAction { saveFile, exportCsv, loadFile, clear, undo, redo }

/// Top title bar: brand link on the left, app menu on the right.
class TitleBar extends ConsumerWidget {
  const TitleBar({super.key});

  static const height = 40.0;

  static final _brandSiteUri = Uri.parse('https://ymck.net/');

  Future<void> _saveFile(BuildContext context, WidgetRef ref) {
    final document = ref.read(documentProvider);
    return _writeFile(
      context,
      ref,
      fileName: downloadFileName(document.name, 'json'),
      contents: const JsonEncoder.withIndent('  ').convert(document.toJson()),
      mimeType: 'application/json',
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final document = ref.read(documentProvider);
    return _writeFile(
      context,
      ref,
      fileName: downloadFileName(document.name, 'csv'),
      contents: encodeDocumentCsv(
        document,
        DocumentCsvLabels(
          timeline: s.csvHeaderTimeline,
          start: s.csvHeaderStart,
          end: s.csvHeaderEnd,
          duration: s.csvHeaderDuration,
          slotType: s.csvHeaderSlotType,
          performer: s.csvHeaderPerformer,
        ),
      ),
      mimeType: 'text/csv',
    );
  }

  Future<void> _writeFile(
    BuildContext context,
    WidgetRef ref, {
    required String fileName,
    required String contents,
    required String mimeType,
  }) async {
    try {
      await ref
          .read(documentFilePortProvider)
          .saveFile(fileName: fileName, contents: contents, mimeType: mimeType);
    } catch (_) {
      if (!context.mounted) return;
      await showErrorDialog(context, S.of(context).errorExportFailed);
    }
  }

  Future<void> _loadFile(BuildContext context, WidgetRef ref) {
    return loadDocumentFromFile(context, ref, confirmReplace: true);
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

    final scheme = theme.colorScheme;

    return Material(
      color: scheme.primary,
      child: SizedBox(
        height: height,
        child: IconTheme(
          data: IconThemeData(color: scheme.onPrimary),
          child: Row(
            children: [
              const SizedBox(width: 4),
              InkWell(
                onTap: () => unawaited(launchUrl(_brandSiteUri)),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Text(
                    'Timetablist by YMCK',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              PopupMenuButton<MenuAction>(
                icon: const Icon(Icons.menu),
                iconColor: scheme.onPrimary,
                tooltip: s.menuTooltip,
                position: PopupMenuPosition.under,
                onSelected: (action) {
                  final editor = ref.read(documentEditorProvider.notifier);
                  switch (action) {
                    case MenuAction.undo:
                      editor.undo();
                    case MenuAction.redo:
                      editor.redo();
                    case MenuAction.saveFile:
                      unawaited(_saveFile(context, ref));
                    case MenuAction.exportCsv:
                      unawaited(_exportCsv(context, ref));
                    case MenuAction.loadFile:
                      unawaited(_loadFile(context, ref));
                    case MenuAction.clear:
                      unawaited(_clear(context, ref));
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: MenuAction.saveFile,
                    child: Text(s.menuExport),
                  ),
                  PopupMenuItem(
                    value: MenuAction.exportCsv,
                    child: Text(s.menuExportCsv),
                  ),
                  PopupMenuItem(
                    value: MenuAction.loadFile,
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
      ),
    );
  }
}

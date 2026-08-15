import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/s.dart';
import '../state/state.dart';

enum MenuAction { export, import, clear, undo, redo }

/// Top title bar: brand link on the left, app menu on the right.
class TitleBar extends ConsumerWidget {
  const TitleBar({super.key});

  static const height = 40.0;

  static final _brandSiteUri = Uri.parse('https://ymck.net/');

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
                  case MenuAction.import:
                  case MenuAction.clear:
                    // Wired up in the menu-actions step.
                    break;
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
                  child: Text(s.menuClear),
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

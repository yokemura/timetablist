import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/state.dart';
import 'ad_area.dart';
import 'dialogs/initial_timeline_dialog.dart';
import 'dialogs/startup_empty_dialog.dart';
import 'document_file_actions.dart';
import 'four_pane_layout.dart';
import 'panes/participant_pane.dart';
import 'panes/property_pane.dart';
import 'panes/slot_category_pane.dart';
import 'panes/timeline_pane.dart';
import 'title_bar.dart';
import 'undo_redo_shortcuts.dart';

/// Overall screen: title bar on top, four panes in the middle, ad area at
/// the bottom. Dialogs and bottom sheets may overlap the ad area.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({this.promptInitialTimeline = true, super.key});

  /// When true, shows the startup empty-document dialog if there are no
  /// timelines. Tests disable this so they can drive the empty pane themselves.
  final bool promptInitialTimeline;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  var _didPrompt = false;

  @override
  void initState() {
    super.initState();
    if (!widget.promptInitialTimeline) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didPrompt) return;
      _didPrompt = true;
      _promptIfEmpty();
    });
  }

  Future<void> _promptIfEmpty() async {
    while (mounted && ref.read(documentProvider).timelines.isEmpty) {
      final choice = await showStartupEmptyDocumentDialog(context);
      if (!mounted) return;
      switch (choice) {
        case StartupEmptyChoice.createNew:
          await showInitialTimelineDialog(context);
          return;
        case StartupEmptyChoice.loadFile:
          await loadDocumentFromFile(context, ref, confirmReplace: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UndoRedoShortcuts(
        child: Column(
          children: [
            TitleBar(),
            Expanded(
              child: FourPaneLayout(
                topLeft: SlotCategoryPane(),
                bottomLeft: ParticipantPane(),
                center: TimelinePane(),
                right: PropertyPane(),
              ),
            ),
            AdArea(),
          ],
        ),
      ),
    );
  }
}

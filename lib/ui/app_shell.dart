import 'package:flutter/material.dart';

import 'ad_area.dart';
import 'four_pane_layout.dart';
import 'panes/participant_pane.dart';
import 'panes/property_pane.dart';
import 'panes/slot_category_pane.dart';
import 'panes/timeline_pane.dart';
import 'title_bar.dart';
import 'undo_redo_shortcuts.dart';

/// Overall screen: title bar on top, four panes in the middle, ad area at
/// the bottom. Dialogs and bottom sheets may overlap the ad area.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

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

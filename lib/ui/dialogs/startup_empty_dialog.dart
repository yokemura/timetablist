import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';

enum StartupEmptyChoice { createNew, loadFile }

/// Asks whether to create a first timeline or load a file. Cannot be cancelled.
Future<StartupEmptyChoice> showStartupEmptyDocumentDialog(
  BuildContext context,
) async {
  final s = S.of(context);
  final choice = await showDialog<StartupEmptyChoice>(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Text(s.startupEmptyPrompt),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(StartupEmptyChoice.loadFile),
            child: Text(s.menuImport),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(StartupEmptyChoice.createNew),
            child: Text(s.menuNew),
          ),
        ],
      ),
    ),
  );
  return choice ?? StartupEmptyChoice.createNew;
}

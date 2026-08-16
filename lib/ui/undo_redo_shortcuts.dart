import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/state.dart';

/// App-wide undo/redo keyboard shortcuts, following the OS convention:
/// Cmd+Z / Shift+Cmd+Z on macOS, Ctrl+Z / Ctrl+Shift+Z (and Ctrl+Y)
/// elsewhere.
class UndoRedoShortcuts extends ConsumerWidget {
  const UndoRedoShortcuts({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMac = defaultTargetPlatform == TargetPlatform.macOS;
    final editor = ref.read(documentEditorProvider.notifier);
    return Shortcuts(
      shortcuts: {
        if (isMac) ...{
          const SingleActivator(LogicalKeyboardKey.keyZ, meta: true):
              const _UndoIntent(),
          const SingleActivator(
            LogicalKeyboardKey.keyZ,
            meta: true,
            shift: true,
          ): const _RedoIntent(),
        } else ...{
          const SingleActivator(LogicalKeyboardKey.keyZ, control: true):
              const _UndoIntent(),
          const SingleActivator(
            LogicalKeyboardKey.keyZ,
            control: true,
            shift: true,
          ): const _RedoIntent(),
          const SingleActivator(LogicalKeyboardKey.keyY, control: true):
              const _RedoIntent(),
        },
      },
      child: Actions(
        actions: {
          _UndoIntent: _EditorShortcutAction(editor.undo),
          _RedoIntent: _EditorShortcutAction(editor.redo),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}

class _UndoIntent extends Intent {
  const _UndoIntent();
}

class _RedoIntent extends Intent {
  const _RedoIntent();
}

class _EditorShortcutAction extends Action<Intent> {
  _EditorShortcutAction(this._run);

  final VoidCallback _run;

  /// Disabled while a text field has focus so it keeps its own undo/redo;
  /// a disabled action lets the event fall through to the text editing
  /// shortcuts defined above this widget.
  @override
  bool isEnabled(Intent intent, [BuildContext? context]) {
    final focused = FocusManager.instance.primaryFocus?.context;
    return focused == null ||
        focused.findAncestorStateOfType<EditableTextState>() == null;
  }

  @override
  Object? invoke(Intent intent) {
    _run();
    return null;
  }
}

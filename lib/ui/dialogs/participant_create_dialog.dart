import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../state/state.dart';

Future<void> showParticipantCreateDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const ParticipantCreateDialog(),
  );
}

/// Dialog that creates a participant (演者).
///
/// A duplicate name shows a warning and blocks creation.
class ParticipantCreateDialog extends ConsumerStatefulWidget {
  const ParticipantCreateDialog({super.key});

  @override
  ConsumerState<ParticipantCreateDialog> createState() =>
      _ParticipantCreateDialogState();
}

class _ParticipantCreateDialogState
    extends ConsumerState<ParticipantCreateDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _name => _nameController.text.trim();

  void _create() {
    ref.read(documentEditorProvider.notifier).createParticipant(name: _name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);

    final isDuplicate =
        _name.isNotEmpty && document.isParticipantNameTaken(_name);
    final canCreate = _name.isNotEmpty && !isDuplicate;

    return AlertDialog(
      title: Text(s.participantCreateTitle),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _nameController,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: s.fieldName,
            errorText: isDuplicate ? s.errorDuplicateParticipantName : null,
            isDense: true,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.actionCancel),
        ),
        FilledButton(
          onPressed: canCreate ? _create : null,
          child: Text(s.actionCreate),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../../state/state.dart';
import '../widgets/requirements_editor.dart';
import '../widgets/warning_text.dart';

Future<void> showParticipantCreateSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 480),
    builder: (_) => const ParticipantCreateSheet(),
  );
}

/// Bottom sheet that creates a participant (演者).
///
/// A duplicate name shows a warning and blocks creation. Requirement items
/// are optional; contradictory requirements block creation too.
class ParticipantCreateSheet extends ConsumerStatefulWidget {
  const ParticipantCreateSheet({super.key});

  @override
  ConsumerState<ParticipantCreateSheet> createState() =>
      _ParticipantCreateSheetState();
}

class _ParticipantCreateSheetState
    extends ConsumerState<ParticipantCreateSheet> {
  final _nameController = TextEditingController();

  /// Null while the requirement editor holds invalid or incomplete input.
  ParticipantRequirements? _requirements = const ParticipantRequirements();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _name => _nameController.text.trim();

  void _create() {
    ref
        .read(documentEditorProvider.notifier)
        .createParticipant(name: _name, requirements: _requirements!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final document = ref.watch(documentProvider);

    final isDuplicate =
        _name.isNotEmpty && document.isParticipantNameTaken(_name);
    final requirements = _requirements;
    final hasContradiction =
        requirements != null && requirements.hasContradiction;
    final canCreate = _name.isNotEmpty &&
        !isDuplicate &&
        requirements != null &&
        !hasContradiction;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.participantCreateTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: s.fieldName,
                  errorText:
                      isDuplicate ? s.errorDuplicateParticipantName : null,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              RequirementsEditor(
                initialValue: const ParticipantRequirements(),
                onChanged: (value) => setState(() => _requirements = value),
              ),
              if (hasContradiction) ...[
                const SizedBox(height: 4),
                WarningText(s.errorRequirementsContradiction),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(s.actionCancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: canCreate ? _create : null,
                    child: Text(s.actionCreate),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

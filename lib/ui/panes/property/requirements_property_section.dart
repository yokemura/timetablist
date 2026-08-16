import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/s.dart';
import '../../../models/models.dart';
import '../../../state/state.dart';
import '../../widgets/requirements_editor.dart';
import '../../widgets/warning_text.dart';
import 'property_scaffold.dart';

/// Edits [Participant.requirements] with an explicit apply action so partial
/// input is not committed mid keystroke.
class RequirementsPropertySection extends ConsumerStatefulWidget {
  const RequirementsPropertySection({required this.participant, super.key});

  final Participant participant;

  @override
  ConsumerState<RequirementsPropertySection> createState() =>
      _RequirementsPropertySectionState();
}

class _RequirementsPropertySectionState
    extends ConsumerState<RequirementsPropertySection> {
  ParticipantRequirements? _pending;
  var _hasContradiction = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final committed = widget.participant.requirements;
    final pending = _pending ?? committed;
    final canApply = _pending != null &&
        !_hasContradiction &&
        _pending != committed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PropertySectionTitle(s.sectionRequirements),
        RequirementsEditor(
          key: ValueKey(widget.participant.id),
          initialValue: committed,
          onChanged: (value) {
            setState(() {
              _pending = value;
              _hasContradiction = value?.hasContradiction ?? false;
            });
          },
        ),
        if (_hasContradiction) WarningText(s.errorRequirementsContradiction),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: canApply
                ? () {
                    ref.read(documentEditorProvider.notifier).updateParticipant(
                          widget.participant.copyWith(requirements: pending),
                        );
                    setState(() => _pending = null);
                  }
                : null,
            child: Text(s.actionOk),
          ),
        ),
      ],
    );
  }
}

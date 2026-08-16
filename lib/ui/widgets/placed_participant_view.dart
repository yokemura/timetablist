import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import 'warning_text.dart';

/// Participant block shown inside a performance slot.
///
/// Rounded corners and padding (applied by the parent) give the impression
/// that this block can be dragged; the slot around it cannot.
class PlacedParticipantView extends StatelessWidget {
  const PlacedParticipantView({
    required this.participant,
    required this.hasMismatch,
    super.key,
  });

  final Participant participant;
  final bool hasMismatch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Material(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              participant.name,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasMismatch) WarningText(s.requirementMismatchLabel),
          ],
        ),
      ),
    );
  }
}

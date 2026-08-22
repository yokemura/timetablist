import 'package:flutter/material.dart';

import '../../models/models.dart';

/// Participant block shown inside a performance slot.
///
/// Rounded corners and padding (applied by the parent) give the impression
/// that this block can be dragged; the slot around it cannot.
class PlacedParticipantView extends StatelessWidget {
  const PlacedParticipantView({
    required this.participant,
    super.key,
  });

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          participant.name,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

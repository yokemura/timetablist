import 'package:flutter/material.dart';

import '../../models/models.dart';

/// Participant list item: name only. Click to select; also acts as a drag
/// source. Assigned participants remain in the list.
class ParticipantListItem extends StatelessWidget {
  const ParticipantListItem({
    required this.participant,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Participant participant;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.secondaryContainer
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            participant.name,
            style: theme.textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

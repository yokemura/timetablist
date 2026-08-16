import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';

/// Slot category list item: name, duration, and the performance attribute.
/// Click to select; also acts as a drag source (wired up in a later step).
class SlotCategoryListItem extends StatelessWidget {
  const SlotCategoryListItem({
    required this.category,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final SlotCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.secondaryContainer
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      s.durationMinutesLabel(category.durationMinutes),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (category.isPerformanceSlot)
                Tooltip(
                  message: s.performanceAttributeLabel,
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/state.dart';
import '../timeline/time_layout.dart';
import 'placed_slot_view.dart';

/// One lane: a timeline name header plus the time-mapped slot stack.
class TimelineLane extends StatelessWidget {
  const TimelineLane({
    required this.timeline,
    required this.placedSlots,
    required this.layout,
    required this.selection,
    required this.onSelect,
    super.key,
  });

  static const width = 168.0;
  static const headerHeight = 28.0;

  final Timeline timeline;
  final List<PlacedSlot> placedSlots;
  final TimeLayout layout;
  final Selection selection;
  final ValueChanged<Selection> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = selection == Selection.timeline(timelineId: timeline.id);
    final midnightY = layout.yOf(TimeLayout.afterMidnight);

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: selected
                ? scheme.secondaryContainer
                : scheme.surfaceContainer,
            child: InkWell(
              onTap: () =>
                  onSelect(Selection.timeline(timelineId: timeline.id)),
              child: SizedBox(
                height: headerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      timeline.name,
                      style: theme.textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: layout.totalHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelect(const Selection.document()),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: midnightY,
                    child: ColoredBox(color: scheme.surfaceContainerLow),
                  ),
                  Positioned(
                    top: midnightY,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ColoredBox(color: scheme.surfaceContainerHighest),
                  ),
                  for (final placed in placedSlots)
                    Positioned(
                      top: layout.yOf(placed.startTime),
                      height: layout.heightOf(placed.startTime, placed.endTime),
                      left: 0,
                      right: 0,
                      child: PlacedSlotView(
                        placed: placed,
                        selected:
                            selection ==
                            Selection.slot(
                              timelineId: timeline.id,
                              slotId: placed.slot.id,
                            ),
                        onTap: () => onSelect(
                          Selection.slot(
                            timelineId: timeline.id,
                            slotId: placed.slot.id,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

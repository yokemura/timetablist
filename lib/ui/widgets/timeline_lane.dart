import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/state.dart';
import '../timeline/drag_data.dart';
import '../timeline/slot_drop.dart';
import '../timeline/time_layout.dart';
import 'placed_slot_view.dart';

/// One lane: a timeline name header plus the time-mapped slot stack.
///
/// When [onSlotCategoryDrop] is set, the lane accepts slot category drags and
/// shows an insertion bar; when [onParticipantDrop] is set, performance slots
/// accept participant drops.
class TimelineLane extends StatefulWidget {
  const TimelineLane({
    required this.timeline,
    required this.placedSlots,
    required this.layout,
    required this.selection,
    required this.onSelect,
    this.onSlotCategoryDrop,
    this.onParticipantDrop,
    super.key,
  });

  static const width = 168.0;
  static const headerHeight = 28.0;
  static const insertionBarThickness = 3.0;

  final Timeline timeline;
  final List<PlacedSlot> placedSlots;
  final TimeLayout layout;
  final Selection selection;
  final ValueChanged<Selection> onSelect;
  final void Function(SlotDrop drop, SlotCategory category)?
      onSlotCategoryDrop;
  final void Function(PlacedSlot target, ParticipantDragData data)?
      onParticipantDrop;

  @override
  State<TimelineLane> createState() => _TimelineLaneState();
}

class _TimelineLaneState extends State<TimelineLane> {
  SlotDrop? _pendingDrop;

  TimeLayout get _layout => widget.layout;

  SlotDrop _dropFor(DragTargetDetails<SlotCategoryDragData> details) {
    // The lane's render box includes the header above the time-mapped stack.
    final box = context.findRenderObject()! as RenderBox;
    final localY =
        box.globalToLocal(details.offset).dy - TimelineLane.headerHeight;
    return computeSlotDrop(
      layout: _layout,
      placedSlots: widget.placedSlots,
      durationMinutes: details.data.category.durationMinutes,
      y: localY,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timeline = widget.timeline;
    final selected =
        widget.selection == Selection.timeline(timelineId: timeline.id);
    final midnightY = _layout.yOf(TimeLayout.afterMidnight);

    Widget stack = Stack(
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
        for (final placed in widget.placedSlots)
          Positioned(
            top: _layout.yOf(placed.startTime),
            height: _layout.heightOf(placed.startTime, placed.endTime),
            left: 0,
            right: 0,
            child: PlacedSlotView(
              placed: placed,
              selected:
                  widget.selection ==
                  Selection.slot(
                    timelineId: timeline.id,
                    slotId: placed.slot.id,
                  ),
              timelineId:
                  widget.onParticipantDrop != null ? timeline.id : null,
              onParticipantDropped: widget.onParticipantDrop == null
                  ? null
                  : (data) => widget.onParticipantDrop!(placed, data),
              onTap: () => widget.onSelect(
                Selection.slot(
                  timelineId: timeline.id,
                  slotId: placed.slot.id,
                ),
              ),
            ),
          ),
        if (_pendingDrop != null)
          Positioned(
            top: _layout.yOf(_pendingDrop!.barTime) -
                TimelineLane.insertionBarThickness / 2,
            height: TimelineLane.insertionBarThickness,
            left: 0,
            right: 0,
            child: ColoredBox(color: scheme.primary),
          ),
      ],
    );

    if (widget.onSlotCategoryDrop != null) {
      // Capture into a local so the builder does not close over the reassigned
      // `stack` variable (which would make the DragTarget build itself).
      final child = stack;
      stack = DragTarget<SlotCategoryDragData>(
        onMove: (details) =>
            setState(() => _pendingDrop = _dropFor(details)),
        onLeave: (_) => setState(() => _pendingDrop = null),
        onAcceptWithDetails: (details) {
          final drop = _dropFor(details);
          setState(() => _pendingDrop = null);
          widget.onSlotCategoryDrop!(drop, details.data.category);
        },
        builder: (context, candidates, rejected) => child,
      );
    }

    return SizedBox(
      width: TimelineLane.width,
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
                  widget.onSelect(Selection.timeline(timelineId: timeline.id)),
              child: SizedBox(
                height: TimelineLane.headerHeight,
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
            height: _layout.totalHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onSelect(const Selection.document()),
              child: stack,
            ),
          ),
        ],
      ),
    );
  }
}

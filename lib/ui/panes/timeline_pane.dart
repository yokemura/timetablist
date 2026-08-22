import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../../state/state.dart';
import '../dialogs/app_dialogs.dart';
import '../dialogs/timeline_create_dialog.dart';
import '../timeline/drag_data.dart';
import '../timeline/slot_drop.dart';
import '../timeline/slot_height_measurer.dart';
import '../timeline/time_layout.dart';
import '../widgets/time_ruler.dart';
import '../widgets/timeline_lane.dart';

/// Center pane: time ruler, one lane per timeline, and a create button.
///
/// Empty documents show only the button. Lanes pack from the left at a
/// fixed width; leftover space accepts slot category drops that create a
/// new timeline.
class TimelinePane extends ConsumerStatefulWidget {
  const TimelinePane({super.key});

  @override
  ConsumerState<TimelinePane> createState() => _TimelinePaneState();
}

class _TimelinePaneState extends ConsumerState<TimelinePane> {
  final _vertical = ScrollController();
  final _horizontal = ScrollController();

  @override
  void dispose() {
    _vertical.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  DocumentEditor get _editor => ref.read(documentEditorProvider.notifier);

  Future<void> _handleSlotCategoryDrop(
    Timeline timeline,
    SlotDrop drop,
    SlotCategory category,
  ) async {
    final s = S.of(context);
    try {
      switch (drop) {
        case SlotDropInsert(:final index):
          _editor.insertSlot(
            timelineId: timeline.id,
            index: index,
            categoryId: category.id,
          );
        case SlotDropLeadingGap(:final newStartTime):
          final confirmed = await showConfirmDialog(
            context,
            message: s.confirmCreateGapSlot,
            confirmLabel: s.actionOk,
          );
          if (confirmed != true || !mounted) return;
          _editor.insertSlotWithLeadingGap(
            timelineId: timeline.id,
            categoryId: category.id,
            newStartTime: newStartTime,
            gapCategoryName: ref
                .read(documentProvider)
                .nextAvailableSlotCategoryName(s.autoGapCategoryName),
          );
        case SlotDropTrailingGap(:final slotStartTime):
          final confirmed = await showConfirmDialog(
            context,
            message: s.confirmCreateGapSlot,
            confirmLabel: s.actionOk,
          );
          if (confirmed != true || !mounted) return;
          _editor.insertSlotWithTrailingGap(
            timelineId: timeline.id,
            categoryId: category.id,
            slotStartTime: slotStartTime,
            gapCategoryName: ref
                .read(documentProvider)
                .nextAvailableSlotCategoryName(s.autoGapCategoryName),
          );
      }
    } on ArgumentError catch (error) {
      if (!mounted) return;
      await showErrorDialog(context, editorErrorMessage(s, error));
    }
  }

  Future<void> _handleEmptyAreaDrop(
    TimelineTime startTime,
    SlotCategory category,
  ) async {
    final s = S.of(context);
    final document = ref.read(documentProvider);
    try {
      _editor.addTimeline(
        Timeline(
          id: generateEntityId(),
          name: document.nextAvailableTimelineName(s.defaultTimelineBaseName),
          startTime: startTime,
          slots: [Slot(id: generateEntityId(), categoryId: category.id)],
        ),
      );
    } on ArgumentError catch (error) {
      if (!mounted) return;
      await showErrorDialog(context, editorErrorMessage(s, error));
    }
  }

  Future<void> _handleParticipantDrop(
    Timeline timeline,
    PlacedSlot target,
    ParticipantDragData data,
  ) async {
    final s = S.of(context);
    final occupantId = target.slot.participantId;
    if (occupantId != null && occupantId != data.participant.id) {
      final confirmed = await showConfirmDialog(
        context,
        message: s.confirmSwapParticipant,
        confirmLabel: s.actionOk,
      );
      if (confirmed != true || !mounted) return;
    }
    _editor.assignParticipant(
      timelineId: timeline.id,
      slotId: target.slot.id,
      participantId: data.participant.id,
      clearTimelineId: data.fromTimelineId,
      clearSlotId: data.fromSlotId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final document = ref.watch(documentProvider);
    final selection = ref.watch(effectiveSelectionProvider);
    // Merge with the ambient default style the same way the Text widgets do,
    // so measurement uses the exact style that renders.
    final defaultStyle = DefaultTextStyle.of(context).style;
    final measurer = SlotHeightMeasurer(
      titleStyle: defaultStyle.merge(theme.textTheme.labelSmall),
      nameStyle: defaultStyle.merge(
        theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      slotContentWidth:
          TimelineLane.width - TimelineLane.slotHorizontalPadding * 2,
    );
    final layout = TimeLayout.fromDocument(
      document,
      measureSlot: measurer.heightOf,
    );

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: document.timelines.isEmpty
                ? _NewTimelineDropArea(
                    layout: layout,
                    onDrop: _handleEmptyAreaDrop,
                    child: const SizedBox.expand(),
                  )
                : Scrollbar(
                    controller: _vertical,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _vertical,
                      child: Scrollbar(
                        controller: _horizontal,
                        thumbVisibility: true,
                        notificationPredicate: (notification) =>
                            notification.depth == 1,
                        child: SingleChildScrollView(
                          controller: _horizontal,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: TimelineLane.headerHeight,
                                  ),
                                  TimeRuler(layout: layout),
                                ],
                              ),
                              for (final timeline in document.timelines)
                                TimelineLane(
                                  timeline: timeline,
                                  placedSlots: document.placedSlotsOf(timeline),
                                  layout: layout,
                                  selection: selection,
                                  onSelect: (next) => ref
                                      .read(selectionProvider.notifier)
                                      .select(next),
                                  onSlotCategoryDrop: (drop, category) =>
                                      _handleSlotCategoryDrop(
                                        timeline,
                                        drop,
                                        category,
                                      ),
                                  onParticipantDrop: (target, data) =>
                                      _handleParticipantDrop(
                                        timeline,
                                        target,
                                        data,
                                      ),
                                ),
                              _NewTimelineDropArea(
                                layout: layout,
                                onDrop: _handleEmptyAreaDrop,
                                child: SizedBox(
                                  width: TimelineLane.width,
                                  height:
                                      TimelineLane.headerHeight +
                                      layout.totalHeight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: FilledButton.icon(
              onPressed: () => showTimelineCreateDialog(context, ref),
              icon: const Icon(Icons.add),
              label: Text(s.createTimelineButton),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty region of the pane: accepts slot category drops at a 10-minute
/// resolution and creates a new timeline (with a dialog).
class _NewTimelineDropArea extends StatefulWidget {
  const _NewTimelineDropArea({
    required this.layout,
    required this.onDrop,
    required this.child,
  });

  final TimeLayout layout;
  final void Function(TimelineTime startTime, SlotCategory category) onDrop;
  final Widget child;

  @override
  State<_NewTimelineDropArea> createState() => _NewTimelineDropAreaState();
}

class _NewTimelineDropAreaState extends State<_NewTimelineDropArea> {
  TimelineTime? _pendingTime;

  TimelineTime _timeFor(DragTargetDetails<SlotCategoryDragData> details) {
    final box = context.findRenderObject()! as RenderBox;
    final localY =
        box.globalToLocal(details.offset).dy - TimelineLane.headerHeight;
    return roundToDropResolution(widget.layout.timeOf(localY));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DragTarget<SlotCategoryDragData>(
      onMove: (details) => setState(() => _pendingTime = _timeFor(details)),
      onLeave: (_) => setState(() => _pendingTime = null),
      onAcceptWithDetails: (details) {
        final time = _timeFor(details);
        setState(() => _pendingTime = null);
        widget.onDrop(time, details.data.category);
      },
      builder: (context, candidates, rejected) => Stack(
        children: [
          widget.child,
          if (_pendingTime != null)
            Positioned(
              top:
                  TimelineLane.headerHeight +
                  widget.layout.yOf(_pendingTime!) -
                  TimelineLane.insertionBarThickness / 2,
              height: TimelineLane.insertionBarThickness,
              left: 0,
              width: TimelineLane.width,
              child: ColoredBox(color: scheme.primary),
            ),
        ],
      ),
    );
  }
}

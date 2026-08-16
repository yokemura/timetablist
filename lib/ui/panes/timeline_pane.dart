import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../state/state.dart';
import '../sheets/timeline_create_sheet.dart';
import '../timeline/time_layout.dart';
import '../widgets/time_ruler.dart';
import '../widgets/timeline_lane.dart';

/// Center pane: time ruler, one lane per timeline, and a create button.
///
/// Empty documents show only the button. Lanes pack from the left at a
/// fixed width; leftover space is the drop target for a new timeline
/// (wired up in the drag-and-drop step).
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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final selection = ref.watch(effectiveSelectionProvider);
    final layout = TimeLayout.fromDocument(document);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: document.timelines.isEmpty
                ? const SizedBox.expand()
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
            child: FilledButton.tonalIcon(
              onPressed: () => showTimelineCreateSheet(context),
              icon: const Icon(Icons.add),
              label: Text(s.createTimelineButton),
            ),
          ),
        ],
      ),
    );
  }
}

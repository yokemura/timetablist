import 'package:flutter/material.dart';

/// Center pane: lanes with timelines and the time scale.
/// Placeholder for now; real content arrives in the timeline-pane step.
class TimelinePane extends StatelessWidget {
  const TimelinePane({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerLow);
  }
}

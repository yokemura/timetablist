import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import 'commit_text_field.dart';

/// [CommitTextField] variant for clock times on a timeline.
///
/// Accepts hours past 24 (e.g. `25:05`) up to the timeline maximum (`30:00`).
/// Used for timeline start/end times and participant requirement times.
class CommitTimeField extends StatelessWidget {
  const CommitTimeField({
    required this.value,
    required this.onCommit,
    this.label,
    this.enabled = true,
    super.key,
  });

  final TimelineTime value;
  final ValueChanged<TimelineTime> onCommit;
  final String? label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CommitTextField(
      value: value.toDisplayString(),
      label: label,
      enabled: enabled,
      hintText: '8:05',
      keyboardType: TextInputType.datetime,
      validator: (text) {
        final parsed = TimelineTime.tryParse(text.trim());
        if (parsed == null) return s.errorInvalidTime;
        if (!parsed.isWithinMax) return s.errorTimeOutOfRange;
        return null;
      },
      onCommit: (text) => onCommit(TimelineTime.parse(text.trim())),
    );
  }
}

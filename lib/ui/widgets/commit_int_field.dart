import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import 'commit_text_field.dart';

/// [CommitTextField] variant for whole numbers (minutes, slot counts, ...).
///
/// Only integers within [min]..[max] are committed.
class CommitIntField extends StatelessWidget {
  const CommitIntField({
    required this.value,
    required this.onCommit,
    this.min = 1,
    this.max,
    this.label,
    this.enabled = true,
    super.key,
  });

  final int value;
  final ValueChanged<int> onCommit;
  final int min;
  final int? max;
  final String? label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CommitTextField(
      value: '$value',
      label: label,
      enabled: enabled,
      keyboardType: TextInputType.number,
      validator: (text) {
        final parsed = int.tryParse(text.trim());
        if (parsed == null) return s.errorInvalidInteger;
        if (parsed < min) return s.errorIntegerMin(min);
        final max = this.max;
        if (max != null && parsed > max) return s.errorIntegerMax(max);
        return null;
      },
      onCommit: (text) => onCommit(int.parse(text.trim())),
    );
  }
}

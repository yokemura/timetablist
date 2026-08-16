import 'package:flutter/material.dart';

/// Requirement-mismatch warning: small text in the warning color.
///
/// Shared by the participant component on the timeline and the slot category
/// picker warnings.
class WarningText extends StatelessWidget {
  const WarningText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }
}

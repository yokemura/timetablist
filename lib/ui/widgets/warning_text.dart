import 'package:flutter/material.dart';

/// Small warning-colored label used for validation messages.
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

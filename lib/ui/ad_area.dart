import 'package:flutter/material.dart';

/// Bottom ad banner area.
///
/// Always reserves a fixed height so that ad load success or failure never
/// changes the layout. Shows a plain placeholder until an ad network is
/// integrated (the final height will match its standard banner size).
class AdArea extends StatelessWidget {
  const AdArea({super.key});

  static const height = 60.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Text(
        'AD',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.outline,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

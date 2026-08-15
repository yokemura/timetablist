import 'package:flutter/material.dart';

/// Right pane: properties of the selected object.
/// Placeholder for now; real content arrives in the property-pane step.
class PropertyPane extends StatelessWidget {
  const PropertyPane({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: Theme.of(context).colorScheme.surface);
  }
}

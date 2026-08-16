import 'package:flutter/material.dart';

import '../../../l10n/generated/s.dart';
import '../../../models/models.dart';
import '../../widgets/warning_text.dart';
import 'property_scaffold.dart';

class RequirementViolationList extends StatelessWidget {
  const RequirementViolationList({required this.violations, super.key});

  final List<RequirementViolation> violations;

  @override
  Widget build(BuildContext context) {
    if (violations.isEmpty) return const SizedBox.shrink();

    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PropertySectionTitle(s.sectionRequirementViolations),
        for (final violation in violations)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: WarningText(_label(s, violation)),
          ),
      ],
    );
  }

  String _label(S s, RequirementViolation violation) => switch (violation) {
    RequirementViolation.belowMinDuration => s.violationBelowMinDuration,
    RequirementViolation.aboveMaxDuration => s.violationAboveMaxDuration,
    RequirementViolation.finishesTooLate => s.violationFinishesTooLate,
    RequirementViolation.startsTooEarly => s.violationStartsTooEarly,
    RequirementViolation.orderTooEarly => s.violationOrderTooEarly,
    RequirementViolation.orderTooLate => s.violationOrderTooLate,
  };
}

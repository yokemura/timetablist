import '../../l10n/generated/s.dart';
import '../../models/models.dart';

/// Short, localized summaries of the explicitly set requirement items,
/// in the same order as the requirement editor rows.
List<String> requirementSummaries(S s, ParticipantRequirements requirements) {
  final min = requirements.minDurationMinutes;
  final max = requirements.maxDurationMinutes;
  final finishBy = requirements.finishBy;
  final startAfter = requirements.startAfter;
  final orderFrom = requirements.preferredOrderFrom;
  final orderBefore = requirements.preferredOrderBefore;
  return [
    if (min != null) s.reqSummaryMinDuration(min),
    if (max != null) s.reqSummaryMaxDuration(max),
    if (finishBy != null) s.reqSummaryFinishBy(finishBy.toDisplayString()),
    if (startAfter != null)
      s.reqSummaryStartAfter(startAfter.toDisplayString()),
    if (orderFrom != null) s.reqSummaryOrderFrom(orderFrom),
    if (orderBefore != null) s.reqSummaryOrderBefore(orderBefore),
  ];
}

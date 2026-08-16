import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';

enum TimelineTimeAdjustment {
  adjustEndpointSlot,
  moveAllSlots,
}

enum SlotDurationAdjustment {
  thisSlotOnly,
  allSameType,
}

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String message,
}) {
  final s = S.of(context);
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(s.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(s.actionDelete),
        ),
      ],
    ),
  );
}

Future<void> showErrorDialog(BuildContext context, String message) {
  final s = S.of(context);
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.actionOk),
        ),
      ],
    ),
  );
}

Future<TimelineTimeAdjustment?> showTimelineStartAdjustmentDialog(
  BuildContext context, {
  required bool canAdjustFirstSlot,
}) {
  final s = S.of(context);
  return showDialog<TimelineTimeAdjustment>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(s.dialogTimelineStartChangeTitle),
      children: [
        if (canAdjustFirstSlot)
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(
              TimelineTimeAdjustment.adjustEndpointSlot,
            ),
            child: Text(s.choiceAdjustFirstSlotOnly),
          ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(
            TimelineTimeAdjustment.moveAllSlots,
          ),
          child: Text(s.choiceMoveAllSlots),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.actionCancel),
        ),
      ],
    ),
  );
}

Future<TimelineTimeAdjustment?> showTimelineEndAdjustmentDialog(
  BuildContext context, {
  required bool canAdjustLastSlot,
}) {
  final s = S.of(context);
  return showDialog<TimelineTimeAdjustment>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(s.dialogTimelineEndChangeTitle),
      children: [
        if (canAdjustLastSlot)
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(
              TimelineTimeAdjustment.adjustEndpointSlot,
            ),
            child: Text(s.choiceAdjustLastSlotOnly),
          ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(
            TimelineTimeAdjustment.moveAllSlots,
          ),
          child: Text(s.choiceMoveAllSlots),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.actionCancel),
        ),
      ],
    ),
  );
}

Future<SlotDurationAdjustment?> showSlotDurationAdjustmentDialog(
  BuildContext context,
) {
  final s = S.of(context);
  return showDialog<SlotDurationAdjustment>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(s.dialogSlotDurationChangeTitle),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(
            SlotDurationAdjustment.thisSlotOnly,
          ),
          child: Text(s.choiceAdjustThisSlotOnly),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(
            SlotDurationAdjustment.allSameType,
          ),
          child: Text(s.choiceAdjustAllSameType),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.actionCancel),
        ),
      ],
    ),
  );
}

Future<bool?> showRemovePerformanceAttributeDialog(BuildContext context) {
  final s = S.of(context);
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(s.confirmRemovePerformanceAttribute),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(s.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(s.actionOk),
        ),
      ],
    ),
  );
}

String editorErrorMessage(S s, Object error) {
  if (error is! ArgumentError) return error.toString();
  final message = error.message?.toString() ?? '';
  if (message.contains('timeline maximum')) {
    return s.errorTimelineExceedsMax;
  }
  if (message.contains('before 0:00')) {
    return s.errorTimelineStartBeforeMidnight;
  }
  if (message.contains('Slot category name is taken')) {
    return s.errorDuplicateCategoryName;
  }
  return message.isEmpty ? error.toString() : message;
}

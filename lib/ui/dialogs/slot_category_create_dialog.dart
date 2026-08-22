import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../../state/state.dart';

Future<void> showSlotCategoryCreateDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const SlotCategoryCreateDialog(),
  );
}

/// Dialog that creates a slot category (枠タイプ).
///
/// A duplicate name shows a warning and blocks creation. Duration must be a
/// positive integer of at most 1800 minutes. The performance attribute
/// defaults to on.
class SlotCategoryCreateDialog extends ConsumerStatefulWidget {
  const SlotCategoryCreateDialog({super.key});

  @override
  ConsumerState<SlotCategoryCreateDialog> createState() =>
      _SlotCategoryCreateDialogState();
}

class _SlotCategoryCreateDialogState
    extends ConsumerState<SlotCategoryCreateDialog> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isPerformance = true;

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  String get _name => _nameController.text.trim();

  int? get _duration {
    final value = int.tryParse(_durationController.text.trim());
    if (value == null ||
        value < 1 ||
        value > TimelineLimits.maxSlotDurationMinutes) {
      return null;
    }
    return value;
  }

  String? _durationError(S s) {
    final text = _durationController.text.trim();
    if (text.isEmpty) return null;
    final value = int.tryParse(text);
    if (value == null) return s.errorInvalidInteger;
    if (value < 1) return s.errorIntegerMin(1);
    if (value > TimelineLimits.maxSlotDurationMinutes) {
      return s.errorIntegerMax(TimelineLimits.maxSlotDurationMinutes);
    }
    return null;
  }

  void _create() {
    ref
        .read(documentEditorProvider.notifier)
        .createSlotCategory(
          name: _name,
          durationMinutes: _duration!,
          isPerformanceSlot: _isPerformance,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);

    final isDuplicate =
        _name.isNotEmpty && document.isSlotCategoryNameTaken(_name);
    final canCreate = _name.isNotEmpty && !isDuplicate && _duration != null;

    return AlertDialog(
      title: Text(s.slotCategoryCreateTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: s.fieldName,
                errorText: isDuplicate ? s.errorDuplicateCategoryName : null,
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: s.fieldDurationMinutes,
                errorText: _durationError(s),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              value: _isPerformance,
              onChanged: (checked) =>
                  setState(() => _isPerformance = checked ?? false),
              title: Text(s.fieldPerformanceAttribute),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.actionCancel),
        ),
        FilledButton(
          onPressed: canCreate ? _create : null,
          child: Text(s.actionCreate),
        ),
      ],
    );
  }
}

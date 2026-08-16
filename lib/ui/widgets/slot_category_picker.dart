import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../timeline/timeline_draft.dart';

/// Existing-or-new slot category picker used by the timeline create sheet
/// (and later by the property pane).
///
/// When no [candidates] exist, only the new-name / duration fields are shown
/// (name prefilled with [draft.newName]). When candidates exist, a dropdown
/// switches between an existing category (read-only details) and a new one.
class SlotCategoryPicker extends StatefulWidget {
  const SlotCategoryPicker({
    required this.draft,
    required this.candidates,
    required this.takenNames,
    required this.onChanged,
    super.key,
  });

  static const newSentinel = '__new__';

  final CategoryDraft draft;
  final List<SlotCategory> candidates;
  final Set<String> takenNames;
  final ValueChanged<CategoryDraft> onChanged;

  @override
  State<SlotCategoryPicker> createState() => _SlotCategoryPickerState();
}

class _SlotCategoryPickerState extends State<SlotCategoryPicker> {
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _nameText);
    _durationController = TextEditingController(text: _durationText);
  }

  @override
  void didUpdateWidget(SlotCategoryPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_nameText != _nameController.text) {
      _nameController.text = _nameText;
    }
    if (_durationText != _durationController.text) {
      _durationController.text = _durationText;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  CategoryDraft get _draft => widget.draft;

  String get _nameText => _draft.isNew ? _draft.newName : _draft.name;

  String get _durationText => _draft.isNew
      ? _draft.newDurationText
      : '${_draft.existing!.durationMinutes}';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDuplicate = _draft.isNew &&
        _draft.name.isNotEmpty &&
        widget.takenNames.contains(_draft.name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.candidates.isNotEmpty)
          DropdownButtonFormField<String>(
            initialValue: _draft.existing?.id ?? SlotCategoryPicker.newSentinel,
            isExpanded: true,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
            items: [
              for (final category in widget.candidates)
                DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name, overflow: TextOverflow.ellipsis),
                ),
              DropdownMenuItem(
                value: SlotCategoryPicker.newSentinel,
                child: Text(s.slotCategoryPickerCreateNew),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              if (value == SlotCategoryPicker.newSentinel) {
                widget.onChanged(_draft.copyWith(clearExisting: true));
              } else {
                widget.onChanged(
                  _draft.copyWith(
                    existing: widget.candidates.firstWhere((c) => c.id == value),
                  ),
                );
              }
            },
          ),
        if (widget.candidates.isNotEmpty) const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          enabled: _draft.isNew,
          onChanged: (text) => widget.onChanged(_draft.copyWith(newName: text)),
          decoration: InputDecoration(
            labelText: s.fieldName,
            errorText: isDuplicate ? s.errorDuplicateCategoryName : null,
            isDense: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _durationController,
          enabled: _draft.isNew,
          keyboardType: TextInputType.number,
          onChanged: (text) =>
              widget.onChanged(_draft.copyWith(newDurationText: text)),
          decoration: InputDecoration(
            labelText: s.fieldDurationMinutes,
            errorText: _draft.isNew ? _durationError(s) : null,
            isDense: true,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  String? _durationError(S s) {
    final text = _draft.newDurationText.trim();
    if (text.isEmpty) return null;
    final value = int.tryParse(text);
    if (value == null) return s.errorInvalidInteger;
    if (value < 1) return s.errorIntegerMin(1);
    if (value > TimelineLimits.maxSlotDurationMinutes) {
      return s.errorIntegerMax(TimelineLimits.maxSlotDurationMinutes);
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../../state/state.dart';
import 'app_dialogs.dart';

/// Opens the pane's timeline creation dialog. When no slot categories exist
/// yet, shows an error prompting to create one first (a timeline cannot be
/// empty, so an initial slot type is required).
Future<void> showTimelineCreateDialog(BuildContext context, WidgetRef ref) {
  final s = S.of(context);
  final document = ref.read(documentProvider);
  if (document.slotCategories.isEmpty) {
    return showErrorDialog(context, s.errorNoSlotCategoriesForTimeline);
  }
  return showDialog<void>(
    context: context,
    builder: (_) => const TimelineCreateDialog(),
  );
}

/// Dialog that creates a timeline with a name, a start time, and one initial
/// slot of the selected slot type.
class TimelineCreateDialog extends ConsumerStatefulWidget {
  const TimelineCreateDialog({super.key});

  @override
  ConsumerState<TimelineCreateDialog> createState() =>
      _TimelineCreateDialogState();
}

class _TimelineCreateDialogState extends ConsumerState<TimelineCreateDialog> {
  late final TextEditingController _nameController;
  final _startController = TextEditingController(text: '10:00');
  String? _categoryId;
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _nameController.text = S.of(context).defaultTimelineBaseName;
    _categoryId = ref.read(documentProvider).slotCategories.first.id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startController.dispose();
    super.dispose();
  }

  String get _name => _nameController.text.trim();

  TimelineTime? get _startTime =>
      TimelineTime.tryParse(_startController.text.trim());

  Future<void> _create() async {
    final s = S.of(context);
    final timeline = Timeline(
      id: generateEntityId(),
      name: _name,
      startTime: _startTime!,
      slots: [Slot(id: generateEntityId(), categoryId: _categoryId!)],
    );
    try {
      ref.read(documentEditorProvider.notifier).addTimeline(timeline);
    } on ArgumentError catch (error) {
      if (!mounted) return;
      await showErrorDialog(context, editorErrorMessage(s, error));
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final document = ref.watch(documentProvider);
    final canCreate =
        _name.isNotEmpty && _startTime != null && _categoryId != null;

    return AlertDialog(
      title: Text(s.timelineCreateTitle),
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
                labelText: s.fieldTimelineName,
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _startController,
              keyboardType: TextInputType.datetime,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: s.fieldStartTime,
                errorText: _startError(s),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: s.fieldInitialSlotCategory,
                isDense: true,
                border: const OutlineInputBorder(),
              ),
              items: [
                for (final category in document.slotCategories)
                  DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (value) => setState(() => _categoryId = value),
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

  String? _startError(S s) {
    final text = _startController.text.trim();
    if (text.isEmpty) return null;
    final time = TimelineTime.tryParse(text);
    if (time == null) return s.errorInvalidTime;
    if (!time.isWithinMax) return s.errorTimeOutOfRange;
    return null;
  }
}

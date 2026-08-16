import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../../state/state.dart';
import '../timeline/timeline_draft.dart';
import '../widgets/slot_category_picker.dart';
import '../widgets/warning_text.dart';

Future<void> showTimelineCreateSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 520),
    builder: (_) => const TimelineCreateSheet(),
  );
}

/// Bottom sheet that creates a timeline from the prep / performance /
/// interval / teardown template. Times update live as the form changes.
class TimelineCreateSheet extends ConsumerStatefulWidget {
  const TimelineCreateSheet({super.key});

  @override
  ConsumerState<TimelineCreateSheet> createState() =>
      _TimelineCreateSheetState();
}

class _TimelineCreateSheetState extends ConsumerState<TimelineCreateSheet> {
  late final TextEditingController _startController;
  late final TextEditingController _countController;
  late TimelineDraft _draft;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: '10:00');
    _countController = TextEditingController(text: '1');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_draftReady) {
      _draft = _initialDraft();
      _draftReady = true;
    }
  }

  var _draftReady = false;

  TimelineDraft _initialDraft() {
    final s = S.of(context);
    final document = ref.read(documentProvider);
    final nonPerformance = document.slotCategories
        .where((c) => !c.isPerformanceSlot)
        .toList();
    final performance = document.slotCategories
        .where((c) => c.isPerformanceSlot)
        .toList();
    return TimelineDraft(
      startTimeText: '10:00',
      hasPrep: false,
      prep: CategoryDraft.initial(
        candidates: nonPerformance,
        defaultName: s.defaultCategoryPrep,
        isPerformanceSlot: false,
      ),
      performanceCountText: '1',
      performance: CategoryDraft.initial(
        candidates: performance,
        defaultName: s.defaultCategoryPerformance,
        isPerformanceSlot: true,
      ),
      hasInterval: false,
      interval: CategoryDraft.initial(
        candidates: nonPerformance,
        defaultName: s.defaultCategoryInterval,
        isPerformanceSlot: false,
      ),
      hasTeardown: false,
      teardown: CategoryDraft.initial(
        candidates: nonPerformance,
        defaultName: s.defaultCategoryTeardown,
        isPerformanceSlot: false,
      ),
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Set<String> _takenNamesExcluding(CategoryDraft self) {
    final document = ref.read(documentProvider);
    final names = document.slotCategories.map((c) => c.name).toSet();
    for (final other in [_draft.prep, _draft.performance, _draft.interval, _draft.teardown]) {
      if (identical(other, self)) continue;
      if (other.isNew && other.name.isNotEmpty) names.add(other.name);
    }
    return names;
  }

  bool _draftValid(CategoryDraft draft) {
    if (draft.durationMinutes == null) return false;
    if (draft.isNew && draft.name.isEmpty) return false;
    if (draft.isNew && _takenNamesExcluding(draft).contains(draft.name)) {
      return false;
    }
    return true;
  }

  bool get _canCreate {
    final times = _draft.times;
    if (times.endTime == null || times.exceedsMax) return false;
    if (_draft.slotSequence == null) return false;
    if (!_draftValid(_draft.performance)) return false;
    if (_draft.hasPrep && !_draftValid(_draft.prep)) return false;
    if (_draft.hasInterval && !_draftValid(_draft.interval)) return false;
    if (_draft.hasTeardown && !_draftValid(_draft.teardown)) return false;
    return true;
  }

  void _create() {
    final s = S.of(context);
    final document = ref.read(documentProvider);
    final sequence = _draft.slotSequence!;
    final newCategories = <SlotCategory>[];

    String resolve(CategoryDraft draft) {
      if (draft.existing != null) return draft.existing!.id;
      for (final created in newCategories) {
        if (created.name == draft.name) return created.id;
      }
      final category = SlotCategory(
        id: generateEntityId(),
        name: draft.name,
        durationMinutes: draft.durationMinutes!,
        isPerformanceSlot: draft.isPerformanceSlot,
      );
      newCategories.add(category);
      return category.id;
    }

    final timeline = Timeline(
      id: generateEntityId(),
      name: s.defaultTimelineName(document.timelines.length + 1),
      startTime: _draft.startTime!,
      slots: [
        for (final step in sequence)
          Slot(id: generateEntityId(), categoryId: resolve(step.category)),
      ],
    );

    ref
        .read(documentEditorProvider.notifier)
        .addTimelineWithCategories(
          timeline: timeline,
          newCategories: newCategories,
        );
    Navigator.of(context).pop();
  }

  String _timeLabel(TimelineTime? time) => time?.toDisplayString() ?? '—';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final document = ref.watch(documentProvider);
    final nonPerformance = document.slotCategories
        .where((c) => !c.isPerformanceSlot)
        .toList();
    final performance = document.slotCategories
        .where((c) => c.isPerformanceSlot)
        .toList();
    final times = _draft.times;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.timelineCreateTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              TextField(
                controller: _startController,
                keyboardType: TextInputType.datetime,
                onChanged: (text) =>
                    setState(() => _draft = _draft.copyWith(startTimeText: text)),
                decoration: InputDecoration(
                  labelText: s.fieldSequenceStart,
                  hintText: '10:00',
                  errorText: _startError(s),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              CheckboxListTile(
                value: _draft.hasPrep,
                onChanged: (checked) => setState(
                  () => _draft = _draft.copyWith(hasPrep: checked ?? false),
                ),
                title: Text(s.fieldHasPrep),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              if (_draft.hasPrep)
                SlotCategoryPicker(
                  key: const Key('picker.prep'),
                  draft: _draft.prep,
                  candidates: nonPerformance,
                  takenNames: _takenNamesExcluding(_draft.prep),
                  onChanged: (prep) =>
                      setState(() => _draft = _draft.copyWith(prep: prep)),
                ),
              const SizedBox(height: 8),
              Text(
                '${s.fieldPerformanceStart}: ${_timeLabel(times.performanceStart)}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _countController,
                keyboardType: TextInputType.number,
                onChanged: (text) => setState(
                  () => _draft = _draft.copyWith(performanceCountText: text),
                ),
                decoration: InputDecoration(
                  labelText: s.fieldPerformanceCount,
                  errorText: _countError(s),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SlotCategoryPicker(
                key: const Key('picker.performance'),
                draft: _draft.performance,
                candidates: performance,
                takenNames: _takenNamesExcluding(_draft.performance),
                onChanged: (value) =>
                    setState(() => _draft = _draft.copyWith(performance: value)),
              ),
              CheckboxListTile(
                value: _draft.hasInterval,
                onChanged: (checked) => setState(
                  () => _draft = _draft.copyWith(hasInterval: checked ?? false),
                ),
                title: Text(s.fieldHasInterval),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              if (_draft.hasInterval)
                SlotCategoryPicker(
                  key: const Key('picker.interval'),
                  draft: _draft.interval,
                  candidates: nonPerformance,
                  takenNames: _takenNamesExcluding(_draft.interval),
                  onChanged: (value) =>
                      setState(() => _draft = _draft.copyWith(interval: value)),
                ),
              CheckboxListTile(
                value: _draft.hasTeardown,
                onChanged: (checked) => setState(
                  () => _draft = _draft.copyWith(hasTeardown: checked ?? false),
                ),
                title: Text(s.fieldHasTeardown),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              if (_draft.hasTeardown) ...[
                Text(
                  '${s.fieldTeardownStart}: ${_timeLabel(times.teardownStart)}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                SlotCategoryPicker(
                  key: const Key('picker.teardown'),
                  draft: _draft.teardown,
                  candidates: nonPerformance,
                  takenNames: _takenNamesExcluding(_draft.teardown),
                  onChanged: (value) =>
                      setState(() => _draft = _draft.copyWith(teardown: value)),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                '${s.fieldEndTime}: ${_timeLabel(times.endTime)}',
                style: theme.textTheme.bodyMedium,
              ),
              if (times.exceedsMax) ...[
                const SizedBox(height: 4),
                WarningText(s.errorTimelineExceedsMax),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(s.actionCancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _canCreate ? _create : null,
                    child: Text(s.actionCreate),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _startError(S s) {
    final text = _draft.startTimeText.trim();
    if (text.isEmpty) return null;
    final time = TimelineTime.tryParse(text);
    if (time == null) return s.errorInvalidTime;
    if (!time.isWithinMax) return s.errorTimeOutOfRange;
    return null;
  }

  String? _countError(S s) {
    final text = _draft.performanceCountText.trim();
    if (text.isEmpty) return null;
    final value = int.tryParse(text);
    if (value == null) return s.errorInvalidInteger;
    if (value < 1) return s.errorIntegerMin(1);
    return null;
  }
}

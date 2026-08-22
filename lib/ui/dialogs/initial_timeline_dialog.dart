import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';
import '../../state/state.dart';
import '../timeline/initial_timeline_draft.dart';
import '../widgets/warning_text.dart';

/// Shows the initial timeline creation dialog. It cannot be cancelled; the
/// only way out is creating a timeline (with the fixed template categories).
Future<void> showInitialTimelineDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const InitialTimelineDialog(),
  );
}

/// Dialog shown at startup while no timelines exist and after the menu's
/// New action: builds a timeline from the venue setup / rehearsal / doors /
/// performance / teardown template. Times update live as the form changes.
class InitialTimelineDialog extends ConsumerStatefulWidget {
  const InitialTimelineDialog({super.key});

  @override
  ConsumerState<InitialTimelineDialog> createState() =>
      _InitialTimelineDialogState();
}

class _InitialTimelineDialogState extends ConsumerState<InitialTimelineDialog> {
  late final TextEditingController _nameController;
  final _countController = TextEditingController(text: '1');
  final _sequenceStartController = TextEditingController(text: '10:00');
  final _rehearsalStartController = TextEditingController();
  final _rehearsalDurationController = TextEditingController();
  final _rehearsalChangeoverController = TextEditingController();
  final _performanceStartController = TextEditingController(text: '10:00');
  final _performanceDurationController = TextEditingController();
  final _changeoverController = TextEditingController();
  final _teardownEndController = TextEditingController();

  var _draft = const InitialTimelineDraft();
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
    final s = S.of(context);
    _nameController.text = s.defaultTimelineBaseName;
    _draft = _draft.copyWith(nameText: s.defaultTimelineBaseName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _sequenceStartController.dispose();
    _rehearsalStartController.dispose();
    _rehearsalDurationController.dispose();
    _rehearsalChangeoverController.dispose();
    _performanceStartController.dispose();
    _performanceDurationController.dispose();
    _changeoverController.dispose();
    _teardownEndController.dispose();
    super.dispose();
  }

  void _update(InitialTimelineDraft draft) => setState(() => _draft = draft);

  void _create() {
    final s = S.of(context);
    final document = ref.read(documentProvider);
    final sequence = _draft.slotSequence!;

    String defaultNameOf(InitialSlotKind kind) => switch (kind) {
          InitialSlotKind.venuePrep => s.defaultCategoryVenuePrep,
          InitialSlotKind.rehearsal => s.defaultCategoryRehearsal,
          InitialSlotKind.rehearsalChangeover =>
            s.defaultCategoryRehearsalChangeover,
          InitialSlotKind.doors => s.defaultCategoryDoors,
          InitialSlotKind.performance => s.defaultCategoryPerformance,
          InitialSlotKind.changeover => s.defaultCategoryChangeover,
          InitialSlotKind.teardown => s.defaultCategoryTeardown,
        };
    bool isPerformanceOf(InitialSlotKind kind) =>
        kind == InitialSlotKind.rehearsal ||
        kind == InitialSlotKind.performance;

    final categories = <InitialSlotKind, SlotCategory>{};
    final newCategories = <SlotCategory>[];
    for (final kind in sequence.toSet()) {
      final category = SlotCategory(
        id: generateEntityId(),
        // Creation normally starts from an empty document, so the default
        // names are free; fall back to the common auto-naming rule just in
        // case categories already exist.
        name: document.nextAvailableSlotCategoryName(defaultNameOf(kind)),
        durationMinutes: _draft.categoryDurationOf(kind)!,
        isPerformanceSlot: isPerformanceOf(kind),
      );
      categories[kind] = category;
      newCategories.add(category);
    }

    final timeline = Timeline(
      id: generateEntityId(),
      name: _draft.name,
      startTime: _draft.sequenceStart!,
      slots: [
        for (final kind in sequence)
          Slot(id: generateEntityId(), categoryId: categories[kind]!.id),
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

  String _minutesLabel(S s, int? minutes) =>
      minutes == null || minutes <= 0 ? '—' : s.durationMinutesLabel(minutes);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final times = _draft.times;
    final canCreate = _draft.slotSequence != null;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(s.initialTimelineCreateTitle),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _textField(
                  controller: _nameController,
                  label: s.fieldTimelineName,
                  onChanged: (text) => _update(_draft.copyWith(nameText: text)),
                ),
                _textField(
                  controller: _countController,
                  label: s.fieldPerformanceCount,
                  keyboardType: TextInputType.number,
                  errorText: _countError(s),
                  onChanged: (text) =>
                      _update(_draft.copyWith(countText: text)),
                ),
                _textField(
                  controller: _sequenceStartController,
                  label: s.fieldSequenceStart,
                  keyboardType: TextInputType.datetime,
                  errorText: _timeError(s, _draft.sequenceStartText),
                  onChanged: (text) =>
                      _update(_draft.copyWith(sequenceStartText: text)),
                ),
                _checkbox(
                  key: const Key('initial.hasVenuePrep'),
                  value: _draft.hasVenuePrep,
                  label: s.fieldHasVenuePrep,
                  onChanged: (checked) =>
                      _update(_draft.copyWith(hasVenuePrep: checked)),
                ),
                if (_draft.hasVenuePrep)
                  _derivedRow(
                    theme,
                    s.fieldDerivedDuration,
                    _minutesLabel(s, times.venuePrepMinutes),
                  ),
                _checkbox(
                  key: const Key('initial.hasRehearsal'),
                  value: _draft.hasRehearsal,
                  label: s.fieldHasRehearsal,
                  onChanged: (checked) =>
                      _update(_draft.copyWith(hasRehearsal: checked)),
                ),
                if (_draft.hasRehearsal) ...[
                  if (_draft.hasVenuePrep)
                    _textField(
                      controller: _rehearsalStartController,
                      label: s.fieldRehearsalStart,
                      keyboardType: TextInputType.datetime,
                      errorText: _timeError(s, _draft.rehearsalStartText),
                      onChanged: (text) =>
                          _update(_draft.copyWith(rehearsalStartText: text)),
                    ),
                  _textField(
                    controller: _rehearsalDurationController,
                    label: s.fieldRehearsalDuration,
                    keyboardType: TextInputType.number,
                    errorText:
                        _minutesError(s, _draft.rehearsalDurationText),
                    onChanged: (text) =>
                        _update(_draft.copyWith(rehearsalDurationText: text)),
                  ),
                  _checkbox(
                    key: const Key('initial.hasRehearsalChangeover'),
                    value: _draft.hasRehearsalChangeover,
                    label: s.fieldHasRehearsalChangeover,
                    onChanged: (checked) => _update(
                      _draft.copyWith(hasRehearsalChangeover: checked),
                    ),
                  ),
                  if (_draft.hasRehearsalChangeover)
                    _textField(
                      controller: _rehearsalChangeoverController,
                      label: s.fieldRehearsalChangeoverDuration,
                      keyboardType: TextInputType.number,
                      errorText:
                          _minutesError(s, _draft.rehearsalChangeoverText),
                      onChanged: (text) => _update(
                        _draft.copyWith(rehearsalChangeoverText: text),
                      ),
                    ),
                  _derivedRow(
                    theme,
                    s.fieldRehearsalEnd,
                    _timeLabel(times.rehearsalEnd),
                  ),
                  _checkbox(
                    key: const Key('initial.hasDoors'),
                    value: _draft.hasDoors,
                    label: s.fieldHasDoors,
                    onChanged: (checked) =>
                        _update(_draft.copyWith(hasDoors: checked)),
                  ),
                  if (_draft.hasDoors)
                    _derivedRow(
                      theme,
                      s.fieldDerivedDuration,
                      _minutesLabel(s, times.doorsMinutes),
                    ),
                ],
                const SizedBox(height: 8),
                Text(
                  s.sectionPerformanceSlots,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                _textField(
                  controller: _performanceStartController,
                  label: s.fieldPerformanceStart,
                  keyboardType: TextInputType.datetime,
                  errorText: _timeError(s, _draft.performanceStartText),
                  onChanged: (text) =>
                      _update(_draft.copyWith(performanceStartText: text)),
                ),
                _textField(
                  controller: _performanceDurationController,
                  label: s.fieldPerformanceDuration,
                  keyboardType: TextInputType.number,
                  errorText: _minutesError(s, _draft.performanceDurationText),
                  onChanged: (text) =>
                      _update(_draft.copyWith(performanceDurationText: text)),
                ),
                _checkbox(
                  key: const Key('initial.hasChangeover'),
                  value: _draft.hasChangeover,
                  label: s.fieldHasChangeover,
                  onChanged: (checked) =>
                      _update(_draft.copyWith(hasChangeover: checked)),
                ),
                if (_draft.hasChangeover)
                  _textField(
                    controller: _changeoverController,
                    label: s.fieldChangeoverDuration,
                    keyboardType: TextInputType.number,
                    errorText: _minutesError(s, _draft.changeoverText),
                    onChanged: (text) =>
                        _update(_draft.copyWith(changeoverText: text)),
                  ),
                _derivedRow(theme, s.fieldShowEndTime, _timeLabel(times.showEnd)),
                _checkbox(
                  key: const Key('initial.hasTeardown'),
                  value: _draft.hasTeardown,
                  label: s.fieldHasTeardown,
                  onChanged: (checked) =>
                      _update(_draft.copyWith(hasTeardown: checked)),
                ),
                if (_draft.hasTeardown) ...[
                  _derivedRow(
                    theme,
                    s.fieldDerivedDuration,
                    _minutesLabel(s, times.teardownMinutes),
                  ),
                  _textField(
                    controller: _teardownEndController,
                    label: s.fieldTeardownEnd,
                    keyboardType: TextInputType.datetime,
                    errorText: _timeError(s, _draft.teardownEndText),
                    onChanged: (text) =>
                        _update(_draft.copyWith(teardownEndText: text)),
                  ),
                ],
                _derivedRow(theme, s.fieldEndTime, _timeLabel(times.endTime)),
                if (times.hasContradiction) ...[
                  const SizedBox(height: 4),
                  WarningText(s.errorTimesContradiction),
                ],
                if (times.exceedsMax) ...[
                  const SizedBox(height: 4),
                  WarningText(s.errorTimelineExceedsMax),
                ],
              ],
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: canCreate ? _create : null,
            child: Text(s.actionCreate),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _checkbox({
    required Key key,
    required bool value,
    required String label,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      key: key,
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _derivedRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text('$label: $value', style: theme.textTheme.bodyMedium),
    );
  }

  String? _countError(S s) {
    final text = _draft.countText.trim();
    if (text.isEmpty) return null;
    final value = int.tryParse(text);
    if (value == null) return s.errorInvalidInteger;
    if (value < 1) return s.errorIntegerMin(1);
    return null;
  }

  String? _timeError(S s, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    final time = TimelineTime.tryParse(trimmed);
    if (time == null) return s.errorInvalidTime;
    if (!time.isWithinMax) return s.errorTimeOutOfRange;
    return null;
  }

  String? _minutesError(S s, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    final value = int.tryParse(trimmed);
    if (value == null) return s.errorInvalidInteger;
    if (value < 1) return s.errorIntegerMin(1);
    if (value > TimelineLimits.maxSlotDurationMinutes) {
      return s.errorIntegerMax(TimelineLimits.maxSlotDurationMinutes);
    }
    return null;
  }
}

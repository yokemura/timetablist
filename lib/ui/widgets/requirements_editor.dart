import 'package:flutter/material.dart';

import '../../l10n/generated/s.dart';
import '../../models/models.dart';

/// Requirement rows in editor order. Order bounds are 1-based performance
/// positions; `orderFrom` is inclusive and `orderBefore` exclusive (so the
/// smallest meaningful value of `orderBefore` is 2).
enum _ReqField {
  minDuration(isTime: false, max: TimelineLimits.maxSlotDurationMinutes),
  maxDuration(isTime: false, max: TimelineLimits.maxSlotDurationMinutes),
  finishBy(isTime: true),
  startAfter(isTime: true),
  orderFrom(isTime: false),
  orderBefore(isTime: false, min: 2);

  const _ReqField({required this.isTime, this.min = 1, this.max});

  final bool isTime;
  final int min;
  final int? max;
}

/// Editor for [ParticipantRequirements]: one checkbox-gated input per item.
///
/// Inputs are only editable while checked. [onChanged] reports the current
/// value, or null while any checked row holds invalid or empty input.
/// Contradiction handling is up to the caller (via
/// [ParticipantRequirements.hasContradiction]).
class RequirementsEditor extends StatefulWidget {
  const RequirementsEditor({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final ParticipantRequirements initialValue;
  final ValueChanged<ParticipantRequirements?> onChanged;

  /// Test keys: `requirements.<field>.checkbox` / `requirements.<field>.field`
  /// where `<field>` is one of minDuration, maxDuration, finishBy, startAfter,
  /// orderFrom, orderBefore.
  static Key checkboxKey(String field) => Key('requirements.$field.checkbox');
  static Key fieldKey(String field) => Key('requirements.$field.field');

  @override
  State<RequirementsEditor> createState() => _RequirementsEditorState();
}

class _RequirementsEditorState extends State<RequirementsEditor> {
  final Map<_ReqField, bool> _enabled = {
    for (final field in _ReqField.values) field: false,
  };
  final Map<_ReqField, TextEditingController> _controllers = {
    for (final field in _ReqField.values) field: TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    final value = widget.initialValue;
    _seed(_ReqField.minDuration, value.minDurationMinutes?.toString());
    _seed(_ReqField.maxDuration, value.maxDurationMinutes?.toString());
    _seed(_ReqField.finishBy, value.finishBy?.toDisplayString());
    _seed(_ReqField.startAfter, value.startAfter?.toDisplayString());
    _seed(_ReqField.orderFrom, value.preferredOrderFrom?.toString());
    _seed(_ReqField.orderBefore, value.preferredOrderBefore?.toString());
  }

  void _seed(_ReqField field, String? text) {
    _enabled[field] = text != null;
    _controllers[field]!.text = text ?? '';
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _text(_ReqField field) => _controllers[field]!.text.trim();

  bool _isValid(_ReqField field) {
    if (!_enabled[field]!) return true;
    final text = _text(field);
    if (field.isTime) {
      final time = TimelineTime.tryParse(text);
      return time != null && time.isWithinMax;
    }
    final value = int.tryParse(text);
    if (value == null || value < field.min) return false;
    final max = field.max;
    return max == null || value <= max;
  }

  String? _errorText(S s, _ReqField field) {
    if (!_enabled[field]!) return null;
    final text = _text(field);
    if (text.isEmpty) return null; // Nothing entered yet; just not confirmable.
    if (field.isTime) {
      final time = TimelineTime.tryParse(text);
      if (time == null) return s.errorInvalidTime;
      if (!time.isWithinMax) return s.errorTimeOutOfRange;
      return null;
    }
    final value = int.tryParse(text);
    if (value == null) return s.errorInvalidInteger;
    if (value < field.min) return s.errorIntegerMin(field.min);
    final max = field.max;
    if (max != null && value > max) return s.errorIntegerMax(max);
    return null;
  }

  ParticipantRequirements? _currentValue() {
    if (_ReqField.values.any((field) => !_isValid(field))) return null;
    int? intOf(_ReqField field) =>
        _enabled[field]! ? int.parse(_text(field)) : null;
    TimelineTime? timeOf(_ReqField field) =>
        _enabled[field]! ? TimelineTime.parse(_text(field)) : null;
    return ParticipantRequirements(
      minDurationMinutes: intOf(_ReqField.minDuration),
      maxDurationMinutes: intOf(_ReqField.maxDuration),
      finishBy: timeOf(_ReqField.finishBy),
      startAfter: timeOf(_ReqField.startAfter),
      preferredOrderFrom: intOf(_ReqField.orderFrom),
      preferredOrderBefore: intOf(_ReqField.orderBefore),
    );
  }

  void _notify() => widget.onChanged(_currentValue());

  String _label(S s, _ReqField field) => switch (field) {
    _ReqField.minDuration => s.reqMinDurationLabel,
    _ReqField.maxDuration => s.reqMaxDurationLabel,
    _ReqField.finishBy => s.reqFinishByLabel,
    _ReqField.startAfter => s.reqStartAfterLabel,
    _ReqField.orderFrom => s.reqOrderFromLabel,
    _ReqField.orderBefore => s.reqOrderBeforeLabel,
  };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        for (final field in _ReqField.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Checkbox(
                  key: RequirementsEditor.checkboxKey(field.name),
                  value: _enabled[field],
                  onChanged: (checked) {
                    setState(() => _enabled[field] = checked ?? false);
                    _notify();
                  },
                ),
                Expanded(
                  child: TextField(
                    key: RequirementsEditor.fieldKey(field.name),
                    controller: _controllers[field],
                    enabled: _enabled[field],
                    keyboardType: field.isTime
                        ? TextInputType.datetime
                        : TextInputType.number,
                    onChanged: (_) {
                      setState(() {});
                      _notify();
                    },
                    decoration: InputDecoration(
                      labelText: _label(s, field),
                      hintText: field.isTime ? '8:05' : null,
                      errorText: _errorText(s, field),
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

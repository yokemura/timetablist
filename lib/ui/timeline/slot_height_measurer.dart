import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../../models/models.dart';
import 'time_layout.dart';

/// Measures the height a slot's contents really render at, so slots whose
/// participant names wrap to multiple lines still fit.
///
/// Mirrors the build of `PlacedSlotView` / `PlacedParticipantView`: a title
/// line, then an optional participant block (name plus optional warning)
/// with its paddings.
class SlotHeightMeasurer {
  SlotHeightMeasurer({
    required this.titleStyle,
    required this.nameStyle,
    required this.warningStyle,
    required this.slotContentWidth,
    required this.warningLabel,
  });

  final TextStyle titleStyle;
  final TextStyle nameStyle;
  final TextStyle warningStyle;

  /// Width slots lay out their contents in (lane width minus paddings).
  final double slotContentWidth;

  final String warningLabel;

  static const _titleHorizontalPadding = 6.0;
  static const _titleVerticalPadding = 2.0;
  static const _participantInnerHorizontal = 8.0;
  static const _participantInnerVertical = 4.0;

  /// Rendered paragraphs can come out fractionally taller than the measured
  /// value (style resolution and sub-pixel rounding, seen on web).
  static const _subPixelSlack = 1.0;

  double heightOf(PlacedSlot placed) {
    var content = _titleVerticalPadding * 2 +
        _textHeight(
          '0:00',
          titleStyle,
          slotContentWidth - _titleHorizontalPadding * 2,
        );

    final participant = placed.participant;
    if (participant != null) {
      final innerWidth = slotContentWidth -
          TimeLayout.participantPadding * 2 -
          _participantInnerHorizontal * 2;
      var block = _participantInnerVertical * 2 +
          _textHeight(participant.name, nameStyle, innerWidth);
      if (placed.requirementViolations().isNotEmpty) {
        block += _textHeight(warningLabel, warningStyle, innerWidth);
      }
      content += TimeLayout.participantPadding * 2 + block;
    }

    return math.max(
      TimeLayout.minSlotHeight,
      math.max(
        placed.durationMinutes * TimeLayout.defaultPixelsPerMinute,
        content.ceilToDouble() + _subPixelSlack,
      ),
    );
  }

  double _textHeight(String text, TextStyle style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: math.max(0, maxWidth));
    final height = painter.height;
    painter.dispose();
    return height;
  }
}
